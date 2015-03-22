 /**********************************************************************
* Description:	Used to fetch events for the given date range, topic list
*				and campus which are:
*					- non-private visibility
*					- approved
*					- active
*					- occurrence start time falls within the given date range
*					- the event's campus is set to "all" or matches the given campus
*					- the event's primary topic area is blank or matches one of the
*					  given topic IDs. 
*
*				The results are ordered by the occurrence start date/time.
*
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created:	8/16/2010
*
* $Workfile: cust_cccev_webu_sp_get_eventsByDateRangeTopicAndCampus.sql $
* $Revision: 2 $ 
* $Header: /trunk/Database/Stored Procedures/cust/Cccev/webu/cust_cccev_webu_sp_get_eventsByDateRangeTopicAndCampus.sql   2   2012-07-18 11:30:21-07:00   nicka $
* 
* $Log: /trunk/Database/Stored Procedures/cust/Cccev/webu/cust_cccev_webu_sp_get_eventsByDateRangeTopicAndCampus.sql $
*  
*  Revision: 2   Date: 2012-07-18 18:30:21Z   User: nicka 
*  Updated with Jason's 2011-11-11 changes that are in production. 
*  
*  Revision: 1   Date: 2010-10-13 18:59:08Z   User: nicka 
*  
**********************************************************************/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id=OBJECT_ID(N'[cust_cccev_webu_sp_get_eventsByDateRangeTopicAndCampus]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [cust_cccev_webu_sp_get_eventsByDateRangeTopicAndCampus]
GO

CREATE PROC [dbo].[cust_cccev_webu_sp_get_eventsByDateRangeTopicAndCampus]

@StartDate DATETIME,
@EndDate DATETIME,
@TopicAreas VARCHAR(1000),
@CampusIDs VARCHAR(100)

AS

SELECT  p.*,
		e.*,
		o.occurrence_id,
		o.occurrence_start_time AS occurrence_start,
		o.occurrence_end_time AS occurrence_end
FROM evnt_event_profile e WITH(NOLOCK)
INNER JOIN core_profile p WITH(NOLOCK)
	ON e.profile_id = p.profile_id
LEFT OUTER JOIN core_profile_occurrence po WITH(NOLOCK)
	ON e.profile_id = po.profile_id
LEFT OUTER JOIN core_occurrence o WITH(NOLOCK)
	ON po.occurrence_id = o.occurrence_id
WHERE e.visibility_type_luid <> 763  -- Private visibility
	AND e.approved_date <> '1/1/1900' 
	AND (
			--e.start BETWEEN @StartDate AND @EndDate AND
			o.occurrence_start_time BETWEEN @StartDate AND @EndDate
		)
	AND (
			@TopicAreas = '' OR
			e.topic_area_luid IN(
									SELECT [item] 
									FROM [dbo].[fnSplit](@TopicAreas)
								)
		)
	AND P.active = 1
	AND	(
			@CampusIDs = '-1' OR
			(
				P.campus_id IS NULL OR
				P.campus_id = -1
			) OR
			P.campus_id in ( select item from fnSplit(@CampusIDs) )
		)
ORDER BY o.occurrence_start_time
GO