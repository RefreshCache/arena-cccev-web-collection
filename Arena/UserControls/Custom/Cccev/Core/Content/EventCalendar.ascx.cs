namespace ArenaWeb.UserControls.Custom.Cccev.Core
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using System.Web.Services;
	using System.Web.Services.Protocols;
	using System.Net;
	using System.Text;
	using System.Configuration;
	using Arena.Core;
	using Arena.Event;
	using Arena.Portal;
	using Arena.Exceptions;
	using Arena.DataLayer.Core;

	/// <summary>
	///		Summary description for EventCalendar.
	/// </summary>
	public partial class EventCalendar : PortalControl
	{
        #region Module Settings

        // Module Settings
        [TextSetting("Topic Areas", "Optional Comma-delimited list of Topic Area IDs to filter on.", false)]
        public string TopicAreasSetting { get { return Setting("TopicAreas", "", false); } }

        [ListFromSqlSetting("Event Visibility Filter", "Optional list of visibilites to be shown in this listing. If none are selected, all will be shown.", false, "",
    "select lookup_id, lookup_value from core_lookup where lookup_type_id = (select lookup_type_id from core_lookup_type where guid = '2DF05A65-19DD-408C-B1F9-1F24AFE5BE9B') order by lookup_value", ListSelectionMode.Multiple)]
        public string VisibilitySetting { get { return Setting("Visibility", "", false); } }

        [BooleanSetting("Topic Area List Visible", "Flag indicating if Topic Area drop down list should be displayed.", false, false)]
        public string TopicAreaListVisibleSetting { get { return Setting("TopicAreaListVisible", "false", false); } }

        [PageSetting("Detail Page", "The page to use for displaying the event details.", true)]
        public string DetailPageIdSetting { get { return Setting("DetailPageId", "", true); } }

        [TextSetting("Calendar Title", "The title to use for the calendar.", false)]
        public string CalendarTitleSetting { get { return Setting("CalendarTitle", "", false); } }

        [BooleanSetting("Show Times", "Flag indicating if times should be displayed.", false, false)]
        public string ShowTimesSetting { get { return Setting("ShowTimes", "false", false); } }

        [CssSetting("CSS File", "Optional Cascading Style Sheet (CSS) to use for calendar.", false)]
        public string CalendarCssSetting { get { return Setting("CalendarCss", "", false); } }

		[NumericSetting( "Number of Months", "Number of months to show in the calendar. Default 4.", false )]
		public string NumberOfMonthsSetting { get { return Setting( "NumberOfMonths", "4", false ); } }

		[BooleanSetting( "Hide Calendar Controls", "Flag indicating if the calendar month and year dropdowns should be hidden.", false, false )]
		public string HideCalendarControlsSetting { get { return Setting( "HideCalendarControls", "false", false ); } }

        #endregion

		protected String[] monthNames={"January","February","March","April","May","June","July","August","September","October","November","December"};
		
		protected void Page_Load(object sender, System.EventArgs e)
		{
            BasePage.AddJavascriptInclude(Page, "include/popupWindow.js");

			// get topicAreas search
            ddTopicArea.Visible = TopicAreaListVisibleSetting.ToLower() == "true";

			StringBuilder calendarScripts = new StringBuilder();

			if (CalendarCssSetting != string.Empty)
				calendarScripts.Append("<link href=\"" + Utilities.GetApplicationPath() + "/css/" + CalendarCssSetting + "\" type=\"text/css\" rel=\"stylesheet\">");
			else
				calendarScripts.Append("<link href=\"" + Utilities.GetApplicationPath() + "/css/calendar.css\" type=\"text/css\" rel=\"stylesheet\">");

			Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "calendarPopup", calendarScripts.ToString());

			if (! IsPostBack)
			{
				if ( HideCalendarControlsSetting.ToLower() == "true" )
				{
					tblCalendarControls.Visible = false;
				}
				else
				{
					for ( int i = 0; i < 12; i++ )
					{
						ListItem item = new ListItem( monthNames[i], Convert.ToString( i + 1 ) );
						if ( ( i + 1 ) == DateTime.Now.Month )
							item.Selected = true;
						ddMonth.Items.Add( item );
					}

					for ( int i = ( DateTime.Now.Year - 1 ); i <= ( DateTime.Now.Year + 1 ); i++ )
					{
						ListItem item = new ListItem( i.ToString(), i.ToString() );
						if ( i == DateTime.Now.Year )
							item.Selected = true;
						ddYear.Items.Add( item );
					}

					if ( ddTopicArea.Visible )
					{
						ListItem li = new ListItem( "All", TopicAreasSetting );
						ddTopicArea.Items.Add( li );

						if ( TopicAreasSetting == string.Empty )
							new LookupType( SystemLookupType.TopicArea ).Values.LoadDropDownList( ddTopicArea );
						else
						{
							foreach ( string topicArea in TopicAreasSetting.Split( ',' ) )
							{
								int topicID = -1;
								if ( Int32.TryParse( topicArea, out topicID ) )
								{
									Lookup topicLu = new Lookup( topicID );
									ddTopicArea.Items.Add( new ListItem( topicLu.Value, topicLu.LookupID.ToString() ) );
								}
							}
						}
					}
				}

				BuildCalendar();	
			}
		}

		private void BuildCalendar()
		{
			string topicAreas = string.Empty;

			// get topicAreas settings
			if (ddTopicArea.Visible)
				topicAreas = ddTopicArea.SelectedValue;
			else
				topicAreas = TopicAreasSetting;

			// get calendar title
            lblCalendarTitle.Text = CalendarTitleSetting;

			int month = DateTime.Now.Month;
			int year = DateTime.Now.Year;

			// get Time Period
			if ( HideCalendarControlsSetting.ToLower() == "false" )
			{
				month = Int32.Parse( ddMonth.SelectedValue );
				year = Int32.Parse( ddYear.SelectedValue );
			}

			// clear current calendar
			tblCalendar.Rows.Clear();
			int numberOfMonths = int.Parse( NumberOfMonthsSetting );

			DateTime calendarEndDate = DateTime.Now.AddMonths( numberOfMonths );
			int daysInLastMonth = DateTime.DaysInMonth( calendarEndDate.Year, calendarEndDate.Month );

			lblCalendarDesc.Text = monthNames[month -1] + ", " + year.ToString();

			TableRow row = new TableRow();
			TableCell cell = new TableCell();

			// Get Calendar Data
			DateTime startDate = DateTime.Parse( month.ToString() + "/1/" + year.ToString() );
			DateTime endDate = DateTime.Parse( calendarEndDate.Month.ToString() + "/" + daysInLastMonth.ToString() + "/" + calendarEndDate.Year.ToString() );

			DataTable dtCalendar = new ProfileData().GetCalendarEvents_DT(startDate, endDate.AddDays(1).AddSeconds(-1), topicAreas, VisibilitySetting, Arena.Core.ArenaContext.Current.Organization.OrganizationID);

			// hide error label
			lblError.Visible = false;
			tblCalendar.Visible = true;

			String[] dayNames={"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};


			for ( int m = 1; m < numberOfMonths; m++ )
			{
				BuildMonth( month, year, ref row, ref cell, dtCalendar, dayNames );
				DateTime nextMonth = startDate.AddMonths( m );
				month = nextMonth.Month;
				year = nextMonth.Year;
			}
		}

		private void BuildMonth( int month, int year, ref TableRow row, ref TableCell cell, DataTable dtCalendar, String[] dayNames )
		{
			int daysPrinted = 0;
			// Add month name row
			row = new TableRow();
			cell = new TableCell();
			cell.HorizontalAlign = HorizontalAlign.Center;
			cell.ColumnSpan = 7;
			cell.Text = monthNames[month - 1] + ", " + year.ToString();
			cell.CssClass = "calendarDateTitle";
			row.Cells.Add( cell );
			tblCalendar.Rows.Add( row );

			// determine day of the week of the first of the month
			DateTime firstOfMonth = new DateTime( year, month, 1 );
			int positionOfFirstDay = Convert.ToInt32( firstOfMonth.DayOfWeek );

			// write day headings
			row = new TableRow();
			for ( int i = 0; i <= 6; i++ )
			{
				cell = new TableCell();
				cell.HorizontalAlign = HorizontalAlign.Center;
				cell.Width = Unit.Percentage( 14 );
				cell.Text = dayNames[i];
				cell.CssClass = "calendarDayHeadingCell";
				row.Cells.Add( cell );
			}
			tblCalendar.Rows.Add( row );

			// load up blank days
			row = new TableRow();
			for ( int i = 1; i <= positionOfFirstDay; i++ )
			{
				cell = new TableCell();
				cell.CssClass = "calendarBlankCell";
				cell.Text = "&nbsp;";
				row.Cells.Add( cell );
				daysPrinted++;
			}

			int daysInMonth = DateTime.DaysInMonth( year, month );

			for ( int i = 1; i <= daysInMonth; i++ )
			{
				if ( daysPrinted == 7 )
				{
					tblCalendar.Rows.Add( row );
					row = new TableRow();
					daysPrinted = 0;
				}

				DateTime curDate = DateTime.Parse( month.ToString() + "/" + i.ToString() + "/" + year.ToString() );

				// get events for current day
				string filter = "occurrence_end_time >= #" + curDate.ToShortDateString() + "# " +
					"and occurrence_start_time < #" + curDate.AddDays( 1 ).ToShortDateString() + "# ";

				//filter = "OccId > 0";
				DataRow[] events = dtCalendar.Select( filter );

				cell = new TableCell();
				cell.CssClass = "calendarCell";
				cell.VerticalAlign = VerticalAlign.Top;
				cell.Text = "<span class=\"calendarNumber\">" + i.ToString() + "</span><ul class=\"calendarItemList\">";

				foreach ( DataRow eventRow in events )
				{
					EventProfile eProfile = new EventProfile( (int)eventRow["profile_id"] );
					DateTime StartTime = ( (DateTime)eventRow["occurrence_start_time"] );
					DateTime EndTime = ( (DateTime)eventRow["occurrence_end_time"] );
					string eventDesc = eProfile.Summary;
					eventDesc = eventDesc.Replace( "'", "\\'" );
					eventDesc = eventDesc.Replace( "\"", "\\'" );
					eventDesc = Utilities.replaceCRLF( eventDesc );

					cell.Text += "<li>";
					if ( ShowTimesSetting.ToLower() == "true" )
					{
						StringBuilder eTime = new StringBuilder();
						if ( StartTime < curDate )
							eTime.Append( "12:00 AM - " );
						else
							eTime.AppendFormat( "{0} - ", StartTime.ToShortTimeString() );

						if ( EndTime > curDate.AddDays( 1 ).AddSeconds( -1 ) )
							eTime.Append( "11:59 PM<br/>" );
						else
							eTime.AppendFormat( "{0}<br/>", EndTime.ToShortTimeString() );

						cell.Text += eTime.ToString();
					}

					string href = string.Empty;
					if ( eProfile.ExternalLink.Trim() != string.Empty )
						href = eProfile.ExternalLink.Trim();
					else
						href = string.Format( "default.aspx?page={0}&occurrenceId={1}&profileId={2}",
							DetailPageIdSetting, eventRow["occurrence_id"].ToString(), eProfile.ProfileID.ToString() );

					cell.Text += string.Format( "<a href=\"{0}\" class=\"calendarItemLink\" onmousemove=\"javascript:get_mouse(event);\" onmouseover=\"javascript:popup('{1}')\" onmouseout=\"kill();\">{2}</a><br/><br/>\n",
						href, eventDesc, eProfile.Name );
				}
				cell.Text += "</ul>";
				row.Cells.Add( cell );

				daysPrinted++;
			}

			for ( int i = daysPrinted; i < 7; i++ )
			{
				cell = new TableCell();
				cell.CssClass = "calendarBlankCell";
				cell.Text = "&nbsp;";
				row.Cells.Add( cell );
			}

			// add final row
			tblCalendar.Rows.Add( row );
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.btnSearch.Click += new EventHandler(btnSearch_Click);
		}

		#endregion

		private void btnSearch_Click(object sender, EventArgs e)
		{
			BuildCalendar();
		}
	}
}
