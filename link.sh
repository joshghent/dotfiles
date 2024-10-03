#!/bin/bash

dotfiles=(
    ".vimrc"
    ".profile"
    ".gitconfig"
    ".gitignore"
)

for file in "${dotfiles[@]}"
do
    :
    echo "Linking $file"
    ln -sf "$PWD/$file" "$HOME/$file"
done

# Link fish config files
fish_config_dir="$HOME/.config/fish/conf.d"
mkdir -p "$fish_config_dir"
ln -sf "$PWD/aliases.fish" "$fish_config_dir/aliases.fish"
ln -sf "$PWD/functions.fish" "$fish_config_dir/functions.fish"

echo "Finishing Linking all dotfiles and fish config files"
