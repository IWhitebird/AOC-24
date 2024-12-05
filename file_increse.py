import sys
import os

def copy_paste_content(file_path, times):
    if not os.path.isabs(file_path):
        raise ValueError("The file path must be absolute.")
    
    if not os.path.isfile(file_path):
        raise FileNotFoundError(f"No such file: '{file_path}'")
    
    with open(file_path, 'r') as file:
        content = file.read()
    
    with open(file_path, 'a') as file:
        for _ in range(times):
            file.write(content)

if __name__ == "__main__":
    file_path = "/home/blade/projects/advent/2024/day3/input.txt"
    times = 1000
    
    copy_paste_content(file_path, times)
