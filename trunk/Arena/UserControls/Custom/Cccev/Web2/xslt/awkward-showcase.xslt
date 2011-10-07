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
        if ((title.Length + titleArray.Length + 1) <= length)
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
		<script type="text/javascript" src="jquery.aw-showcase.js"></script>
		<script type="text/javascript" implements-prefix="js">
			<xsl:comment>
				<![CDATA[
$(document).ready(function()
{
	$("#showcase").awShowcase(
	{
		showcase_width:			700,
		showcase_height:		470,
		hundred_percent:		false,
		auto:					false,
		interval:				3000,
		continuous:				false,
		loading:				true,
		tooltip_width:			200,
		tooltip_icon_width:		32,
		tooltip_icon_height:	32,
		tooltip_offsetx:		18,
		tooltip_offsety:		0,
		arrows:					true,
		buttons:				true,
		btn_numbers:			true,
		keybord_keys:			true,
		mousetrace:				false,
		pauseonover:			true,
		transition:				'vslide', /* hslide/vslide/fade */
		transition_delay:		300,
		transition_speed:		500,
		show_caption:			'onhover', /* onload/onhover/show */
		thumbnails:				true,
		thumbnails_position:	'outside-last', /* outside-last/outside-first/inside-last/inside-first */
		thumbnails_direction:	'vertical', /* vertical/horizontal */
		thumbnails_slidex:		0, /* 0 = auto / 1 = slide one thumbnail / 2 = slide two thumbnails / etc. */
		dynamic_height:			false,
		speed_change:			true
	});
});
			]]>
			</xsl:comment>
		</script>
		
		<div id="showcase" class="showcase">
			<!-- Each child div in #showcase with the class .showcase-slide represents a slide. -->

			<xsl:for-each select="/*/container[count(item) > 0]">
				<xsl:for-each select="item">
					<div class="showcase-slide">
						<div class="showcase-content">
							<a>
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
						<div class="showcase-thumbnail">
							<img width="140px">
								<xsl:attribute name="src">
									<xsl:value-of select="@imageUrl"/>
								</xsl:attribute>
								<xsl:attribute name="alt">
									<xsl:value-of select="@title"/>
								</xsl:attribute>
							</img>
							<div class="showcase-thumbnail-caption">
								<xsl:value-of disable-output-escaping="yes" select="cs:TruncateTitle(@title, 40)" />
							</div>
							<div class="showcase-thumbnail-cover"></div>
						</div>
					</div>
				</xsl:for-each>
			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet>
