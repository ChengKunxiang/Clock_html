#!/bin/bash
python -m http.server &
URL="http://localhost:8000"
firefox -fullscreen "$URL"