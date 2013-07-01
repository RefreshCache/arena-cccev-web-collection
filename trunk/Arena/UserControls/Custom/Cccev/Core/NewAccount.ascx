<%@ control language="c#"  CodeFile="NewAccount.ascx.cs" inherits="ArenaWeb.UserControls.Custom.Cccev.Core.NewAccount" %>
		
<input type="hidden" id="iRedirect" runat="server" name="iRedirect" />
<input type="hidden" id="iEmail" runat="server" name="iEmail" />
<input type="hidden" id="iPassword" runat="server" name="iPassword" />
	
<asp:Panel ID="pnlMessage" Runat="server" Visible="False" style="margin-bottom:10px;padding:5px;border:1px solid #333333;background-color:#eeeeee">
	<asp:Label ID="lblMessage" Runat="server" CssClass="errorText" Visible="False" />
	<asp:Panel ID="pnlEmailExists" Runat="server">
		<table cellpadding="0" cellspacing="0" border="0">
		    <tr>
			    <td valign="top"><img src="images/public/question.jpg" border="0" /></td>
			    <td valign="top" class="errorText" style="padding-left:5px">
				    The e-mail address you've entered is already associated with 
				    one or more existing account(s) in our system. These accounts
				    are listed below. You can have the username and password of 
				    any of these existing accounts e-mailed to you by clicking 
				    the 'Send Info'	link next to the name.<br /><br />
				    <div class="smallText" style="padding-left:10px">
					    <asp:PlaceHolder ID="phExistingAccounts" Runat="server" />
				    </div>
				    <br />
				    If you still wish to continue creating a new account, please click 
				    the 'Create New Account' button below.<br /><br />
				    <asp:Button ID="btnCreate" Runat="server" CssClass="smallText" Text="Create New Account" />
			    </td>
		    </tr>
		</table>
	</asp:Panel>
</asp:Panel>
<asp:Panel ID="pnlCreateAccount" runat="server" DefaultButton="btnSubmit">
    <asp:Literal runat="server" ID="litPrefixHTML"></asp:Literal>
    <div class="textWrap create-account container-fluid">
        <div class="row-fluid">
            <div class="span4"> <!-- Column 1 -->
                <div class="control-group">
                    <label class="control-label formItem" for="tbFirstName">First name</label>
                    <div class="controls">
                        <asp:TextBox placeholder="First name" ID="tbFirstName" Runat="server" TabIndex="1" CssClass="formItem" maxlength="50" />
			            <asp:RequiredFieldValidator ID="reqFirstName" Runat="server" ControlToValidate="tbFirstName" CssClass="errorText" Display="Dynamic" ErrorMessage="First Name is required" Text=" *" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label formItem" for="tbLirstName">Last name</label>
                    <div class="controls">
                        <asp:TextBox placeholder="Last name" ID="tbLastName" Runat="server" TabIndex="2" CssClass="formItem" maxlength="50" />
			            <asp:RequiredFieldValidator ID="reqLastName" Runat="server" ControlToValidate="tbLastName" CssClass="errorText" 
				        Display="Dynamic" ErrorMessage="Last Name is required" Text=" *" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label formItem" for="tbEmail">E-mail</label>
                    <div class="controls">
                            <asp:TextBox placeholder="user@something.com" ID="tbEmail" Runat="server" TabIndex="3" CssClass="formItem" maxlength="100" />
			                <asp:RequiredFieldValidator ID="reqEmail" Runat="server" ControlToValidate="tbEmail" CssClass="errorText" 
				                Display="Dynamic" ErrorMessage="A Valid Email is required" Text=" *" />
			                <asp:RegularExpressionValidator id="revEmail" runat="server" ControlToValidate="tbEmail" CssClass="errorText"
				                Display="Dynamic" ValidationExpression="[\w\.\'_%-]+(\+[\w-]*)?@([\w-]+\.)+[\w-]+" 
				                ErrorMessage="Invalid Email Address" Text=" *" />
                    </div>
                </div>

                <div class="control-group" runat="server" id="cgBirthDate">
                    <label class="control-label formItem" for="tbBirthDate">Birth Date</label>
                    <div class="controls">
			            <Arena:DateTextBox placeholder="mm/dd/yyyy" ID="tbBirthDate" Runat="server" style="width:80px" TabIndex="4" CssClass="formItem" MaxLenth="30" />
			            <asp:RequiredFieldValidator ID="reqBirthDate" Runat="server" ControlToValidate="tbBirthDate" CssClass="errorText" 
				            Display="Dynamic" ErrorMessage="Birth Date is required" Text=" *" />
                    </div>
                </div>

                <div class="control-group" runat="server" id="cgMaritalStatus">
                    <label class="control-label formItem" for="ddlMaritalStatus">Marital Status</label>
                    <div class="controls">
			            <asp:DropDownList ID="ddlMaritalStatus" Runat="server" TabIndex="5" CssClass="formItem" />
			            <asp:RequiredFieldValidator ID="reqMaritalStatus" Runat="server" ControlToValidate="ddlMaritalStatus" CssClass="errorText" 
				            Display="Dynamic" ErrorMessage="Marital Status is required" Text=" *" />
                    </div>
                </div>

                <div class="control-group" runat="server" id="cgGender">
                    <label class="control-label formItem" for="ddlGender">Gender</label>
                    <div class="controls">
			            <asp:DropDownList ID="ddlGender" Runat="server" TabIndex="6" CssClass="formItem">
				            <asp:ListItem Value="" />
				            <asp:ListItem Value="0" Text="Male" />
				            <asp:ListItem Value="1" Text="Female" />
			            </asp:DropDownList>
			            <asp:RequiredFieldValidator ID="reqGender" Runat="server" ControlToValidate="ddlGender" CssClass="errorText" 
				            Display="Dynamic" ErrorMessage="Gender is required" Text=" *" />
                    </div>
                </div>

            </div>

            <div class="span4"> <!-- Column 2 -->

                <div class="control-group" runat="server" id="cgAddress">
                    <label class="control-label formItem" for="tbStreetAddress">Street Address</label>
                    <div class="controls">
	                    <asp:TextBox placeholder="555 E. Main St." ID="tbStreetAddress" Runat="server" TabIndex="7" CssClass="formItem" maxlength="100" />
                        <asp:RequiredFieldValidator ID="reqStreetAddress" Runat="server" ControlToValidate="tbStreetAddress" CssClass="errorText" 
				            Display="Dynamic" ErrorMessage="Street Address is required" Text=" *" />
                    </div>

                    <label class="control-label formItem" for="tbCity">City</label>
                    <div class="controls">
	                    <asp:TextBox placeholder="City" ID="tbCity" Runat="server" CssClass="formItem" TabIndex="8" maxlength="64" />
                        <asp:RequiredFieldValidator ID="reqCity" Runat="server" ControlToValidate="tbCity" CssClass="errorText" 
				            Display="Dynamic" ErrorMessage="City is required" Text=" *" />
                    </div>

                    <label class="control-label formItem" for="ddlState">State</label>
                    <div class="controls">
	                    <asp:DropDownList ID="ddlState" Runat="server" TabIndex="9" CssClass="formItem">
                            <asp:ListItem value="" />
                            <asp:ListItem value="AL" Text="Alabama" />
                            <asp:ListItem value="AK" Text="Alaska" />
                            <asp:ListItem value="AZ" Text="Arizona" />
                            <asp:ListItem value="AR" Text="Arkansas" />
                            <asp:ListItem value="CA" Text="California" />
                            <asp:ListItem value="CO" Text="Colorado" />
                            <asp:ListItem value="CT" Text="Connecticut" />
                            <asp:ListItem value="DE" Text="Delaware" />
                            <asp:ListItem value="DC" Text="District of Columbia" />
                            <asp:ListItem value="FL" Text="Florida" />
                            <asp:ListItem value="GA" Text="Georgia" />
                            <asp:ListItem value="GU" Text="Guam" />
                            <asp:ListItem value="HI" Text="Hawaii" />
                            <asp:ListItem value="ID" Text="Idaho" />
                            <asp:ListItem value="IL" Text="Illinois" />
                            <asp:ListItem value="IN" Text="Indiana" />
                            <asp:ListItem value="IA" Text="Iowa" />
                            <asp:ListItem value="KS" Text="Kansas" />
                            <asp:ListItem value="KY" Text="Kentucky" />
                            <asp:ListItem value="LA" Text="Louisiana" />
                            <asp:ListItem value="ME" Text="Maine" />
                            <asp:ListItem value="MD" Text="Maryland" />
                            <asp:ListItem value="MA" Text="Massachusetts" />
                            <asp:ListItem value="MI" Text="Michigan" />
                            <asp:ListItem value="MN" Text="Minnesota" />
                            <asp:ListItem value="MS" Text="Mississippi" />
                            <asp:ListItem value="MO" Text="Missouri" />
                            <asp:ListItem value="MT" Text="Montana" />
                            <asp:ListItem value="NE" Text="Nebraska" />
                            <asp:ListItem value="NV" Text="Nevada" />
                            <asp:ListItem value="NH" Text="New Hampshire" />
                            <asp:ListItem value="NJ" Text="New Jersey" />
                            <asp:ListItem value="NM" Text="New Mexico" />
                            <asp:ListItem value="NY" Text="New York" />
                            <asp:ListItem value="NC" Text="North Carolina" />
                            <asp:ListItem value="ND" Text="North Dakota" />
                            <asp:ListItem value="OH" Text="Ohio" />
                            <asp:ListItem value="OK" Text="Oklahoma" />
                            <asp:ListItem value="OR" Text="Oregon" />
                            <asp:ListItem value="PA" Text="Pennsylvania" />
                            <asp:ListItem value="PR" Text="Puerto Rico" />
                            <asp:ListItem value="RI" Text="Rhode Island" />
                            <asp:ListItem value="SC" Text="South Carolina" />
                            <asp:ListItem value="SD" Text="South Dakota" />
                            <asp:ListItem value="TN" Text="Tennessee" />
                            <asp:ListItem value="TX" Text="Texas" />
                            <asp:ListItem value="UT" Text="Utah" />
                            <asp:ListItem value="VT" Text="Vermont" />
                            <asp:ListItem value="VI" Text="Virgin Islands" />
                            <asp:ListItem value="VA" Text="Virginia" />
                            <asp:ListItem value="WA" Text="Washington" />
                            <asp:ListItem value="WV" Text="West Virginia" />
                            <asp:ListItem value="WI" Text="Wisconsin" />
                            <asp:ListItem value="WY" Text="Wyoming" />
                            <asp:ListItem value="AA" Text="AA" />
                            <asp:ListItem value="AE" Text="AE" />
                            <asp:ListItem value="AP" Text="AP" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="reqState" Runat="server" ControlToValidate="ddlState" CssClass="errorText" 
				            Display="Dynamic" ErrorMessage="State is required" Text=" *" />
                    </div>

                    <label class="control-label formItem" for="tbZipCode">ZIP Code</label>
                    <div class="controls">
	                    <asp:TextBox placeholder="00000-0000" ID="tbZipCode" Runat="server" TabIndex="10" CssClass="formItem" maxlength="24" />
                        <asp:RequiredFieldValidator ID="reqZipCode" Runat="server" ControlToValidate="tbZipCode" CssClass="errorText" 
				            Display="Dynamic" ErrorMessage="Zip Code is required" Text=" *" />
                    </div>

                </div>

                <div class="control-group" runat="server" id="cgHomePhone">
                    <label class="control-label formItem" for="tbHomePhone">Home Phone</label>
                    <div class="controls">
                        <Arena:PhoneTextBox placeholder="(xxx) xxx-xxxx" ID="tbHomePhone" Runat="server" TabIndex="11" CssClass="formItem" Required="true" />
                    </div>
                </div>

                <div class="control-group" runat="server" id="cgWorkPhone">
                    <label class="control-label formItem" for="tbWorkPhone">Work Phone</label>
                    <div class="controls">
                        <Arena:PhoneTextBox placeholder="(xxx) xxx-xxxx" ID="tbWorkPhone" Runat="server" TabIndex="12" CssClass="formItem" ShowExtension="true" />
                    </div>
                </div>

                <div class="control-group" runat="server" id="cgCellPhone">
                    <label class="control-label formItem" for="tbCellPhone">Cell Phone</label>
                    <div class="controls">
	                    <Arena:PhoneTextBox placeholder="(xxx) xxx-xxxx" ID="tbCellPhone" Runat="server" CssClass="formItem" TabIndex="13" />
                         <label class="checkbox">
                            <asp:CheckBox ID="cbSMS" runat="server" class="smallText" TabIndex="14" Text="Enable SMS" />
                        </label>
                    </div>
                </div>
            </div>

            <div class="span4"> <!-- Column 3 -->

                <div class="control-group" runat="server" id="cgCampus">
                    <label class="control-label formItem" for="ddlCampus">Primary Campus</label>
                    <div class="controls">
                        <asp:DropDownList ID="ddlCampus" runat="server" CssClass="formItem" TabIndex="15"></asp:DropDownList>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label formItem" for="tbLoginID">Desired Login ID</label>
                    <div class="controls">
	                <asp:TextBox id="tbLoginID" Runat="server" TabIndex="16" cssclass="formItem" width="100" MaxLength="50" />        
                    <asp:RequiredFieldValidator ID="reqLoginID" Runat="server" ControlToValidate="tbLoginID" CssClass="errorText" 
				        Display="Dynamic" ErrorMessage="Desired Login ID is required" Text=" *" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label formItem" for="tbPassword">Password</label>
                    <div class="controls">
	                    <asp:TextBox id="tbPassword" Runat="server" TabIndex="17" TextMode="Password" cssclass="formItem" width="100" MaxLength="100" />        
                        <asp:RequiredFieldValidator ID="reqPassword" Runat="server" ControlToValidate="tbPassword" CssClass="errorText" EnableViewState="True"  
				            Display="Dynamic" ErrorMessage="Password is required" Text=" *" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label formItem" for="tbPassword2">Verify Password</label>
                    <div class="controls">
	                    <asp:TextBox id="tbPassword2" Runat="server" TabIndex="18" TextMode="Password" cssclass="formItem" width="100" MaxLength="100" />        
                        <asp:RequiredFieldValidator ID="reqPassword2" Runat="server" ControlToValidate="tbPassword2" CssClass="errorText" EnableViewState="True" 
				            Display="Dynamic" ErrorMessage="Verify Password is required" Text=" *" />
                        <asp:CompareValidator ID="cvPassword2" Runat="server" ControlToValidate="tbPassword2" ControlToCompare="tbPassword" Operator="Equal" 
				            CssClass="errorText" Display="Dynamic" ErrorMessage="Verify Password does not equal Password" Text=" *" />
                    </div>
                </div>

                <asp:Button ID="btnSubmit" Runat="server" CssClass="smallText btn btn-primary" TabIndex="19" Text="Register" />

            </div>
        </div>
    </div>
    <asp:Literal runat="server" ID="litPostfixHTML"></asp:Literal>
</asp:Panel>