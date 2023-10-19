<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:foo="whatever" version="3.0" exclude-result-prefixes="tei xhtml">

    <xsl:output method="xhtml" indent="yes"/>

    <xsl:mode on-no-match="shallow-skip"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren</title>
                <meta name="author" content="Schnitzler, Arthur"/>
                <meta name="language" content="de"/>
                <meta name="description"
                    content="Berufliche Korrespondenzen von Arthur Schnitzler (1862–1931) mit Autorinnen und Autoren."/>
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
                    <h1>Arthur Schnitzler</h1>
                    <h1>Briefwechsel mit Autorinnen und Autoren (1888–1931)</h1>
                </div>
                <div>
                    <p>Herausgegeben von Martin Anton Müller, Gerd-Hermann Susen und Laura
                        Untner</p>
                </div>
                <div>
                    <p>E-Book basierend auf <a href="https://schnitzler-briefe.acdh.oeaw.ac.at/"
                            >https://schnitzler-briefe.acdh.oeaw.ac.at/</a>.</p>
                    <xsl:variable name="currentDate" select="current-date()"/>
                    <p>Stand: <xsl:value-of select="foo:format-date-german($currentDate)"/>.</p>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:function name="foo:format-date-german">
        <xsl:param name="date" as="xs:date"/>
        <xsl:variable name="year" select="format-number(year-from-date($date), '0000')"/>
        <xsl:variable name="month" select="month-from-date($date)"/>
        <xsl:variable name="day" select="day-from-date($date)"/>
        <xsl:variable name="month-name" as="xs:string" select="
                (
                'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
                'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'
                )[$month]"/>
        <xsl:sequence select="concat($day, '. ', $month-name, ' ', $year)"/>
    </xsl:function>

</xsl:stylesheet>
