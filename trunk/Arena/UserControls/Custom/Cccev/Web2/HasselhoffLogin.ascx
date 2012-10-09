<%@ control language="c#" inherits="ArenaWeb.UserControls.Security.UserLogin, Arena" %>
<%@ Import Namespace="Arena.Portal" %>
<script runat="server">
    
    [PageSetting("Passthrough Page", "Page to tunnel login request through.", false)]
    public string PassthroughPageSetting { get { return Setting("PassthroughPage", "", false); } }
    
    private void Page_PreRender(object sender, EventArgs e)
    {
        btnLoginSend.Text = "I Forgot My User Name";

        if (!string.IsNullOrEmpty(PassthroughPageSetting))
        {
            ihPassthrough.Value = PassthroughPageSetting;
        }
    }
</script>
<div id="centralaz-login">
    <h3>Sign in with your Central account</h3>
    <input type="hidden" id="iRedirect" runat="server" name="iRedirect" />
    <input type="hidden" id="ihPassthrough" runat="server" name="ihPassthrough" />
    <asp:label id="lblMessage" cssClass="errorText error" runat="server" Visible="false" />

    <asp:Panel id="pnlLogin" runat="server" Visible="true" CssClass="pnlLogin" DefaultButton="btnSignin">
        <ul>
            <li>
                <label for="<%= txtLoginId.ClientID %>"><%= LoginIDCaptionSetting %>:</label>
                <asp:TextBox id="txtLoginId" cssclass="formItem" runat="server" />
            </li>
            <li>
                <label for="<%= txtPassword.ClientID %>">Password:</label>
                <asp:TextBox id="txtPassword" textmode="password" cssclass="formItem" runat="server" /><br/>
                <asp:checkbox id="cbRemember" CssClass="smallText" runat="server" Text="Remember Password" />
            </li>
        </ul>
        <asp:Button id="btnSignin" runat="server" text="Sign In" CssClass="smallText" onclick="btnSignin_Click"></asp:Button>
        <asp:Panel ID="pnlImportantNote" runat="Server" CssClass="important notice" Visible="false"/>
    </asp:Panel>

    <asp:Panel ID="pnlChangePassword" CssClass="changePass" runat="server" Visible="False" DefaultButton="btnChangePassword">
	    <h3>Your password has expired.  Please change it before continuing.</h3>
        <ul>
            <li>
                <label for="<%= txtNewPassword.ClientID %>">New Password:</label>
                <asp:TextBox ID="txtNewPassword" TextMode="Password" CssClass="formItem" runat="server" />
			    <asp:RequiredFieldValidator ControlToValidate="txtNewPassword" ID="rfvNewPassword" Runat= "server" ErrorMessage="Password is required!" CssClass="errorText error" Display="None" SetFocusOnError="true"></asp:RequiredFieldValidator>
			    <asp:RegularExpressionValidator ControlToValidate="txtNewPassword" ID="revNewPassword" Runat="server" ErrorMessage="Invalid Password" CssClass="errorText error" ValidationExpression="\w+" EnableClientScript="false"></asp:RegularExpressionValidator>
            </li>
            <li>
                <label for="<%= txtNewPassword2.ClientID %>">Confirm Password:</label>
                <asp:TextBox ID="txtNewPassword2" TextMode="Password" CssClass="formItem" runat="server" />
			    <asp:RequiredFieldValidator ControlToValidate="txtNewPassword2" ID="rfvNewPassword2" Runat= "server" ErrorMessage="Password confirmation is required!" CssClass="errorText error" Display="None" SetFocusOnError="true"></asp:RequiredFieldValidator>
			    <asp:CompareValidator ID="cvNewPassword2" Runat="server" ControlToValidate="txtNewPassword2" ControlToCompare="txtNewPassword" ErrorMessage="Password confirmation must match password!" CssClass="errorText error" Display="None" Operator="Equal"></asp:CompareValidator>
            </li>
        </ul>
        <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="smallText" OnClick="btnChangePassword_Click" />
    </asp:Panel>

    <asp:Panel ID="pnlCreateAccount" CssClass="module createAccount" Runat="server" Visible="False">
	    <asp:Button ID="btnCreateAccount" Runat="server" Text="Create An Account" CssClass="smallText" />
    </asp:Panel>

    <asp:Panel ID="pnlForgot" CssClass="module forgotPass" Runat="server" Visible="False">
	    <asp:Button ID="btnSend" Runat="server" Text="I Forgot My Password" CssClass="smallText" />
	    <asp:Button ID="btnLoginSend" Runat="server" CssClass="smallText" />
    </asp:Panel>

    <script type="text/javascript">
        $(function () {
            $("input[id$='btnSignin']").click(function() {
                var passthroughPage = $("input[id$='ihPassthrough']").val(),
                    redirectPath = window.location.search,
                    queryString;
                redirectPath = redirectPath.substring(redirectPath.indexOf("requestUrl=") + 11);

                if (passthroughPage.trim() !== "" && redirectPath.trim() !== "") {
                    queryString = "default.aspx?page=" + passthroughPage + "&requestUrl=" + escape(redirectPath);
                    $("input[id$='iRedirect']").val(queryString);
                }

                return true;
            });
        });
    </script>
</div>