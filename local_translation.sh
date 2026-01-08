#!/bin/bash


set -e

command -v ffmpeg >/dev/null 2>&1 || { echo >&2 "I require ffmpeg but it's not installed.  Aborting."; exit 1; }
command -v jq >/dev/null 2>&1 || { echo >&2 "I require jq but it's not installed.  Aborting."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo >&2 "I require curl but it's not installed.  Aborting."; exit 1; }

# --- Hardcode your API keys here ---
# Replace with your actual Hugging Face API Token
HF_TOKEN=""
# Replace with your actual Google Gemini API Key
GEMINI_API_KEY=""


if [ -z "$1" ]; then
    echo "Usage: $0 <local_video_file>"
    exit 1
fi
VIDEO_FILE="$1"
FILENAME="extracted_audio"
AUDIO_FILE="${FILENAME}.flac"


if [ ! -f "$VIDEO_FILE" ]; then
    echo "Error: Video file '$VIDEO_FILE' does not exist."
    exit 1
fi


echo "--- Extracting audio from video ---"
ffmpeg -i "$VIDEO_FILE" -vn -acodec flac "$AUDIO_FILE"
echo "--- Audio extracted successfully ---"


echo "--- Transcribing audio with Whisper ---"
WHISPER_RESPONSE=$(curl https://router.huggingface.co/hf-inference/models/openai/whisper-large-v3-turbo \
    -X POST \
    -H "Authorization: Bearer $HF_TOKEN" \
    -H "Content-Type: audio/flac" \
    --data-binary @"$AUDIO_FILE")
TRANSCRIPTION=$(echo "$WHISPER_RESPONSE" | jq -r '.text')
echo "--- Transcription complete ---"
echo "Transcription: $TRANSCRIPTION"


echo "--- Translating to Hindi with Gemini Flash ---"
GEMINI_PAYLOAD=$(jq -n \
                  --arg text "$TRANSCRIPTION" \
                  '{
                    "contents":[
                      {
                        "parts":[
                          {
                            "text": "Translate the following English text to Hindi, use common Hindi with a mix of English to make it easy to understand by the user: \($text)"
                          }
                        ]
                      }
                    ]
                  }')

GEMINI_RESPONSE=$(curl -s \
    -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}" \
    -H 'Content-Type: application/json' \
    -d "$GEMINI_PAYLOAD")

HINDI_TRANSLATION=$(echo "$GEMINI_RESPONSE" | jq -r '.candidates[0].content.parts[0].text')

echo "--- Translation complete ---"
echo "Hindi Translation: $HINDI_TRANSLATION"
echo "$HINDI_TRANSLATION" > hindi_translation.txt
echo "--- Hindi translation saved to hindi_translation.txt ---"

# --- Clean up the extracted audio file
rm "$AUDIO_FILE"
echo "--- Cleanup complete ---"
