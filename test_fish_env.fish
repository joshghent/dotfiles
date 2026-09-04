#!/usr/bin/env fish
# Checks for the .env auto-load functions in dot_config/fish.
# Run directly, or via `make test` (skipped where fish is not installed).

set -l SRC (status dirname)/dot_config/fish
source $SRC/functions/load.fish
source $SRC/functions/unload.fish
source $SRC/conf.d/env_auto.fish

set -g FAILED 0
function check
    if test "$argv[2]" = "$argv[3]"
        echo "  ok   $argv[1]"
    else
        echo "  FAIL $argv[1]: expected [$argv[3]] got [$argv[2]]"
        set -g FAILED 1
    end
end

# The sandbox has to live under $HOME so the walk-up stop condition is exercised.
set -g ROOT (mktemp -d $HOME/envtest.XXXXXX)
mkdir -p $ROOT/proj/src $ROOT/other
printf '%s\n' \
    '# a comment' \
    '' \
    'FOO=bar' \
    'export EXPORTED=yes' \
    'QUOTED="has spaces"' \
    "SINGLE='sq'" \
    'DSN=postgres://u:p@h/db?a=1' \
    'PATH=/evil' \
    'not a valid key=x' \
    'PREEXISTING=fromfile' >$ROOT/proj/.env
printf 'OTHER=elsewhere\n' >$ROOT/other/.env

set -gx PREEXISTING original
set -g PATH_BEFORE "$PATH"

cd $ROOT/proj
check "basic key" "$FOO" bar
check "export prefix stripped" "$EXPORTED" yes
check "double quotes stripped" "$QUOTED" "has spaces"
check "single quotes stripped" "$SINGLE" sq
check "value keeps its =" "$DSN" 'postgres://u:p@h/db?a=1'
check "PATH not hijacked" "$PATH" "$PATH_BEFORE"
check "invalid key skipped" (set -q not; echo $status) 1
check "pre-existing overridden" "$PREEXISTING" fromfile

cd $ROOT/proj/src
check "subdir keeps env" "$FOO" bar

cd $ROOT/other
check "sibling project loads" "$OTHER" elsewhere
check "old project unloaded" (set -q FOO; echo $status) 1
check "pre-existing restored" "$PREEXISTING" original

cd $ROOT
check "leaving unloads" (set -q OTHER; echo $status) 1
check "no bookkeeping leaks" (set -q __env_keys; echo $status) 1

cd /
rm -rf $ROOT
test $FAILED -eq 0; and echo "fish env: all pass"; or echo "fish env: FAILURES"
exit $FAILED
