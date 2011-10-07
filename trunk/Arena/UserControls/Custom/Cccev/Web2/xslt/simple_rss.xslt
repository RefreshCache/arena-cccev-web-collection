<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
       xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
       xmlns:cs="urn:cs"
       xmlns:js="urn:custom-javascript"
       exclude-result-prefixes="msxsl js"
 >
<xsl:output method="html" indent="no"/>

	<msxsl:script language="c#" implements-prefix="cs">
		<![CDATA[

 	public static string TruncateText( string text, int maxLength )
 	{
		if ( text.Length > maxLength )
		{
			text = text.Substring( 0, maxLength - 1);
		}
		return text;
    }
 ]]>
	</msxsl:script>
	
	<xsl:template match="//rss">
		<h2 class="content-heading">Blog</h2>
		<ul id="blog">
			<xsl:for-each select="channel">
				<li class="post">
					<div class="author">
						<img>
							<xsl:attribute name="src">
								<xsl:value-of select="itunes:image/@href" />
							</xsl:attribute>
							<xsl:attribute name="alt">
								<xsl:value-of select="itunes:author"/>
							</xsl:attribute>
						</img>
						<span>
							<xsl:value-of select="itunes:author"/>
						</span>
					</div>

					<xsl:for-each select="item[position() = 1]">
						<h3>
							<xsl:value-of select="title" />
						</h3>
						<p>
							<xsl:value-of select="cs:TruncateText(description, 100)"  disable-output-escaping="yes"/>

							<xsl:text> </xsl:text>
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="link"/>
								</xsl:attribute>Read More
							</a>
						</p>
					</xsl:for-each>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
</xsl:stylesheet>