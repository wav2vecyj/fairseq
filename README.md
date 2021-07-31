### How to infer wav2vec2.0 for a single wav file?
Bash script for inference is present at examples/speech_recognition/sun.sh. Command to run bash file is mentioned below:
```
sh examples/speech_recognition/run.sh <wav_file> <wav_file_id> <wav2vec2_model_path> <kenlm_model_path> <output_folder> 
```
Exaplantion and example of each of the argument for the above bash script is mentioned in the below table.

### About Input Arguments
|Argument|Meaning|Example|
|--------|-------|--------|
|<wav_file> | Absolute path of the wav file you want the transcript for. Please make sure that the wav file has 16000 sample rate, is a mono-channel audio and is encoded in pcm_sle16 format. | /home/ubuntu/sample.wav|
|<wav_file_id> | Any unique identifier string for the wav file | example: sample |
|<wav2vec2_model_path| Absolute path of the fine-tuned wav2vec2 model | /home/ubuntu/wav2vec2.pt |
|<kenlm_model_path> | Absolute path of apporpriate kenlm language model used for wav2vec2 | /home/ubuntu/kenlm.bin |
|<output_folder>| Absolute path of the folder where you want the outputs of the wav2vec2 model | /home/ubuntu/output/ |

### About the Bash Script

The below table explains all the steps that this pipeline does, and also mentions where the code is taken from. 
| Step | What it does | Code Reference |
|-------|-------------|----------------|
|1| Detects the segments in the long wav file, where voice activity is present, and dumps all the voice segments into a specific folder | py-webrtcvad |
|2| Splits the segments if the segment duration is greater than 15 seconds (because we cannot infer long wav files using wav2vec2) | Written by me |
|3| Builds the manifest files for wav2vec2 | fairseq |
|4| Creates temporary label file for wav2vec2 | Written by me |
|5| Wav2vec2 inference | fairseq |
