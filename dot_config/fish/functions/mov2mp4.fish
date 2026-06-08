function mov2mp4 --description "Convert .MOV files to MP4 (skip existing)"
    for f in *.MOV *.mov
        if test -f "$f"
            set out (string replace -r '\.mov$|\.MOV$' '.mp4' "$f")
            if test -f "$out"
                echo "Skipping $f (already exists)"
                continue
            end

            echo "Converting $f → $out"
            ffmpeg -i "$f" \
                -c:v libx264 \
                -preset slow \
                -crf 18 \
                -c:a aac \
                -movflags +faststart \
                "$out"
        end
    end
end
