import os

directory = "./OEBPS/texts"

def parse_xhtml_files(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".xhtml"):
            filepath = os.path.join(directory, filename)
            with open(filepath, "r") as file:
                content = file.read()
            
            updated_content = content.replace(' xmlns=""', '')

            with open(filepath, "w") as file:
                file.write(updated_content)

parse_xhtml_files(directory)