function cat --description 'View text via bat, images via kitty/chafa'
    set -l use_bat 0
    if command -v bat >/dev/null
        set use_bat 1
    end

    if test (count $argv) -eq 0
        if test $use_bat -eq 1
            command bat --paging=never
        else
            command cat
        end
        return $status
    end

    set -l has_opts 0
    for arg in $argv
        if string match -qr '^-' -- $arg
            set has_opts 1
            break
        end
    end

    if test $has_opts -eq 1
        if test $use_bat -eq 1
            command bat --paging=never $argv
        else
            command cat $argv
        end
        return $status
    end

    set -l kitty_ok 0
    if set -q KITTY_WINDOW_ID; and command -v kitty >/dev/null
        set kitty_ok 1
    end

    set -l chafa_ok 0
    if command -v chafa >/dev/null
        set chafa_ok 1
    end

    set -l imgcat_ok 0
    if command -v imgcat >/dev/null
        set imgcat_ok 1
    end

    for arg in $argv
        if test -f "$arg"
            set -l lower (string lower -- "$arg")
            if string match -qr '\.(png|jpe?g|gif|webp|bmp|tiff?|avif|heic|heif)$' -- $lower
                if test $kitty_ok -eq 1
                    kitty +kitten icat --clear --transfer-mode=stream --stdin=no "$arg"
                else if test $chafa_ok -eq 1
                    chafa "$arg"
                else if test $imgcat_ok -eq 1
                    imgcat "$arg"
                else
                    echo "cat: no image viewer found for $arg (install kitty or chafa)" >&2
                end
            else
                if test $use_bat -eq 1
                    command bat --paging=never "$arg"
                else
                    command cat "$arg"
                end
            end
        else
            if test $use_bat -eq 1
                command bat --paging=never "$arg"
            else
                command cat "$arg"
            end
        end
    end
end
