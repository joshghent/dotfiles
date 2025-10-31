function bb
    if test -t 1
        set stdout_redirect ">/dev/null"
    else
        set stdout_redirect ""
    end

    if test -t 2
        set stderr_redirect "2>/dev/null"
    else
        set stderr_redirect ""
    end

    eval "$argv $stdout_redirect $stderr_redirect &"
end
