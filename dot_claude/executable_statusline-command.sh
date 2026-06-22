#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
effort=$(echo "$input" | jq -r '.effort.level // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
if [ ${#git_branch} -gt 15 ]; then
	git_branch="$(printf '%s' "$git_branch" | cut -c1-14)…"
fi
git_staged=$(git -C "$cwd" --no-optional-locks diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
git_unstaged=$(git -C "$cwd" --no-optional-locks diff --name-only 2>/dev/null | wc -l | tr -d ' ')
git_untracked=$(git -C "$cwd" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

dir=$(basename "$cwd")

# Icons are written as literal UTF-8 so they render under any POSIX printf.
# Do NOT switch back to \xNN escapes here: dash's printf (Ubuntu /bin/sh)
# does not interpret hex escapes and would emit them verbatim.
parts=""

append() {
	if [ -z "$parts" ]; then
		parts="$1"
	else
		parts="$parts  $1"
	fi
}

# Directory
if [ -n "$dir" ]; then
	append "$(printf '\033[36m📁 %s\033[0m' "$dir")"
fi

# Git branch + diff counts
if [ -n "$git_branch" ]; then
	diff_info=""
	if [ "$git_staged" -gt 0 ] 2>/dev/null; then
		diff_info="${diff_info}$(printf '\033[32m+%s\033[0m' "$git_staged")"
	fi
	if [ "$git_unstaged" -gt 0 ] 2>/dev/null; then
		[ -n "$diff_info" ] && diff_info="${diff_info} "
		diff_info="${diff_info}$(printf '\033[31m~%s\033[0m' "$git_unstaged")"
	fi
	if [ "$git_untracked" -gt 0 ] 2>/dev/null; then
		[ -n "$diff_info" ] && diff_info="${diff_info} "
		diff_info="${diff_info}$(printf '\033[33m?%s\033[0m' "$git_untracked")"
	fi
	if [ -n "$diff_info" ]; then
		append "$(printf '\033[35m🌿 %s\033[0m  %s' "$git_branch" "$diff_info")"
	else
		append "$(printf '\033[35m🌿 %s\033[0m' "$git_branch")"
	fi
fi

# Model
if [ -n "$model" ]; then
	append "$(printf '\033[34m🤖 %s\033[0m' "$model")"
fi

# Effort
if [ -n "$effort" ]; then
	case "$effort" in
	low) effort_label="low" ;;
	medium) effort_label="med" ;;
	high) effort_label="high" ;;
	xhigh) effort_label="xhigh" ;;
	max) effort_label="max" ;;
	*) effort_label="$effort" ;;
	esac
	append "$(printf '\033[33m⚡ %s\033[0m' "$effort_label")"
fi

# Context usage as a progress bar
if [ -n "$used" ]; then
	used_int=$(printf '%.0f' "$used")
	filled=$((used_int * 10 / 100))
	empty=$((10 - filled))
	bar=""
	i=0
	while [ $i -lt $filled ]; do
		bar="${bar}█"
		i=$((i + 1))
	done
	i=0
	while [ $i -lt $empty ]; do
		bar="${bar}░"
		i=$((i + 1))
	done
	if [ "$used_int" -ge 80 ]; then
		color='\033[31m'
	elif [ "$used_int" -ge 50 ]; then
		color='\033[33m'
	else
		color='\033[32m'
	fi
	append "$(printf '%b🧠 %s %s%%\033[0m' "$color" "$bar" "$used_int")"
fi

printf '%s' "$parts"
