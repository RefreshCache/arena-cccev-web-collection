<%@ Control Language="C#" AutoEventWireup="true" ClassName="SimpleLoginLogout" Inherits="Arena.Portal.PortalControl" %>
<%@ Import Namespace="Arena.Portal" %>

<script runat="server">
    
    [PageSetting("Registration Page", "Page to send users to create an account.", true)]
    public string RegistrationPageSetting { get { return Setting("RegistrationPage", "", true); } }

    [PageSetting("User Profile Page", "Optional page that would direct a user to edit their personal information.", false)]
    public string UserProfilePageSetting { get { return Setting("UserProfilePage", "", false); } }
    
    private void lbLogout_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        Response.Cookies["portalRoles"].Value = null;
        Response.Cookies["portalRoles"].Path = "/";
        Response.Redirect(Request.ApplicationPath);
    }
    
</script>

<% if (Request.IsAuthenticated) {
       if (!string.IsNullOrEmpty(UserProfilePageSetting)) { %>
          <a href="default.aspx?page=<%= UserProfilePageSetting %>" class="login"><%= CurrentPerson.FullName %></a>
    <% }
       else { %>
           <span class="login"><%= CurrentPerson.FullName %>
    <% } %>
     | <asp:LinkButton ID="lbLogout" runat="server" Text="Logout" OnClick="lbLogout_Click" /></span>
<% }
   else { %>
    <span class="login"><a href="default.aspx?page=<%= CurrentPortal.LoginPageID %>&requestUrl=<%= Server.UrlEncode(Request.RawUrl) %>">Login</a> | <a href="default.aspx?page=<%= RegistrationPageSetting %>">Register</a></span>
<% } %>