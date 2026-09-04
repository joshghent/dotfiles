function unload --description 'Remove the variables set by the last `load`'
    for key in $__env_keys
        set -e $key
        if contains -- $key $__env_restore
            set -l prev __env_prev_$key
            set -gx $key $$prev
            set -e $prev
        end
    end
    set -e __env_keys __env_restore __env_file
end
