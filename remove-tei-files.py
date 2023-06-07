import os
import re

def delete_files_with_tei_tag(directory):
    tei_pattern = re.compile(r'<TEI\b[^>]*>.*?</TEI>', re.DOTALL | re.IGNORECASE)
    xhtml_files_found = False  # Flag to track if any XHTML files are found
    removed_files = []  # List to store the names of the removed files
    
    def contains_tei_tag(content, tei_pattern):
        return bool(tei_pattern.search(content))
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.xhtml'):
                xhtml_files_found = True  # Set the flag to True
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    if contains_tei_tag(content, tei_pattern):
                        os.remove(file_path)
                        removed_files.append(file)  # Add the filename to the removed files list
                        print(f"Deleted file: {file_path}")
                except IOError:
                    print(f"Error reading file: {file_path}")
    
    if not xhtml_files_found:
        print("No XHTML files found in the specified directory.")
    else:
        print("Removed files:")
        for file in removed_files:
            print(file)

directory = './OEBPS/texts'
delete_files_with_tei_tag(directory)