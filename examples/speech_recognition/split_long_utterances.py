import soundfile as sf
import os
import sys

if __name__ == "__main__":
    
    args = sys.argv[1:]
    if len(args) != 2:
        sys.stderr.write(
            'Usage: split_long_utterances.py <input_folder> <output_folder>\n')
        sys.exit(1)

    input_folder = args[0]
    output_folder = args[1]
        
    for file in os.listdir(input_folder):
        
        if file.endswith('.wav'):
            
            wav_filename = input_folder + file
            data, sample_rate = sf.read(wav_filename)
            FIFTEEN_SECONDS = 15*sample_rate
            
            for i in range(0, len(data), FIFTEEN_SECONDS):
                chunk = data[i:i+FIFTEEN_SECONDS]
                chunk_number = int(i/FIFTEEN_SECONDS)
                out_filename = output_folder + file.split('.')[0] + '_' + str(chunk_number) + '.wav'
                sf.write(out_filename, chunk, sample_rate)