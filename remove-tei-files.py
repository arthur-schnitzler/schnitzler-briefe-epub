import os
import re

def delete_files_with_tei_tag(directory):
    tei_pattern = re.compile(r'<TEI\b[^>]*>.*?</TEI>', re.DOTALL | re.IGNORECASE)
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.xhtml'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    if contains_tei_tag(content, tei_pattern):
                        os.remove(file_path)
                        print(f"Deleted file: {file_path}")
                except IOError:
                    print(f"Error reading file: {file_path}")

def contains_tei_tag(content, tei_pattern):
    return bool(tei_pattern.search(content))

directory = './OEBPS/texts'
delete_files_with_tei_tag(directory)