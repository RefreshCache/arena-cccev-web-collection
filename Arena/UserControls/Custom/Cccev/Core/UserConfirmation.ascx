<%@ control language="c#" AutoEventWireup="true"  CodeFile="UserConfirmation.ascx.cs" inherits="ArenaWeb.UserControls.Custom.Cccev.Core.UserConfirmation" %>
<%@ Register TagPrefix="Arena" Namespace="Arena.Portal.UI" Assembly="Arena.Portal.UI" %>

<div class="userConfirmation">
<asp:Panel ID="pnlMessage" Runat="server" Visible="False" style="margin-bottom:10px;padding:5px;border:1px solid #333333;background-color:#eeeeee">
	<asp:Label ID="lblMessage" Runat="server" CssClass="errorText error" Visible="False"></asp:Label>
</asp:Panel>

<asp:Panel ID="pnlEdit" Runat="server" CssClass="normalText webForm" DefaultButton="btnSubmit">
	<table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td style="padding:15px">
			<asp:Table cellpadding="2" cellspacing="0" border="0" ID="tbl" runat="server">
			<asp:TableRow>
				<asp:TableCell align="right" class="formLabel" nowrap>First Name</asp:TableCell>
				<asp:TableCell class="formItem">
					<asp:TextBox ID="tbFirstName" Runat="server" CssClass="formItem" size="22" maxlength="50"></asp:TextBox>
					<asp:RequiredFieldValidator ID="reqFirstName" Runat="server" ControlToValidate="tbFirstName" CssClass="errorText" 
						Display="Static" ErrorMessage="First Name is required"> *</asp:RequiredFieldValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow>
				<asp:TableCell align="right" class="formLabel" nowrap>Last Name</asp:TableCell>
				<asp:TableCell class="formItem">
					<asp:TextBox ID="tbLastName" Runat="server" CssClass="formItem" size="22" maxlength="50"></asp:TextBox>
					<asp:RequiredFieldValidator ID="reqLastName" Runat="server" ControlToValidate="tbLastName" CssClass="errorText" 
						Display="Static" ErrorMessage="Last Name is required"> *</asp:RequiredFieldValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow id="trNameText" runat="server">
				<asp:TableCell></asp:TableCell>
				<asp:TableCell id="tdNameText" runat="server" class="smallText"></asp:TableCell>
			</asp:TableRow>
			<asp:TableRow>
				<asp:TableCell align="right" class="formLabel" nowrap>E-mail</asp:TableCell>
				<asp:TableCell class="formItem">
					<asp:TextBox ID="tbEmail" Runat="server" CssClass="formItem" size="22" maxlength="100"></asp:TextBox>
					<asp:RequiredFieldValidator ID="reqEmail" Runat="server" ControlToValidate="tbEmail" CssClass="errorText" 
						Display="Static" ErrorMessage="Email is required"> *</asp:RequiredFieldValidator>
					<asp:RegularExpressionValidator id="revEmail" runat="server" ControlToValidate="tbEmail" CssClass="errorText"
						Display="Static" ValidationExpression="[\w\.\'_%-]+(\+[\w-]*)?@([\w-]+\.)+[\w-]+" 
						ErrorMessage="Invalid Email Address"> *</asp:RegularExpressionValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trBirthDate" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap style="padding-top:10px">Birth Date</asp:TableCell>
				<asp:TableCell class="formItem" nowrap style="padding-top:10px">
					<Arena:DateTextBox ID="tbBirthDate" Runat="server" style="width:80px" CssClass="formItem" MaxLenth="30" />
					<asp:RequiredFieldValidator ID="reqBirthDate" Runat="server" ControlToValidate="tbBirthDate" CssClass="errorText" 
						Display="Static" ErrorMessage="Birth Date is required"> *</asp:RequiredFieldValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trMaritalStatus" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap>Marital Status</asp:TableCell>
				<asp:TableCell class="formItem">
					<asp:DropDownList ID="ddlMaritalStatus" Runat="server" CssClass="formItem"></asp:DropDownList>
					<asp:RequiredFieldValidator ID="reqMaritalStatus" Runat="server" ControlToValidate="ddlMaritalStatus" CssClass="errorText" 
						Display="Static" ErrorMessage="Marital Status is required"> *</asp:RequiredFieldValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trGender" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap>Gender</asp:TableCell>
				<asp:TableCell class="formItem">
					<asp:DropDownList ID="ddlGender" Runat="server" CssClass="formItem">
						<asp:ListItem Value=""></asp:ListItem>
						<asp:ListItem Value="0">Male</asp:ListItem>
						<asp:ListItem Value="1">Female</asp:ListItem>
					</asp:DropDownList>
					<asp:RequiredFieldValidator ID="reqGender" Runat="server" ControlToValidate="ddlGender" CssClass="errorText" 
						Display="Static" ErrorMessage="Gender is required"> *</asp:RequiredFieldValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trStreetAddress" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap style="padding-top:10px">Street Address</asp:TableCell>
				<asp:TableCell class="formItem" style="padding-top:10px">
					<asp:TextBox ID="tbStreetAddress" Runat="server" CssClass="formItem" size="22" maxlength="100"></asp:TextBox>
					<asp:RequiredFieldValidator ID="reqStreetAddress" Runat="server" ControlToValidate="tbStreetAddress" CssClass="errorText" 
						Display="Static" ErrorMessage="Street Address is required"> *</asp:RequiredFieldValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trCity" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap>City</asp:TableCell>
				<asp:TableCell class="formItem">
					<asp:TextBox ID="tbCity" Runat="server" CssClass="formItem" size="22" maxlength="64"></asp:TextBox>
					<asp:RequiredFieldValidator ID="reqCity" Runat="server" ControlToValidate="tbCity" CssClass="errorText" 
						Display="Static" ErrorMessage="City is required"> *</asp:RequiredFieldValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trState" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap>State</asp:TableCell>
				<asp:TableCell class="formItem">
					<asp:DropDownList ID="ddlState" Runat="server" CssClass="formItem">
						<asp:ListItem value=""></asp:ListItem>
						<asp:ListItem value="AL">Alabama</asp:ListItem>
						<asp:ListItem value="AK">Alaska</asp:ListItem>
						<asp:ListItem value="AZ">Arizona</asp:ListItem>
						<asp:ListItem value="AR">Arkansas</asp:ListItem>
						<asp:ListItem value="CA">California</asp:ListItem>
						<asp:ListItem value="CO">Colorado</asp:ListItem>
						<asp:ListItem value="CT">Connecticut</asp:ListItem>
						<asp:ListItem value="DE">Delaware</asp:ListItem>
						<asp:ListItem value="DC">District of Columbia</asp:ListItem>
						<asp:ListItem value="FL">Florida</asp:ListItem>
						<asp:ListItem value="GA">Georgia</asp:ListItem>
						<asp:ListItem value="GU">Guam</asp:ListItem>
						<asp:ListItem value="HI">Hawaii</asp:ListItem>
						<asp:ListItem value="ID">Idaho</asp:ListItem>
						<asp:ListItem value="IL">Illinois</asp:ListItem>
						<asp:ListItem value="IN">Indiana</asp:ListItem>
						<asp:ListItem value="IA">Iowa</asp:ListItem>
						<asp:ListItem value="KS">Kansas</asp:ListItem>
						<asp:ListItem value="KY">Kentucky</asp:ListItem>
						<asp:ListItem value="LA">Louisiana</asp:ListItem>
						<asp:ListItem value="ME">Maine</asp:ListItem>
						<asp:ListItem value="MD">Maryland</asp:ListItem>
						<asp:ListItem value="MA">Massachusetts</asp:ListItem>
						<asp:ListItem value="MI">Michigan</asp:ListItem>
						<asp:ListItem value="MN">Minnesota</asp:ListItem>
						<asp:ListItem value="MS">Mississippi</asp:ListItem>
						<asp:ListItem value="MO">Missouri</asp:ListItem>
						<asp:ListItem value="MT">Montana</asp:ListItem>
						<asp:ListItem value="NE">Nebraska</asp:ListItem>
						<asp:ListItem value="NV">Nevada</asp:ListItem>
						<asp:ListItem value="NH">New Hampshire</asp:ListItem>
						<asp:ListItem value="NJ">New Jersey</asp:ListItem>
						<asp:ListItem value="NM">New Mexico</asp:ListItem>
						<asp:ListItem value="NY">New York</asp:ListItem>
						<asp:ListItem value="NC">North Carolina</asp:ListItem>
						<asp:ListItem value="ND">North Dakota</asp:ListItem>
						<asp:ListItem value="OH">Ohio</asp:ListItem>
						<asp:ListItem value="OK">Oklahoma</asp:ListItem>
						<asp:ListItem value="OR">Oregon</asp:ListItem>
						<asp:ListItem value="PA">Pennsylvania</asp:ListItem>
						<asp:ListItem value="PR">Puerto Rico</asp:ListItem>
						<asp:ListItem value="RI">Rhode Island</asp:ListItem>
						<asp:ListItem value="SC">South Carolina</asp:ListItem>
						<asp:ListItem value="SD">South Dakota</asp:ListItem>
						<asp:ListItem value="TN">Tennessee</asp:ListItem>
						<asp:ListItem value="TX">Texas</asp:ListItem>
						<asp:ListItem value="UT">Utah</asp:ListItem>
						<asp:ListItem value="VT">Vermont</asp:ListItem>
						<asp:ListItem value="VI">Virgin Islands</asp:ListItem>
						<asp:ListItem value="VA">Virginia</asp:ListItem>
						<asp:ListItem value="WA">Washington</asp:ListItem>
						<asp:ListItem value="WV">West Virginia</asp:ListItem>
						<asp:ListItem value="WI">Wisconsin</asp:ListItem>
						<asp:ListItem value="WY">Wyoming</asp:ListItem>
						<asp:ListItem value="AA">AA</asp:ListItem>
						<asp:ListItem value="AE">AE</asp:ListItem>
						<asp:ListItem value="AP">AP</asp:ListItem>
					</asp:DropDownList>
					<asp:RequiredFieldValidator ID="reqState" Runat="server" ControlToValidate="ddlState" CssClass="errorText" 
						Display="Static" ErrorMessage="State is required"> *</asp:RequiredFieldValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trZipCode" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap>Zip Code</asp:TableCell>
				<asp:TableCell class="formItem">
					<asp:TextBox ID="tbZipCode" Runat="server" CssClass="formItem" size="22" maxlength="24"></asp:TextBox>
					<asp:RequiredFieldValidator ID="reqZipCode" Runat="server" ControlToValidate="tbZipCode" CssClass="errorText" 
						Display="Static" ErrorMessage="Zip Code is required"> *</asp:RequiredFieldValidator>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trHomePhone" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap style="padding-top:10px">Home Phone</asp:TableCell>
				<asp:TableCell class="formItem" style="padding-top:10px">
					<Arena:PhoneTextBox ID="tbHomePhone" Runat="server" CssClass="formItem" Required="true" />
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trWorkPhone" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap>Work Phone</asp:TableCell>
				<asp:TableCell class="formItem">
					<Arena:PhoneTextBox ID="tbWorkPhone" Runat="server" CssClass="formItem" />
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow ID="trCellPhone" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap>Cell Phone</asp:TableCell>
				<asp:TableCell class="formItem">
					<Arena:PhoneTextBox ID="tbCellPhone" Runat="server" CssClass="formItem" />
				    <asp:CheckBox ID="cbCellSMS" runat="server" CssClass="smalltext" Text="Enable SMS" />
				</asp:TableCell>
			</asp:TableRow>
			
            <asp:TableRow ID="trCampus" runat="server">
				<asp:TableCell align="right" class="formLabel" nowrap>Primary Campus</asp:TableCell>
				<asp:TableCell class="formItem">
					<asp:DropDownList ID="ddlCampus" runat="server"></asp:DropDownList>
				</asp:TableCell>
            </asp:TableRow>
			
            <asp:TableRow>
				<asp:TableCell align="right" class="formLabel" nowrap valign="top">Notes / Comments</asp:TableCell>
				<asp:TableCell class="formItem" valign="top">
					<asp:TextBox ID="tbNotes" Runat="server" CssClass="formItem" TextMode="MultiLine" Rows="3" style="width:200px;" ></asp:TextBox>
				</asp:TableCell>
			</asp:TableRow>
			<asp:TableRow>
				<asp:TableCell align="right" class="formLabel" nowrap style="padding-top:5px"></asp:TableCell>
				<asp:TableCell class="formItem" style="padding-top:5px">
					<asp:Button ID="btnSubmit" Runat="server" CssClass="smallText" Text="Submit"></asp:Button>
				</asp:TableCell>
			</asp:TableRow>
			</asp:Table>
		</td>
		<td id="tdFamily" runat="server" valign="top" nowrap="nowrap" class="normalText">
            <ul>
                <li class="header">Family Members</li>
                <asp:Literal ID="lcFamilyMembers" runat="server"></asp:Literal>
            </ul>
		</td>
		<td id="tdLogin" runat="server" valign="top" width="200px" style="padding:15px;border-left:solid 1px #999999" class="normalText">
			If you already have an account on our site, login to populate the fields to the left:
			<br><br>
			<asp:Panel ID="pnlLogin" runat="server" DefaultButton="btnSignin">
			<table cellspacing="0" cellpadding="2" border="0">
				<tr>
					<td class="formLabel" style="padding-left:10px">
						Login ID:
					</td>
					<td style="padding-left:5px">
						<asp:TextBox id="txtLoginId" width="100" cssclass="formItem" runat="server" />
					</td>
				</tr>
				<tr>
					<td class="formLabel" style="padding-left:10px">
						Password:
					</td>
					<td style="padding-left:5px">
						<asp:TextBox id="txtPassword" width="100" textmode="password" cssclass="formItem" runat="server" />&nbsp;
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="padding-left:5px" class="anchorText">
						<asp:Button id="btnSignin" runat="server" text="Sign In" CssClass="smallText" CausesValidation="False" onclick="btnSignin_Click"></asp:Button>
					</td>
				</tr>
			</table>
			<div style="padding-left:10px">
				<br>
				<asp:label id="lblLoginMessage" cssClass="errorText" runat="server" />
			</div>
			</asp:Panel>
		</td>
	</tr>
	</table>

</asp:Panel>
</div>
