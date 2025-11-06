#!/bin/bash

# Render all Mermaid diagrams for Persona presentation
# Usage: ./render_all.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Rendering Persona presentation diagrams..."
echo ""

# Create renders directory if it doesn't exist
mkdir -p renders

# Diagram list
diagrams=(
    "01_intelligence_cycle"
    "02_behavioral_coherence"
    "03_timeline"
    "04_vnc_control"
)

# Render behavioral system separately (different filename)
echo "Rendering 01_behavioral_system.png (3-layer system)..."
mmdc -i 01_intelligence_cycle.mmd -o renders/01_behavioral_system.png -w 1920 -H 1080 -b transparent
echo "  Done: renders/01_behavioral_system.png"
echo ""

# Render each diagram
for diagram in "${diagrams[@]}"; do
    echo "Rendering ${diagram}.mmd..."

    # Gantt chart needs larger size for readable font
    if [ "$diagram" = "03_timeline" ]; then
        mmdc -i "${diagram}.mmd" -o "renders/${diagram}.png" -w 2400 -H 1080 -b transparent
    # VNC control needs custom CSS for thicker lines
    elif [ "$diagram" = "04_vnc_control" ]; then
        mmdc -i "${diagram}.mmd" -o "renders/${diagram}.png" -w 1920 -H 1080 -b transparent -C vnc-custom.css
    else
        mmdc -i "${diagram}.mmd" -o "renders/${diagram}.png" -w 1920 -H 1080 -b transparent
    fi

    echo "  Done: renders/${diagram}.png"
    echo ""
done

echo "All diagrams rendered successfully!"
echo ""
echo "Files created in: ${SCRIPT_DIR}/renders/"
ls -lh renders/*.png
