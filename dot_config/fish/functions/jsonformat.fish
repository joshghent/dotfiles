function prettyjson
    if type -q node
        node -e '
        process.stdin.setEncoding("utf8")

        let jsonString = ""

        process.stdin.on("readable", () => {
          const chunk = process.stdin.read()
          if (chunk) {
            jsonString += chunk
          }
        })

        process.stdin.on("end", () => {
          console.log(
            require("util").inspect(
              JSON.parse(jsonString.trim()),
              {
                depth: 100,
                colors: true
              }
            )
          )
        })
        '
    else if type -q jq
        jq
    else
        cat
    end
end
