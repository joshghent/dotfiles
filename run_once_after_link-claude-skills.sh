#!/usr/bin/env bash
# Link personal Claude skills (github.com/joshghent/skills) into ~/.claude/skills
# so they're available everywhere. Clones the repo if it's not already present,
# then symlinks each skill (any dir containing a SKILL.md) into the skills dir.
set -euo pipefail

SKILLS_REPO="$HOME/Projects/skills"
SKILLS_DEST="$HOME/.claude/skills"
REPO_URL="https://github.com/joshghent/skills.git"

if [ ! -d "$SKILLS_REPO/.git" ]; then
	mkdir -p "$(dirname "$SKILLS_REPO")"
	git clone "$REPO_URL" "$SKILLS_REPO"
fi

mkdir -p "$SKILLS_DEST"

find "$SKILLS_REPO" -maxdepth 2 -name SKILL.md -print0 | while IFS= read -r -d '' skill; do
	dir="$(dirname "$skill")"
	name="$(basename "$dir")"
	ln -sfn "$dir" "$SKILLS_DEST/$name"
	echo "linked skill: $name -> $SKILLS_DEST/$name"
done
