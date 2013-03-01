<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
   <xsl:template match="*">
      <xsl:value-of select="."/>
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="text()">
      <xsl:value-of select="."/>
   </xsl:template>

   <xsl:template match="/">
      <HTML>
         <HEAD>
            <TITLE>
               <xsl:value-of select="book/title"/>
            </TITLE>
<STYLE >
BODY {
	BACKGROUND: white fixed no-repeat left top; COLOR: black; FONT-FAMILY: sans-serif; MARGIN: 2em 1em 2em 20px
}
TH {
	FONT-FAMILY: sans-serif
}
TD {
	FONT-FAMILY: sans-serif
}
H1 {
	TEXT-ALIGN: left
}
H2 {
	TEXT-ALIGN: left
}
H3 {
	TEXT-ALIGN: left
}
H4 {
	TEXT-ALIGN: left
}
H5 {
	TEXT-ALIGN: left
}
H6 {
	TEXT-ALIGN: left
}
H1 {
	COLOR: #005a9c
}
H2 {
	COLOR: #005a9c
}
H3 {
	COLOR: #005a9c
}
H1 {
	FONT: 170% sans-serif
}
H2 {
	FONT: 140% sans-serif
}
H3 {
	FONT: 120% sans-serif
}
H4 {
	FONT: bold 100% sans-serif
}
H5 {
	FONT: italic 100% sans-serif
}
H6 {
	FONT: small-caps 100% sans-serif
}
.hide {
	DISPLAY: none
}
DIV.head {
	MARGIN-BOTTOM: 1em
}
DIV.head H1 {
	CLEAR: both; MARGIN-TOP: 2em
}
DIV.head TABLE {
	MARGIN-LEFT: 2em; MARGIN-TOP: 2em
}
DIV.head IMG {
	BORDER-BOTTOM: medium none; BORDER-LEFT: medium none; BORDER-RIGHT: medium none; BORDER-TOP: medium none; COLOR: white
}
P.copyright {
	FONT-SIZE: small
}
P.copyright SMALL {
	FONT-SIZE: small
}

@media Screen    
{
A:hover {
	BACKGROUND: #ffa
}
    }
PRE {
	MARGIN-LEFT: 2em
}
DT {
	MARGIN-BOTTOM: 0px; MARGIN-TOP: 0px
}
DD {
	MARGIN-BOTTOM: 0px; MARGIN-TOP: 0px
}
DT {
	FONT-WEIGHT: bold
}
PRE {
	FONT-FAMILY: monospace
}
CODE {
	FONT-FAMILY: monospace
}
UL.toc {
	LIST-STYLE: none
}

@media Aural    
{
H1 {
	stress: 20; richness: 90
}
H2 {
	stress: 20; richness: 90
}
H3 {
	stress: 20; richness: 90
}
.hide {
	speak: none
}
P.copyright {
	volume: x-soft; speech-rate: x-fast
}
DT {
	pause-before: 20%
}
PRE {
	speak-punctuation: code
}
    }
</STYLE>
         </HEAD>
          <BODY STYLE="font:9pt Verdana">
            <xsl:for-each select="book">
               <H1>
                  <xsl:value-of select="bookinfo/titleabbrev"/>
               </H1>
               <H1>
			      <xsl:value-of select="bookinfo/title"/>
               </H1>
               <H1>
			      <xsl:value-of select="bookinfo/subtitle"/>
               </H1>
               <H4>
                  <xsl:value-of select="bookinfo/author/firstname"/>
                  <xsl:value-of select="bookinfo/author/surname"/>
               </H4>
               <H4>
                  <xsl:value-of select="bookinfo/pubdate"/>
               </H4>
            </xsl:for-each>
            <hr/>
             <H2>Table of Contents</H2>
        <xsl:apply-templates select="book/chapter">
          <xsl:template match="chapter|sect1|sect2|sect3|sect4|sect5">
            <DIV STYLE="margin-left:1em">
              <a>
              <xsl:attribute name="href">
                 #<xsl:eval>sectionNum(this)</xsl:eval>
              </xsl:attribute>
              <xsl:eval>sectionNum(this)</xsl:eval>
              <xsl:value-of select="title"/>
              </a>
              <xsl:apply-templates select="sect1|sect2|sect3|sect4|sect5"/>
            </DIV>
          </xsl:template>
        </xsl:apply-templates>
            <hr/>
            <xsl:apply-templates/>
         </BODY>
      </HTML>
   </xsl:template>
   <xsl:template match="book">
     <xsl:apply-templates />
   </xsl:template>
   <xsl:template match="author" />
   <xsl:template match="titleabbrev" />
   <xsl:template match="title" />
   <xsl:template match="subtitle" />
   <xsl:template match="pubdate" />
   <xsl:template match="bookinfo">
     <xsl:apply-templates />
     <hr /> 
   </xsl:template>
   <xsl:template match="legalnotice">
      <h3>Notice</h3>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="othercredit">
      <h3>Credit</h3>
      <xsl:value-of select="contrib"/>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="contrib"/>
   <xsl:template match="preface">
      <h2>
         <xsl:value-of select="title"/>
      </h2>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="chapter">
      <h2>
          <a> 
            <xsl:attribute name="name"><xsl:eval>sectionNum(this)</xsl:eval></xsl:attribute>
            <xsl:value-of select="title"/>
          </a>
      </h2>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="sect1">
      <h3>
          <a> 
            <xsl:attribute name="name"><xsl:eval>sectionNum(this)</xsl:eval></xsl:attribute>
            <xsl:value-of select="title"/>
          </a>         
      </h3>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="sect2">
      <h4>
          <a> 
            <xsl:attribute name="name"><xsl:eval>sectionNum(this)</xsl:eval></xsl:attribute>
            <xsl:value-of select="title"/>
          </a>
      </h4>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="sect3">
      <h5>
          <a> 
            <xsl:attribute name="name"><xsl:eval>sectionNum(this)</xsl:eval></xsl:attribute>
            <xsl:value-of select="title"/>
          </a>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="itemizedlist">
      <div class="{name(.)}">
         <xsl:if test="title">
            <xsl:apply-templates select="title"/>
         </xsl:if>
         <ul>
            <xsl:apply-templates select="listitem"/>
         </ul>
      </div>
   </xsl:template>
   <xsl:template match="itemizedlist/title">
      <p>
         <b>
            <xsl:apply-templates/>
         </b>
      </p>
   </xsl:template>
   <xsl:template match="variablelist">
      <div class="{name(.)}">
         <xsl:if test="title">
            <xsl:apply-templates select="title"/>
         </xsl:if>
         <dl>
            <xsl:apply-templates select="varlistentry"/>
         </dl>
      </div>
   </xsl:template>
   <xsl:template match="variablelist/title">
      <p>
         <b>
            <xsl:apply-templates/>
         </b>
      </p>
   </xsl:template>
   <xsl:template match="listitem">
      <li>
         <a name="{$id}"/>
         <xsl:apply-templates/>
      </li>
   </xsl:template>

   <xsl:template match="quote">
      "
         <xsl:apply-templates/>
      "
   </xsl:template>

   <xsl:template match="para">
      <p>
         <xsl:apply-templates/>
      </p>
   </xsl:template>

<xsl:template match="literallayout">
   <pre class="{name(.)}" STYLE="font:9pt Courier"><xsl:apply-templates/></pre>
</xsl:template>

<xsl:template match="emphasis">
      <b>
         <xsl:apply-templates/>
      </b>
</xsl:template>

   <xsl:template match="title"/>
   <xsl:script>
    function sectionNum(e) {
      if (e)
      {
          return sectionNum(e.selectSingleNode("ancestor(chapter|sect1|sect2|sect3|sect4|sect5)")) +
               formatIndex(childNumber(e), "1") + ".";
      }
      else
      {
        return "";
      }
    }
    
    var prodCount = 1;
    function prodNum() {
      return formatIndex(prodCount++, "1");
    }

  </xsl:script>
</xsl:stylesheet>
