vim9script

def PrepareBuffer(bufname: string): number
    var buffers = getbufinfo()->filter((_, v) => fnamemodify(v.name, ":t") == bufname)

    var bufnr = -1

    if len(buffers) > 0
        bufnr = buffers[0].bufnr
    else
        bufnr = bufadd(bufname)
    endif

    var windows = win_findbuf(bufnr)

    if windows->len() == 0
        exe "sbuffer" bufnr
        set filetype=ii
    else
        win_gotoid(windows[0])
    endif

    silent :%d _

    return bufnr
enddef

def GetPromptStr(): string
    return $"{b:irc_channel}> "
enddef

def FormatTime(msg: string): string
    return substitute(msg, '^\d\+', '\=strftime("%H:%M", submatch(0)->str2nr())', '')
enddef

def StripPrompt(msg: string): string
    var msg_start = matchend(msg, $'^{GetPromptStr()}')
    if msg_start != -1
        return msg[msg_start : ]
    else
        return ""
    endif
enddef

def Filter(msg: string): bool
    var result = false
    for rx in g:ii_filter_rx
        if match(msg, rx) != -1
            result = true
            break
        endif
    endfor
    return result
enddef

def UpdateChannelBuffer(bufnr: number, msg: string)
    if Filter(msg)
        return
    endif
    appendbufline(bufnr, getbufinfo(bufnr)[0].linecount - 1, FormatTime(msg))
enddef

def Cmd(value: string)
    writefile([value], fnamemodify($"~/irc/{b:irc_server}/in", ":p"), "a")
enddef

export def Prompt()
    var last_line = getline('$')
    if match(last_line, '^\d\d:\d\d\s') != -1
        append("$", GetPromptStr())
    else
        setline("$", GetPromptStr())
    endif
enddef

export def SendMessage()
    if line('.') != line("$")
        return
    endif
    var msg = StripPrompt(getbufline(bufnr(), line("$"))[0])
    if match(msg, '^\s*$') != -1
        Prompt()
        return
    endif
    writefile([msg], fnamemodify($"~/irc/{b:irc_server}/{b:irc_channel}/in", ":p"), "a")
    Prompt()
enddef

export def Join(irc_server: string, irc_channel: string)
    var bufnr = PrepareBuffer($'{irc_channel} - {irc_server}')
    b:irc_channel = irc_channel
    b:irc_server = irc_server
    b:shell_job = job_start(["/bin/sh", "-c", $"tail -f -n 100 ~/irc/{b:irc_server}/\\{irc_channel}/out"], {
        out_cb: (ch, msg) => UpdateChannelBuffer(bufnr, msg)
    })
    Prompt()
    Cmd($"/j {irc_channel}")
enddef
