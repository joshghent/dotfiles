#!/bin/bash
set -e
set -o pipefail

ERRORS=()

# Get all dotfiles and pipe into shellcheck
for f in $(find . -type f -not -iwholename '*.git*' -not -iwholename './.vim/**' -not -iwholename '*.DS_Store' | sort -u); do
	if file "$f" | grep --quiet shell; then
		{
			shellcheck "$f" && echo "[OK]: sucessfully linted $f"
		} || {
			# Add to errors list
			ERRORS+=("$f")
		}
	fi
done

if [ ${#ERRORS[@]} -eq 0 ]; then
	echo "No errors, hooray"
else
	echo "These files failed shellcheck: ${ERRORS[*]}"
	exit 1
fi
