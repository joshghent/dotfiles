function uuid
  set uuidvar (npx uuid)
  echo "$uuidvar"
  echo -n "$uuidvar" | pbcopy
end
