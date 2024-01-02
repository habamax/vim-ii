vim9script

import autoload 'ii/prompt.vim'

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
    var in_file = fnamemodify($"{g:ii_path}/{b:irc_server}/in", ":p")
    if filewritable(in_file)
        writefile([value], in_file, "a")
    endif
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
    b:shell_job = job_start(["/bin/sh", "-c", $'tail -f --retry {num_lines} {g:ii_path}/{b:irc_server}/\{b:irc_channel}/out'], {
        out_cb: (ch, msg) => UpdateChannelBuffer(bufnr, msg)
    })
    prompt.Set()
enddef

export def Join(irc_server: string, irc_channel: string)
    var bufnr = PrepareBuffer($'{irc_channel} - {irc_server}')
    b:irc_channel = irc_channel
    b:irc_server = irc_server
    Cmd($"/j {irc_channel}")
    Tail(bufnr)
enddef

export def Complete(_, _, _): string
    # for now assuming ~/irc/
    var irc_compl = ""
    var irc_path = expand(g:ii_path)
    var servers = readdir(irc_path, (dir) => isdirectory($'{irc_path}/{dir}'))
    for server in servers
        var channels = readdir($"{irc_path}/{server}", (dir) => isdirectory($'{irc_path}/{server}/{dir}'))
        for channel in channels
            irc_compl ..= $"{server} {channel}\n"
        endfor
    endfor
    return irc_compl
enddef
