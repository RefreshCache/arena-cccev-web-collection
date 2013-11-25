<%@ Control Language="c#" Inherits="ArenaWeb.UserControls.Custom.Cccev.Core.FamilyRegistration" CodeFile="FamilyRegistration.ascx.cs" %>
<%@ Import Namespace="Arena.Core" %>
<%@ Import Namespace="Arena.Custom.CCV.Core" %>

<div id="FamilyPreRegistration" class="module">

    <asp:UpdatePanel ID="upFamily" runat="server">
    <ContentTemplate>
       
        <asp:HiddenField ID="hfYouGuid" runat="server" />
        <asp:HiddenField ID="hfSpouseGuid" runat="server" />
        
        <asp:Panel ID="pnlYou" runat="server">
            <h2>Your Information</h2>
            <p>
                Thanks for taking the time to pre-register for the children's area. Please enter your information below.
				Enter as much information as possible. Your name is required, and the additional information <b>we use to make
				sure we don't create a duplicate</b> of you in our database.
				<span class="info">If you enter your cell phone number, you'll be able to use that number to check-in on the weekend.</span>
            </p>
            
            <ul>
            <li class="name">
            <p>
                <asp:Label ID="lblYouFirstName" runat="server" AssociatedControlID="tbYouFirstName" Text="Your First Name"></asp:Label>
                <asp:TextBox ID="tbYouFirstName" class="formItem" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfYouFirstName" runat="server" ControlToValidate="tbYouFirstName" Display="Dynamic" 
                    ErrorMessage="Your First Name is required!"> *</asp:RequiredFieldValidator>
            </p>            
            <p>
                <asp:Label ID="lblYouLastName" runat="server" AssociatedControlID="tbYouLastName" Text="Your Last Name"></asp:Label>
                <asp:TextBox ID="tbYouLastName" class="formItem" runat="server" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfYouLastName" runat="server" ControlToValidate="tbYouLastName" Display="Dynamic" 
                    ErrorMessage="Your Last Name is required!"> *</asp:RequiredFieldValidator>
            </p>       
            </li>
            <li class="address">     
            <p>
                <asp:Label ID="lblAddress" runat="server" AssociatedControlID="tbAddress" Text="Your Address"></asp:Label>
                <asp:TextBox ID="tbAddress" class="formItem" runat="server" Width="200px" ></asp:TextBox><br />
            </p>
            <p>
                <asp:TextBox ID="tbCity" class="formItem" runat="server">City</asp:TextBox><strong>,</strong>&nbsp;&nbsp;
                <asp:TextBox ID="tbState" class="formItem" runat="server" Width="25px">AZ</asp:TextBox>
                <asp:TextBox ID="tbZip" class="formItem" runat="server" Width="80px">Zip</asp:TextBox>
            </p>      
            </li>
            <li class="information">      
            <p>
                <asp:Label ID="lblYouHome" runat="server" AssociatedControlID="ptbYouHomeNum" Text="Your Home Number"></asp:Label>
                <Arena:PhoneTextBox ID="ptbYouHomeNum" CssClass="formItem" runat="server" />
            </p>            
            <p>
                <asp:Label ID="lblYouBirthDate" runat="server" AssociatedControlID="dtYouBirthDate" Text="Your Birthdate"></asp:Label>
                <Arena:DateTextBox ID="dtYouBirthDate" class="formItem" runat="server" Width="80px"></Arena:DateTextBox>
            </p>            
            <p>
                <asp:Label ID="lblYouGender" runat="server" AssociatedControlID="ddlYouGender" Text="Your Gender"></asp:Label>
                <asp:DropDownList ID="ddlYouGender" class="formItem" runat="server"> 
                    <asp:ListItem Text="" Value="Unknown"></asp:ListItem>
                    <asp:ListItem Text="Female" Value="Female"></asp:ListItem>
                    <asp:ListItem Text="Male" Value="Male" ></asp:ListItem>
                </asp:DropDownList>
            </p>      
            </li>
            </ul>      
            <div class="buttons">
                <asp:LinkButton ID="lbYouNext" class="button" runat="server" Text="Next >>" 
                    onclick="lbYouNext_Click"></asp:LinkButton>
            </div>
        </asp:Panel>
        
        <asp:Panel ID="pnlSpouse" runat="server" Visible="false">
            <h2>Spouse Information</h2>
            <p>
                If you have a spouse you can enter her/his information below. If not, just skip this step.
            </p>
            <ul>
            <li>
            <p>
                <asp:Label ID="lblSpouseFirstName" runat="server" AssociatedControlID="tbSpouseFirstName" Text="Spouse First Name"></asp:Label>
                <asp:TextBox ID="tbSpouseFirstName" class="formItem" runat="server" Width="100px"></asp:TextBox>
            </p>            
            <p>
                <asp:Label ID="lblSpouseLastName" runat="server" AssociatedControlID="tbSpouseLastName" Text="Spouse Last Name"></asp:Label>
                <asp:TextBox ID="tbSpouseLastName" class="formItem" runat="server" Width="100px"></asp:TextBox>
            </p>
            </li>
            <li>            
            <p>
                <asp:Label ID="lblSpouseBirthDate" runat="server" AssociatedControlID="dtSpouseBirthDate" Text="Spouse Birthdate"></asp:Label>
                <Arena:DateTextBox ID="dtSpouseBirthDate" class="formItem" runat="server" Width="80px"></Arena:DateTextBox>
            </p>            
            </li>
            </ul>

            <div class="buttons">
                 <asp:LinkButton ID="lbSpousePrev" runat="server" class="button" Text="<< Back" 
                    onclick="lbSpousePrev_Click"></asp:LinkButton>
               <asp:LinkButton ID="lbSpouseNext" runat="server" class="button" Text="Next >>" 
                    onclick="lbSpouseNext_Click"></asp:LinkButton>
            </div>
        </asp:Panel>
        
        <asp:Panel ID="pnlFamilyMembers" runat="server" CssClass="PreRegistration" Visible="false">
        
            <h2>Your Children</h2>
            <p>
                Enter the information for your children below.
            </p>
            <ul>
            <li class="children">
            <asp:ListView ID="lvFamilyMembers" runat="server" OnItemDataBound="lvFamilyMembers_OnItemDataBound" OnItemCommand="lvFamilyMembers_OnItemCommand">

                <LayoutTemplate>
	                <table cellpadding="2" cellspacing="0" border="0">
	                <tr>
	                    <th>First</th>
	                    <th>Last</th>
	                    <th>Birth Date</th>
	                    <th>Gender</th>
	                    <th>Grade</th>
	                    <th></th>
	                </tr>
	                <tr runat="server" id="itemPlaceHolder"></tr>
	                <tr>
	                    <td></td>
	                    <td colspan="6"><asp:LinkButton ID="lbAddChild" runat="server" Text="Add Another Child" CommandName="Add"></asp:LinkButton></td>
	                </tr>
	                </table>
                </LayoutTemplate>

                <ItemTemplate>
                    <tr>
		            <td><asp:HiddenField ID="hfPersonGuid" runat="server" Value='<%# Eval("PersonGuid") %>' />
		            <asp:TextBox ID="tbFirstName" CssClass="formItem" runat="server" Width="100px" Text='<%# Eval("NickName") %>'></asp:TextBox></td>
		            <td><asp:TextBox ID="tbLastName" CssClass="formItem" runat="server" Width="100px" Text='<%# Eval("LastName") %>'></asp:TextBox></td>
		            <td><Arena:DateTextBox ID="dtbBirthDate" CssClass="formItem" runat="server" Width="80px" Text='<%# ((DateTime)Eval("BirthDate")).ToShortDateString() %>'></Arena:DateTextBox></td>
		            <td>
		                <asp:DropDownList ID="ddlGender" CssClass="formItem" runat="server" SelectedValue='<%# Eval("Gender").ToString() %>'>
		                    <asp:ListItem Text="" Value="Unknown"></asp:ListItem>
		                    <asp:ListItem Text="Female" Value="Female"></asp:ListItem>
		                    <asp:ListItem Text="Male" Value="Male" ></asp:ListItem>
	                    </asp:DropDownList>
		            </td>
		            <td>
		                <asp:DropDownList ID="ddlGrade" CssClass="formItem" runat="server" selectedValue='<%# GetGrade((DateTime)Eval("GraduationDate")) %>'>
		                    <asp:ListItem Text="" Value="-1"></asp:ListItem>
		                    <asp:ListItem Text="Kindergarten" Value="0"></asp:ListItem>
		                    <asp:ListItem Text="1st" Value="1"></asp:ListItem>
		                    <asp:ListItem Text="2nd" Value="2"></asp:ListItem>
		                    <asp:ListItem Text="3rd" Value="3"></asp:ListItem>
		                    <asp:ListItem Text="4th" Value="4"></asp:ListItem>
		                    <asp:ListItem Text="5th" Value="5"></asp:ListItem>
		                    <asp:ListItem Text="6th" Value="6"></asp:ListItem>
		                    <asp:ListItem Text="7th" Value="7"></asp:ListItem>
		                    <asp:ListItem Text="8th" Value="8"></asp:ListItem>
		                    <asp:ListItem Text="9th" Value="9"></asp:ListItem>
		                    <asp:ListItem Text="10th" Value="10"></asp:ListItem>
		                    <asp:ListItem Text="11th" Value="11"></asp:ListItem>
		                    <asp:ListItem Text="12th" Value="12"></asp:ListItem>
		                    </asp:DropDownList>
		            </td>
		            <td><asp:LinkButton ID="lbRemoveChild" runat="server" Text="Remove" CommandName="Remove"
		                Visible='<%# (Eval("FamilyRole.Value").ToString() != "Adult") %>'></asp:LinkButton></td>
                    </tr>
                </ItemTemplate>
                
            </asp:ListView>
            </li></ul>
            
            <div class="buttons">
                 <asp:LinkButton ID="lbFamilyMembersPrev" runat="server" class="button" Text="<< Back" 
                    onclick="lbFamilyMembersPrev_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbFamilyMembersNext" runat="server" class="button" Text="Next >>" 
                    onclick="lbFamilyMembersNext_Click"></asp:LinkButton>
            </div>
            
        </asp:Panel>	    
        
        <asp:Panel ID="pnlContactInfo" runat="server" Visible="false">

            <h2>Contact Information</h2>
            <p>
                Enter any email addresses or cell phone numbers that you'd like to register.
                Any of the cell phone numbers you enter can be used to check-in on the weekends.
            </p>
            <ul>
            <li class="contact-info">
            <asp:ListView ID="lvEmailCell" runat="server" OnItemDataBound="lvEmailCell_OnItemDataBound">

                <LayoutTemplate>
	                <table cellpadding="2" cellspacing="0" border="0">
	                <tr>
	                    <th></th>
	                    <th>Email</th>
	                    <th>Cell Phone</th>
	                </tr>
	                <tr runat="server" id="itemPlaceHolder"></tr>
	                </table>
                </LayoutTemplate>

                <ItemTemplate>
                    <tr>
	                <td>
	                    <asp:HiddenField ID="hfPersonGuid" runat="server" Value='<%# Eval("PersonGuid") %>' />
                        <%# Eval("NickName") %>	                
                    </td>
		            <td><asp:TextBox ID="tbEmail" runat="server" class="formItem" width="200px" Text='<%# Eval("Emails.FirstActive") %>'></asp:TextBox></td>
		            <td><Arena:PhoneTextBox ID="ptbCellNum" CssClass="formItem" runat="server" Width="100px" PhoneNumber='<%# ((FamilyMember)Container.DataItem).PhoneNumber(SystemLookup.PhoneType_Cell) %>'/></td>
                    </tr>
                </ItemTemplate>
                
            </asp:ListView>
            </li>
            </ul>
            <div class="buttons">
                <asp:LinkButton ID="lbContactInfoPrev" runat="server" class="button" Text="<< Back" 
                    onclick="lbContactInfoPrev_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbContactInfoNext" runat="server" class="button" Text="Finish >>" 
                    onclick="lbContactInfoNext_Click"></asp:LinkButton>
            </div>
            
        </asp:Panel>
        
    </ContentTemplate>
    </asp:UpdatePanel>
</div>


