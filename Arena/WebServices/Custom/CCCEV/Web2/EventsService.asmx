﻿<%@ WebService Language="C#" Class="EventsService" %>

/**********************************************************************
* Description:  TBD
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: TBD
*
* $Workfile: EventsService.asmx $
* $Revision: 12 $
* $Header: /trunk/Arena/WebServices/Custom/CCCEV/Web2/EventsService.asmx   12   2011-04-05 15:46:09-07:00   JasonO $
*
* $Log: /trunk/Arena/WebServices/Custom/CCCEV/Web2/EventsService.asmx $
* 
* Revision: 12   Date: 2011-04-05 22:46:09Z   User: JasonO 
* Functionality updates for Glendale campus rollout and usability 
* improvements. 
* 
* Revision: 11   Date: 2010-08-04 21:45:02Z   User: JasonO 
* Adding some validation logic to close potential XSS vulnerabilities. 
* 
* Revision: 10   Date: 2010-08-03 23:56:55Z   User: JasonO 
* Adding ability to define topic areas on calendar pages. 
* 
* Revision: 9   Date: 2010-07-28 15:48:28Z   User: JasonO 
* Tweaking GetEventRelativeTime algorithm logic for determining whether an 
* event is past. Now comparing dates only. 
* 
* Revision: 8   Date: 2010-07-26 21:04:28Z   User: JasonO 
* Adding Occurrence ID's to EventProfile's ForeignKey field to build dynamic 
* URL to event details page. 
* 
* Revision: 7   Date: 2010-07-23 00:37:33Z   User: JasonO 
* Making a few last second tweaks 
* 
* Revision: 6   Date: 2010-07-22 23:56:15Z   User: JasonO 
* Adding method overload and logic for determining tag importance 
* 
* Revision: 5   Date: 2010-07-21 22:23:44Z   User: JasonO 
* Refactoring web service code into controller class. 
**********************************************************************/

using System;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using Arena.Custom.Cccev.DataUtils;
using Arena.Custom.Cccev.FrameworkUtils.Application;
using Arena.Event;

[WebService(Namespace = "http://localhost/Arena")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class EventsService : WebService
{
    private readonly EventProfileController controller;
    
    public EventsService()
    {
        controller = new EventProfileController();
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public object[] GetEventList(DateTime start, DateTime end, string keywords, string topicIDs, int campusID, int pageID)
    {
        // Valiating to prevent any funny business
        if (!topicIDs.IsValidIDList())
        {
            throw new InvalidOperationException("Hey! No funny business!");
        }
        

        return (from e in controller.GetEventsByDateRangeAndCampus(start, end, keywords, topicIDs, campusID)
                let cssClass = (e.Campus == null || campusID != e.Campus.CampusId) ? "all-church-event" : "event-profile"
                select GetEventJson(e, pageID, cssClass)).ToArray();
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public object[] GetAlphabeticalEventList(DateTime start, DateTime end, string keywords, string topicIDs, int campusID, int pageID)
    {
        // Valiating to prevent any funny business
        if (!topicIDs.IsValidIDList())
        {
            throw new InvalidOperationException("Hey! No funny business!");
        }

        return (from e in controller.GetEventsByDateRangeAndCampus(start, end, keywords, topicIDs, campusID)
                let className = GetEventRelativeTime(e)
                orderby e.Name ascending
                select GetEventJson(e, pageID, className)).ToArray();
    }
    
    /// <summary>
    /// Algorithm for calculating an event's time relative to the given start date. Similar to Twitter's relative time.
    /// </summary>
    /// <param name="eventProfile">Event Profile to compare</param>
    /// <returns>Relative date string</returns>
    private static string GetEventRelativeTime(EventProfile eventProfile)
    {
        TimeSpan timeSpan = eventProfile.Start - DateTime.Now;
        
        if (DateTime.Now.Date > eventProfile.Start.Date) { return "past"; }
        if (timeSpan.Days == 0) { return "today"; }
        if (timeSpan.Days == 1) { return "tomorrow"; }
        if (timeSpan.Days <= 7) { return "this-week"; }
        if (timeSpan.Days > 7 && timeSpan.Days <= 14) { return "next-week"; }
        if (timeSpan.Days > 14 && timeSpan.Days <= 21) { return "two-weeks"; }
        if (timeSpan.Days > 21 && timeSpan.Days <= 28) { return "three-weeks"; }
        if (timeSpan.Days > 28 && timeSpan.Days <= 31) { return "one-month"; }
        if (timeSpan.Days > 31 && timeSpan.Days <= 62) { return "two-months"; }
        if (timeSpan.Days > 62 && timeSpan.Days <= 93) { return "three-months"; }
        
        return "more-than-three-momths";
    }
    
    /// <summary>
    /// Converts an EventProfile object to an anonymous object to be parsed to JSON by the client
    /// </summary>
    /// <param name="eventProfile">EventProfile to convert</param>
    /// <param name="pageID">Event Details page ID</param>
    /// <param name="cssClass">CSS class name</param>
    /// <returns>Anonymous object</returns>
    private static object GetEventJson(EventProfile eventProfile, int pageID, string cssClass)
    {      
        return new
        {
            id = eventProfile.ProfileID,
            title = eventProfile.Name,
            description = eventProfile.Summary,
            allDay = false,
            start = eventProfile.Start.ToString(),
            end = eventProfile.End.ToString(),
            url = eventProfile.ExternalLink.Trim() != string.Empty ? 
                eventProfile.ExternalLink : 
                string.Format("default.aspx?page={0}&profileId={1}&occurrenceId={2}", 
                    pageID, eventProfile.ProfileID, eventProfile.ForiegnKey),
            imageUrl = string.Format("CachedBlob.aspx?guid={0}", eventProfile.Image.GUID),
            className = cssClass,
            editable = false
        };
    }

}