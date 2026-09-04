#!/bin/bash
set -e
set -o pipefail

ERRORS=()

check() {
	if shellcheck "$1"; then
		echo "[OK]: successfully linted $2"
	else
		ERRORS+=("$2")
	fi
}

# Plain shell scripts lint as-is.
while IFS= read -r f; do
	if file "$f" | grep --quiet shell; then
		check "$f" "$f"
	fi
done < <(find . -type f \
	-not -iwholename '*.git*' \
	-not -iwholename './.vim/**' \
	-not -iwholename '*.DS_Store' \
	-not -name '*.fish' \
	-not -name '*.tmpl' \
	-not -iwholename './.bash_prompt' | sort -u)

# Templates are not valid shell until chezmoi has rendered them, so shellcheck
# can only see Go template syntax and gives up at the first `{{`. Render each
# one first and lint what would actually run. Every branch needs its own render
# or the OS-specific half of each file goes unchecked.
if command -v chezmoi >/dev/null; then
	RENDER_DIR=$(mktemp -d)
	trap 'rm -rf "$RENDER_DIR"' EXIT

	# os | osRelease.id | casks_enabled
	MATRIX=(
		"darwin::false"
		"darwin::true"
		"linux:ubuntu:false"
		"linux:fedora:false"
	)

	for combo in "${MATRIX[@]}"; do
		IFS=':' read -r os distro casks <<<"$combo"
		label="$os${distro:+-$distro}${casks:+-casks-$casks}"
		cfg="$RENDER_DIR/$label.toml"
		# Dummy identity: these only have to satisfy the templates, never ship.
		cat >"$cfg" <<-TOML
			[data]
			name = "Lint User"
			email = "lint@example.com"
			git_email = "lint@example.com"
			machine_type = "work"
			casks_enabled = $casks
			[data.gpg]
			create_key = true
			key_type = "ed25519"
			key_length = 4096
			expire_days = 0
			[data.chezmoi]
			os = "$os"
			[data.chezmoi.osRelease]
			id = "$distro"
		TOML

		for f in ./*.sh.tmpl; do
			[ -e "$f" ] || continue
			base=$(basename "$f" .tmpl)
			out="$RENDER_DIR/$label--$base"
			if ! chezmoi execute-template --config "$cfg" --config-format toml \
				--file "$f" >"$out" 2>"$RENDER_DIR/err"; then
				echo "[RENDER FAILED] $f ($label): $(head -1 "$RENDER_DIR/err")"
				ERRORS+=("$f ($label, render)")
				continue
			fi
			check "$out" "$f ($label)"
		done
	done
elif [ -n "$CI" ]; then
	# Skipping locally is a convenience; skipping in CI would quietly drop
	# every template from the lint and still report green.
	echo "chezmoi is required in CI to lint templates" >&2
	exit 1
else
	echo "chezmoi not installed, skipping template lint"
fi

if [ ${#ERRORS[@]} -eq 0 ]; then
	echo "No errors, hooray"
else
	printf 'These files failed shellcheck:\n'
	printf '  %s\n' "${ERRORS[@]}"
	exit 1
fi
