<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" version="3.0"
    exclude-result-prefixes="tei xhtml">

    <xsl:output method="xhtml"/>

    <xsl:mode on-no-match="shallow-skip"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren</title>
                <meta name="editor" content="Müller, Martin Anton"/>
                <meta name="editor" content="Susen, Gerd-Hermann"/>
                <meta name="editor" content="Untner, Laura"/>
                <meta name="DC.Title"
                    content="Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren"/>
                <meta name="DC.Type" content="Text"/>
                <meta name="DC.Format" content="text/html"/>
            </head>
            <body>
                <div>
                    <h1>Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren</h1>
                </div>
                <div>
                    <p>Herausgegeben von Martin Anton Müller, Gerd-Hermann Susen und Laura
                        Untner</p>
                </div>
                <div>
                    <p>Diese Edition basiert auf der digitalen kritischen Edition der Briefwechsel
                        Arthur Schnitzlers mit Autorinnen und Autoren (<a
                            href="https://schnitzler-briefe.acdh.oeaw.ac.at/"
                            >https://schnitzler-briefe.acdh.oeaw.ac.at/</a>).</p>
                    <p>Dieses E-Book wird, wie die digitale Edition, immer wieder aktualisiert.
                        Zuletzt: <xsl:value-of select="fn:current-date()"/>.</p>
                    <p>Die der Edition zugrundeliegenden Daten können unter <a
                            href="https://github.com/arthur-schnitzler/schnitzler-briefe-epub"
                            >https://github.com/arthur-schnitzler/schnitzler-briefe-epub</a> geladen
                        werden.</p>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
