import sys

file_path = sys.argv[1]
content = sys.stdin.read()

with open(file_path, 'a') as f:
    f.write(content + "\n")
