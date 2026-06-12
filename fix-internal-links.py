import glob
import os
import re

# Schreibt in den transformierten Briefen (OEBPS/texts/L0*.xhtml) alle lokalen
# Links um, deren Ziel im Epub nicht existiert: Querverweise auf nicht (oder
# noch nicht) publizierte Briefe, andere Editionsteile (Texte, Umfeldtexte
# usw.), Tagebuch-Daten und PMB-Entitäten zeigen sonst ins Leere. Solche Links
# werden auf die Online-Ausgabe umgeleitet.
#
# Muss nach remove-tei-files.py laufen, wenn der endgültige Dateibestand in
# OEBPS/texts feststeht.

TEXTS_DIR = "./OEBPS/texts"
ONLINE_BASE = "https://schnitzler-briefe.acdh.oeaw.ac.at/"
TAGEBUCH_BASE = "https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__"

existing = set(os.listdir(TEXTS_DIR))

HREF_PATTERN = re.compile(r'href="([^":#/]+)"')


def rewrite(match):
    target = match.group(1)
    if target in existing:
        return match.group(0)
    # Tagebuch-Datum, z. B. 1911-10-29
    if re.fullmatch(r"\d{4}-\d{2}-\d{2}", target):
        return f'href="{TAGEBUCH_BASE}{target}.html"'
    # alles andere auf die Online-Ausgabe umleiten
    if target.endswith(".xhtml"):
        target = target[: -len(".xhtml")] + ".html"
    elif not target.endswith(".html"):
        target = target + ".html"
    return f'href="{ONLINE_BASE}{target}"'


changed = 0
rewritten = 0
for path in glob.glob(os.path.join(TEXTS_DIR, "L0*.xhtml")):
    with open(path, encoding="utf-8") as f:
        content = f.read()
    new_content, count = HREF_PATTERN.subn(rewrite, content)
    if count and new_content != content:
        with open(path, "w", encoding="utf-8") as f:
            f.write(new_content)
        changed += 1
        rewritten += sum(
            1 for m in HREF_PATTERN.finditer(content) if m.group(1) not in existing
        )

print(f"{rewritten} tote Links in {changed} Dateien auf die Online-Ausgabe umgeleitet")
