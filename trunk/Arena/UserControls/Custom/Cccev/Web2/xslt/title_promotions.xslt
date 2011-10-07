<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="no"/>
	<xsl:template match="/">
		<style>
			<![CDATA[
			#promotions li.item
			{
				height: auto;
			}
			
			#promotions li.item h3
			{
				color: #676666;
				font-size: 20px;
				font-weight: normal;
				padding-right: 20px;
			}
			
			#promotions li.item h3 a
			{
		    color: #23C3EA;
		    text-decoration: none;
			}
			
			#promotions p
			{
				padding-left: 0px;
				padding-right: 35px;
			}
			]]>
		</style>
		<!-- News List -->
		<ul id="promotions">
			<xsl:for-each select="/*/container[count(item) > 0]">
				<xsl:for-each select="item">
					<li class="item">
							<h3>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="@detailsUrl"/>
									</xsl:attribute>
								<xsl:value-of select="@title"/>
								</a>
							</h3>
							<p>
							<xsl:value-of select="@summary" disable-output-escaping="yes"/>
						</p>
					</li>
				</xsl:for-each>
			</xsl:for-each>
		</ul>
	</xsl:template>

</xsl:stylesheet>