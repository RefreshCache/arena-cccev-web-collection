<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
       xmlns:cs="urn:cs"
       xmlns:js="urn:custom-javascript"
       exclude-result-prefixes="msxsl js"
 >

	<msxsl:script language="c#" implements-prefix="cs">
		<![CDATA[

 	public static string TwittifyLinks( string msg )
 	{
		//var tweet = input.replace(/(^|\s)@(\w+)/g, "$1@<a href="http://www.twitter.com/$2">$2</a>");	
        	string linkRegex = @"((www\.|(http|https|ftp|news|file)+\:\/\/)[&#95;.a-z0-9-]+\.[a-z0-9\/&#95;:@=.+?,##%&~-]*[^.|\'|\# |!|\(|?|,| |>|<|;|\)])";
        	string userRegex = @"(^|\s)@(\w+)";
        	string hashRegex = @"(^|\s)#(\w+)";
        
        	Regex r = new Regex(linkRegex, RegexOptions.IgnoreCase);
        	msg = r.Replace(msg, "<a href=\"$1\">$1</a>").Replace("href=\"www", "href=\"http://www");
        
        	r = new Regex( userRegex );
        	msg = r.Replace(msg, "$1@<a href=\"http://www.twitter.com/$2\">$2</a>");

		r = new Regex ( hashRegex );
		msg = r.Replace( msg, "$1#<a href=\"http://search.twitter.com/search?q=%23$2\">$2</a>" );
		
		return msg;
 	}

	public static string AuthorLink( string author )
	{
		return string.Format( "<a href=\"http://www.twitter.com/{0}\">{0}</a>", author );
	}
	
	public static string RelativeDate( string pubDate )
    	{
		DateTime d = DateTime.Parse( pubDate );
		DateTime now = DateTime.Now;
		TimeSpan timeSince = now - d;
		
		double inSeconds = timeSince.TotalSeconds;
		double inMinutes = timeSince.TotalMinutes;
		double inHours = timeSince.TotalHours;
		double inDays = timeSince.TotalDays;
		double inMonths = inDays / 30;
		double inYears = inDays / 365;

		if(Math.Round(inSeconds) == 1){
			return "1 second ago";
		}
		else if(inMinutes < 1.0){
			return Math.Floor(inSeconds) + " seconds ago";
		}
		else if(Math.Floor(inMinutes) == 1){
			return "1 minute ago";
		}
		else if(inHours < 1.0){
			return Math.Floor(inMinutes) + " minutes ago";
		}
		else if(Math.Floor(inHours) == 1){
			return "about an hour ago";
		}
		else if(inDays < 1.0){
			return Math.Floor(inHours) + " hours ago";
		}
		else if(Math.Floor(inDays) == 1){
			return "1 day ago";
		}
		else if(inMonths < 3 ){
			return Math.Floor(inDays) + " days ago";
		}
		else if(inMonths <= 12 ){
			return Math.Floor(inMonths) + " months ago ";
		}
		else if(Math.Floor(inYears) <= 1){
			return "1 year ago";
		}
		else
		{
			return Math.Floor(inYears) + " years ago";
		}
    }
 ]]>
	</msxsl:script>

  <xsl:template match="/">
    <h2 class="content-heading">Social</h2>
    <ul id="social-networks">
      <xsl:if test="errors">
        <xsl:call-template name="errors"></xsl:call-template>
      </xsl:if>
      <xsl:if test="rss/channel">
        <xsl:call-template name="tweets"></xsl:call-template>
      </xsl:if>
      <li class="logo">
        <a href="http://twitter.com/cccev" title="Follow Central on Twitter">
          <img src="templates/cccev/hasselhoff/img/twitter-logo.png" alt="Follow Central on Twitter" />
        </a>
      </li>
      <li class="logo">
        <a href="http://www.facebook.com/centralchristian" title="Become a fan of Central on Facebook">
          <img src="templates/cccev/hasselhoff/img/facebook-logo.png" alt="Become a fan of Central on Facebook" />
        </a>
      </li>
      <li class="logo">
        <a href="http://www.centralaz.com/blog" title="See what&apos;s new in the Central Blog">
          <img src="templates/cccev/hasselhoff/img/blog-logo.png" alt="See what&apos;s new in The Drop" />
        </a>
      </li>
    </ul>
  </xsl:template>

	<xsl:template name="tweets">
			<xsl:for-each select="rss/channel/item[position() &lt;= 1]">
					<li class="tweet">
						<xsl:value-of disable-output-escaping="yes" select="cs:TwittifyLinks( substring-after(title,': ') )" />
						<span class="relative-date">
							<xsl:value-of select="cs:RelativeDate(pubDate)" />
						</span>
					</li>
			</xsl:for-each>
	</xsl:template>

  <xsl:template name="errors">
      <li class="tweet smallText">
        oops, twitter is not available
        <span class="relative-date"></span>
      </li>
  </xsl:template>
  
</xsl:stylesheet>