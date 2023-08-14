<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" version="3.0"
    exclude-result-prefixes="tei xhtml">
    
    <xsl:output method="xhtml" indent="yes"/>
    
    <xsl:mode on-no-match="shallow-skip"/>

    <xsl:key name="doc-by-year" match="xhtml:html"
        use="substring-before(xhtml:head/xhtml:meta[@name = 'date']/@content, '-')"/>

    <xsl:template match="/">
        <xsl:variable name="relevant-docs"
            select="collection('../OEBPS/texts?select=L0*.xhtml;recurse=yes')/xhtml:html"/>

        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>Korrespondenzstücke nach Jahren</title>
            </head>
            <body>
                <div>
                    <h1>Korrespondenzstücke nach Jahren</h1>
                    <ul class="toc-list">
                        <!-- Group and sort relevant documents by year and ISO date -->
                        <xsl:for-each-group select="$relevant-docs"
                            group-by="substring(xhtml:head/xhtml:meta[@name = 'date']/@content, 1, 10)">
                            <xsl:sort select="current-grouping-key()" data-type="text"/>
                            <xsl:sort select="xhtml:head/xhtml:meta[@name = 'date']/@content"
                                data-type="text"/>
                            <xsl:sort select="xhtml:head/xhtml:meta[@name = 'n']/@content"
                                data-type="text"/>

                            <!-- Get the earliest document within the group -->
                            <xsl:variable name="earliest-doc" select="current-group()[1]"/>

                            <!-- Get the ID of the earliest document -->
                            <xsl:variable name="earliest-id"
                                select="$earliest-doc//xhtml:head/xhtml:meta[@name = 'id']/@content"/>

                            <!-- Create the list item for the current year if it’s the earliest document -->
                            <xsl:choose>
                                <xsl:when test="$earliest-id">
                                    <li>
                                        <a href="{$earliest-id}.xhtml">
                                            <span class="title">
                                                <xsl:value-of
                                                  select="substring(current-grouping-key(), 1, 4)"/>
                                            </span>
                                        </a>
                                    </li>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </ul>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
