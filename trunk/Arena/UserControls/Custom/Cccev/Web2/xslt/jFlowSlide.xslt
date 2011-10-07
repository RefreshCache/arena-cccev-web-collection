<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
	<div id="galleryNav" style="display: none">
		<div class="controlNav nav1"></div>
		<div class="controlNav nav2"></div>
		<div class="controlNav nav3"></div>
	</div>
	<hr />
	<div id="galleryPages">
		<div>
			<div class="galleryList">
			<xsl:for-each select="/*/container[count(item) > 0]">
				<xsl:for-each select="item">
				<div>
					<a rel="gallery[websites]">
						<xsl:attribute name="href">
							<xsl:value-of select="@detailsUrl"/>
						</xsl:attribute>
						<img>
							<xsl:attribute name="src">
								<xsl:value-of select="@imageUrl"/>
							</xsl:attribute>
							<xsl:attribute name="alt">
								<xsl:value-of select="@title"/>
							</xsl:attribute>
						</img>
					</a>
				</div>
				</xsl:for-each>
			</xsl:for-each>
			</div>
		</div>
	</div>
	</xsl:template>
</xsl:stylesheet>
