import os
import re

def delete_files_with_tei_tag(directory):
    tei_pattern = re.compile(r'<TEI', re.IGNORECASE)
    xhtml_files_found = False  # Flag to track if any XHTML files are found
    removed_files = []  # List to store the names of the removed files

    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.xhtml'):
                xhtml_files_found = True  # Set the flag to True
                file_path = os.path.normpath(os.path.join(root, file))
                print(f"Processing file: {file_path}")
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()

                    if tei_pattern.search(content):
                        os.remove(file_path)
                        removed_files.append(file)  # Add the filename to the removed files list
                        print(f"<TEI tag found in file: {file_path}")
                except IOError as e:
                    print(f"Error reading file: {file_path}: {str(e)}")

    if not xhtml_files_found:
        print("No XHTML files found in the specified directory.")
    else:
        print("Removed files:")
        for file in removed_files:
            print(file)

directory = './OEBPS/texts'
delete_files_with_tei_tag(directory)