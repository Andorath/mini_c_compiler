<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" 
	      encoding="UTF-8"
	      indent="no"/>

  <xsl:variable name="apos">'</xsl:variable>

  <xsl:template match="/">
    <html>
      <head>
	<meta charset="UTF-8" />
        <title>Bilotta</title>
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>   
        <link href="prism.css" rel="stylesheet" />
          <script src="//cdn.jsdelivr.net/highlight.js/9.1.0/highlight.min.js"></script>
        <link type="text/css" rel="stylesheet" href="tree-view.css"/>        
        <script>
            $(document).ready(function(){
                $.get('input.c', function(data) 
                {
                    $("code").text(data);
                    Prism.highlightElement($('code')[0]);
                }, 'text');
            });
            </script>
            <script src="prism.js"></script> 
          
          
      </head>
      <body>
        <div class="wrapper">  
            <div class="tree">
                <h3>Parse-Tree</h3>
                <xsl:apply-templates select="." mode="render"/>
            </div>
            <div class="sourceCodeWrapper">
                <div class="sourceCode">
                    <h3>Source Code</h3>
                    <p></p>
                    <p></p>
                    <pre>
                        <code class="language-c">while(true)</code>
                    </pre>
                </div>
            </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="/" mode="render">
    <xsl:apply-templates mode="render"/>
  </xsl:template>

  <xsl:template match="*" mode="render">
    <xsl:call-template name="ascii-art-hierarchy"/>
    <br/>
    <xsl:call-template name="ascii-art-hierarchy"/>
    <span class='connector'>
        <svg height="2" width="20">
            <line x1="0" y1="0" x2="20" y2="0" style="stroke:rgb(69, 201, 171);stroke-width:5" />
        </svg>
      </span>
    <span>
        
        <svg width="50" height="20">
            <rect x="0" y="0" rx="5" ry="5" width="50" height="20" style="fill:rgb(130,180,205);opacity:0.5" />
            <text x="50%" y="50%" text-anchor="middle" alignment-baseline="middle">
                <xsl:value-of select="local-name()"/>
            </text>
        </svg>
        
      </span>
    <xsl:text>&#160;</xsl:text>
    <br/>
    <xsl:apply-templates select="@*" mode="render"/>
    <xsl:apply-templates mode="render"/>
  </xsl:template>

  <xsl:template match="@*" mode="render">
    <xsl:call-template name="ascii-art-hierarchy"/>
    <span class='connector'>&#160;&#160;</span>
    <span class='connector'>
        
    </span>
    <xsl:text>&#160;</xsl:text>
    <xsl:text></xsl:text>

    <br/>

  </xsl:template>

  <xsl:template match="text()" mode="render">
    <xsl:call-template name="ascii-art-hierarchy"/>
    <br/>
    <xsl:call-template name="ascii-art-hierarchy"/>
    <span class='connector'>
    
        <svg height="2" width="20">
            <line x1="0" y1="0" x2="20" y2="0" style="stroke:rgb(69, 201, 171);stroke-width:5" />
        </svg>
        
    </span>
    <xsl:text>&#160;</xsl:text>
    <span class="value">
      <xsl:call-template name="escape-ws">
        <xsl:with-param name="text" select="translate(.,' ','&#160;')"/>
      </xsl:call-template>
    </span>
    <br/>
  </xsl:template>

  <xsl:template match="comment()" mode="render" />
  <xsl:template match="processing-instruction()" mode="render" />


  <xsl:template name="ascii-art-hierarchy">
    <xsl:for-each select="ancestor::*">
      <xsl:choose>
        <xsl:when test="following-sibling::node()">
          <span class='connector'>&#160;&#160;</span>
          
            <!-- LINEE -->
            
            <div class='mydivAzzurro1'>
                
                <svg height="20" width="2">
                    <line x1="0" y1="0" x2="0" y2="30" style="stroke:rgb(69, 201, 171);stroke-width:5" />
                </svg>
                
            </div>
            
            <span class='connector'>&#160;&#160;</span>
            
          <xsl:text>&#160;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <span class='connector'>&#160;&#160;&#160;&#160;</span>
          
            <span class='connector'>&#160;&#160;</span>

            
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="parent::node() and ../child::node()">
        <span class='connector'>&#160;&#160;</span>
        <xsl:text>
            
           <!-- LINEE -->
            <div class="myDivAzzurro">
                <svg height="20" width="2">
                    <line x1="0" y1="0" x2="0" y2="30" style="stroke:rgb(69, 201, 171);stroke-width:3.5" />
                </svg>
            </div>
        
            
        </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <span class='connector'>&#160;&#160;&#160;</span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- recursive template to escape linefeeds, tabs -->
  <xsl:template name="escape-ws">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text, '&#xA;')">
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-before($text, '&#xA;')"/>
        </xsl:call-template>
        <span class="escape">\n</span>
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-after($text, '&#xA;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, '&#x9;')">
        <xsl:value-of select="substring-before($text, '&#x9;')"/>
        <span class="escape">\t</span>
        <xsl:call-template name="escape-ws">
          <xsl:with-param name="text" select="substring-after($text, '&#x9;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
