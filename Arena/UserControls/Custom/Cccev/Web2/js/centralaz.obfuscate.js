/**********************************************************************
* Description:  TBD
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: TBD
*
* $Workfile: centralaz.obfuscate.js $
* $Revision: 2 $
* $Header: /trunk/Arena/UserControls/Custom/Cccev/Web2/js/centralaz.obfuscate.js   2   2011-04-27 14:12:47-07:00   JasonO $
*
* $Log: /trunk/Arena/UserControls/Custom/Cccev/Web2/js/centralaz.obfuscate.js $
*  
*  Revision: 2   Date: 2011-04-27 21:12:47Z   User: JasonO 
*  Streamlining code. Adding additional obfuscation through comment injection. 
*  
*  Revision: 1   Date: 2011-04-27 18:58:13Z   User: JasonO 
*  Implementing some basic email obfuscation algorithm in an attempt to mask 
*  email harvesters. 
**********************************************************************/

CentralAZ_Obfuscate = {};

CentralAZ_Obfuscate.obfuscate = function ()
{
	$("a").each(function (index, value)
	{
		var href = $(this).attr("href");

		if (href && href.toLowerCase().indexOf("mailto") != -1)
		{
				var text = $(this).text();
				var email = href.substring(href.indexOf("mailto") + 7)
				var mailto = "mailto:" + CentralAZ_Obfuscate.urlEncode(email);
				$(this).attr("href", mailto);
				value.innerHTML = CentralAZ_Obfuscate.htmlEncode(text);
			}
		}
	});

	return false;
}

CentralAZ_Obfuscate.htmlEncode = function (value) {
	var result = new String();

	for (var i = 0; i < value.length; i++) {

		// Html encode 25% of characters
		if (Math.random() < 0.25 || value.charAt(i) == ':' || value.charAt(i) == '@' || value.charAt(i) == '.') {
			var charCode = value.charCodeAt(i);
			result += ("&#" + charCode + ";");
			result += "<!-- " + charCode + " -->";
		}
		else {
			result += value.charAt(i);
		}
	}

	return result;
}

CentralAZ_Obfuscate.urlEncode = function (value) {
	var HEX = "0123456789ABCDEF";
	var result = new String();

	for (var i = 0; i < value.length; i++) {
		
		// Url encode 25% of characters
		if (Math.random() < 0.25) {
			var charCode = value.charCodeAt(i);
			result += ("%" + HEX.charAt((charCode >> 4) & 0xF) + HEX.charAt(charCode & 0xF));
		} 
		else {
			result += value.charAt(i);
		}
	}

	return result;
}

$(function () {
	CentralAZ_Obfuscate.obfuscate();
});