<%@ WebService Language="C#" Class="ArenaWebService.Custom.Cccev.Promotions.PromotionService" %>

/**********************************************************************
* Description:	Web Service to get a collection of Arena Promotions
* Created By:	Dallon Feldner
* Date Created:	10/1/2008
*
* $Workfile: PromotionService.asmx $
* $Revision: 10 $ 
* $Header: /trunk/Arena/WebServices/Custom/CCCEV/Promotions/PromotionService.asmx   10   2009-02-04 17:44:24-07:00   DallonF $
* 
* $Log: /trunk/Arena/WebServices/Custom/CCCEV/Promotions/PromotionService.asmx $
* 
* Revision: 10   Date: 2009-02-05 00:44:24Z   User: DallonF 
* Tested GetAllActiveChildEvents() 
* 
* Revision: 9   Date: 2008-11-17 21:51:55Z   User: DallonF 
* Latest version 
* 
* Revision: 8   Date: 2008-11-17 21:45:06Z   User: DallonF 
**********************************************************************/

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Linq;
using System.Web.Services.Protocols;
using Arena.Marketing;
using Arena.Core;
using Arena.Event;
using Arena.Portal;
using Arena.DataLayer.Marketing;
using Arena.Organization;

namespace ArenaWebService.Custom.Cccev.Promotions
{
    [WebService(Namespace = "http://cccev.com/WebService/PromotionService")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class PromotionService : System.Web.Services.WebService
	{

		public struct PromotionSummaryData
		{
			private int _PromotionRequestId;
			public int PromotionRequestId { get { return _PromotionRequestId; } set { _PromotionRequestId = value; } }
						
			private string _Title;
			public string Title { get { return _Title; } set { _Title = value; } }

			private string _ImageURL;
			public string ImageURL { get { return _ImageURL; } set { _ImageURL = value; } }

			private string _Summary;
			public string Summary { get { return _Summary; } set { _Summary = value; } }
		}
		
		public struct EventSummaryData
		{
			public string Summary { get; set; }
			public string ImageUrl { get; set; }
			public DateTime Start { get; set; }
			public DateTime End { get; set; }
			public ContactData Contact { get; set; }

			public struct ContactData
			{
				public string Name { get; set; }
				public string PhoneNumber { get; set; }
				public string Email { get; set; }

				public ContactData(string name, string phone, string email) : this()
				{
					Name = name;
					PhoneNumber = phone;
					Email = email;
				}
			}
			
			public EventSummaryData(EventProfile eventTag, string imagePath) : this()
			{
				Summary = eventTag.Summary;
				ImageUrl = GetImageUrl(eventTag.Image.GUID, imagePath);
				Start = eventTag.Start;
				End = eventTag.End;
				Contact = new ContactData(eventTag.ContactName, eventTag.ContactPhone, eventTag.ContactEmail);
			}	
		}

		[WebMethod]
		public List<EventSummaryData> GetAllActiveChildEvents(int tagId, DateTime fromDate, DateTime toDate, int orgId)
		{
			OrganizationSetting setting = new OrganizationSetting(orgId, "CCCEV.PromoService.ImagePagePath");
			string imagepagepath = setting.Value;
			ProfileCollection profileCollection = new ProfileCollection();
			profileCollection.LoadChildProfiles(tagId, orgId, Arena.Enums.ProfileType.Event, -1);
			IEnumerable<EventSummaryData> tags;
			try
			{
				tags = from Profile p in profileCollection
                       let ep = new EventProfile(p.ProfileID)
					   where ep.Start >= fromDate
					   && ep.Start <= toDate
					   && ep.Active
					   select new EventSummaryData(ep, imagepagepath);
			}
			catch (Exception)
			{
				return new List<EventSummaryData>();
				throw;
			}
			
			return tags.ToList();
		}

		public static string GetImageUrl(Guid blobGuid, string imagepath, int width, int height)
		{
			return string.Format(@"{0}?guid={1}&width={2}&height={3}", imagepath, blobGuid, width, height);
		}
		
		public static string GetImageUrl(Guid blobGuid, string imagepath)
		{
			return string.Format(@"{0}?guid={1}", imagepath, blobGuid);
		}
			

		public static PromotionSummaryData GetDataFromRequest(PromotionRequest req, string imagepath, int height, int width)
		{
			PromotionSummaryData result = new PromotionSummaryData();
			result.PromotionRequestId = req.PromotionRequestID;
			result.Title = req.Title;
			result.ImageURL = GetImageUrl(req.WebSummaryImageBlob.GUID, imagepath, width, height);
			result.Summary = req.WebSummary;
			return result;
		}

		[WebMethod]
		public List<PromotionSummaryData> GetPromotionsByTags(string tagIds, int maxItems, bool eventsOnly, int orgId)
		{
			OrganizationSetting setting = new OrganizationSetting(orgId, "CCCEV.PromoService.ImagePagePath");
			string imagepagepath = setting.Value;
			setting = new OrganizationSetting(orgId, "CCCEV.PromoService.ImageHeight");
			int imageheight = Convert.ToInt32(setting.Value);
			setting = new OrganizationSetting(orgId, "CCCEV.PromoService.ImageWidth");
			int imagewidth = Convert.ToInt32(setting.Value);
			List<PromotionSummaryData> results = new List<PromotionSummaryData>();
			string tagIdsString = tagIds; 
			
            PromotionRequestCollection promoColl = new PromotionRequestCollection();
            promoColl.LoadCurrentWebRequests(tagIdsString, "", -1, maxItems, eventsOnly, -1);
            results = (from PromotionRequest p in promoColl
                      select GetDataFromRequest(p, imagepagepath, imageheight, imagewidth)).ToList();
            /*DataTable promotions = new PromotionRequestData().GetCurrentPromotionWebRequests_DT(
                tagIdsString, "", -1, maxItems, eventsOnly, -1);
			foreach (DataRow row in promotions.Rows)
			{
				int promoId = (int)row["promotion_request_id"];
				PromotionRequest req = new PromotionRequest(promoId);
				results.Add(GetDataFromRequest(req, imagepagepath, imageheight, imagewidth));
			}*/
			return results;
		}

	} 
}

