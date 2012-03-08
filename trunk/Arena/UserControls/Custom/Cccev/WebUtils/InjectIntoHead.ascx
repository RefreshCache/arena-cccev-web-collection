<%@ Control Language="C#" ClassName="InjectIntoHead" Inherits="Arena.Portal.PortalControl" %>
<%@ Import Namespace="Arena.Portal"%>
<asp:ScriptManagerProxy ID="smpScripts" runat="server" />
<asp:PlaceHolder ID="phScript" runat="server" />
<script runat="server">
/**********************************************************************
* Description:	Dynamically inject an HTML tag into the page header
* Created By:   Nick Airdo @ Central Christian Church of the East Valley
* Date Conjured:	03/08/2012
*
* $Workfile: InjectIntoHead.ascx $
* $Revision: 1 $ 
* $Header: /trunk/Arena/UserControls/Custom/Cccev/WebUtils/InjectIntoHead.ascx   1   2012-03-08 15:22:41-07:00   nicka $
* 
* $Log: /trunk/Arena/UserControls/Custom/Cccev/WebUtils/InjectIntoHead.ascx $
*  
*  Revision: 1   Date: 2012-03-08 22:22:41Z   User: nicka 
*  Injects text HTML into the page header. 
**********************************************************************/
[TextSetting( "HTML Tag To Inject", "An literal HTML tag (ie: <meta name=\"viewport\" content=\"width=1024; user-scalable=yes\" />).", false )]
    public string HtmlTagSetting { get { return Setting( "HtmlTag", "", false ); } }

    private void Page_Load(object sender, EventArgs e)
    {
        if ( !string.IsNullOrEmpty( HtmlTagSetting ) )
        {
            Page.Header.Controls.Add( new LiteralControl( HtmlTagSetting ) );
        }
    }
</script>
