import datetime
import json
import os
import re
import shutil
import unicodedata
import zipfile
from xml.sax.saxutils import escape

# Baut fuer jede Korrespondenz (laut ./correspondences.json, erzeugt von
# extract-correspondences.py) ein eigenes Epub aus den bereits transformierten
# Dateien in OEBPS. Muss nach dem kompletten Epub-Build laufen, wenn
# OEBPS/texts/*.xhtml vorliegen. Ausgabe: out/korrespondenzen/*.epub

ROOT = os.path.dirname(os.path.abspath(__file__))
TEXTS_DIR = os.path.join(ROOT, "OEBPS", "texts")
OUT_DIR = os.path.join(ROOT, "out", "korrespondenzen")
ONLINE_BASE = "https://schnitzler-briefe.acdh.oeaw.ac.at/"

EDITORS = ["Müller, Martin Anton", "Susen, Gerd-Hermann", "Untner, Laura"]

MONTH_NAMES = [
    "Januar", "Februar", "März", "April", "Mai", "Juni",
    "Juli", "August", "September", "Oktober", "November", "Dezember",
]


def german_date(date):
    return f"{date.day}. {MONTH_NAMES[date.month - 1]} {date.year}"


def display_name(name):
    """'Mamroth, Fedor' -> 'Fedor Mamroth'"""
    parts = name.split(", ", 1)
    if len(parts) == 2:
        return f"{parts[1]} {parts[0]}"
    return name


def slugify(name):
    replacements = {
        "ä": "ae", "ö": "oe", "ü": "ue", "Ä": "Ae", "Ö": "Oe", "Ü": "Ue", "ß": "ss",
    }
    for src, repl in replacements.items():
        name = name.replace(src, repl)
    name = unicodedata.normalize("NFKD", name)
    name = "".join(c for c in name if not unicodedata.combining(c))
    name = re.sub(r"[^A-Za-z0-9]+", "-", name).strip("-").lower()
    return name


def read_letter_meta(letter_id):
    path = os.path.join(TEXTS_DIR, f"{letter_id}.xhtml")
    with open(path, encoding="utf-8") as f:
        text = f.read()
    title = re.search(r"<title>(.*?)</title>", text, re.DOTALL)
    date = re.search(r'<meta name="date" content="([^"]*)"', text)
    n = re.search(r'<meta name="n" content="([^"]*)"', text)
    return {
        "id": letter_id,
        "text": text,
        # Titel ist im Quelldokument bereits XML-escaped
        "title": title.group(1).strip() if title else letter_id,
        "date": date.group(1) if date else "",
        "n": n.group(1) if n else "",
    }


def rewrite_links(text, included_ids):
    """Links auf Briefe, die nicht in diesem Epub enthalten sind,
    auf die Online-Ausgabe umleiten."""

    def repl(match):
        letter_id = match.group(1)
        if letter_id in included_ids:
            return match.group(0)
        return f'href="{ONLINE_BASE}{letter_id}.html"'

    return re.sub(r'href="(L0\d+)\.xhtml"', repl, text)


def build_content_opf(corr_id, title, letters):
    items = []
    spine = []
    for letter in letters:
        items.append(
            f'        <item id="{letter["id"]}" href="texts/{letter["id"]}.xhtml" '
            f'media-type="application/xhtml+xml"/>'
        )
        spine.append(f'        <itemref idref="{letter["id"]}"/>')
    return f"""<package xmlns="http://www.idpf.org/2007/opf" version="2.0" unique-identifier="asbw-epub">
    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
        <dc:identifier id="asbw-epub">asbw-epub-{corr_id}</dc:identifier>
        <dc:title>{escape(title)}</dc:title>
        <dc:creator>Müller, Martin Anton</dc:creator>
        <dc:creator>Susen, Gerd-Hermann</dc:creator>
        <dc:creator>Untner, Laura</dc:creator>
        <dc:publisher>Austrian Centre for Digital Humanities and Cultural Heritage at the Austrian Academy of Sciences</dc:publisher>
        <dc:language>German</dc:language>
        <dc:date>{datetime.date.today().year}</dc:date>
        <dc:subject>Arthur Schnitzler’s literary correspondences</dc:subject>
    </metadata>
    <manifest>
        <item id="cover-html" href="texts/cover.xhtml" media-type="application/xhtml+xml"/>
        <item id="inhaltsverzeichnis" href="inhaltsverzeichnis.ncx" media-type="application/x-dtbncx+xml"/>
        <item id="titel" href="texts/titel.xhtml" media-type="application/xhtml+xml"/>
        <item id="rechte" href="texts/rechte.xhtml" media-type="application/xhtml+xml"/>
        <item id="vorbemerkung" href="texts/vorbemerkung.xhtml" media-type="application/xhtml+xml"/>
        <item id="toc-years" href="texts/toc-years.xhtml" media-type="application/xhtml+xml"/>
{chr(10).join(items)}
        <item id="inhalt" href="texts/inhalt.xhtml" media-type="application/xhtml+xml"/>
        <item id="css" href="styles/stylesheet.css" media-type="text/css"/>
        <item id="cover.jpg" href="images/cover.jpg" media-type="image/jpeg"/>
    </manifest>
    <spine toc="inhaltsverzeichnis">
        <itemref idref="cover-html" linear="no"/>
        <itemref idref="titel"/>
        <itemref idref="rechte"/>
        <itemref idref="vorbemerkung"/>
        <itemref idref="toc-years"/>
{chr(10).join(spine)}
        <itemref idref="inhalt"/>
    </spine>
    <guide>
        <reference type="cover" title="Cover" href="texts/cover.xhtml"/>
        <reference type="text" title="Titel" href="texts/titel.xhtml"/>
    </guide>
</package>
"""


def build_ncx(corr_id, title, letters):
    nav_points = []
    play_order = 5
    for letter in letters:
        play_order += 1
        nav_points.append(f"""        <navPoint id="{letter["id"]}" playOrder="{play_order}">
            <navLabel>
                <text>{letter["title"]}</text>
            </navLabel>
            <content src="texts/{letter["id"]}.xhtml"/>
        </navPoint>""")
    play_order += 1
    return f"""<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1" xml:lang="de">
    <head>
        <meta name="dtb:uid" content="asbw-epub-{corr_id}"/>
        <meta content="0" name="dtb:totalPageCount"/>
        <meta content="0" name="dtb:maxPageNumber"/>
    </head>
    <docTitle>
        <text>{escape(title)}</text>
    </docTitle>
    <docAuthor>
        <text>Müller, Martin Anton</text>
    </docAuthor>
    <docAuthor>
        <text>Susen, Gerd-Hermann</text>
    </docAuthor>
    <docAuthor>
        <text>Untner, Laura</text>
    </docAuthor>
    <navMap>
        <navPoint id="cover" playOrder="1">
            <navLabel>
                <text>Cover</text>
            </navLabel>
            <content src="texts/cover.xhtml"/>
        </navPoint>
        <navPoint id="titel" playOrder="2">
            <navLabel>
                <text>Titelblatt</text>
            </navLabel>
            <content src="texts/titel.xhtml"/>
        </navPoint>
        <navPoint id="rechte" playOrder="3">
            <navLabel>
                <text>Rechtehinweis</text>
            </navLabel>
            <content src="texts/rechte.xhtml"/>
        </navPoint>
        <navPoint id="vorbemerkung" playOrder="4">
            <navLabel>
                <text>Vorbemerkung</text>
            </navLabel>
            <content src="texts/vorbemerkung.xhtml"/>
        </navPoint>
        <navPoint id="toc-years" playOrder="5">
            <navLabel>
                <text>Korrespondenzstücke nach Jahren</text>
            </navLabel>
            <content src="texts/toc-years.xhtml"/>
        </navPoint>
{chr(10).join(nav_points)}
        <navPoint id="toc" playOrder="{play_order}">
            <navLabel>
                <text>Alle Korrespondenzstücke</text>
            </navLabel>
            <content src="texts/inhalt.xhtml"/>
        </navPoint>
    </navMap>
</ncx>
"""


def build_inhalt(letters):
    entries = []
    for letter in letters:
        entries.append(
            f'                <li><a href="{letter["id"]}.xhtml">'
            f'<span class="title">{letter["title"]}</span></a></li>'
        )
    return f"""<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Alle Korrespondenzstücke</title>
    </head>
    <body>
        <div>
            <h1>Alle Korrespondenzstücke</h1>
            <ul class="toc-list">
{chr(10).join(entries)}
            </ul>
        </div>
    </body>
</html>
"""


def build_toc_years(letters):
    first_of_year = {}
    for letter in letters:
        year = letter["date"][:4]
        if re.match(r"\d{4}$", year) and year not in first_of_year:
            first_of_year[year] = letter["id"]
    entries = [
        f'                <li><a href="{letter_id}.xhtml">'
        f'<span class="title">{year}</span></a></li>'
        for year, letter_id in sorted(first_of_year.items())
    ]
    return f"""<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Korrespondenzstücke nach Jahren</title>
    </head>
    <body>
        <div>
            <h1>Korrespondenzstücke nach Jahren</h1>
            <ul class="toc-list">
{chr(10).join(entries)}
            </ul>
        </div>
    </body>
</html>
"""


def build_titel(person, year_range):
    heading = f"Briefwechsel mit {escape(person)}"
    if year_range:
        heading += f" ({year_range})"
    title = f"Arthur Schnitzler: Briefwechsel mit {escape(person)}"
    today = german_date(datetime.date.today())
    editor_metas = "\n".join(
        f'        <meta name="editor" content="{escape(e)}" />' for e in EDITORS
    )
    return f"""<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>{title}</title>
        <meta name="author" content="Schnitzler, Arthur" />
        <meta name="language" content="de" />
        <meta name="description" content="Berufliche Korrespondenz von Arthur Schnitzler (1862–1931) mit {escape(person)}." />
{editor_metas}
        <meta name="DC.Title" content="{title}" />
        <meta name="DC.Type" content="Text" />
        <meta name="DC.Format" content="text/html" />
    </head>
    <body>
        <div>
            <h1>Arthur Schnitzler</h1>
            <h1>{heading}</h1>
        </div>
        <div>
            <p>Herausgegeben von Martin Anton Müller, Gerd-Hermann Susen und Laura
                Untner</p>
        </div>
        <div>
            <p>E-Book basierend auf <a href="{ONLINE_BASE}">{ONLINE_BASE}</a>.</p>
            <p>Stand: {today}.</p>
        </div>
    </body>
</html>
"""


def year_range_of(letters):
    years = sorted({l["date"][:4] for l in letters if re.match(r"\d{4}", l["date"])})
    if not years:
        return ""
    if years[0] == years[-1]:
        return years[0]
    return f"{years[0]}–{years[-1]}"


def write_epub(path, files):
    """files: Liste von (Archivpfad, Inhalt als bytes)."""
    with zipfile.ZipFile(path, "w") as zf:
        # mimetype muss als erster Eintrag unkomprimiert vorliegen
        zf.writestr(
            zipfile.ZipInfo("mimetype"), "application/epub+zip",
            compress_type=zipfile.ZIP_STORED,
        )
        for arcname, data in files:
            zf.writestr(arcname, data, compress_type=zipfile.ZIP_DEFLATED)


def main():
    with open(os.path.join(ROOT, "correspondences.json"), encoding="utf-8") as f:
        correspondences = json.load(f)

    # Verzeichnis leeren, damit keine Epubs verschwundener Korrespondenzen liegen bleiben
    if os.path.isdir(OUT_DIR):
        shutil.rmtree(OUT_DIR)
    os.makedirs(OUT_DIR)

    static_files = []
    for relpath in [
        "META-INF/container.xml",
        "OEBPS/texts/cover.xhtml",
        "OEBPS/texts/rechte.xhtml",
        "OEBPS/texts/vorbemerkung.xhtml",
        "OEBPS/styles/stylesheet.css",
        "OEBPS/images/cover.jpg",
    ]:
        with open(os.path.join(ROOT, relpath), "rb") as f:
            static_files.append((relpath, f.read()))

    built = 0
    for corr_id, entry in sorted(correspondences.items(), key=lambda kv: kv[1]["name"]):
        letter_ids = [
            l for l in entry["letters"]
            if os.path.isfile(os.path.join(TEXTS_DIR, f"{l}.xhtml"))
        ]
        if not letter_ids:
            print(f"{corr_id} ({entry['name']}): keine Briefe vorhanden, übersprungen")
            continue

        letters = [read_letter_meta(l) for l in letter_ids]
        letters.sort(key=lambda l: (l["date"], l["n"], l["id"]))
        included_ids = {l["id"] for l in letters}

        person = display_name(entry["name"])
        title = f"Arthur Schnitzler: Briefwechsel mit {person}"

        files = list(static_files)
        files.append(("OEBPS/content.opf", build_content_opf(corr_id, title, letters).encode("utf-8")))
        files.append(("OEBPS/inhaltsverzeichnis.ncx", build_ncx(corr_id, title, letters).encode("utf-8")))
        files.append(("OEBPS/texts/titel.xhtml", build_titel(person, year_range_of(letters)).encode("utf-8")))
        files.append(("OEBPS/texts/inhalt.xhtml", build_inhalt(letters).encode("utf-8")))
        files.append(("OEBPS/texts/toc-years.xhtml", build_toc_years(letters).encode("utf-8")))
        for letter in letters:
            files.append((
                f'OEBPS/texts/{letter["id"]}.xhtml',
                rewrite_links(letter["text"], included_ids).encode("utf-8"),
            ))

        filename = f"schnitzler-briefe-{slugify(entry['name'])}.epub"
        write_epub(os.path.join(OUT_DIR, filename), files)
        built += 1
        print(f"{filename}: {len(letters)} Briefe ({entry['name']})")

    print(f"\n{built} Epubs nach {OUT_DIR} geschrieben")


if __name__ == "__main__":
    main()
