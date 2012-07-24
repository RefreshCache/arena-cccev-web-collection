<%@ Control Language="C#" ClassName="ArenaWeb.UserControls.Custom.Cccev.Web2.SimpleSearch" Inherits="Arena.Portal.PortalControl" %>
<%@ Import Namespace="Arena.Portal" %>

<script runat="server">
    [PageSetting("Search Results Page", "Page search results will be displayed on.", true)]
    public string SearchResultPageSetting { get { return Setting("SearchResultPage", "", true); } }

	[TextSetting( "Container DIV CSS Class", "Class name to use for the DIV (panel) that is the container for the module.", false )]
	public string ContainerCSSClassSetting { get { return Setting( "ContainerCSSClass", "", false ); } }

	[TextSetting( "Input CSS Class", "Class name to use for the INPUT (textbox) field. Default 'search'", false )]
	public string InputCSSClassSetting { get { return Setting( "InputCSSClass", "search", false ); } }

	[TextSetting( "Button CSS Class", "Class name to use for the image button (ImageButton) field. Default 'search-button'", false )]
	public string ButtonCSSClassSetting { get { return Setting( "ButtonCSSClass", "search-button", false ); } }
	
	[TextSetting( "Button Image Path", "Path to the desired image for the button (ImageButton). Default '~/Images/blank.gif'", false )]
	public string ButtonImagePathSetting { get { return Setting( "ButtonImagePath", "~/Images/blank.gif", false ); } }

	private void Page_Init( object sender, EventArgs e )
	{
		if ( !Page.IsPostBack )
		{
			pnlSearch.CssClass = ContainerCSSClassSetting;
			tbSearch.CssClass = InputCSSClassSetting;
			ibSearch.CssClass = ButtonCSSClassSetting;
			ibSearch.ImageUrl = ButtonImagePathSetting;
		}
	}
	
    private void ibSearch_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("Default.aspx?page={0}&q={1}", SearchResultPageSetting, Server.UrlEncode(tbSearch.Text)));
    }
    
</script>

<script type="text/javascript">
    $(function () {
        $("input[id$='tbSearch']").focus(function () {
            var $that = $(this);
            if ($that.val() === 'SEARCH') {
                $that.val('');
            }
        })
            .blur(function () {
                var $that = $(this);
                if ($that.val() === '') {
                    $that.val('SEARCH');
                }
            });

        $("input[id$='ibSearch']").click(function () {
            $(document).unbind("submit").bind("submit", function () { return true; });
        });
    });
</script>

<asp:Panel ID="pnlSearch" runat="server" DefaultButton="ibSearch">
<asp:TextBox ID="tbSearch" runat="server" Text="SEARCH" />
<asp:ImageButton ID="ibSearch" runat="server" OnClick="ibSearch_Click" />
</asp:Panel>