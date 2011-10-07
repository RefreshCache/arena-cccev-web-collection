<?xml version="1.0" encoding="UTF-8" ?>
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

public static string TruncateTitle( string text, int length )
{
    string title = "";
    string[] titleArray = text.Split(new char[] { ' ' });
    
    foreach (string s in titleArray)
    {
        if ((title.Length + s.Length + 1) <= length)
        {
            title += " " + s;
        }
        else
        {
            break;
        }
    }
    
    return title;
}
]]>
</msxsl:script>

<msxsl:script language="JavaScript" implements-prefix="js">
    <![CDATA[
        function getTruncatedTitle(theTitle, length)
        {
	        var title = '';
	        var titleArray = theTitle.split(' ');

	        for (var i = 0; i < titleArray.length; i++)
	        {
		        // Add extra char for space
		        if ((title.length + titleArray[i].length + 1) <= length)
		        {
			        title += ' ' + titleArray[i];
		        }
		        else
		        {
			        break;
		        }
	        }

	        return title;
        }
    ]]>
</msxsl:script>
	
<xsl:template match="/">
	<script type="text/javascript" implements-prefix="js">
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
					textMaxWidth: 480
				});
			});
			]]>
		</xsl:comment>
	</script>

	<ul id="feature-slider">
		<xsl:for-each select="/*/container[count(item) > 0]">
			<xsl:for-each select="item">
				<li>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="@detailsUrl"/>
						</xsl:attribute>
						<img width="879" height="350">
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
                <xsl:value-of select="cs:TruncateTitle(@title, 27)"/>
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

	<div id="feature-nav">
		<a href="#" id="feature-nav-prev" class="left">&lt;</a>
		<a href="#" id="feature-nav-next" class="right">&gt;</a>
	</div>
	<p id="feature-links">
		<a href="default.aspx?page=4178" title="Who is Jesus?">Who is Jesus?</a> / <a href="default.aspx?page=4347" title="Service Times">Service Times</a> / <a href="default.aspx?page=4346" title="Directions">Directions</a> / <a href="default.aspx?page=4166" title="What to Expect">What to Expect</a>
	</p>
</xsl:template>

</xsl:stylesheet>

  