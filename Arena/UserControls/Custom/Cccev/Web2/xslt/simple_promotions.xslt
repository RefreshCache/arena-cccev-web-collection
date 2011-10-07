<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="no"/>

	<xsl:template match="/">

		<h2>News, Events, &amp; Announcements</h2>
		<hr />
		<!-- News List -->
		<ul class="newsList">
			<xsl:for-each select="/*/container[count(item) > 0]">
				<xsl:for-each select="item">
					<li>
						<xsl:if test="@imageUrl != ''">
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="@detailsUrl"/>
								</xsl:attribute>
								<img border="0" class="avatar">
									<xsl:attribute name="src">
										<xsl:value-of select="@imageUrl"/>
									</xsl:attribute>
									<xsl:attribute name="alt">
										<xsl:value-of select="@title"/>
									</xsl:attribute>
								</img>
							</a>
						</xsl:if>
						<div>
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="@detailsUrl"/>
								</xsl:attribute>
							<h3>
								<xsl:value-of select="@title"/>
							</h3>
							</a>
							<p>
								<xsl:value-of select="@summary" disable-output-escaping="yes"/>
								<xsl:text> </xsl:text>
								<a class="more">
									<xsl:attribute name="href">
										<xsl:value-of select="@detailsUrl"/>
									</xsl:attribute>More...
								</a>
							</p>
						</div>
					</li>
				</xsl:for-each>
			</xsl:for-each>
		</ul>
	</xsl:template>

</xsl:stylesheet>