function clipboard
    if type -q pbcopy
        pbcopy
    else if type -q xclip
        xclip -selection clipboard
    else if type -q putclip
        putclip
    else
        rm -f /tmp/clipboard ^/dev/null
        if test (count $argv) -eq 0
            cat > /tmp/clipboard
        else
            cat $argv[1] > /tmp/clipboard
        end
    end
end
