<%@ WebService Language="C#" Class="PromotionService" %>
/**********************************************************************
* Description:  Fetches Arena News/Promotions.
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Created:	04/28/2010 13:42:02
*
* $Workfile: PromotionService.asmx $
* $Revision: 13 $ 
* $Header: /trunk/Arena/WebServices/Custom/CCCEV/Web2/PromotionService.asmx   13   2010-12-30 11:37:16-07:00   nicka $
* 
* $Log: /trunk/Arena/WebServices/Custom/CCCEV/Web2/PromotionService.asmx $
* 
* Revision: 13   Date: 2010-12-30 18:37:16Z   User: nicka 
* Don't send bad urls to invalid CachedBlob when the guid is blank. 
* 
* Revision: 12   Date: 2010-08-30 23:37:05Z   User: nicka 
* Total rewrite to work 100% via client ajax webservice calls. 
* 
* Revision: 11   Date: 2010-08-18 21:42:14Z   User: nicka 
* When getting promotions, if no topic is supplied, it will only retrieve the 
* topics that are active and where qualifier 2 is true. 
* 
* Revision: 10   Date: 2010-08-04 21:45:02Z   User: JasonO 
* Adding some validation logic to close potential XSS vulnerabilities. 
* 
* Revision: 9   Date: 2010-08-02 23:33:42Z   User: nicka 
* Added support for passing an event details page ID. 
* 
* Revision: 8   Date: 2010-05-27 16:50:44Z   User: nicka 
* Turns out a PromotionRequest will sometimes have a NULL Campus property. 
* 
* Revision: 7   Date: 2010-05-27 16:40:41Z   User: JasonO 
* One last R# suggestion. 
* 
* Revision: 6   Date: 2010-05-27 16:36:23Z   User: nicka 
* Recommended Resharper cleanup 
* 
* Revision: 5   Date: 2010-05-27 16:13:26Z   User: nicka 
* Changed Campus filtering to include all non-campus specific items and 
* matching campus specific items. 
* 
* Revision: 4   Date: 2010-05-26 21:24:16Z   User: JasonO 
* Adding support for setting preferred news topics 
* 
* Revision: 3   Date: 2010-05-25 16:10:10Z   User: nicka 
* Remove second method signature 
* 
* Revision: 2   Date: 2010-05-20 20:14:01Z   User: nicka 
* Changed GetTopics to GetTopicList 
* 
* Revision: 1   Date: 2010-05-20 17:52:08Z   User: nicka 
**********************************************************************/
using System;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using Arena.Core;
using Arena.Document;
using Arena.Marketing;
using Arena.Utility;

using Arena.Custom.Cccev.FrameworkUtils.FrameworkConstants;
using Arena.Custom.Cccev.DataUtils;

[WebService(Namespace = "http://localhost/Arena")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class PromotionService : WebService
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public object[] GetTopicList()
    {
        LookupCollection topics = new LookupCollection(SystemLookupType.TopicArea);

        return (from topic in topics.OfType<Lookup>()
                where topic.Active && topic.Qualifier2 == "true"
                orderby topic.Order
                select GetTopicJson(topic)
               ).ToArray();
    }

    [Obsolete( "Use GetPrimaryPromotions instead." )]
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public object[] GetPromotions( int campusID, string topicIDs, int promotionDetailPageID, int eventDetailPageID )
    {
        return GetGeneral( topicIDs, "primary", campusID, 99, false, -1, promotionDetailPageID, eventDetailPageID );
    }

    [WebMethod]
    [ScriptMethod( ResponseFormat = ResponseFormat.Json )]
    public object[] GetPrimary( string topicIDs, int campusID, int promotionDetailPageID, int eventDetailPageID )
    {
        return GetGeneral( topicIDs, "primary", campusID, 99, false, -1, promotionDetailPageID, eventDetailPageID );
    }
    
    [WebMethod]
    [ScriptMethod( ResponseFormat = ResponseFormat.Json )]
    public object[] GetByAreaFilter( string topicIDs, string areaFilter, int campusID, int maxItems, int documentTypeID, int promotionDetailPageID, int eventDetailPageID )
    {
        return GetGeneral( topicIDs, areaFilter, campusID, maxItems, false, documentTypeID, promotionDetailPageID, eventDetailPageID );
    }
    
    /// <summary>
    /// Gets the active promotions for the given campusID, topicsIDs, and areaFilter parameters.
    /// If no topicsIDs are supplied, then every "active" topic whose qualifier 2 is true is used.
    /// </summary>
    /// <param name="topicIDs">Comma delimited string of topicIDs.</param>
    /// <param name="areaFilter">primary, secondary or both</param>
    /// <param name="campusID">A campus ID or -1 to match all campuses.</param>
    /// <param name="maxItems">max number of items to return</param>
    /// <param name="eventsOnly">Boolean indicating if only promotions tied to events should be returned.</param>
    /// <param name="documentTypeID">A documentTypeID or -1 to match all campuses.</param>
    /// <param name="promotionDetailPageID">The page ID of a page which contains a promotion details module.</param>
    /// <param name="eventDetailPageID">The page ID of a page which contains an event details module.</param>
    /// <returns>An array of promotions { id, topic, title, summary, imageUrl, detailsUrl } where the detailsUrl
    /// either refers to the promotion's external URL value, or event details page, or a promotion details page.</returns>
    [WebMethod]
    [ScriptMethod( ResponseFormat = ResponseFormat.Json )]
    public object[] GetGeneral( string topicIDs, string areaFilter, int campusID, int maxItems, bool eventsOnly, int documentTypeID, int promotionDetailPageID, int eventDetailPageID )
    {
        // Valiating to prevent any funny business
        if ( !topicIDs.IsValidIDList() )
        {
            throw new InvalidOperationException( "Hey! No funny business!" );
        }

        if ( topicIDs == string.Empty )
        {
            LookupCollection topics = new LookupCollection( SystemLookupType.TopicArea );

            topicIDs = string.Join( ",", ( from topic in topics.OfType<Lookup>()
                                           where topic.Active && topic.Qualifier2 == "true"
                                           orderby topic.Order
                                           select topic.LookupID.ToString()
                   ).ToArray() );
        }

        PromotionRequestCollection prc = new PromotionRequestCollection();

        // WARNING!!!
        // DON'T pass the campusID to LoadCurrentWebRequests or else you'll only get
        // items which are tied to it, instead, we will filter down below to include
        // items that are non-campus specific AND items which are campusID specific
        prc.LoadCurrentWebRequests( topicIDs, areaFilter, -1, maxItems, eventsOnly, documentTypeID );

        return ( from p in prc.OfType<PromotionRequest>()
                 where p.Campus == null || p.Campus.CampusId == -1 || p.Campus.CampusId == campusID

                 orderby p.Priority
                 select GetPromotionJson( p, promotionDetailPageID, eventDetailPageID, documentTypeID )
               ).ToArray();
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public object ChangeTopics(string topicsIDs)
    {
        // Valiating to prevent any funny business
        if (!topicsIDs.IsValidIDList())
        {
            throw new InvalidOperationException("Hey! No funny business!");
        }

        var context = ArenaContext.Current;

        if (context.Person != null && context.Person.PersonID != Constants.NULL_INT)
        {            
            Arena.Core.Attribute attribute = new Arena.Core.Attribute(SystemGuids.WEB_PREFS_NEWS_TOPICS_ATTRIBUTE);
            PersonAttribute personAttribute = new PersonAttribute(context.Person.PersonID, attribute.AttributeId);
            personAttribute.StringValue = topicsIDs;
            personAttribute.Save(context.Organization.OrganizationID, context.User.Identity.Name);
        }

        return null;
    }

    #region Private Helpers

    private static object GetTopicJson(Lookup topic)
    {
        return new
        {
            id = topic.LookupID,
            name = topic.Value
        };
    }

    private static object GetPromotionJson( PromotionRequest p, int promotionDetailPageID, int eventDetailPageID, int documentTypeID )
    {
        return new
        {
            id = p.PromotionRequestID,
            topic = p.TopicArea.Value,
            title = p.Title,
            summary = p.WebSummary,
            priority = p.Priority,
            imageUrl = GetImageUrl( p, documentTypeID ),
            detailsUrl = GetDetailsUrl( p, promotionDetailPageID, eventDetailPageID )
        };
    }

	/// <summary>
	///	Creates the URL to the image via the CachedBlob.
	/// </summary>
	/// <param name="guid"></param>
	/// <returns>the image URL to the cached blob or an empty string.</returns>
    private static string GetImageUrl( PromotionRequest promotion, int documentTypeID )
    {
        string guid = string.Empty;
        if ( documentTypeID != -1 )
        {
            PromotionRequestDocument doc = promotion.Documents.GetFirstByType( documentTypeID );
            if ( doc != null )
            {
                guid = doc.GUID.ToString();
            }
        }
        else
        {
            guid = promotion.WebSummaryImageBlob.GUID.ToString();
        }

		if ( string.Empty == guid )
		{
			return "";
		}
		else
		{
			return string.Format( "CachedBlob.aspx?guid={0}", guid );
		}
    }
	
    private static string GetDetailsUrl( PromotionRequest promotion, int promotionDetailPageID, int eventDetailPageID )
    {
        if (promotion.WebExternalLink != string.Empty)
        {
            return promotion.WebExternalLink;
        }

        if ( promotion.EventID != -1 )
        {
            return string.Format( "default.aspx?page={0}&eventId={1}", eventDetailPageID, promotion.EventID );
        }

        string detailPage = ( promotionDetailPageID == -1 ) ? "" : String.Format( "page={0}&", promotionDetailPageID );
        
        return String.Format("default.aspx?{0}promotionId={1}", detailPage, promotion.PromotionRequestID);
    }

    #endregion
}