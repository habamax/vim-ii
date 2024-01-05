vim9script

import autoload 'ii/prompt.vim'

def PrepareBuffer(irc_server: string, irc_channel: string): number
    var bufname = $'{irc_channel} - {irc_server}'
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
        b:irc_server = irc_server
        b:irc_channel = irc_channel
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

export def Cmd(value: string, irc_server: string = "", irc_channel = "")
    var server = empty(irc_server) ? get(b:, "irc_server", "") : irc_server
    var in_file = fnamemodify($"{g:ii_path}/{server}/in", ":p")
    if filewritable(in_file)
        writefile([value], in_file, "a")
        if value =~ '^/j\s'
            var channel = matchstr(value, '^/j\s\+\zs\S\+')
            if !empty(channel)
                Tail(PrepareBuffer(server, channel))
            endif
        endif
    endif
enddef

export def Tail(bufnr: number, all: bool = false)
    if exists("b:ii_tail_job") && job_status(b:ii_tail_job) == "run"
        job_stop(b:ii_tail_job)
    endif
    var num_lines: string
    if all
        num_lines = '-n +1'
    else
        num_lines = $'-n {g:ii_tail_n}'
    endif
    b:ii_tail_job = job_start(["/bin/sh", "-c", $'tail -f --retry {num_lines} {g:ii_path}/{b:irc_server}/\{b:irc_channel}/out'], {
        out_cb: (ch, msg) => UpdateChannelBuffer(bufnr, msg)
    })
    prompt.Set()
enddef

export def Untail(bufnr: number)
    var ii_tail_job = getbufvar(bufnr, "ii_tail_job", null_job)
    if job_status(ii_tail_job) == "run"
        job_stop(ii_tail_job)
    endif
enddef

export def Join(irc_server: string, irc_channel: string)
    Cmd($"/j {irc_channel}", irc_server, irc_channel)
enddef

export def Complete(_, _, _): string
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
