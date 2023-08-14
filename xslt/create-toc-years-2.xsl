<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" version="3.0"
    exclude-result-prefixes="tei xhtml">

    <xsl:output method="xhtml" indent="yes"/>

    <xsl:mode on-no-match="shallow-skip"/>

    <xsl:key name="year-key" match="xhtml:li" use="xhtml:a/xhtml:span[@class = 'title']"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>Korrespondenzstücke nach Jahren</title>
            </head>
            <body>
                <div>
                    <h1>Korrespondenzstücke nach Jahren</h1>
                    <ul class="toc-list">
                        <xsl:for-each
                            select="//xhtml:li[generate-id() = generate-id(key('year-key', xhtml:a/xhtml:span[@class = 'title'])[1])]">
                            <li>
                                <a href="{xhtml:a/@href}">
                                    <span class="title">
                                        <xsl:value-of select="xhtml:a/xhtml:span/text()"/>
                                    </span>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
