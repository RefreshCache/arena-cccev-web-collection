<%@ WebService Language="C#" Class="MediaService" %>

using System;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using Arena.Core;
using Arena.DataLayer.Core;
using Arena.Feed;

[WebService(Namespace = "http://cccev.com/WebService/Custom/Cccev/Prayer/PrayerRequests")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class MediaService : WebService 
{
    public class FeedItem
    {
        public string EnclosureUrl { get; set; }
        public string ImageUrl { get; set; }
        public string Author { get; set; }
        public string Title { get; set; }
        public string PublishDate { get; set; }
    }

    [WebMethod]
    [ScriptMethod]
    public FeedItem[] GetMedia()
    {
        try
        {
            const int LIMIT = 15;

            // TODO: Consider mapping this to an org setting
            var channel = new Channel(1);

            var feedItems = (from t in channel.Topics
                             let items = t.ActiveItems
                             from i in items
                             let itemFormat = i.ItemFormats.FirstOrDefault(f => f.MimeType == "text/html")
                             where itemFormat != null && !string.IsNullOrEmpty(itemFormat.EnclosureUrl)
                             orderby i.PublishDate descending
                             select new FeedItem
                                        {
                                            PublishDate = i.PublishDate.ToShortDateString(),
                                            Title = i.Title,
                                            Author = i.Author.Name,
                                            ImageUrl = string.Format("/arena/cachedblob.aspx?guid={0}&height=64&width=212", t.Image.GUID),
                                            EnclosureUrl = i.ItemFormats.FirstOrDefault(f => f.MimeType == "text/html").EnclosureUrl
                                        })
                            .Take(LIMIT);

            return feedItems.ToArray();
        }
        catch (Exception ex)
        {
            new ExceptionHistoryData().AddUpdate_Exception(ex, ArenaContext.Current.Organization.OrganizationID, 
                "Cccev.WebServices", ArenaContext.Current.ServerUrl);
            throw;
        }
    }
    
}