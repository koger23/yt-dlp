#!/bin/bash

# Check if the required commands are installed
command -v parallel >/dev/null 2>&1 || { echo >&2 "Parallel is required but not installed. Aborting."; exit 1; }
command -v yt-dlp >/dev/null 2>&1 || { echo >&2 "yt-dlp is required but not installed. Aborting."; exit 1; }

# Input file containing URLs
input_file="../liked_songs.txt"
# to download playlist to text file:
# yt-dlp --flat-playlist -i --print-to-file url liked_songs.txt "https://music.youtube.com/browse/VLPLKFIZ_YqyfUa_OTSQj3R4nmZ5U3c1GapD"

# Function to process a single URL
process_url() {
    url="$1"
    # Replace this line with the command you want to run for each URL
    # Example: curl -O "$url"
    echo "Processing URL: $url"
    yt-dlp -f bestaudio --extract-audio --audio-quality 0 --audio-format mp3 --output "%(artist)s - %(title)s.%(ext)s" $url
}

# Export the function so it can be used by parallel
export -f process_url

# Read URLs from the input file and process them in parallel 40 at once
cat "$input_file" | parallel -j40 process_url