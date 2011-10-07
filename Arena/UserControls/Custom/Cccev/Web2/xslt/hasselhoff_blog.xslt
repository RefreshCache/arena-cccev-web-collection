<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
       xmlns:cs="urn:cs"
       xmlns:js="urn:custom-javascript"
       exclude-result-prefixes="msxsl js"
 >
<xsl:output method="html" indent="no"/>

	<xsl:template match="rss/channel">
			<xsl:for-each select="item[position() = 1]">
				<li class="post">
					<div class="author">
						<img src="img/cal.jpg" alt="Cal Jernigan" />
						<span>Cal Jernigan</span>
					</div>
					<h3>Lovely Beautiful Simple World</h3>
					<p>
						Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque rutrum lorem eget magna vehicula eu
						dictum ipsum auctor. <a href="#">Read More</a>
					</p>
				</li>


				<li class="post">
					<div class="author">
						<img src="img/cal.jpg" alt="Cal Jernigan" />
						<span>Cal Jernigan</span>
					</div>
					<h3>Lovely Beautiful Simple World</h3>
					<p>
						Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque rutrum lorem eget magna vehicula eu
						dictum ipsum auctor. <a href="#">Read More</a>
					</p>
				</li>
			</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>