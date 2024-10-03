#!/bin/fish

uuid(){
  uuidvar=$(npx uuid)
  echo "$uuidvar"
  echo "$uuidvar" | tr -d '\n' | pbcopy
}

gro(){
    git fetch origin
    git rebase origin/$1 $1
}
