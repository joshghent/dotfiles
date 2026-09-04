function load --description 'Export variables from a .env file (default: ./.env)'
    set -l file (string trim -- "$argv[1]")
    test -n "$file"; or set file .env
    test -r $file; or return

    # Refuse variables that can hijack the shell itself. A .env arrives with any
    # `git clone`, and auto-loading means you never opted in to this particular
    # one. A PATH or LD_PRELOAD entry in it would run attacker code as you.
    set -l blocked PATH LD_PRELOAD LD_LIBRARY_PATH DYLD_INSERT_LIBRARIES DYLD_LIBRARY_PATH IFS

    while read -l line
        set line (string trim -- $line)
        string match -qr '^(#|$)' -- $line; and continue

        set -l pair (string split -m1 '=' -- (string replace -r '^export\s+' '' -- $line))
        test (count $pair) -eq 2; or continue

        set -l key (string trim -- $pair[1])
        string match -qr '^[A-Za-z_][A-Za-z0-9_]*$' -- $key; or continue
        if contains -- $key $blocked
            echo "load: refusing to set $key from $file" >&2
            continue
        end

        # Strip one layer of matching surrounding quotes, if present.
        set -l value (string replace -r '^(["\'])(.*)\1$' '$2' -- (string trim -- $pair[2]))

        # Remember what was here first so unload can put it back rather than
        # erasing a value that predates this file.
        if not contains -- $key $__env_keys
            if set -q $key
                set -g __env_prev_$key $$key
                set -ga __env_restore $key
            end
            set -ga __env_keys $key
        end

        set -gx $key $value
    end <$file

    set -g __env_file (path resolve $file)
end
