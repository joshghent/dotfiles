#!/bin/bash

dotfiles=(
    ".zshrc"
    ".vimrc"
    ".bash_profile"
    ".functions"
    ".profile"
    ".aliases"
    ".gitconfig"
)

for file in "${dotfiles[@]}"
do
    :
    echo "Linking $file"
    ln -sf $PWD/$file ~/$file
done

echo "Finishing Linking all dotfiles"
