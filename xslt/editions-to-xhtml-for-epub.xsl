<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:mam="whatever" version="3.0"
    exclude-result-prefixes="#all">

    <xsl:output method="xhtml" omit-xml-declaration="no" indent="yes"/>

    <xsl:mode on-no-match="shallow-skip"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>
                    <xsl:copy-of select="//tei:titleStmt/tei:title[@level = 'a']/text()"/>
                </title>
                <meta>
                    <xsl:attribute name="name">
                        <xsl:text>id</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="content">
                        <xsl:value-of select="tei:TEI/@xml:id"/>
                    </xsl:attribute>
                </meta>
                <meta>
                    <xsl:attribute name="name">
                        <xsl:text>date</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="content">
                        <xsl:if test="//tei:correspAction[@type = 'sent']//tei:date/@when">
                            <xsl:value-of
                                select="//tei:correspAction[@type = 'sent']//tei:date/@when"/>
                        </xsl:if>
                        <xsl:if test="//tei:correspAction[@type = 'sent']//tei:date/@notBefore">
                            <xsl:text>zwischen </xsl:text>
                            <xsl:value-of
                                select="//tei:correspAction[@type = 'sent']//tei:date/@notBefore"/>
                            <xsl:text> und </xsl:text>
                            <xsl:value-of
                                select="//tei:correspAction[@type = 'sent']//tei:date/@notAfter"/>
                        </xsl:if>
                    </xsl:attribute>
                </meta>
                <meta>
                    <xsl:attribute name="name">
                        <xsl:text>n</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="content">
                        <xsl:value-of select="//tei:correspAction[@type = 'sent']//tei:date/@n"/>
                    </xsl:attribute>
                </meta>
                <meta name="series"
                    content="Arthur Schnitzlers Briefwechsel mit Autorinnen und Autoren"/>
                <meta name="editor" content="Martin Anton Müller"/>
                <meta name="editor" content="Gerd-Hermann Susen"/>
                <meta name="editor" content="Laura Untner"/>
                <meta name="publisher"
                    content="Austrian Centre for Digital Humanities and Cultural Heritage"/>
            </head>
            <body style="font-family: serif; text-align: left;">
                <!-- Titel -->
                <h4>
                    <xsl:text>Korrespondenzstück </xsl:text>
                    <xsl:value-of select="tei:TEI/@xml:id"/>
                </h4>
                <h2>
                    <xsl:copy-of select="//tei:titleStmt/tei:title[@level = 'a']/text()"/>
                </h2>
                <!-- Text -->
                <div class="text">
                    <xsl:apply-templates select="//tei:body"/>
                </div>
                <!-- Fußnoten -->
                <xsl:if test="//tei:note[@type = 'footnote']">
                    <div class="footnote" style="font-size: smaller;">
                        <xsl:apply-templates select="//tei:note[@type = 'footnote']" mode="footnote"
                        />
                    </div>
                </xsl:if>
                <!-- msDesc -->
                <xsl:if test="//tei:msDesc">
                    <div class="msDesc" style="font-size: smaller;">
                        <br/>
                        <br/>
                        <h4>Manuskriptbeschreibung</h4>
                        <xsl:apply-templates select="//tei:msDesc"/>
                    </div>
                </xsl:if>
                <!-- Kommentar -->
                <xsl:if test="//tei:note[@type = 'commentary' or @type = 'textConst']">
                    <div class="kommentar" style="font-size: smaller;">
                        <br/>
                        <h4>Kommentar</h4>
                        <xsl:apply-templates
                            select="//tei:note[@type = 'textConst' or @type = 'commentary']"
                            mode="kommentaranhang"/>
                    </div>
                </xsl:if>
            </body>
        </html>
    </xsl:template>

    <!-- copy -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- normalize space -->
    <xsl:template match="text()">
        <xsl:if test="normalize-space(.)">
            <xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>

    <!-- body -->
    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- msDesc -->
    <xsl:template match="tei:msDesc">
        <xsl:if test="//tei:witness">
            <xsl:for-each select="//tei:witness">
                <h5>Textzeuge <xsl:value-of select="@n"/></h5>
                <table class="witness">
                    <xsl:if test="//tei:msIdentifier">
                        <tr>
                            <th style="text-align: left;">Signatur</th>
                            <td style="vertical-align: top;">
                                <xsl:for-each select="//tei:msIdentifier/child::*">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="not(position() = last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </td>
                        </tr>
                    </xsl:if>
                    <xsl:if test="//tei:physDesc">
                        <tr>
                            <th style="text-align: left;">Beschreibung</th>
                            <td style="vertical-align: top;">
                                <xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:objectDesc"
                                />
                            </td>
                        </tr>
                        <xsl:if test="tei:msDesc/tei:physDesc/tei:typeDesc">
                            <xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:typeDesc"/>
                        </xsl:if>
                        <xsl:if test="tei:msDesc/tei:physDesc/tei:handDesc">
                            <xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:handDesc"/>
                        </xsl:if>
                        <xsl:if test="tei:msDesc/tei:physDesc/tei:additions">
                            <tr>
                                <th style="text-align: left;">Zufügungen</th>
                                <td/>
                            </tr>
                            <xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:additions"/>
                        </xsl:if>
                    </xsl:if>
                </table>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="//tei:biblStruct">
            <xsl:for-each select="//tei:biblStruct">
                <h5>Druck <xsl:value-of select="position()"/></h5>
                <table class="print">
                    <tr>
                        <th/>
                        <td style="vertical-align: top;">
                            <xsl:value-of select="mam:bibliografische-angabe(.)"/>
                        </td>
                    </tr>
                </table>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:function name="mam:bibliografische-angabe">
        <xsl:param name="biblStruct-input" as="node()"/>
        <xsl:choose>
            <!-- Zuerst Analytic -->
            <xsl:when test="$biblStruct-input/tei:analytic">
                <xsl:value-of select="mam:analytic-angabe($biblStruct-input)"/>
                <xsl:text> </xsl:text>
                <xsl:text>In: </xsl:text>
                <xsl:value-of select="mam:monogr-angabe($biblStruct-input/tei:monogr[last()])"/>
            </xsl:when>
            <!-- Jetzt abfragen ob mehrere monogr -->
            <xsl:when test="count($biblStruct-input/tei:monogr) = 2">
                <xsl:value-of select="mam:monogr-angabe($biblStruct-input/tei:monogr[last()])"/>
                <xsl:text>. Band</xsl:text>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="mam:monogr-angabe($biblStruct-input/tei:monogr[1])"/>
            </xsl:when>
            <!-- Ansonsten ist es eine einzelne monogr -->
            <xsl:otherwise>
                <xsl:value-of select="mam:monogr-angabe($biblStruct-input/tei:monogr[last()])"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(empty($biblStruct-input/tei:monogr//tei:biblScope[@unit = 'sec']))">
            <xsl:text>, Sec. </xsl:text>
            <xsl:value-of select="$biblStruct-input/tei:monogr//tei:biblScope[@unit = 'sec']"/>
        </xsl:if>
        <xsl:if test="not(empty($biblStruct-input/tei:monogr//tei:biblScope[@unit = 'pp']))">
            <xsl:text>, S. </xsl:text>
            <xsl:value-of select="$biblStruct-input/tei:monogr//tei:biblScope[@unit = 'pp']"/>
        </xsl:if>
        <xsl:if test="not(empty($biblStruct-input/tei:monogr//tei:biblScope[@unit = 'col']))">
            <xsl:text>, Sp. </xsl:text>
            <xsl:value-of select="$biblStruct-input/tei:monogr//tei:biblScope[@unit = 'col']"/>
        </xsl:if>
        <xsl:if test="not(empty($biblStruct-input/tei:series))">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="$biblStruct-input/tei:series/tei:title"/>
            <xsl:if test="$biblStruct-input/tei:series/tei:biblScope">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="$biblStruct-input/tei:series/tei:biblScope"/>
            </xsl:if>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:text>.</xsl:text>
    </xsl:function>
    <xsl:function name="mam:analytic-angabe">
        <xsl:param name="gedruckte-quellen" as="node()"/>
        <xsl:variable name="analytic" as="node()" select="$gedruckte-quellen/tei:analytic"/>
        <xsl:choose>
            <xsl:when test="$analytic/tei:author[2]">
                <xsl:value-of
                    select="mam:autor-rekursion($analytic, 1, count($analytic/tei:author))"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:when test="$analytic/tei:author[1]">
                <xsl:value-of select="mam:vorname-vor-nachname($analytic/tei:author)"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="not($analytic/tei:title/@type = 'j')">
                <span class="italic">
                    <xsl:value-of select="normalize-space($analytic/tei:title)"/>
                    <xsl:choose>
                        <xsl:when test="ends-with(normalize-space($analytic/tei:title), '!')"/>
                        <xsl:when test="ends-with(normalize-space($analytic/tei:title), '?')"/>
                        <xsl:otherwise>
                            <xsl:text>.</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($analytic/tei:title)"/>
                <xsl:choose>
                    <xsl:when test="ends-with(normalize-space($analytic/tei:title), '!')"/>
                    <xsl:when test="ends-with(normalize-space($analytic/tei:title), '?')"/>
                    <xsl:otherwise>
                        <xsl:text>.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$analytic/tei:editor[1]">
            <xsl:text>. </xsl:text>
            <xsl:choose>
                <xsl:when test="$analytic/tei:editor[2]">
                    <xsl:text>Hg. </xsl:text>
                    <xsl:value-of
                        select="mam:editor-rekursion($analytic, 1, count($analytic/tei:editor))"/>
                </xsl:when>
                <xsl:when
                    test="$analytic/tei:editor[1] and contains($analytic/tei:editor[1], ', ') and not(count(contains($analytic/tei:editor[1], ' ')) &gt; 2) and not(contains($analytic/tei:editor[1], 'Hg') or contains($analytic/tei:editor[1], 'Hrsg'))">
                    <xsl:text>Hg. </xsl:text>
                    <xsl:value-of select="mam:vorname-vor-nachname($analytic/tei:editor/text())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$analytic/tei:editor/text()"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>.</xsl:text>
        </xsl:if>
    </xsl:function>
    <xsl:function name="mam:editor-rekursion">
        <xsl:param name="monogr" as="node()"/>
        <xsl:param name="autor-count"/>
        <xsl:param name="autor-count-gesamt"/>
        <!-- in den Fällen, wo ein Text unter einem Kürzel erschien, wird zum sortieren der key-Wert verwendet -->
        <xsl:value-of select="mam:vorname-vor-nachname($monogr/tei:editor[$autor-count])"/>
        <xsl:if test="$autor-count &lt; $autor-count-gesamt">
            <xsl:text>, </xsl:text>
            <xsl:value-of
                select="mam:autor-rekursion($monogr, $autor-count + 1, $autor-count-gesamt)"/>
        </xsl:if>
    </xsl:function>
    <xsl:function name="mam:autor-rekursion">
        <xsl:param name="monogr" as="node()"/>
        <xsl:param name="autor-count"/>
        <xsl:param name="autor-count-gesamt"/>
        <!-- in den Fällen, wo ein Text unter einem Kürzel erschien, wird zum sortieren der key-Wert verwendet -->
        <xsl:value-of select="mam:vorname-vor-nachname($monogr/tei:author[$autor-count])"/>
        <xsl:if test="$autor-count &lt; $autor-count-gesamt">
            <xsl:text>, </xsl:text>
            <xsl:value-of
                select="mam:autor-rekursion($monogr, $autor-count + 1, $autor-count-gesamt)"/>
        </xsl:if>
    </xsl:function>
    <xsl:function name="mam:monogr-angabe">
        <xsl:param name="monogr" as="node()"/>
        <xsl:choose>
            <xsl:when test="$monogr/tei:author[2]">
                <xsl:value-of select="mam:autor-rekursion($monogr, 1, count($monogr/tei:author))"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:when test="$monogr/tei:author[1]">
                <xsl:value-of select="mam:vorname-vor-nachname($monogr/tei:author/text())"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:value-of select="$monogr/tei:title"/>
        <xsl:if test="$monogr/tei:editor[1]">
            <xsl:text>. </xsl:text>
            <xsl:choose>
                <xsl:when test="$monogr/tei:editor[2]">
                    <!-- es gibt mehr als einen Herausgeber -->
                    <xsl:text>Hgg. </xsl:text>
                    <xsl:for-each select="$monogr/tei:editor">
                        <xsl:choose>
                            <xsl:when test="contains(., ', ')">
                                <xsl:value-of
                                    select="concat(substring-after(normalize-space(.), ', '), ' ', substring-before(normalize-space(.), ', '))"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="position() = last()"/>
                            <xsl:when test="position() = last() - 1">
                                <xsl:text> und </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>, </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when
                    test="contains($monogr/tei:editor, 'Hg.') or contains($monogr/tei:editor, 'Hrsg.') or contains($monogr/tei:editor, 'erausge') or contains($monogr/tei:editor, 'Edited')">
                    <xsl:value-of select="$monogr/tei:editor"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Hg. </xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains($monogr/tei:editor, ', ')">
                            <xsl:value-of
                                select="concat(substring-after(normalize-space($monogr/tei:editor), ', '), ' ', substring-before(normalize-space($monogr/tei:editor), ', '))"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$monogr/tei:editor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$monogr/tei:edition">
            <xsl:text>. </xsl:text>
            <xsl:value-of select="$monogr/tei:edition"/>
        </xsl:if>
        <xsl:choose>
            <!-- Hier Abfrage, ob es ein Journal ist -->
            <xsl:when test="$monogr/tei:title[@level = 'j']">
                <xsl:value-of select="mam:jg-bd-nr($monogr)"/>
            </xsl:when>
            <!-- Im anderen Fall müsste es ein 'm' für monographic sein -->
            <xsl:otherwise>
                <xsl:if test="$monogr[child::tei:imprint]">
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="mam:imprint-in-index($monogr)"/>
                </xsl:if>
                <xsl:if test="$monogr/tei:biblScope/@unit = 'vol'">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$monogr/tei:biblScope[@unit = 'vol']"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="mam:imprint-in-index">
        <xsl:param name="monogr" as="node()"/>
        <xsl:variable name="imprint" as="node()" select="$monogr/tei:imprint"/>
        <xsl:choose>
            <xsl:when test="$imprint/tei:pubPlace != ''">
                <xsl:value-of select="$imprint/tei:pubPlace" separator=", "/>
                <xsl:choose>
                    <xsl:when test="$imprint/tei:publisher != ''">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="$imprint/tei:publisher"/>
                        <xsl:choose>
                            <xsl:when test="$imprint/tei:date != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$imprint/tei:date"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$imprint/tei:date != ''">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="$imprint/tei:date"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$imprint/tei:publisher != ''">
                        <xsl:value-of select="$imprint/tei:publisher"/>
                        <xsl:choose>
                            <xsl:when test="$imprint/tei:date != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$imprint/tei:date"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$imprint/tei:date != ''">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="$imprint/tei:date"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="mam:jg-bd-nr">
        <xsl:param name="monogr"/>
        <!-- Ist Jahrgang vorhanden, stehts als erstes -->
        <xsl:if test="$monogr//tei:biblScope[@unit = 'jg']">
            <xsl:text>, Jg. </xsl:text>
            <xsl:value-of select="$monogr//tei:biblScope[@unit = 'jg']"/>
        </xsl:if>
        <!-- Ist Band vorhanden, stets auch -->
        <xsl:if test="$monogr//tei:biblScope[@unit = 'vol']">
            <xsl:text>, Bd. </xsl:text>
            <xsl:value-of select="$monogr//tei:biblScope[@unit = 'vol']"/>
        </xsl:if>
        <!-- Jetzt abfragen, wie viel vom Datum vorhanden: vier Stellen=Jahr, sechs Stellen: Jahr und Monat, acht Stellen: komplettes Datum
              Damit entscheidet sich, wo das Datum platziert wird, vor der Nr. oder danach, oder mit Komma am Schluss -->
        <xsl:choose>
            <xsl:when test="string-length($monogr/tei:imprint/tei:date/@when) = 4">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="$monogr/tei:imprint/tei:date"/>
                <xsl:text>)</xsl:text>
                <xsl:if test="$monogr//tei:biblScope[@unit = 'nr']">
                    <xsl:text> Nr. </xsl:text>
                    <xsl:value-of select="$monogr//tei:biblScope[@unit = 'nr']"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="string-length($monogr/tei:imprint/tei:date/@when) = 6">
                <xsl:if test="$monogr//tei:biblScope[@unit = 'nr']">
                    <xsl:text>, Nr. </xsl:text>
                    <xsl:value-of select="$monogr//tei:biblScope[@unit = 'nr']"/>
                </xsl:if>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="normalize-space(($monogr/tei:imprint/tei:date))"/>
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$monogr//tei:biblScope[@unit = 'nr']">
                    <xsl:text>, Nr. </xsl:text>
                    <xsl:value-of select="$monogr//tei:biblScope[@unit = 'nr']"/>
                </xsl:if>
                <xsl:if test="$monogr/tei:imprint/tei:date">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="normalize-space(($monogr/tei:imprint/tei:date))"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- auch noch physDesc -->
    <xsl:template match="tei:incident/tei:desc/tei:stamp">
        <xsl:text>Stempel </xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>:</xsl:text>
        <br/>
        <xsl:if test="tei:placeName"> Ort: <xsl:apply-templates select="./tei:placeName"/>
            <br/>
        </xsl:if>
        <xsl:if test="tei:date"> Datum: <xsl:apply-templates select="./tei:date"/>
            <br/>
        </xsl:if>
        <xsl:if test="tei:time"> Zeit: <xsl:apply-templates select="./tei:time"/>
            <br/>
        </xsl:if>
        <xsl:if test="tei:addSpan"> Vorgang: <xsl:apply-templates select="./tei:addSpan"/>
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:addSpan">
        <span class="addSpan">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:incident">
        <tr>
            <xsl:apply-templates select="tei:desc"/>
        </tr>
    </xsl:template>
    <xsl:template match="tei:additions">
        <xsl:apply-templates select="tei:incident[@type = 'supplement']"/>
        <xsl:apply-templates select="tei:incident[@type = 'postal']"/>
        <xsl:apply-templates select="tei:incident[@type = 'receiver']"/>
        <xsl:apply-templates select="tei:incident[@type = 'archival']"/>
        <xsl:apply-templates select="tei:incident[@type = 'additional-information']"/>
        <xsl:apply-templates select="tei:incident[@type = 'editorial']"/>
    </xsl:template>
    <xsl:template match="tei:incident[@type = 'supplement']/tei:desc">
        <xsl:variable name="poschitzion"
            select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'supplement'])"/>
        <xsl:choose>
            <xsl:when test="$poschitzion &gt; 0">
                <td/>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'supplement'])">
                <th>Beilage</th>
                <td style="vertical-align: top;">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'supplement']">
                <th>Beilagen</th>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'postal']]">
        <xsl:variable name="poschitzion"
            select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'postal'])"/>
        <xsl:choose>
            <xsl:when test="$poschitzion &gt; 0">
                <th/>
                <td style="vertical-align: top;">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'postal'])">
                <th>
                    <xsl:text>Versand</xsl:text>
                </th>
                <td style="vertical-align: top;">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'postal']">
                <th>
                    <xsl:text>Versand</xsl:text>
                </th>
                <td style="vertical-align: top;">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:incident[@type = 'receiver']/tei:desc">
        <xsl:variable name="receiver"
            select="substring-before(ancestor::tei:teiHeader//tei:correspDesc/tei:correspAction[@type = 'received']/tei:persName[1], ',')"/>
        <xsl:variable name="poschitzion"
            select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'receiver'])"/>
        <xsl:choose>
            <xsl:when test="$poschitzion &gt; 0">
                <th>
                    <xsl:value-of select="$receiver"/>
                </th>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'receiver']">
                <th>
                    <xsl:value-of select="$receiver"/>
                </th>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <th>
                    <xsl:value-of select="$receiver"/>
                </th>
                <td style="vertical-align: top;">
                    <xsl:apply-templates/>
                </td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'archival']]">
        <xsl:variable name="poschitzion"
            select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'archival'])"/>
        <xsl:choose>
            <xsl:when test="$poschitzion &gt; 0">
                <td/>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'archival'])">
                <th>
                    <xsl:text>Ordnung</xsl:text>
                </th>
                <td style="vertical-align: top;">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'archival']">
                <th>
                    <xsl:text>Ordnung</xsl:text>
                </th>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'additional-information']]">
        <xsl:variable name="poschitzion"
            select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'additional-information'])"/>
        <xsl:choose>
            <xsl:when test="$poschitzion &gt; 0">
                <td/>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'additional-information'])">
                <th>
                    <xsl:text>Zusatz</xsl:text>
                </th>
                <td style="vertical-align: top;">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'additional-information']">
                <th>
                    <xsl:text>Zusatz</xsl:text>
                </th>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'editorial']]">
        <xsl:variable name="poschitzion"
            select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'editorial'])"/>
        <xsl:choose>
            <xsl:when test="$poschitzion &gt; 0">
                <td/>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'editorial'])">
                <th>Editorischer Hinweis</th>
                <td style="vertical-align: top;">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'editorial']">
                <th>Editorischer Hinweise</th>
                <td style="vertical-align: top;">
                    <xsl:value-of select="$poschitzion + 1"/>
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:typeDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:typeDesc/tei:p">
        <tr>
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::tei:p)">
                    <th>Typografie</th>
                </xsl:when>
                <xsl:otherwise>
                    <th/>
                </xsl:otherwise>
            </xsl:choose>
            <td style="vertical-align: top;">
                <xsl:apply-templates/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="tei:handDesc">
        <xsl:choose>
            <!-- Nur eine Handschrift, diese demnach vom Autor/der Autorin: -->
            <xsl:when test="not(child::tei:handNote[2]) and not(tei:handNote/@corresp)">
                <tr>
                    <th style="text-align: left;">Handschrift</th>
                    <td style="vertical-align: top;">
                        <xsl:value-of select="mam:handNote(tei:handNote)"/>
                    </td>
                </tr>
            </xsl:when>
            <!-- Nur eine Handschrift, diese nicht vom Autor/der Autorin: -->
            <xsl:when test="not(child::tei:handNote[2]) and (tei:handNote/@corresp)">
                <xsl:choose>
                    <xsl:when test="handNote/@corresp = 'schreibkraft'">
                        <tr>
                            <th style="text-align: left;">Handschrift einer Schreibkraft</th>
                            <td style="vertical-align: top;">
                                <xsl:value-of select="mam:handNote(tei:handNote)"/>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="sender"
                            select="ancestor::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent']/tei:persName[@ref = tei:handNote/@corresp]"/>
                        <tr>
                            <th style="text-align: left;">Handschrift <xsl:value-of select="$sender"
                                />
                            </th>
                            <td style="vertical-align: top;">
                                <xsl:value-of select="mam:handNote(tei:handNote)"/>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="handDesc-v" select="current()"/>
                <xsl:variable name="sender"
                    select="ancestor::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent']"
                    as="node()"/>
                <xsl:for-each select="distinct-values(tei:handNote/@corresp)">
                    <xsl:variable name="corespi" select="."/>
                    <xsl:variable name="corespi-name" select="$sender/tei:persName[@ref = $corespi]"/>
                    <xsl:choose>
                        <xsl:when test="count($handDesc-v/tei:handNote[@corresp = $corespi]) = 1">
                            <tr>
                                <th style="text-align: left;">Handschrift <xsl:value-of
                                        select="mam:vorname-vor-nachname($corespi-name)"/>
                                </th>
                                <td style="vertical-align: top;">
                                    <xsl:value-of
                                        select="mam:handNote($handDesc-v/tei:handNote[@corresp = $corespi])"
                                    />
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="$handDesc-v/tei:handNote[@corresp = $corespi]">
                                <tr>
                                    <xsl:choose>
                                        <xsl:when test="position() = 1">
                                            <th style="text-align: left;">Handschrift <xsl:value-of
                                                  select="mam:vorname-vor-nachname($corespi-name)"/>
                                            </th>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <th/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <td style="vertical-align: top;">
                                        <xsl:variable name="poschitzon" select="position()"/>
                                        <xsl:value-of select="$poschitzon"/>
                                        <xsl:text>) </xsl:text>
                                        <xsl:value-of select="mam:handNote(current())"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:function name="mam:handNote">
        <xsl:param name="entry" as="node()"/>
        <xsl:choose>
            <xsl:when test="$entry/@medium = 'bleistift'">
                <xsl:text>Bleistift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'roter_buntstift'">
                <xsl:text>roter Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'blauer_buntstift'">
                <xsl:text>blauer Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'gruener_buntstift'">
                <xsl:text>grüner Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'schwarze_tinte'">
                <xsl:text>schwarze Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'blaue_tinte'">
                <xsl:text>blaue Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'gruene_tinte'">
                <xsl:text>grüne Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'rote_tinte'">
                <xsl:text>rote Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'anderes'">
                <xsl:text>anderes Schreibmittel</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="not($entry/@style = 'nicht_anzuwenden')">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$entry/@style = 'deutsche-kurrent'">
                <xsl:text>deutsche Kurrentschrift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@style = 'lateinische-kurrent'">
                <xsl:text>lateinische Kurrentschrift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@style = 'gabelsberger'">
                <xsl:text>Gabelsberger Kurzschrift</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="string-length(normalize-space($entry/.)) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="($entry/.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:objectDesc/tei:desc[@type = '_blaetter']">
        <xsl:choose>
            <xsl:when test="parent::tei:objectDesc/tei:desc/@type = 'karte'">
                <xsl:choose>
                    <xsl:when test="@n = '1'">
                        <xsl:value-of select="concat(@n, ' Karte')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(@n, ' Karten')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@n = '1'">
                        <xsl:value-of select="concat(@n, ' Blatt')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(@n, ' Blätter')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(.) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = '_seiten']">
        <xsl:text>, </xsl:text>
        <xsl:choose>
            <xsl:when test="@n = '1'">
                <xsl:value-of select="concat(@n, ' Seite')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(@n, ' Seiten')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(.) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:if
            test="preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'entwurf' or @type = 'reproduktion'] or following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'entwurf' or @type = 'reproduktion']">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc">
        <xsl:apply-templates
            select="tei:desc[@type = 'karte' or @type = 'bild' or @type = 'kartenbrief' or @type = 'brief' or @type = 'telegramm' or @type = 'widmung' or @type = 'anderes']"/>
        <xsl:apply-templates select="tei:desc[@type = '_blaetter']"/>
        <xsl:apply-templates select="tei:desc[@type = '_seiten']"/>
        <xsl:apply-templates select="tei:desc[@type = 'umschlag']"/>
        <xsl:apply-templates select="tei:desc[@type = 'reproduktion']"/>
        <xsl:apply-templates select="tei:desc[@type = 'entwurf']"/>
        <xsl:apply-templates select="tei:desc[@type = 'fragment']"/>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'karte']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'bildpostkarte'">
                <xsl:text>Bildpostkarte</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'postkarte'">
                <xsl:text>Postkarte</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'briefkarte'">
                <xsl:text>Briefkarte</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'visitenkarte'">
                <xsl:text>Visitenkarte</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Karte</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'reproduktion']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'fotokopie'">
                <xsl:text>Fotokopie</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'fotografische_vervielfaeltigung'">
                <xsl:text>Fotografische Vervielfältigung</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'ms_abschrift'">
                <xsl:text>maschinelle Abschrift</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'hs_abschrift'">
                <xsl:text>handschriftliche Abschrift</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'durchschlag'">
                <xsl:text>maschineller Durchschlag</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Reproduktion</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'widmung']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_vorsatzblatt'">
                <xsl:text>Widmung am Vorsatzblatt</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_titelblatt'">
                <xsl:text>Widmung am Titelblatt</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_vortitel'">
                <xsl:text>Widmung am Vortitel</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_schmutztitel'">
                <xsl:text>Widmung am Schmutztitel</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_umschlag'">
                <xsl:text>Widmung am Umschlag</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Widmung</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'brief']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Brief</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'bild']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'fotografie'">
                <xsl:text>Fotografie</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Bild</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'kartenbrief']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Kartenbrief</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'umschlag']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Umschlag</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'telegramm']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Telegramm</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'anderes']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>XXXXAnderes</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'entwurf']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Entwurf</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'fragment']) or (preceding-sibling::tei:desc[@type = 'fragment'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'fragment']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Fragment</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[not(@type)]">
        <xsl:text>XXXX desc-Fehler</xsl:text>
    </xsl:template>

    <!-- tables -->
    <xsl:template match="tei:table">
        <xsl:variable name="maxCells" select="max(tei:row/count(tei:cell))"/>
        <table>
            <xsl:apply-templates select="tei:row">
                <xsl:with-param name="maxCells" select="$maxCells"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>

    <xsl:template match="tei:row">
        <xsl:param name="maxCells"/>
        <tr>
            <xsl:apply-templates select="tei:cell"/>
            <!-- create additional empty cells if necessary -->
            <xsl:if test="count(tei:cell) &lt; $maxCells">
                <xsl:call-template name="createEmptyCells">
                    <xsl:with-param name="count" select="$maxCells - count(tei:cell)"/>
                </xsl:call-template>
            </xsl:if>
        </tr>
    </xsl:template>

    <xsl:template match="tei:cell">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template name="createEmptyCells">
        <xsl:param name="count"/>
        <xsl:if test="$count > 0">
            <td/>
            <xsl:call-template name="createEmptyCells">
                <xsl:with-param name="count" select="$count - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- exclude notes (except for footnotes) in the main text, but include them in the footnote/comment section -->
    <xsl:template match="tei:note[@type = 'footnote']">
        <sup style="font-size: 0.8em;">
            <xsl:number level="any"/>
        </sup>
    </xsl:template>
    <xsl:template match="tei:note[@type = 'footnote']" mode="footnote">
        <div class="footnote">
            <sup style="font-size: 0.8em;">
                <xsl:number level="any"/>
            </sup>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:note[(@type = 'textConst' or @type = 'commentary')]"/>
    <xsl:template
        match="tei:note[(@type = 'textConst' or @type = 'commentary') and not(ancestor::tei:note[@type = 'footnote'])]"
        mode="kommentaranhang">
        <p>
            <xsl:attribute name="class">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <!-- Der Teil hier bildet das Lemma und kürzt es -->
            <xsl:variable name="lemma-start" as="xs:string"
                select="substring(@xml:id, 1, string-length(@xml:id) - 1)"/>
            <xsl:variable name="lemma-end" as="xs:string" select="@xml:id"/>
            <xsl:variable name="lemmaganz">
                <xsl:for-each-group
                    select="ancestor::tei:*/tei:anchor[@xml:id = $lemma-start]/following-sibling::node()"
                    group-ending-with="tei:note[@xml:id = $lemma-end]">
                    <xsl:if test="position() eq 1">
                        <xsl:apply-templates select="current-group()[position() != last()]"
                            mode="lemma"/>
                    </xsl:if>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:variable name="lemma" as="xs:string">
                <xsl:choose>
                    <xsl:when test="not(contains($lemmaganz, ' '))">
                        <xsl:value-of select="$lemmaganz"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space($lemmaganz)) &gt; 24">
                        <xsl:variable name="lemma-kurz"
                            select="concat(tokenize(normalize-space($lemmaganz), ' ')[1], ' … ', tokenize(normalize-space($lemmaganz), ' ')[last()])"/>
                        <xsl:choose>
                            <xsl:when
                                test="string-length(normalize-space($lemmaganz)) - string-length($lemma-kurz) &lt; 5">
                                <xsl:value-of select="normalize-space($lemmaganz)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$lemma-kurz"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$lemmaganz"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <span class="lemma">
                <xsl:choose>
                    <xsl:when test="string-length($lemma) &gt; 0">
                        <xsl:value-of select="$lemma"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>XXXX Lemmafehler</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>]&#160;</xsl:text>
            </span>
            <span class="kommentar-text">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:apply-templates select="node() except Lemma"/>
            </span>
        </p>
    </xsl:template>

    <xsl:template match="tei:c[@rendition = '#prozent']" mode="lemma">
        <xsl:text>%</xsl:text>
    </xsl:template>

    <xsl:template match="tei:l" mode="lemma">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="tei:c[@rendition = '#dots']" mode="lemma">
        <xsl:value-of select="mam:dots(@n)"/>
    </xsl:template>

    <xsl:template match="tei:c[@rendition = '#langesS']" mode="lemma">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:c[@rendition = '#kaufmannsund']" mode="lemma">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>

    <xsl:template match="tei:c[@rendition = '#tilde']" mode="lemma">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']">~</xsl:template>

    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']" mode="lemma">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']" mode="lemma">
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']" mode="lemma">
        <xsl:text> </xsl:text>
    </xsl:template>



    <xsl:template match="tei:c[@rendition = '#gemination-m']" mode="lemma">
        <span class="gemination">mm</span>
    </xsl:template>

    <xsl:template match="tei:c[@rendition = '#gemination-n']" mode="lemma">
        <span class="gemination">nn</span>
    </xsl:template>

    <!-- anchor löschen -->
    <xsl:template match="tei:anchor">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- title -->
    <xsl:template match="tei:body//tei:title">
        <xsl:if test=".[@level = 'm']">
            <span class="mono-title" style="font-style: italic;">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
        <xsl:if test=".[@level = 'j']">
            <span class="journal-title">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
        <xsl:if test=".[@level = 's']">
            <span class="series-title">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
        <xsl:if test=".[@level = 'a']">
            <span class="article-title">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
    </xsl:template>

    <!-- title in Kommentaren -->
    <xsl:template match="tei:title">
        <xsl:if test=".[@level = 'm']">
            <span class="mono-title" style="font-style: italic;">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
        <xsl:if test=".[@level = 'j']">
            <span class="journal-title">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
        <xsl:if test=".[@level = 's']">
            <span class="series-title">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
        <xsl:if test=".[@level = 'a']">
            <span class="article-title">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
    </xsl:template>

    <!-- bibl -->
    <xsl:template match="tei:bibl">
        <span class="bibl">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- pubPlace -->
    <xsl:template match="tei:pubPlace">
        <span class="pubPlace">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- publisher -->
    <xsl:template match="tei:publisher">
        <span class="publisher">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- div address -->
    <xsl:template match="tei:div[@type = 'address']">
        <div class="address">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- div image -->
    <xsl:template match="tei:div[@type = 'image']"/>

    <!-- address -->
    <xsl:template match="tei:address">
        <p class="address">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- addrLine -->
    <xsl:template match="tei:addrLine">
        <span class="addrLine">
            <xsl:apply-templates/>
        </span>
        <br/>
    </xsl:template>

    <!-- writing sessions -->
    <xsl:template match="tei:div[@type = 'writingSession']">
        <div>
            <xsl:attribute name="class">
                <xsl:text>writingSession</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="content">
                <xsl:value-of select="@n"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- beschädigte Stellen mit kleinen Punkten unterstreichen -->
    <xsl:template match="tei:damage">
        <span class="damage" style="text-decoration: underline; text-decoration-style: dotted;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Umgang mit Lücken -->
    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="@reason = 'deleted'">
                <span class="del gap">
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:when>
            <xsl:when test="@reason = 'illegible'">
                <span class="ill gap">
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:gap[@unit = 'chars' and @reason = 'illegible']">
        <span class="illegible">
            <xsl:value-of select="mam:gaps(@quantity)"/>
        </span>
    </xsl:template>
    <xsl:function name="mam:gaps">
        <xsl:param name="anzahl"/>
        <xsl:text>×</xsl:text>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="mam:gaps($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:gap[@unit = 'lines' and @reason = 'illegible']">
        <div class="illegible">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="@quantity"/>
            <xsl:text> Zeilen unleserlich] </xsl:text>
        </div>
    </xsl:template>
    <xsl:template match="tei:gap[@reason = 'outOfScope']">
        <span class="outOfScope">[…]</span>
    </xsl:template>

    <!-- Datumsangaben -->
    <xsl:template match="tei:date">
        <span class="date">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Umgang mit Streichungen -->
    <xsl:template match="tei:del">
        <del style="text-decoration: line-through;">
            <xsl:apply-templates/>
        </del>
    </xsl:template>

    <!-- Umgang mit handShift -->
    <xsl:template match="tei:handShift[not(@scribe)]">
        <xsl:choose>
            <xsl:when test="@medium = 'typewriter'">
                <span class="typewriter">
                    <xsl:text>[maschinenschriftlich:] </xsl:text>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="handschriftlich">
                    <xsl:text>[handschriftlich:] </xsl:text>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:handShift[@scribe]">
        <xsl:variable name="scribe">
            <xsl:value-of select="@scribe"/>
        </xsl:variable>
        <span class="handschriftlich">
            <xsl:text>[handschriftlich </xsl:text>
            <xsl:value-of
                select="mam:vorname-vor-nachname(ancestor::tei:TEI/descendant::tei:correspDesc//tei:persName[@ref = $scribe])"/>
            <xsl:text>:] </xsl:text>
        </span>
    </xsl:template>
    <xsl:function name="mam:vorname-vor-nachname">
        <xsl:param name="autorname"/>
        <xsl:choose>
            <xsl:when test="contains($autorname, ', ')">
                <xsl:value-of select="substring-after($autorname, ', ')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring-before($autorname, ', ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$autorname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Umgang mit space -->
    <xsl:template match="tei:space">
        <span class="space">
            <xsl:value-of select="
                    string-join((for $i in 1 to @quantity
                    return
                        '&#x00A0;'), '')"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'line']">
        <xsl:value-of select="mam:spaci-space(@quantity, @quantity)"/>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and not(@quantity = 1)]">
        <xsl:variable name="weite" select="0.5 * @quantity"/>
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('display:inline-block; width: ', $weite, 'em; ')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:space[@dim = 'vertical' and not(@unit)]">
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('padding-bottom:', @quantity, 'em;')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:function name="mam:spaci-space">
        <xsl:param name="anzahl"/>
        <xsl:param name="gesamt"/>  <br/>
        <xsl:if test="$anzahl &lt; $gesamt">
            <xsl:value-of select="mam:spaci-space($anzahl, $gesamt)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:milestone[@rend = 'line']">
        <xsl:text>&amp;#10;</xsl:text>
    </xsl:template>

    <!-- Umgang mit Einfügungen -->
    <xsl:template match="tei:add">
        <span>
            <xsl:attribute name="class">
                <xsl:text>add</xsl:text>
            </xsl:attribute>
            <xsl:if test=".[@place]">
                <xsl:attribute name="content">
                    <xsl:value-of select="@place"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:text>&#8595;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&#8595;</xsl:text>
        </span>
    </xsl:template>

    <!-- geogNames übernehmen wie places -->
    <xsl:template match="tei:geogName">
        <span class="place">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Entitätsferenzen -->
    <xsl:template match="tei:rs">
        <span>
            <xsl:if test=".[@type = 'place']">
                <xsl:attribute name="class">
                    <xsl:text>place</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@type = 'person']">
                <xsl:attribute name="class">
                    <xsl:text>person</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@type = 'org']">
                <xsl:attribute name="class">
                    <xsl:text>org</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@type = 'work'] and .[not(ancestor::tei:note)]">
                <xsl:attribute name="class">
                    <xsl:text>work</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@type = 'work'] and .[ancestor::tei:note]">
                <xsl:attribute name="class">
                    <xsl:text>work</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-style: italic;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:placeName">
        <span class="place">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Hervorhebungen -->
    <xsl:template match="tei:hi">
        <span>
            <xsl:if test=".[@rend = 'superscript']">
                <xsl:attribute name="class">
                    <xsl:text>superscript</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>position: relative; top: -0.5em; font-size: 80%;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'subscript']">
                <xsl:attribute name="class">
                    <xsl:text>subscript</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>position: relative; top: 0.5em; font-size: 80%</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'spaced_out']">
                <xsl:attribute name="class">
                    <xsl:text>spaced_out</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>letter-spacing: 2px;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'bold']">
                <xsl:attribute name="class">
                    <xsl:text>bold</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-weight: bold;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'antiqua']">
                <xsl:attribute name="class">
                    <xsl:text>antiqua</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-variant: small-caps;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'capitals']">
                <xsl:attribute name="class">
                    <xsl:text>capitals</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-variant: small-caps;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'small_caps']">
                <xsl:attribute name="class">
                    <xsl:text>small_caps</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-variant: small-caps;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'latintype']">
                <xsl:attribute name="class">
                    <xsl:text>latintype</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-variant: small-caps;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'stamp']">
                <xsl:attribute name="class">
                    <xsl:text>stamp</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-family: sans-serif;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'pre-print']">
                <xsl:attribute name="class">
                    <xsl:text>pre-print</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-family: sans-serif;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'italics']">
                <xsl:attribute name="class">
                    <xsl:text>italics</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-style: italic;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@rend = 'underline']">
                <xsl:attribute name="class">
                    <xsl:text>underline</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:if test="@n = 1">
                        <xsl:text>text-decoration: underline;</xsl:text>
                    </xsl:if>
                    <xsl:if test="@n = 2">
                        <xsl:text>text-decoration:underline;
                    border-bottom: 1px solid #000;</xsl:text>
                    </xsl:if>
                    <xsl:if test="@n = 3">
                        <xsl:text>border-bottom: 3px double; line-height: 1.9em;</xsl:text>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Absätze -->
    <xsl:template
        match="tei:p[not(ancestor::tei:typeDesc) and not(ancestor::tei:desc) and not(ancestor::tei:note) and not(ancestor::tei:quote) and (not(@*) or @rend = 'inline' or @rend = 'left')]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template
        match="tei:p[ancestor::tei:desc or ancestor::tei:note and not(ancestor::tei:quote)]">
        <span class="p">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template
        match="tei:p[(@rend = 'center' or @rend = 'right') and not(ancestor::tei:desc) and not(ancestor::tei:quote)]">
        <p>
            <xsl:if test="@rend">
                <xsl:attribute name="style">
                    <xsl:if test=".[@rend = 'center']">
                        <xsl:text>text-align: center;</xsl:text>
                    </xsl:if>
                    <xsl:if test=".[@rend = 'right']">
                        <xsl:text>text-align: right;</xsl:text>
                    </xsl:if>
                </xsl:attribute></xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- p in Kommentaren -->
    <xsl:template match="tei:p[ancestor::tei:note and not(ancestor::tei:quote)]">
        <p><xsl:apply-templates/></p>
    </xsl:template>

    <!-- p in quote -->
    <xsl:template match="tei:quote/tei:p[position() &lt; last()]">
        <span class="p-in-quote">
            <xsl:apply-templates/>
            <xsl:text> / </xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="tei:quote/tei:p[last()]">
        <span class="p-in-quote">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- postscript -->
    <xsl:template match="tei:postscript">
        <div class="postscript">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- supplied -->
    <xsl:template match="tei:supplied[not(@*)]">
        <span class="supplied">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="tei:supplied[@type = 'image-description']">
        <span class="supplied">
            <xsl:text>[Bildbeschreibung: </xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>

    <!-- Gedichte -->
    <xsl:template match="tei:lg[@type = 'poem']">
        <div class="poem" style="display: block; margin: 1em 0;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'stanza']">
        <p class="stanza" style="display: block; margin: 1em 0;">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:l">
        <span class="line">
            <xsl:apply-templates/>
        </span>
        <br/>
    </xsl:template>

    <!-- dateline -->
    <xsl:template match="tei:dateline[@rend = 'inline']">
        <span class="dateline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:dateline[not(@*) or @rend = 'left']">
        <p class="dateline">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:dateline[@rend = 'center' or @rend = 'right']">
        <p>
            <xsl:attribute name="class">
                <xsl:text>dateline</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="style">
                <xsl:if test=".[@rend = 'center']">
                    <xsl:text>text-align: center;</xsl:text>
                </xsl:if>
                <xsl:if test=".[@rend = 'right']">
                    <xsl:text>text-align: right;</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- salute -->
    <xsl:template match="tei:salute[@rend = 'inline' and not(ancestor::tei:p)]">
        <span class="salute">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:salute[not(@*) or @rend = 'left' and not(ancestor::tei:p)]">
        <span class="salute">
            <xsl:apply-templates/>
        </span>
        <br/>
    </xsl:template>
    <xsl:template match="tei:salute[@rend = 'center' or @rend = 'right' and not(ancestor::tei:p)]">
        <span>
            <xsl:attribute name="class">
                <xsl:text>salute</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="style">
                <xsl:if test=".[@rend = 'center']">
                    <xsl:text>text-align: center;</xsl:text>
                </xsl:if>
                <xsl:if test=".[@rend = 'right']">
                    <xsl:text>text-align: right;</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
        <br/>
    </xsl:template>

    <!-- salute in Absätzen -->
    <xsl:template match="tei:salute[@rend = 'inline' and ancestor::tei:p]">
        <span class="salute">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:salute[not(@*) or @rend = 'left' and ancestor::tei:p]">
        <span class="salute">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:salute[@rend = 'center' or @rend = 'right' and ancestor::tei:p]">
        <span>
            <xsl:attribute name="class">
                <xsl:text>salute</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="style">
                <xsl:if test=".[@rend = 'center']">
                    <xsl:text>text-align: center;</xsl:text>
                </xsl:if>
                <xsl:if test=".[@rend = 'right']">
                    <xsl:text>text-align: right;</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Seitenumbruch -->
    <xsl:template match="tei:pb">
        <xsl:text>&#124;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- seg / side by side -->
    <xsl:template match="tei:seg[@rend = 'left']">
        <span class="seg-left" style="float: left; width: 50%">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:seg[@rend = 'right']">
        <span class="seg-left" style="float: left; width: 50%">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- refs -->
    <xsl:template
        match="tei:ref[not(@type = 'schnitzler-tagebuch') and not(@type = 'schnitzler-briefe') and not(@type = 'schnitzler-bahr') and not(@type = 'schnitzler-lektueren')]">
        <xsl:choose>
            <xsl:when test="@target[ends-with(., '.xml')]">
                <xsl:element name="a">
                    <xsl:attribute name="href"> show.html?ref=<xsl:value-of
                            select="tokenize(./@target, '/')[4]"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[@type = 'schnitzler-tagebuch']">
        <xsl:choose>
            <xsl:when test="@subtype = 'date-only'">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', @target, '.html')"
                        />
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@target = ''">
                            <xsl:text>FEHLER</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="format-date(@target, '[D].&#160;[M].&#160;[Y]')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@subtype = 'See'">
                        <xsl:text>Siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'Cf'">
                        <xsl:text>Vgl. </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'see'">
                        <xsl:text>siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'cf'">
                        <xsl:text>vgl. </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', @target, '.html')"
                        />
                    </xsl:attribute>
                    <xsl:text>A. S.: Tagebuch, </xsl:text>
                    <xsl:value-of select="format-date(@target, '[D].&#160;[M].&#160;[Y]')"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template
        match="tei:ref[@type = 'schnitzler-briefe' or @type = 'schnitzler-bahr' or @type = 'schnitzler-lektueren']">
        <xsl:variable name="type-url" as="xs:string">
            <xsl:choose>
                <xsl:when test="@type = 'schnitzler-briefe'">
                    <xsl:text/>
                </xsl:when>
                <xsl:when test="@type = 'schnitzler-bahr'">
                    <xsl:text>https://schnitzler-bahr.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'schnitzler-lektueren'">
                    <xsl:text>https://schnitzler-lektueren.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ref-mit-endung" as="xs:string">
            <xsl:choose>
                <xsl:when test="contains(@target, '.xml')">
                    <xsl:value-of select="replace(@target, '.xml', '.html')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(@target, '.html')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@subtype = 'date-only'">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$ref-mit-endung"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@type = 'schnitzler-briefe'">
                            <xsl:value-of
                                select="document(concat($type-url, replace($ref-mit-endung, '.html', '.xml')))/descendant::tei:correspAction[1]/tei:date[1]/text()"
                            />
                        </xsl:when>
                        <xsl:when test="@type = 'schnitzler-bahr'">
                            <xsl:value-of
                                select="document(concat($type-url, replace($ref-mit-endung, '.html', '.xml')))/descendant::tei:dateSender[1]/tei:date[1]/text()"
                            />
                        </xsl:when>
                    </xsl:choose>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@subtype = 'See'">
                        <xsl:text>Siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'Cf'">
                        <xsl:text>Vgl. </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'see'">
                        <xsl:text>siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'cf'">
                        <xsl:text>vgl. </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$ref-mit-endung"/>
                    </xsl:attribute>
                    <xsl:variable name="dateiname-xml" as="xs:string?">
                        <xsl:choose>
                            <xsl:when test="@type = 'schnitzler-briefe'">
                                <xsl:value-of
                                    select="concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-data/main/data/editions/', replace($ref-mit-endung, '.html', '.xml'))"
                                />
                            </xsl:when>
                            <xsl:when test="@type = 'schnitzler-bahr'">
                                <xsl:value-of
                                    select="concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-bahr-data/main/data/editions/', replace($ref-mit-endung, '.html', '.xml'))"
                                />
                            </xsl:when>
                            <xsl:when test="@type = 'schnitzler-lektueren'">
                                <xsl:value-of
                                    select="concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-lektueren/main/data/editions/', replace($ref-mit-endung, '.html', '.xml'))"
                                />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="document($dateiname-xml)/child::*[1]">
                            <xsl:value-of
                                select="document($dateiname-xml)/descendant::tei:titleStmt[1]/tei:title[@level = 'a'][1]/text()"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$dateiname-xml"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- c -->
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']">
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']">
        <span class="gemination-m">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']">
        <span class="gemination-n">nn</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#prozent']">
        <xsl:text>%</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#dots']">
        <xsl:value-of select="mam:dots(@n)"/>
    </xsl:template>
    <xsl:function name="mam:dots">
        <xsl:param name="anzahl"/> . <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="mam:dots($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>

    <!-- opener -->
    <xsl:template match="tei:opener">
        <div class="opener">
            <xsl:apply-templates/>
        </div>
        <br/>
    </xsl:template>

    <!-- closer -->
    <xsl:template match="tei:closer">
        <div class="closer">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- time -->
    <xsl:template match="tei:time">
        <span class="time">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- lb -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

    <!-- signed -->
    <xsl:template match="tei:signed">
        <br/>
        <span class="signature" style="text-align: right;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- unclear -->
    <xsl:template match="tei:unclear">
        <span class="unclear" style="color: grey;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- quote -->
    <xsl:template match="tei:quote[not(/tei:p)]">
        <span class="quote">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- frame -->
    <xsl:template match="tei:frame">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- subst -->
    <xsl:template match="tei:subst">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- ignore these elements -->
    <xsl:template match="tei:graphic"/>
    <xsl:template match="tei:figure"/>
    <xsl:template match="tei:foreign"/>

</xsl:stylesheet>
