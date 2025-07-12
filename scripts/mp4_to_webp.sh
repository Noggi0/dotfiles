#!/bin/bash

# Fonction de conversion d’un .mp4 en .webp animé
convert_mp4_to_webp() {
    input="$1"
    base="${input%.mp4}"

    echo "🎬 Traitement de $input..."

    ffmpeg -hwaccel cuda -i "$input" \
        -vf "fps=30,scale=1920:1080:flags=lanczos" \
        -loop 0 -lossless 1 -an -y "${base}.webp"

    echo "✅ ${base}.webp terminé."
}

export -f convert_mp4_to_webp

# Parcours de tous les .mp4 en parallèle
find . -maxdepth 1 -type f -name "*.mp4" | parallel convert_mp4_to_webp {}
