<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/" version="3.0"
    exclude-result-prefixes="tei xhtml ncx">

    <xsl:output method="xhtml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="ncx:navPoint[@playOrder = '0']">
        <xsl:variable name="maxPlayOrder" select="max(//ncx:navPoint/@playOrder)"/>
        <xsl:element name="navPoint" namespace="http://www.daisy.org/z3986/2005/ncx/">
            <xsl:attribute name="id">
                <xsl:text>toc</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="playOrder">
                <xsl:value-of select="$maxPlayOrder + 1"/>
            </xsl:attribute>
            <xsl:element name="navLabel" namespace="http://www.daisy.org/z3986/2005/ncx/">
                <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/">
                    <xsl:text>Alle Korrespondenzstücke</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="content" namespace="http://www.daisy.org/z3986/2005/ncx/">
                <xsl:attribute name="src">
                    <xsl:text>texts/inhalt.xhtml</xsl:text>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
