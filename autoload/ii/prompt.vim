vim9script


export def GetName(): string
    return $"{b:irc_channel}> "
enddef

export def Strip(msg: string): string
    var msg_start = matchend(msg, $'^{GetName()}')
    if msg_start != -1
        return msg[msg_start : ]
    else
        return msg
    endif
enddef

export def Set(keep: bool = false, clip: bool = false)
    var last_line = getline('$')
    var prompt_val = ""
    if keep
        var maybe_prompt_val = Strip(last_line)
        if maybe_prompt_val != last_line
            prompt_val = maybe_prompt_val
        endif
    endif
    if clip
        setreg('"', Strip(last_line))
        if &clipboard =~ 'unnamed\>'
            setreg('*', @")
        elseif &clipboard =~ 'unnamedplus'
            setreg('+', @")
        endif
    endif
    if match(last_line, '^\S\{3} \d\{1,2} \d\d:\d\d\s') != -1
        append("$", GetName() .. prompt_val)
    else
        setline("$", GetName() .. prompt_val)
    endif
enddef

export def StartInsert()
    if line('.') != line('$')
        return
    endif
    if getline('.') == GetName()
        :startinsert!
    else
        :startinsert
    endif
enddef

def IrcCommand(msg: string): string
    var result: string = msg
    var cmd = matchlist(result, '^/\(me\)\s\(.*\)')
    if !empty(cmd) && cmd[1] == "me"
        result = printf('%1$cACTION %2$s%1$c', 0x01, cmd[2])
    endif
    return result
enddef

export def SendMessage()
    if line('.') != line("$")
        Set(true)
        return
    endif
    var prompt_line = getline('$')
    var msg = Strip(prompt_line)
    if match(msg, '^\s*$') != -1 || msg == prompt_line
        Set()
        return
    endif
    msg = IrcCommand(msg)
    writefile([msg], fnamemodify($"~/irc/{b:irc_server}/{b:irc_channel}/in", ":p"), "a")
    Set()
enddef

export def Insert(mapping: string)
    var is_prompt_line = (line('.') == line('$'))
    var prompt_str = GetName()
    var prompt_len = strlen(prompt_str)
    if (!is_prompt_line || col('.') <= prompt_len) && mapping != "CR"
        :exe $'normal! i{mapping}'
        return
    endif
    var prompt_line = getline('$')
    if mapping == "CR"
        SendMessage()
        :normal! G$
        startinsert!
        return
    elseif mapping == "\<C-u>"
        var col_e = col('.') - 1
        setline('$', prompt_str .. prompt_line[col_e : ])
        :normal! 0E2l
        if strlen(prompt_str) >= strlen(getline('$'))
            :startinsert!
        else
            :startinsert
        endif
    elseif mapping == "\<C-w>"
        var col_e = col('.') - 1
        while col_e > strlen(prompt_str) && prompt_line[col_e - 1] =~ '\s'
            col_e -= 1
        endwhile
        while col_e > strlen(prompt_str) && prompt_line[col_e - 1] =~ '\S'
            col_e -= 1
        endwhile
        if col_e >= strlen(prompt_str)
            var first_part = ""
            var last_part = prompt_line[col('.') - 1 : ]
            if col_e > prompt_len
                first_part = prompt_line[prompt_len : col_e - 1]
            endif
            setline('$', prompt_str .. first_part .. last_part)
            :exe $"normal! {col_e + 1}|"
            if col_e >= strlen(getline('$'))
                :startinsert!
            else
                :startinsert
            endif
        endif
    endif
enddef

export def Normal(mapping: string)
    var prompt_str = GetName()
    if mapping =~ 'g\?I'
        Set(true)
        :normal! G0W
        if strlen(prompt_str) >= strlen(getline('$'))
            :startinsert!
        else
            :startinsert
        endif
    elseif mapping == "A" || mapping == "CR"
        Set(true)
        :normal! G$
        :startinsert!
    elseif mapping == "dd"
        Set(false, true)
        :normal! G0W
    elseif mapping == "cc"
        Set(false, true)
        :normal! G$
        :startinsert!
    endif
enddef

