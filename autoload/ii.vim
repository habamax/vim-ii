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

def FormatMsg(msg: string): string
    var result = msg
    var action = matchlist(result, '^\(.\{-}\) \(<\S\{-}>\) ACTION \(.*\)')
    if !empty(action)
        result = $'{action[1]} *** {action[2]} {action[3]}'
    endif
    # format time
    result = substitute(result, '^\d\+', '\=strftime("%b %d %H:%M", submatch(0)->str2nr())', '')
    return result
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
    appendbufline(bufnr, getbufinfo(bufnr)[0].linecount - 1, FormatMsg(msg))
enddef

export def Cmd(value: string)
    writefile([value], fnamemodify($"~/irc/{b:irc_server}/in", ":p"), "a")
enddef

export def Prompt(keep: bool = false)
    var last_line = getline('$')
    var prompt_val = ""
    if keep
        prompt_val = StripPrompt(last_line)
    endif
    if match(last_line, '^\S\{3} \d\{1,2} \d\d:\d\d\s') != -1
        append("$", GetPromptStr() .. prompt_val)
    else
        setline("$", GetPromptStr() .. prompt_val)
    endif
enddef

export def SendMessage()
    if line('.') != line("$")
        Prompt(true)
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

export def Tail(bufnr: number, all: bool = false)
    if exists("b:shell_job") && job_status(b:shell_job) == "run"
        job_stop(b:shell_job)
    endif
    var num_lines: string
    if all
        num_lines = '-n +1'
    else
        num_lines = $'-n {g:ii_tail_n}'
    endif
    b:shell_job = job_start(["/bin/sh", "-c", $'tail -f --retry {num_lines} ~/irc/{b:irc_server}/\{b:irc_channel}/out'], {
        out_cb: (ch, msg) => UpdateChannelBuffer(bufnr, msg)
    })
    Prompt()
enddef

export def Join(irc_server: string, irc_channel: string)
    var bufnr = PrepareBuffer($'{irc_channel} - {irc_server}')
    b:irc_channel = irc_channel
    b:irc_server = irc_server
    Cmd($"/j {irc_channel}")
    Tail(bufnr)
enddef
