function notify
    # Usage: notify <title> <description>
    set title (or $argv[1] "Notification")
    set description (or $argv[2] (date "+%Y-%m-%dT%H:%M:%S%z"))

    # Try notify-send
    if type -q notify-send
        notify-send --expire-time=5000 $title $description
        if test $status -eq 0
            return
        end
    end

    # Try osascript (macOS)
    if type -q osascript
        set js "var app = Application.currentApplication(); app.includeStandardAdditions = true; app.displayNotification($description) withTitle:$title;"
        osascript -l JavaScript -e $js
        if test $status -eq 0
            return
        end
    end

    # Fallback error
    echo "can't send notifications" >&2
    return 1
end
