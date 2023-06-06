import os
import xml.etree.ElementTree as ET

# Set the path to the editions directory
editions_dir = "./editions"

# Get the absolute path to the editions directory
editions_path = os.path.abspath(editions_dir)

# Loop through each XML file in the editions directory
for filename in os.listdir(editions_path):
    if filename.endswith(".xml"):
        file_path = os.path.join(editions_path, filename)
        tree = ET.parse(file_path)
        root = tree.getroot()

        # Define the TEI namespace
        namespace = {"tei": "http://www.tei-c.org/ns/1.0"}

        # Find the revisionDesc with the attribute "status" equal to "approved"
        revision_desc = root.find(".//tei:revisionDesc[@status='approved']", namespace)

        if revision_desc is None:
            # Delete the file if revisionDesc with "approved" status is not found
            os.remove(file_path)
            print(f"Deleted file: {filename}")
        else:
            print(f"File {filename} is approved.")