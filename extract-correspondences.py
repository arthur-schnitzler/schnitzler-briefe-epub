import json
import os
import xml.etree.ElementTree as ET

# Liest aus den TEI-Dateien in ./editions die Zuordnung der Briefe zu den
# Korrespondenzen (tei:correspContext/tei:ref[@type='belongsToCorrespondence'])
# und schreibt sie nach ./correspondences.json.
#
# Muss laufen, solange das editions-Verzeichnis noch existiert (es wird von
# editions-to-epub.xml geloescht), also nach remove-unapproved-files.py und
# vor "ant -f editions-to-epub.xml".

editions_dir = "./editions"
output_file = "./correspondences.json"

namespace = {"tei": "http://www.tei-c.org/ns/1.0"}

correspondences = {}

for filename in sorted(os.listdir(os.path.abspath(editions_dir))):
    if not filename.endswith(".xml"):
        continue
    letter_id = filename[:-4]
    file_path = os.path.join(editions_dir, filename)
    try:
        tree = ET.parse(file_path)
    except ET.ParseError as e:
        print(f"WARNUNG: {filename} konnte nicht geparst werden: {e}")
        continue
    refs = tree.getroot().findall(
        ".//tei:correspContext/tei:ref[@type='belongsToCorrespondence']", namespace
    )
    for ref in refs:
        target = ref.get("target")
        if not target or target == "correspondence_null":
            continue
        name = "".join(ref.itertext()).strip()
        entry = correspondences.setdefault(target, {"name": name, "letters": []})
        if name and not entry["name"]:
            entry["name"] = name
        if letter_id not in entry["letters"]:
            entry["letters"].append(letter_id)

with open(output_file, "w", encoding="utf-8") as f:
    json.dump(correspondences, f, ensure_ascii=False, indent=2)

print(f"{len(correspondences)} Korrespondenzen nach {output_file} geschrieben:")
for corr_id, entry in sorted(correspondences.items(), key=lambda kv: kv[1]["name"]):
    print(f"  {corr_id}: {entry['name']} ({len(entry['letters'])} Briefe)")
