<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
       xmlns:cs="urn:cs"
       xmlns:js="urn:custom-javascript"
       exclude-result-prefixes="msxsl js"
 >
<xsl:output method="html" indent="yes"/>
<msxsl:script language="c#" implements-prefix="cs">
	<![CDATA[

public static string TruncateText( string text, int maxLength )
{
	return TruncateText( text, maxLength, "" );
}

public static string TruncateText( string text, int maxLength, string append )
{
	if ( text.Length > maxLength )
	{
		text = string.Format("{0}{1}", text.Substring( 0, maxLength - 1), append );
	}
	return text;
}
]]>
</msxsl:script>
	
<xsl:template match="/">
	<script type="text/javascript">
		<xsl:comment>
			<![CDATA[
			$(document).ready(function()
			{
				$("#feature").featureShow({
					prevId: 'feature-nav-prev',
					nextId: 'feature-nav-next',
					auto: true,
					continuous: true,
					speed: 2000,
					pause: 9000,
					textMaxWidth: 500
				});
			});
			]]>
		</xsl:comment>
	</script>
  <xsl:if test="/*/container[count(item) > 0]">
    <div id="feature">
      <ul id="feature-slider">
        <xsl:for-each select="/*/container[count(item) > 0]">
          <xsl:for-each select="item">
            <li>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="@detailsUrl"/>
                </xsl:attribute>
                <img width="653" height="350">
                  <xsl:attribute name="src">
                    <xsl:value-of select="@imageUrl"/>
                  </xsl:attribute>
                  <xsl:attribute name="alt">
                    <xsl:value-of select="@title"/>
                  </xsl:attribute>
                </img>
              </a>
              <div class="feature-text">
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="@detailsUrl"/>
                  </xsl:attribute>
                  <h1 class="heading">
                    <xsl:value-of select="@title"/>
                  </h1>
                </a>
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="@detailsUrl"/>
                  </xsl:attribute>
                  <p class="caption">
                    <xsl:value-of disable-output-escaping="yes" select="cs:TruncateText(@summary, 130, '...')" />
                  </p>
                </a>
              </div>
            </li>
          </xsl:for-each>
        </xsl:for-each>
      </ul>
    </div>
    <div id="feature-nav">
      <a href="#" id="feature-nav-prev" class="left">&lt;</a>
      <a href="#" id="feature-nav-next" class="right">&gt;</a>
    </div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

  