import os
import zipfile

def zip_in_chunks(folder_path, output_prefix, max_size_gb=4):
    folder_path = os.path.abspath(os.path.expanduser(folder_path))
    max_size = int(max_size_gb * 1024 * 1024 * 1024)
    
    archive_num = 1
    current_zip_name = f"{output_prefix}_{archive_num}.zip"
    zf = zipfile.ZipFile(current_zip_name, "w", zipfile.ZIP_DEFLATED)
    
    current_size = 0
    print(f"--- Creating {current_zip_name} ---")

    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)
            file_size = os.path.getsize(file_path)

            # If adding this file exceeds the limit, start a new zip
            if current_size + file_size > max_size:
                zf.close()
                print(f"Finished {current_zip_name} (Size: {current_size / (1024**3):.2f} GB)")
                
                archive_num += 1
                current_zip_name = f"{output_prefix}_{archive_num}.zip"
                zf = zipfile.ZipFile(current_zip_name, "w", zipfile.ZIP_DEFLATED)
                current_size = 0
                print(f"--- Creating {current_zip_name} ---")

            # Add file to the current zip
            # arcname ensures we don't store the entire absolute path inside the zip
            arcname = os.path.relpath(file_path, folder_path)
            zf.write(file_path, arcname)
            current_size += file_size

    zf.close()
    print(f"Finished {current_zip_name} (Size: {current_size / (1024**3):.2f} GB)")
    print("--- All files archived into independent volumes! ---")

# Usage
# Note: folder_path should be the UNZIPPED folder of your courses.
zip_in_chunks('/path/to/folder', 'name file', max_size_gb=3)
