import os

directory = "./OEBPS/texts"

def parse_xhtml_files(directory):
    xhtml_files_found = False  # Flag to track if any XHTML files are found
    corrected_files = []  # List to store the names of the corrected files
    
    for filename in os.listdir(directory):
        if filename.startswith("L0") and filename.endswith(".xhtml"):
            xhtml_files_found = True  # Set the flag to True
            filepath = os.path.join(directory, filename)
            
            try:
                with open(filepath, "r") as file:
                    content = file.read()

                updated_content = content.replace(' xmlns=""', '')

                with open(filepath, "w") as file:
                    file.write(updated_content)
                
                corrected_files.append(filename)  # Add the filename to the corrected files list
                    
            except Exception as e:
                print(f"Error processing file '{filepath}': {str(e)}")

    if not xhtml_files_found:
        print("No XHTML files found in the specified directory.")
    else:
        print(f"Number of XHTML files corrected: {len(corrected_files)}")
        print("Corrected files:")
        for filename in corrected_files:
            print(filename)

parse_xhtml_files(directory)