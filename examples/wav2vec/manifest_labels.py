import sys

if __name__ == "__main__":
    
    args = sys.argv[1:]
    if len(args) != 1:
        sys.stderr.write(
            'Usage: manifest_labels.py <input_folder>n')
        sys.exit(1)
        
    file = open(args[0] + 'valid.tsv', 'r')
    file_out = open(args[0] + 'valid.ltr', 'w')
    count = 0
    for sentence in file:
        if count!=0:
            file_out.write('T E M P\n')
        else:
            count += 1
    file_out.close()
