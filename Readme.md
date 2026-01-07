# YouTube to Hindi Translation

This project contains two bash scripts that transcribe audio from YouTube videos or local video files and translate the transcription to Hindi.

## Scripts

### 1. transcription.sh
Downloads audio from a YouTube video, transcribes it using OpenAI's Whisper model, and translates it to Hindi using Google's Gemini Flash.

**Usage:**
```bash
./transcription.sh <youtube_video_link>
```

**Example:**
```bash
./transcription.sh "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

### 2. translation.sh
Extracts audio from a local video file, transcribes it using Whisper, and translates it to Hindi using Gemini Flash.

**Usage:**
```bash
./translation.sh <local_video_file>
```

**Example:**
```bash
./translation.sh my_video.mp4
```

## Prerequisites

Both scripts require the following dependencies to be installed:

- **ffmpeg** - For audio processing
- **jq** - For JSON parsing
- **curl** - For API requests
- **yt-dlp** - For downloading YouTube videos (required for transcription.sh only)

### Install Dependencies

**macOS (using Homebrew):**
```bash
brew install ffmpeg jq yt-dlp
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install ffmpeg jq curl
pip install yt-dlp
```

## Setup

1. **Get API Keys:**
   - **Hugging Face Token**: Sign up at [Hugging Face](https://huggingface.co/) and get your API token from your profile settings
   - **Google Gemini API Key**: Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)

2. **Configure API Keys:**
   
   Edit both script files and add your API keys:
   ```bash
   HF_TOKEN="your_huggingface_token_here"
   GEMINI_API_KEY="your_gemini_api_key_here"
   ```

3. **Make Scripts Executable:**
   ```bash
   chmod +x transcription.sh translation.sh
   ```

## How It Works

1. **Audio Extraction/Download**: 
   - `transcription.sh` downloads audio from YouTube in FLAC format
   - `translation.sh` extracts audio from a local video file

2. **Transcription**: 
   - Both scripts use OpenAI's Whisper Large V3 Turbo model via Hugging Face API to transcribe the audio to text

3. **Translation**: 
   - The transcribed text is translated to Hindi using Google's Gemini 2.5 Flash model
   - The translation uses a mix of Hindi and English for better comprehension

4. **Output**: 
   - The Hindi translation is saved to `hindi_translation.txt`
   - The temporary audio file is automatically cleaned up

## Output

Both scripts generate a `hindi_translation.txt` file containing the Hindi translation of the video's audio content.

## Notes

- The scripts automatically clean up temporary audio files after processing
- Audio files are processed in FLAC format for better quality
- The translation uses "Hinglish" (Hindi mixed with English) for easier understanding
- Both scripts exit immediately if any command fails (`set -e`)

## License

MIT