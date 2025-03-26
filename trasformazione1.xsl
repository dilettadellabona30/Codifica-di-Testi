<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Template principale: struttura base della pagina -->
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>
          <xsl:value-of select="//tei:titleStmt/tei:title"/>
        </title>
        <link rel="stylesheet" type="text/css" href="style.css"/>
        <script src="script1.js"></script>
      </head>
      <body>
        <header>
          <div class="container">
            <h1><xsl:value-of select="//tei:titleStmt/tei:title"/></h1>
            <nav>
              <ul>
                <li><a href="#fascicolo66">Fascicolo 66</a></li>
                <li><a href="#fascicolo67">Fascicolo 67</a></li>
                <li><a href="#glossario">Glossario</a></li>
              </ul>
            </nav>
          </div>
        </header>
        
        <div class="container">
          <!-- Applica i template per i fascicoli -->
          <xsl:apply-templates select="//tei:div[@type='fascicolo' and @n='66']"/>
          <xsl:apply-templates select="//tei:div[@type='fascicolo' and @n='67']"/>
          <!-- Glossario -->
          <xsl:apply-templates select="//tei:notesStmt"/>
        </div>
        
        <footer>
          <div class="container">
            <div class="footer-section">
              <h3>Codifica</h3>
              <p>
                <strong>Codifica a cura di:</strong>
                <xsl:value-of select="//tei:titleStmt/tei:respStmt[1]/tei:name"/>
              </p>
            </div>
            <div class="footer-section">
              <h3>Coordinamento</h3>
              <p>
                <strong>Coordinata da:</strong>
                <xsl:value-of select="//tei:seriesStmt/tei:respStmt/tei:name"/>
              </p>
            </div>
            <div class="footer-section">
              <h3>Pubblicazione</h3>
              <p>
                <strong>Publisher:</strong>
                <xsl:value-of select="//tei:publicationStmt/tei:publisher"/><br/>
                <strong>Data:</strong>
                <xsl:value-of select="//tei:publicationStmt/tei:date"/>
              </p>
            </div>
            <div class="footer-section">
              <h3>Bibliografia</h3>
              <p>
                <strong>Monografia:</strong>
                <xsl:value-of select="//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:title"/><br/>
                <strong>Fondatori:</strong>
                <xsl:for-each select="//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:respStmt[1]/tei:name">
                  <xsl:value-of select="."/>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
                <br/>
                <strong>Responsabile:</strong>
                <xsl:value-of select="//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:respStmt[2]/tei:name"/><br/>
                <strong>Imprint:</strong>
                <xsl:value-of select="//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:publisher"/> -
                <xsl:value-of select="//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:pubPlace"/>,
                <xsl:value-of select="//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:imprint/tei:date"/>
              </p>
            </div>
          </div>
        </footer>
      </body>
    </html>
  </xsl:template>

  

  <!-- Template per i fascicoli: sincronizzazione immagini e testo -->
  <xsl:template match="tei:div[@type='fascicolo']">
    <div class="fascicolo" id="{concat('fascicolo', @n)}">
      <h2>Fascicolo <xsl:value-of select="@n"/></h2>
      <div class="gallery-container">
        <!-- Colonna sinistra: slider immagini -->
        <div class="left-column">
          <div class="slides">
            <xsl:choose>
              <!-- Fascicolo 66 -->
              <xsl:when test="@n = '66'">
                <xsl:for-each select="/tei:TEI/tei:facsimile/tei:surface[
                  starts-with(@xml:id, 'articolo1') or contains(@xml:id, '66')
                ]">
                  <div class="slide" data-ref="{tei:zone[1]/@xml:id}">
                    <img src="immagini/{tei:graphic/@url}"
                         width="{tei:graphic/@width}"
                         height="{tei:graphic/@height}"
                         alt="Facsimile"
                         usemap="{concat('#mappa_', tei:zone[1]/@xml:id)}" />
                    <map name="{concat('mappa_', tei:zone[1]/@xml:id)}">
                      <xsl:for-each select="tei:zone">
                        <area shape="rect"
                              data-ref="{@xml:id}"
                              coords="{concat(@ulx, ',', @uly, ',', @lrx, ',', @lry)}"
                              href="#"
                              alt="Zona {position()}" />
                      </xsl:for-each>
                    </map>
                  </div>
                </xsl:for-each>
              </xsl:when>
              <!-- Fascicolo 67 -->
              <xsl:when test="@n = '67'">
                <xsl:for-each select="/tei:TEI/tei:facsimile/tei:surface[
                  starts-with(@xml:id, 'articolo2') or contains(@xml:id, '67')
                ]">
                  <div class="slide" data-ref="{tei:zone[1]/@xml:id}">
                    <img src="immagini/{tei:graphic/@url}"
                         width="{tei:graphic/@width}"
                         height="{tei:graphic/@height}"
                         alt="Facsimile"
                         usemap="{concat('#mappa_', tei:zone[1]/@xml:id)}" />
                    <map name="{concat('mappa_', tei:zone[1]/@xml:id)}">
                      <xsl:for-each select="tei:zone">
                        <area shape="rect"
                              data-ref="{@xml:id}"
                              coords="{concat(@ulx, ',', @uly, ',', @lrx, ',', @lry)}"
                              href="#"
                              alt="Zona {position()}" />
                      </xsl:for-each>
                    </map>
                  </div>
                </xsl:for-each>
              </xsl:when>
            </xsl:choose>
          </div>
          <div class="navigation">
            <button class="prev">←</button>
            <button class="next">→</button>
          </div>
        </div>
        
        <!-- Colonna destra: slider testo sincronizzato -->
        <div class="right-column">
          
          <div class="navigation">
            <button type="button" class="button" id="persone_reali">Persone reali</button>
            <button type="button" class="button" id="personaggi">Personaggi</button>
            <button type="button" class="button" id="opere">Opere</button>
            <button type="button" class="button" id="luoghi">Luoghi</button>
            <button type="button" class="button" id="luoghi_naturali">Luoghi naturali</button>
            <button type="button" class="button" id="casa_editrice">Casa editrice</button>
            <button type="button" class="button" id="date">Date</button>
            <button type="button" class="button" id="temi_motivi">Temi/ motivi</button>
            <button type="button" class="button" id="correnti_letterarie">Correnti letterarie</button>
            <button type="button" class="button" id="testo_lingua_straniera">Testo in lingua straniera</button>
            <button type="button" class="button" id="citazioni">Citazioni</button>
            <button type="button" class="button" id="organizzazioni">Organizzazioni</button>
          </div>

          <div class="text-slides">
            <!-- Per fascicolo 66 -->
            <xsl:if test="@n = '66'">
              <xsl:for-each select="/tei:TEI/tei:facsimile/tei:surface[
                starts-with(@xml:id, 'articolo1') or contains(@xml:id, '66')
              ]">
                <!-- Per ogni surface, itero su ciascun <zone> -->
                <xsl:for-each select="tei:zone">
                  <div class="text-slide" data-ref="{@xml:id}">
                    <xsl:variable name="zoneId" select="@xml:id"/>
                    <xsl:apply-templates select="/tei:TEI/tei:text/tei:body//*[@corresp = concat('#', $zoneId)]"/>
                  </div>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:if>
            <!-- Per fascicolo 67 -->
            <xsl:if test="@n = '67'">
              <xsl:for-each select="/tei:TEI/tei:facsimile/tei:surface[
                starts-with(@xml:id, 'articolo2') or contains(@xml:id, '67')
              ]">
                <xsl:for-each select="tei:zone">
                  <div class="text-slide" data-ref="{@xml:id}">
                    <xsl:variable name="zoneId" select="@xml:id"/>
                    <xsl:apply-templates select="/tei:TEI/tei:text/tei:body//*[@corresp = concat('#', $zoneId)]"/>
                  </div>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:if>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <!-- Template per il glossario -->
  <xsl:template match="tei:notesStmt">
    <div class="glossario" id="glossario">
      <h2>Glossario</h2>
      <xsl:apply-templates select="node()"/>
    </div>
  </xsl:template>
  
  <!-- Template per le voci del glossario -->
  <xsl:template match="tei:item">
    <div class="glossario-item">
      <p><xsl:value-of select="."/></p>
    </div>
  </xsl:template>

    
  <!-- Template per “marcare” gli elementi con data-cat. Intercettiamo tutti gli elementi che contengono un @ref o @corresp con valore tipo #luoghi, #date, #opere, ecc. e li avvolgiamo in uno <span> con data-cat corrispondente.-->
  
  <xsl:template match="*[contains(@ref, '#') or contains(@corresp, '#')]">
    <!-- Ricavo la 'categoria' rimuovendo il cancelletto -->
    <xsl:variable name="cat">
      <xsl:choose>
        <xsl:when test="@ref">
          <xsl:value-of select="substring-after(@ref, '#')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring-after(@corresp, '#')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <span class="testo-categorizzato" data-cat="{$cat}">
      <!-- Qui stampo il contenuto “normale” dell’elemento -->
      <xsl:apply-templates select="node()"/>
    </span>
  </xsl:template>
  
  <!-- Template per il testo generale -->
  <xsl:template match="tei:text">
    <div class="text">
      <xsl:apply-templates select="node()"/>
    </div>
  </xsl:template>
  
  <!-- Template per i paragrafi -->
  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates select="node()"/>
    </p>
  </xsl:template>
  
  <!-- Template per le interruzioni di linea -->
  <xsl:template match="tei:lb">
    <br/>
  </xsl:template>
  
</xsl:stylesheet>
