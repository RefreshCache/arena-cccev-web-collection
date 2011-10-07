<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"> 
<xsl:output method="html" indent="no"/>
   
<xsl:template match="/">
	<!-- News Flash -->
	<div class="left-bar-content">
		<h1>She Says...</h1>
		<xsl:for-each select="/*/container[count(item) > 0]">
			<xsl:for-each select="item[position() = 1]">
				<xsl:value-of select="@summary" disable-output-escaping="yes" />
				<p><a class="more"><xsl:attribute name="href"><xsl:value-of select="@detailsUrl"/></xsl:attribute>read more</a></p>
			</xsl:for-each>
		</xsl:for-each>
	</div>
</xsl:template>

</xsl:stylesheet>