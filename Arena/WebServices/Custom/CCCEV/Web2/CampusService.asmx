<%@ WebService Language="C#" Class="CampusService" %>

using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using Arena.Core;
using Arena.Custom.Cccev.DataUtils;
using Arena.Custom.Cccev.FrameworkUtils.Application;
using Arena.Custom.Cccev.FrameworkUtils.FrameworkConstants;
using Arena.Organization;

[WebService(Namespace = "http://localhost/Arena")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class CampusService : WebService 
{
    private readonly CampusController controller;
    
    public CampusService()
    {
        controller = new CampusController();
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public object GetCampus()
    {
        var campus = controller.GetDefaultCampus();
        var lookup = controller.GetCampusExtendedAttributes(campus.CampusId);
        return GetCampusJson(campus, lookup);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public object GetCampusByID(int campusID)
    {
        if (campusID == -1)
        {
            return GetFakeCampus();
        }
        
        var campus = ArenaContext.Current.Organization.Campuses.FirstOrDefault(c => c.CampusId == campusID);
        var lookup = controller.GetCampusExtendedAttributes(campusID);
        return GetCampusJson(campus, lookup);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
    public object[] GetCampusList()
    {
        var lookupType = new LookupType(SystemGuids.CAMPUS_LOOKUP_TYPE);
        var campuses = controller.GetCampusList();

        return (from c in campuses
                let campus = c
                let lookup = lookupType.Values.FirstOrDefault(l => int.Parse(l.Qualifier) == campus.CampusId)
                select GetCampusJson(c, lookup)).ToArray();
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void ChangeCampus(int campusID)
    {
        var context = ArenaContext.Current;

        if (context.Person != null && context.Person.PersonID != Constants.NULL_INT)
        {
            controller.ChangeCurrentPersonCampus(campusID);
        }
    }
    
    private static object GetCampusJson(Campus campus, Lookup lookup)
    {
        // TODO: Consider adding some resiliency here. Lookup could be null Arena is not configured properly
        var address = campus.Address;
        return new {
                       campusID = campus.CampusId,
                       name = campus.Name,
                       address = address.StreetLine1,
                       city = address.City,
                       state = address.State,
                       zip = address.PostalCode,
                       phone = lookup.Qualifier2,
                       email = lookup.Qualifier3,
                       expireMe_3_7 = true
                   };
    }
    
    private static object GetFakeCampus()
    {
        return new {
                        campusID = -1,
                        name = "Select Campus",
                        address = "",
                        city = "",
                        state = "",
                        zip = "",
                        phone = "480.924.4946",
                        email = "info@centralaz.com",
                        expireMe_3_7 = true
                   };
    }
}