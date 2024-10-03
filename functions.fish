#/bin/fish

function uuid
  set uuidvar (npx uuid)
  echo "$uuidvar"
  echo -n "$uuidvar" | pbcopy
end

function gro
    git fetch origin
    git rebase origin/$argv[1] $argv[1]
end
