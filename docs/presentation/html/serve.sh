#!/bin/bash
# Run server from parent directory so relative paths work correctly

cd "$(dirname "$0")/.."
echo "Starting server from: $(pwd)"
echo "Open: http://localhost:8000/html/"
python3 -m http.server 8000
