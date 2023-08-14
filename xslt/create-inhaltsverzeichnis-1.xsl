<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/" version="3.0"
    exclude-result-prefixes="tei xhtml ncx">

    <xsl:output method="xhtml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:mode on-no-match="shallow-skip"/>

    <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>

    <xsl:template match="ncx:navPoint[@id = 'x']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="/">
        <xsl:element name="ncx" namespace="http://www.daisy.org/z3986/2005/ncx/">
            <xsl:attribute name="version">
                <xsl:text>2005-1</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
            </xsl:attribute>
            <xsl:element name="head" namespace="http://www.daisy.org/z3986/2005/ncx/">
                <xsl:element name="meta" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:attribute name="name">
                        <xsl:text>dtb:uid</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="content">
                        <xsl:text>asbw-epub</xsl:text>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="meta" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:attribute name="content">
                        <xsl:text>0</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:text>dtb:totalPageCount</xsl:text>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="meta" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:attribute name="content">
                        <xsl:text>0</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:text>dtb:maxPageNumber</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:element name="docTitle" namespace="http://www.daisy.org/z3986/2005/ncx/">
                <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:text>Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="docAuthor" namespace="http://www.daisy.org/z3986/2005/ncx/">
                <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:text>Müller, Martin Anton</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="docAuthor" namespace="http://www.daisy.org/z3986/2005/ncx/">
                <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:text>Susen, Gerd-Hermann</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="docAuthor" namespace="http://www.daisy.org/z3986/2005/ncx/">
                <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:text>Untner, Laura</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="navMap" namespace="http://www.daisy.org/z3986/2005/ncx/">
                <xsl:element name="navPoint" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:attribute name="id">
                        <xsl:text>cover</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="playOrder">
                        <xsl:text>1</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="navLabel" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                            <xsl:text>Cover</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="content" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:attribute name="src">
                            <xsl:text>texts/cover.xhtml</xsl:text>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="navPoint" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:attribute name="id">
                        <xsl:text>titel</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="playOrder">
                        <xsl:text>2</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="navLabel" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                            <xsl:text>Titelblatt</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="content" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:attribute name="src">
                            <xsl:text>texts/titel.xhtml</xsl:text>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="navPoint" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:attribute name="id">
                        <xsl:text>rechte</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="playOrder">
                        <xsl:text>3</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="navLabel" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                            <xsl:text>Rechtehinweis</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="content" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:attribute name="src">
                            <xsl:text>texts/rechte.xhtml</xsl:text>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="navPoint" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:attribute name="id">
                        <xsl:text>vorbemerkung</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="playOrder">
                        <xsl:text>4</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="navLabel" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                            <xsl:text>Vorbemerkung</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="content" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:attribute name="src">
                            <xsl:text>texts/vorbemerkung.xhtml</xsl:text>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="navPoint" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:attribute name="id">
                        <xsl:text>toc-years</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="playOrder">
                        <xsl:text>5</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="navLabel" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                            <xsl:text>Korrespondenzstücke nach Jahren</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="content" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:attribute name="src">
                            <xsl:text>texts/toc-years.xhtml</xsl:text>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:copy-of select="ncx:navPoint[@id = 'toc']"/>
                <xsl:for-each
                    select="collection(concat($folderURI, '/?select=L0*.xhtml;recurse=yes'))">
                    <xsl:sort select="//xhtml:meta[@name = 'date']/@content" order="ascending"/>
                    <xsl:sort select="//xhtml:meta[@name = 'n']/@content" order="ascending"/>
                    <xsl:element name="navPoint" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:attribute name="id">
                            <xsl:value-of select="//xhtml:meta[@name = 'id']/@content"/>
                        </xsl:attribute>
                        <xsl:attribute name="playOrder">
                            <xsl:number value="position() + 5" format="1"/>
                        </xsl:attribute>
                        <xsl:element name="navLabel"
                            namespace="http://www.daisy.org/z3986/2005/ncx/">
                            <xsl:element name="text"
                                namespace="http://www.daisy.org/z3986/2005/ncx/">
                                <xsl:copy-of select="//xhtml:title/text()"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="content" namespace="http://www.daisy.org/z3986/2005/ncx/">
                            <xsl:attribute name="src">
                                <xsl:value-of
                                    select="concat('texts/', //xhtml:meta[@name = 'id']/@content, '.xhtml')"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <xsl:element name="navPoint" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:attribute name="id">
                        <xsl:text>toc</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="playOrder">
                        <xsl:text>0</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="navLabel" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                            <xsl:text>Alle Korrespondenzstücke</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="content" namespace="http://www.daisy.org/z3986/2005/ncx/">
                        <xsl:attribute name="src">
                            <xsl:text>inhalt.xhtml</xsl:text>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
