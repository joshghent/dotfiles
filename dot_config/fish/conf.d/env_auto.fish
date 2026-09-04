# Auto-load the nearest .env on directory change, and unload it on the way out.
# Lives in conf.d rather than functions/ because fish only autoloads a function
# when it is called by name. An event handler has to exist before the event.

function __env_nearest --description 'Path of the nearest .env at or above $PWD, stopping below $HOME'
    set -l dir $PWD
    while test -n "$dir"; and test "$dir" != "$HOME"
        if test -r $dir/.env
            echo $dir/.env
            return 0
        end
        set dir (string replace -r '/[^/]*$' '' -- $dir)
    end
    return 1
end

function __env_sync --on-variable PWD --description 'Reload .env when the directory changes'
    set -l found (__env_nearest)
    # Moving between subdirectories of the same project resolves to the same
    # file, so leave the environment alone rather than churning it.
    test "$found" = "$__env_file"; and return
    unload
    test -n "$found"; and load $found
end

__env_sync
