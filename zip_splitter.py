import os
import shutil

def zip_and_split(folder_path, output_base_name, chunk_size_gb=4):
    # Convert GB to Bytes
    chunk_size = chunk_size_gb * 1024 * 1024 * 1024
    zip_file_name = f"{output_base_name}.zip"

    print(f"--- Archiving folder: {folder_path} ---")
    # Create the initial large zip file
    shutil.make_archive(output_base_name, 'zip', folder_path)

    print(f"--- Splitting into {chunk_size_gb}GB chunks ---")
    part_num = 1
    with open(zip_file_name, 'rb') as f:
        while True:
            chunk = f.read(chunk_size)
            if not chunk:
                break
            
            part_name = f"{zip_file_name}.part{part_num}"
            with open(part_name, 'wb') as chunk_file:
                chunk_file.write(chunk)
            
            print(f"Created: {part_name}")
            part_num += 1

    # Clean up the original large zip file
    os.remove(zip_file_name)
    print("--- Process Complete ---")

# Usage
zip_and_split('your_folder_here', 'my_archive', chunk_size_gb=4)
