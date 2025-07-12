#!/bin/bash

# Fonction de conversion pour un seul fichier
convert_mp4_to_gif() {
    input="$1"
    base="${input%.mp4}"

    echo "Traitement de $input..."

    # Générer la palette (pas besoin d'accélération ici, c’est rapide)
    ffmpeg -hwaccel cuda -i "$input" \
        -vf "fps=30,scale=1920:1080:flags=lanczos,palettegen" \
        -frames:v 1 -y "${base}_palette.png"

    # Générer le GIF avec la palette
    ffmpeg -hwaccel cuda -i "$input" -i "${base}_palette.png" \
        -filter_complex "fps=30,scale=1920:1080:flags=lanczos[x];[x][1:v]paletteuse" \
        -y "${base}.gif"

    # Nettoyage
    rm -f "${base}_palette.png"

    echo "✅ ${base}.gif terminé."
}

export -f convert_mp4_to_gif

# Trouve tous les fichiers .mp4 et les passe à GNU parallel
find . -maxdepth 1 -type f -name "*.mp4" | parallel convert_mp4_to_gif {}
