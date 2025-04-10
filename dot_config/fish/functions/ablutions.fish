function ablutions
    echo "Homebrew"
    brew update
    brew upgrade

    echo "Chez-moi"
    chezmoi git pull
end
