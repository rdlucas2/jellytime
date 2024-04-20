import os
import subprocess
import re

base_directory = f'/mnt/c/ProgramData/NZBGet/complete'

def parse_title(ffmpeg_output: str):
    # Regular expression to find the title in the metadata
    title_pattern = re.compile(r"^\s*title\s*:\s*(.+)$", re.MULTILINE)

    # Search for the title
    title_match = title_pattern.search(ffmpeg_output)

    # Extract the title if found
    if title_match:
        title = title_match.group(1)
    else:
        title = "Title not found"

    print(" ")
    print("Extracted title:", title)

    return title

def extract_and_rename_files(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".mp4"):
            filepath = os.path.join(directory, filename)
            # Prepare the command to execute
            command = ["ffmpeg", "-i", filepath, "-f", "ffmetadata", "-"]
            # try:
            print(" ")
            print("=================================================")
            # Execute the command and capture the output
            result = subprocess.run(command, stderr=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
            # FFmpeg writes metadata to stderr, so we capture that
            metadata = result.stderr
            print(" ")
            print(f"Processing: {filename}")
            # print("###############")
            # print(" ")
            # print(f"Metadata for {filename}:")
            # print(metadata)
            # print("***************")
            title = parse_title(metadata)
            # print(title)
            
            # Placeholder for renaming logic
            new_filename = title # edit the filename here as needed
            new_filepath = os.path.join(directory, new_filename)
            # os.rename(filepath, new_filepath)
            print(" ")
            print(f"Renamed {filename} to:\n\n{new_filepath}")
                
            # except Exception as e:
            #     print(f"Error extracting metadata for {filename}: {e}")

# Iterate through each subdirectory in the base_directory
for subdir_name in os.listdir(base_directory):
    subdir_path = os.path.join(base_directory, subdir_name)
    if os.path.isdir(subdir_path):
        print(f"Processing directory: {subdir_path}")
        extract_and_rename_files(subdir_path)
