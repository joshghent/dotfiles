function timer
    # Usage: timer <seconds>
    if test (count $argv) -lt 1
        echo "Usage: timer <seconds>"
        return 1
    end

    set seconds $argv[1]
    sleep $seconds

    # Play sound
    if type -q sfx
        sfx ringaling
    end

    # Notify
    if type -q notify
        notify "timer complete" $seconds
    else
        echo "timer complete: $seconds"
    end
end
