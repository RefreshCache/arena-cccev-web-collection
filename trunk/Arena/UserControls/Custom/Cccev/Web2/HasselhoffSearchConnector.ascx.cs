/**********************************************************************
* Description:  Search Connector for MS Enterprise Search Server.
*				This is entirely based on the reference application found
*				at http://www.codeplex.com/MossSrchWs and the article at
*				http://msdn2.microsoft.com/en-us/library/bb852171.aspx
*
*               The search Query Schema is specified here:
*               http://msdn2.microsoft.com/en-us/library/ms563775.aspx
*               
*               This version of Search Connector has been adapted for
*               Projekt Hasselhoff and made more extensible for future
*               projects.
* 
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created: 6/2/2010
*
* $Workfile: HasselhoffSearchConnector.ascx.cs $
* $Revision: 1 $
* $Header: /trunk/Arena/UserControls/Custom/Cccev/Web2/HasselhoffSearchConnector.ascx.cs   1   2010-06-02 16:37:47-07:00   JasonO $
*
* $Log: /trunk/Arena/UserControls/Custom/Cccev/Web2/HasselhoffSearchConnector.ascx.cs $
*  
*  Revision: 1   Date: 2010-06-02 23:37:47Z   User: JasonO 
*  Adding style rules for search results, extending/cleaning up old search 
*  connector from Liger. 
**********************************************************************/

using System;
using System.Data;
using System.Net;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using Arena.Custom.Cccev.WebUtils.QueryService;
using Arena.Custom.Cccev.WebUtils.Search;
using Arena.Portal;

namespace ArenaWeb.UserControls.Custom.Cccev.Web2
{
    public partial class HasselhoffSearchConnector : PortalControl
    {
        [TextSetting("Search Server URL", "The URL of your MS Search Service (eg, http://mss01/_vti_bin/search.asmx)", true)]
        public string SearchServerURLSetting { get { return Setting("SearchServerURL", "", true); } }

        [TextSetting("WebService Account UserName", "The username to use in the Network Credentials for the WebService call.", true)]
        public string WebServiceUserNameSetting { get { return Setting("WebServiceUserName", "", true); } }

        [TextSetting("WebService Account Password", "The password to use in the Network Credentials for the WebService call.", true)]
        public string WebServicePasswordSetting { get { return Setting("WebServicePassword", "", true); } }

        [TextSetting("WebService Account Domain", "The domain to use in the Network Credentials for the WebService call.", true)]
        public string WebServiceDomainSetting { get { return Setting("WebServiceDomain", "", true); } }

        [NumericSetting("Return Results Page Size", "The number of items to display on each page of the result set (default = 10).", false)]
        public string ReturnResultsPageSizeSetting { get { return Setting("ReturnResultsPageSize", "10", false); } }

        [TextSetting("Search Button Image Path", "Relative path to image for search button above results.", false)]
        public string SearchImagePathSetting { get { return Setting("SearchImagePath", "Templates/CCCEV/Hasselhoff/img/search-big.gif", false); } }

        private DataSet queryResults;
        private readonly DateTime _startTime = DateTime.Now;
        private DateTime _endTime = DateTime.Now;

        protected void Page_Load(object sender, EventArgs e)
        {
            // If the user provided text in the textbox use it...
            if (txtSearch.Text.Length > 0)
            {
                dgSearchResults.CurrentPageIndex = 0;
                MSQueryService();
            }
            // otherwise look for a search term in the query string "q"
            else if (Request.QueryString["q"] != null)
            {
                txtSearch.Text = Request.QueryString["q"];
                dgSearchResults.CurrentPageIndex = 0;
                MSQueryService();
            }
            else
            {
                divHeader.Visible = false;
            }

            ibGo.ImageUrl = string.Format("~/{0}", SearchImagePathSetting);
        }

        /// <summary>
		/// Called when the user clicks the Go/Search button.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnGo_Click( object sender, ImageClickEventArgs e )
		{
			if ( ! String.IsNullOrEmpty( txtSearch.Text ) )
			{
				MSQueryService();
			}
		}

		/// <summary>
		/// Called when changing the page on the datagrid's pager
		/// </summary>
		/// <param name="source"></param>
		/// <param name="e"></param>
		protected void dgSearchResults_PageIndexChanged( object source, DataGridPageChangedEventArgs e )
		{
			dgSearchResults.CurrentPageIndex = e.NewPageIndex;
			BindData( 1 );
		}


		/// <summary>
		/// Used to format the size (bytes) into KB.
		/// </summary>
		/// <param name="size"></param>
		/// <returns></returns>
		public string FormatSize( object size )
		{
			string sSize = "0 KB";
			try
			{
				long lSize = (Int64)size / 1024;
				sSize = lSize + " KB";
			}
			catch
			{ }

			return sSize;
		}

		/// <summary>
		/// This will "bold" the search term in the search result fields.
		/// </summary>
		/// <param name="text">text from a search result field</param>
		/// <returns>the text with the search term bolded using HTML markup</returns>
		public string HighlightKeywords(object text)
		{
			string stringToSearch = (string)text;
			string replacedString = Regex.Replace( stringToSearch, txtSearch.Text, "<b>" + txtSearch.Text + "</b>", RegexOptions.IgnoreCase );
			return replacedString;
		}

		private void MSQueryService()
		{
			BindData( 1 );
		}

		/// <summary>
		/// This will make a search request and bind the search results to the 
		/// table.  In theory the search request could be done in chunks
		/// starting at the given startAt variable, however we're just going to
		/// fetch the entire result set when we do the query since we don't have
		/// 100k+ resulting matches.
		/// </summary>
		/// <param name="startAt"></param>
		private void BindData( int startAt )
		{
			dgSearchResults.PageSize = Convert.ToInt32( ReturnResultsPageSizeSetting );

			try
			{
				string keywordString = txtSearch.Text;
				QueryRequest queryRequest = BuildQueryRequest( keywordString, true, startAt, null );
				QueryService queryService = new QueryService
				                                {
				                                    Url = SearchServerURLSetting,
				                                    Credentials = new NetworkCredential(WebServiceUserNameSetting, WebServicePasswordSetting, WebServiceDomainSetting)
				                                };

			    //queryService.Credentials = System.Net.CredentialCache.DefaultCredentials;
			    queryResults = queryService.QueryEx( queryRequest.ToString() );
				_endTime = DateTime.Now;
				if ( queryResults.Tables[ 0 ].Rows.Count > 0 )
				{
					dgSearchResults.Visible = true;
					divNoResults.Visible = false;
					DisplayHeader( queryResults.Tables[ 0 ].Rows.Count );
					dgSearchResults.DataSource = queryResults.Tables[ 0 ];
					dgSearchResults.DataBind();
				}
				else
				{
					dgSearchResults.Visible = false;
					divHeader.Visible = false;
					divNoResults.Visible = true;
				}
				divErrorMessage.Visible = false;
			}
			catch
			{
				dgSearchResults.DataSource = null;
				dgSearchResults.DataBind();
				divHeader.Visible = false;
				dgSearchResults.Visible = false;
				divErrorMessage.Visible = true;
			}
		}

		private void DisplayHeader( int total )
		{
			divHeader.Visible = true;
			TimeSpan ts = _endTime.Subtract( _startTime );
			int startItem = dgSearchResults.CurrentPageIndex * dgSearchResults.PageSize + 1;
			int endItem = startItem + dgSearchResults.PageSize - 1;
			if ( endItem > total )
				endItem = total;
			divHeader.InnerHtml = "Results <b>" + startItem + "</b> - <b>" + endItem + "</b> of about <b>" + total + "</b>. (<b>" + ts.Seconds + "." + ts.Milliseconds + "</b> seconds)";
		}

		private static QueryRequest BuildQueryRequest( string text, bool isKeyword, int startAt, string target )
        {
			QueryRequest queryRequest = new QueryRequest
			                                {
			                                    QueryText = text, 
                                                QueryID = Guid.NewGuid()
			                                };

		    // Decide what type of query we're doing
            queryRequest.QueryType = isKeyword ? QueryType.Keyword : QueryType.MsSql;

            // Set the number of results to return
			//queryRequest.Count = returnCount;
			queryRequest.StartAt = startAt;

            // Set the web service target, if needed
            if (string.IsNullOrEmpty( target ) == false)
            {
                queryRequest.Target = target;
            }

            // Set query options, as appropriate
            queryRequest.EnableStemming = true; // checkBoxEnableStemming.Checked;
            queryRequest.IgnoreAllNoiseQuery = true; //checkBoxIgnoreAllNoiseQuery.Checked;
            queryRequest.ImplicitAndBehavior = true; //checkBoxImplicitAndBehavior.Checked;
            queryRequest.TrimDuplicates = true; //checkBoxTrimDuplicates.Checked;
            queryRequest.IncludeRelevantResults = true; // checkBoxIncludeRelevantResults.Checked;
            queryRequest.IncludeHighConfidenceResults = true; // checkBoxIncludeHighConfidenceResults.Checked;
            queryRequest.IncludeSpecialTermResults = true; //checkBoxIncludeSpecialTermResults.Checked;
			return queryRequest;
		}
    }
}