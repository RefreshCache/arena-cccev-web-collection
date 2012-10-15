/**********************************************************************
* Description:  Increments a page's hit counter. 
* Created By:	Nick Airdo @ Central Christian Church (Cccev)
* Date Created:	4/5/2012 11:32:59 PM
*
* $Workfile: SimpleHitCounter.ascx.cs $
* $Revision: 1 $ 
* $Header: /trunk/Arena/UserControls/Custom/Cccev/WebUtils/SimpleHitCounter.ascx.cs   1   2012-04-11 13:35:57-07:00   nicka $
* 
* $Log: /trunk/Arena/UserControls/Custom/Cccev/WebUtils/SimpleHitCounter.ascx.cs $
*  
*  Revision: 1   Date: 2012-04-11 20:35:57Z   User: nicka 
*  Simple hit counter module and service used for VBS 2012 
**********************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

using Arena.Core;
using Arena.Portal;
using Arena.DataLayer.Core;

namespace ArenaWeb.UserControls.Custom.Cccev.WebUtils
{
	public partial class SimpleHitCounter : PortalControl
	{
		[NumericSetting( "LookupTypeID", "ID of the Lookup Type where storing hit counter.", true )]
		public int LookupTypeIDSetting { get { return Convert.ToInt16( Setting( "LookupTypeID", "", true ) ); } }

		[NumericSetting( "LookupID", "ID of the Lookup for this page's hit counter.", true )]
		public int LookupIDSetting { get { return Convert.ToInt32( Setting( "LookupID", "", true ) ); } }

		protected IEnumerable<Lookup> storageLookupType;

		protected void Page_Load( object sender, EventArgs e )
		{
			int pageID = CurrentPortalPage.PortalPageID;

			try
			{
				Lookup pageLookup = new Lookup( LookupIDSetting, false );

				if ( pageLookup == null )
				{
					// Save the new start time for the campus.
					Lookup newLookup = new Lookup();
					newLookup.LookupTypeID = LookupTypeIDSetting;
					newLookup.Value = pageID.ToString();
					newLookup.Qualifier = "1";
					newLookup.Qualifier2 = DateTime.Now.ToShortDateTimeString();
					newLookup.Save();
				}
				else
				{
					int i = Convert.ToInt32( pageLookup.Qualifier );
					i++;
					pageLookup.Qualifier = i.ToString();
					pageLookup.Qualifier2 = DateTime.Now.ToShortDateTimeString();
					pageLookup.Save();
				}
			}
			catch ( System.Exception ex )
			{
				// Log this error.
			}
		}
	}
}