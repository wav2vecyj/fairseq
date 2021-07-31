wav_file=$1
wav_file_id=$2
wav2vec2_model_path=$3
kenlm_model_path=$4
results_path=$5

mkdir temp
mkdir temp/temp_vad/
mkdir temp/temp_segments/
mkdir temp/temp_manifest/
echo "Step-1 DONE. All temporary folders are made."

vad_directory="$(pwd)/temp/temp_vad/"
python examples/speech_recognition/vad.py 2 $wav_file $wav_file_id $vad_directory
echo "Step-2 DONE. Voice activity detection finished, vad segments are dumped into folder $vad_directory"

segment_directory="$(pwd)/temp/temp_segments/"
python examples/speech_recognition/split_long_utterances.py $vad_directory $segment_directory
echo "Step-3 DONE. Utterances with length > 15 seconds are split, and dumped into folder $segment_directory"

manifest_directory="$(pwd)/temp/temp_manifest/"
python examples/wav2vec/wav2vec_manifest.py $segment_directory --dest $manifest_directory --ext "wav" --valid-percent 1
echo "Step-4 DONE. Input manifest for infer.py pipeline is made, dumped into folder $manifest_directory"

python examples/wav2vec/manifest_labels.py $manifest_directory
echo "Step-5 DONE. Temporary label manifest for infer.py pipeline is made, dumped into folder $manifest_directory"

wget https://dl.fbaipublicfiles.com/fairseq/wav2vec/dict.ltr.txt -P $manifest_directory
echo "Step-6 DONE. Dowloaded letter dictionary and dumped into folder $manifest_directory"

python examples/speech_recognition/infer.py $manifest_directory --task audio_finetuning --nbest 1 --path $wav2vec2_model_path --gen-subset valid --results-path $results_path --w2l-decoder kenlm --lm-model $kenlm_model_path --lm-weight 2 --word-score -1 --sil-weight 0 --criterion ctc --labels ltr --max-tokens 4000000 --post-process letter
echo "Step-7 DONE. Wav2vec2 inference done, outputs dumped into folder $results_path"

rm -r temp
echo "Step-8 DONE. Removed all the temporary folders"
