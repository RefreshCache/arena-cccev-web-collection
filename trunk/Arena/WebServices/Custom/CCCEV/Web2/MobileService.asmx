<%@ WebService Language="C#" Class="MobileService" %>

using System.Text.RegularExpressions;
using System.Web.Script.Services;
using System.Web.Services;
using Arena.Utility;

[WebService(Namespace = "http://localhost/arena")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class MobileService  : WebService 
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void SubmitFeedback(string name, string email, string message)
    {
        var isValid = true;
        var emailAddress = Server.UrlDecode(email);
        var emailIsValid = new Regex(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");

        var fromName = Server.UrlDecode(name);
        fromName = fromName.Replace("\n", "");
        fromName = fromName.Replace("\r", "");
        
        var emailBody = Server.UrlDecode(message);

        var nameIsValid = (!string.IsNullOrEmpty(fromName) && fromName.Trim().ToLower() != "undefined");
        var bodyIsValid = (!string.IsNullOrEmpty(emailBody) && emailBody.Trim().ToLower() != "undefined");
        
        if (!emailIsValid.IsMatch(emailAddress) && string.IsNullOrEmpty(emailAddress))
        {
            isValid = false;
        }
        
        if (!nameIsValid || !bodyIsValid)
        {
            isValid = false;
        }
        
        if (isValid)
        {
            ArenaSendMail.SendMail(emailAddress, fromName, "webmaster@centralaz.com", email, string.Empty, string.Empty, 
                "Feedback from CentralAZ Mobile", string.Empty, emailBody);
        }
    }
}