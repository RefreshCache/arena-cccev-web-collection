/**********************************************************************
* Description:  Alternative version of Arena's UserConfirmation module
*				and ProfileMemberAdd...
*				which is to be used as a one stop shop for adding people
*				to serving tags.  It will attempt to find an existing person
*				based on an exact match of firstname, lastname, email and
*				birthdate instead of adding a new person.  It only adds
*				a new person if no match was found.  It then adds the
*				person to the given tag with the comment/note.
*				
* Created By:   Nick Airdo @ Central Christian Church (Cccev)
* Date Created: 4/18/2012
*
* $Workfile: UserConfirmation.ascx.cs $
* $Revision: 1 $
* $Header: /trunk/Arena/UserControls/Custom/Cccev/Core/UserConfirmation.ascx.cs   1   2012-09-10 17:21:40-07:00   nicka $
*
* $Log: /trunk/Arena/UserControls/Custom/Cccev/Core/UserConfirmation.ascx.cs $
*  
*  Revision: 1   Date: 2012-09-11 00:21:40Z   User: nicka 
*  Initial version 
**********************************************************************/

namespace ArenaWeb.UserControls.Custom.Cccev.Core
{
	using Arena.Core;
	using Arena.Core.Communications;
	using Arena.DataLayer.Security;
	using Arena.Enums;
	using Arena.Organization;
	using Arena.Portal;
	using Arena.Portal.UI;
	using Arena.Security;
	using ASP;
	using System;
	using System.Collections;
	using System.Collections.Generic;
	using System.Text;
	using System.Web;
	using System.Web.Profile;
	using System.Web.Security;
	using System.Web.UI;
	using System.Web.UI.HtmlControls;
	using System.Web.UI.WebControls;
	using System.ComponentModel;
	using System.Linq;
	using Arena.DataLayer.Core;

	public partial class UserConfirmation : PortalControl
	{
		private const string REDIRECT_SESSION = "RedirectValue";
		private Person person;

		#region Module Settings

		// Cccev new settings vvv
		[BooleanSetting( "Require Birth Date", "Flag indicating whether or not to show and require this field.", false, false ), Category("Show Fields")]
		public bool RequireBirthDateSetting { get { return Boolean.Parse( base.Setting( "RequireBirthDate", "false", false ) ); } }

		[BooleanSetting( "Require Marital Status", "Flag indicating whether or not to show and require this field", false, false ), Category( "Show Fields" )]
		public bool RequireMaritalStatusSetting { get { return Boolean.Parse( base.Setting( "RequireMaritalStatus", "false", false ) ); } }

		[BooleanSetting( "Require Gender", "Flag indicating whether or not to show and require this field", false, false ), Category( "Show Fields" )]
		public bool RequireGenderSetting { get { return Boolean.Parse( base.Setting( "RequireGender", "false", false ) ); } }

		[BooleanSetting( "Require Address", "Flag indicating whether or not to show and require this field", false, false ), Category( "Show Fields" )]
		public bool RequireAddressSetting { get { return Boolean.Parse( base.Setting( "RequireAddress", "false", false ) ); } }

		[BooleanSetting( "Require Home Phone", "Flag indicating whether or not to show and require this field", false, false ), Category( "Show Fields" )]
		public bool RequireHomePhoneSetting { get { return Boolean.Parse( base.Setting( "RequireHomePhone", "false", false ) ); } }

		[BooleanSetting( "Require Work Phone", "Flag indicating whether or not to show and require this field", false, false ), Category( "Show Fields" )]
		public bool RequireWorkPhoneSetting { get { return Boolean.Parse( base.Setting( "RequireWorkPhone", "false", false ) ); } }

		[BooleanSetting( "Require Cell Phone", "Flag indicating whether or not to show and require this field", false, false ), Category( "Show Fields" )]
		public bool RequireCellPhoneSetting { get { return Boolean.Parse( base.Setting( "RequireCellPhone", "false", false ) ); } }

		[BooleanSetting( "Require Campus", "Flag indicating whether or not to show and require this field", false, false ), Category( "Show Fields" )]
		public bool RequireCampusSetting { get { return Boolean.Parse( base.Setting( "RequireCampus", "false", false ) ); } }

		[TextSetting( "Redirect After Success URL", "The URL that the user will be redirected to after being added to a serving tag.", false )]
		public string RedirectAfterSuccessURLSetting{ get { return base.Setting( "RedirectAfterSuccessURL", "", false ); } }
		
		// ^^^ Cccev new settings.

		[LookupSetting("Member Status", "The Member Status to set a user to when they add themself through this form.", true, "0B4532DB-3188-40F5-B188-E7E6E4448C85")]
		public string MemberStatusIDSetting
		{
			get
			{
				return base.Setting("MemberStatusID", "", true);
			}
		}

		[CampusSetting("Default Campus", "The campus to assign a user to when they add themself through this form.", false)]
		public string CampusSetting
		{
			get
			{
				return base.Setting("Campus", "", false);
			}
		}

		[TextSetting("Redirect URL", "The URL that the user will be redirected to after selecting or creating their account.  This can be overridden by the query string.", false)]
		public string RedirectSetting
		{
			get
			{
				return base.Setting("Redirect", "", false);
			}
		}
		
		[TagSetting("Profile ID", "An optional profile ID that the user will be automatically added to when they complete this new account form.", false)]
		public string ProfileIDSetting
		{
			get
			{
				return base.Setting("ProfileID", "", false);
			}
		}
		
		[LookupSetting("Profile Source", "If using the Profile ID setting, then this value must be set to a valid Profile Source Lookup value.", false, "43DB58F9-C43F-4913-84FF-2E3CEA59C134")]
		public string SourceLUIDSetting
		{
			get
			{
				return base.Setting("SourceLUID", "", false);
			}
		}
		
		[LookupSetting("Profile Status", "If using the Profile ID setting, then this value must be set to a valid Profile Status Lookup value.", false, "705F785D-36DB-4BF2-9C35-2A7F72A55731")]
		public string StatusLUIDSetting
		{
			get
			{
				return base.Setting("StatusLUID", "", false);
			}
		}
		
		[TextSetting("Notify", "List of e-mail addresses to notify when content is changed (multiple e-mails can be provided when separated by a semi-colon.)", false)]
		public string NotifySetting
		{
			get
			{
				return base.Setting("Notify", string.Empty, false);
			}
		}
		
		[BooleanSetting("Show Family", "Flag indicating if the other family members should be able to be viewed and edited.", false, false)]
		public string ShowFamilySetting
		{
			get
			{
				return base.Setting("ShowFamily", "false", false);
			}
		}
		
		[AttributeSetting("Attribute Groups", "The list of attributes to show to the person when they sign up or confirm", false, ListSelectionMode.Multiple)]
		public string AttributesSetting
		{
			get
			{
				return base.Setting("Attributes", "", false);
			}
		}
		
		#endregion

		protected void Page_Load(object sender, EventArgs e)
		{
			// Cccev vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			if ( ! RequireBirthDateSetting )
			{
				reqBirthDate.Enabled = trBirthDate.Visible = false;
			}

			if ( ! RequireGenderSetting )
			{
				reqGender.Enabled = trGender.Visible = false;
			}

			if ( ! RequireMaritalStatusSetting )
			{
				reqMaritalStatus.Enabled = trMaritalStatus.Visible = false;
			}

			if ( ! RequireAddressSetting )
			{
				reqStreetAddress.Enabled = reqCity.Enabled = reqState.Enabled = reqZipCode.Enabled = false;
				trStreetAddress.Visible = trCity.Visible = trState.Visible = trZipCode.Visible = false;
			}

			if ( ! RequireHomePhoneSetting )
			{
				tbHomePhone.Enabled = trHomePhone.Visible = false;
			}

			if ( ! RequireWorkPhoneSetting )
			{
				tbWorkPhone.Enabled = trWorkPhone.Visible = false;
			}

			if ( ! RequireCellPhoneSetting )
			{
				tbCellPhone.Enabled =  trCellPhone.Visible = false;
			}

			if ( ! RequireCampusSetting )
			{
				ddlCampus.Enabled = trCampus.Visible = false;
			}
			// Cccev ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

			this.pnlMessage.Visible = false;
			this.lblMessage.Visible = false;
			this.lblLoginMessage.Text = string.Empty;

			if (ArenaContext.Current.SelectedPerson == null)
			{
				this.person = base.CurrentPerson;
			}
			else
			{
				if (base.CurrentPerson != null && ArenaContext.Current.SelectedPerson.FamilyId == base.CurrentPerson.FamilyId)
				{
					this.person = ArenaContext.Current.SelectedPerson;
				}
				else
				{
					this.pnlEdit.Visible = false;
					this.lblMessage.Text = "You do not have permission to edit this information";
					this.lblMessage.Visible = true;
					this.pnlMessage.Visible = true;
				}
			}

			if (this.person == null)
			{
				this.person = new Person();
			}

			this.EnableLogout();
			this.LoadAttributes();

			if (!this.Page.IsPostBack)
			{
				base.Session["RedirectValue"] = string.Empty;
				if (base.Request.QueryString["requestpage"] != null)
				{
					base.Session["RedirectValue"] = string.Format("default.aspx?page={0}", base.Request.QueryString["requestpage"]);
				}
				if (base.Session["RedirectValue"].ToString() == string.Empty && base.Request.QueryString["requestUrl"] != null && !base.Request.QueryString["requestUrl"].ToLower().StartsWith("http"))
				{
					base.Session["RedirectValue"] = base.Request.QueryString["requestUrl"];
				}
				if (base.Session["RedirectValue"].ToString() == string.Empty && this.RedirectSetting != string.Empty)
				{
					base.Session["RedirectValue"] = this.RedirectSetting;
				}
				
				LookupType lookupType = new LookupType(SystemLookupType.MaritalStatus);
				lookupType.Values.LoadDropDownList(this.ddlMaritalStatus);

				this.ddlCampus.Items.Clear();
				CampusCollection campusCollection = new CampusCollection( base.CurrentOrganization.OrganizationID );
				campusCollection.LoadDropDownList( this.ddlCampus, "Select Campus" );

				if (base.Request.IsAuthenticated)
				{
					this.SetInfo();
					this.tdLogin.Visible = false;
					this.tdFamily.Visible = bool.Parse(this.ShowFamilySetting);
					return;
				}
				this.tdFamily.Visible = false;
				this.tdLogin.Visible = true;
			}
		}

		private void EnableLogout()
		{
			if (this.person.PersonID == -1)
			{
				this.tbFirstName.Enabled = true;
				this.tbLastName.Enabled = true;
				this.trNameText.Visible = false;
				return;
			}
			this.tbFirstName.Enabled = false;
			this.tbLastName.Enabled = false;
			this.trNameText.Visible = true;
			if (this.person.PersonID == base.CurrentPerson.PersonID)
			{
				this.tdNameText.Controls.Clear();
				this.tdNameText.Controls.Add(new LiteralControl(string.Format("Note: You have logged in using the Login ID for {0}.  If you are trying to confirm someone other than {1}, you must first ", this.person.FullName, this.person.FirstName)));
				LinkButton linkButton = new LinkButton();
				this.tdNameText.Controls.Add(linkButton);
				linkButton.ID = "lbLogout";
				linkButton.Click += new EventHandler(this.lbLogout_Click);
				linkButton.Text = "logout";
				this.tdNameText.Controls.Add(new LiteralControl(" and then either login using the other person's login information, or create a new account for them."));
			}
		}

		private void SetInfo()
		{
			this.ddlMaritalStatus.SelectedIndex = -1;
			this.ddlGender.SelectedIndex = -1;
			this.ddlState.SelectedIndex = -1;
			this.tbFirstName.Text = this.person.FirstName;
			this.tbLastName.Text = this.person.LastName;
			this.tbEmail.Text = this.person.Emails.FirstActive;
			if (this.person.BirthDate != DateTime.MinValue && this.person.BirthDate != DateTime.Parse("1/1/1900"))
			{
				this.tbBirthDate.Text = this.person.BirthDate.ToShortDateString();
			}
			foreach (ListItem listItem in this.ddlMaritalStatus.Items)
			{
				listItem.Selected = (listItem.Value == this.person.MaritalStatus.LookupID.ToString());
			}

			foreach ( ListItem listItem in this.ddlCampus.Items )
			{
				if ( this.person.Campus != null )
					listItem.Selected = ( listItem.Value == this.person.Campus.CampusId.ToString() );
			}

			if (this.person.Gender == Gender.Male)
			{
				this.ddlGender.SelectedValue = "0";
			}
			if (this.person.Gender == Gender.Female)
			{
				this.ddlGender.SelectedValue = "1";
			}
			if (this.person.PrimaryAddress != null && this.person.PrimaryAddress.AddressID != -1)
			{
				this.tbStreetAddress.Text = this.person.PrimaryAddress.StreetLine1;
				this.tbCity.Text = this.person.PrimaryAddress.City;
				ListItem listItem2 = this.ddlState.Items.FindByValue(this.person.PrimaryAddress.State);
				if (listItem2 != null)
				{
					listItem2.Selected = true;
				}
				this.tbZipCode.Text = this.person.PrimaryAddress.PostalCode;
			}
			PersonPhone personPhone = this.person.Phones.FindByType(SystemLookup.PhoneType_Home);
			if (personPhone != null)
			{
				this.tbHomePhone.PhoneNumber = personPhone.Number;
			}
			personPhone = this.person.Phones.FindByType(SystemLookup.PhoneType_Business);
			if (personPhone != null)
			{
				this.tbWorkPhone.PhoneNumber = personPhone.Number;
			}
			personPhone = this.person.Phones.FindByType(SystemLookup.PhoneType_Cell);
			if (personPhone != null)
			{
				this.tbCellPhone.PhoneNumber = personPhone.Number;
				this.cbCellSMS.Checked = personPhone.SMSEnabled;
			}
			Family family = this.person.Family();
			foreach (FamilyMember current in family.FamilyMembers)
			{
				if (current.PersonID != this.person.PersonID)
				{
					Literal expr_302 = this.lcFamilyMembers;
					expr_302.Text += string.Format("<li class=\"formItem\"><a href=\"default.aspx?page={0}&guid={1}\">{2}</a></li>", base.CurrentPortalPage.PortalPageID.ToString(), current.PersonGUID.ToString(), current.FullName);
				}
			}
		}

		private void LoadAttributes()
		{
			if (!string.IsNullOrEmpty(this.AttributesSetting))
			{
				string[] array = this.AttributesSetting.Split(new char[]
				{
					','
				}, StringSplitOptions.RemoveEmptyEntries);
				string[] array2 = array;
				for (int i = 0; i < array2.Length; i++)
				{
					string s = array2[i];
					int num = -1;
					if (int.TryParse(s, out num) && num != -1)
					{
						Arena.Core.Attribute attribute = new Arena.Core.Attribute(num);
						PersonAttribute personAttribute = (PersonAttribute)this.person.Attributes.FindByID(attribute.AttributeId);
						if (personAttribute == null)
						{
							personAttribute = new PersonAttribute(this.person.PersonID, num);
						}
						this.AddAttributeEdit(attribute, personAttribute, !this.Page.IsPostBack);
					}
				}
			}
		}

		private void AddAttributeEdit(Arena.Core.Attribute attribute, PersonAttribute personAttribute, bool setValues)
		{
			TableRow tableRow = new TableRow();
			tableRow.ID = "trAttribute_" + attribute.AttributeId.ToString();
			TableCell tableCell = new TableCell();
			tableRow.Cells.Add(tableCell);
			tableCell.ID = "tcAttribute_" + attribute.AttributeId.ToString();
			tableCell.VerticalAlign = VerticalAlign.Middle;
			tableCell.HorizontalAlign = HorizontalAlign.Right;
			tableCell.Wrap = false;
			tableCell.CssClass = "formLabel";
			tableCell.Text = attribute.AttributeName;
			tableCell = new TableCell();
			tableCell.CssClass = "formItem";
			tableCell.Wrap = false;
			tableRow.Cells.Add(tableCell);
			new AttributeHelper
			{
				EditItemCssClass = "formItem"
			}.AddEditControls(tableCell, attribute, personAttribute, setValues);
			this.tbl.Rows.AddAt(this.tbl.Rows.Count - 2, tableRow);
		}

		private void lbLogout_Click(object sender, EventArgs e)
		{
			FormsAuthentication.SignOut();
			base.Response.Cookies["portalroles"].Value = null;
			base.Response.Cookies["portalroles"].Path = "/";
			base.Response.Redirect("default.aspx?" + base.Request.QueryString.ToString(), true);
		}

		protected void btnSignin_Click(object sender, EventArgs e)
		{
			this.SignIn();
		}

		private void SignIn()
		{
			Arena.Security.Login login = new Arena.Security.Login(this.txtLoginId.Text);
			if (!(login.LoginID != string.Empty))
			{
				this.lblLoginMessage.Text = "The Login ID you entered does not exist in our system!  Please verify that your Login ID and Password have been entered correctly.";
				return;
			}
			if (login.AuthenticateInDatabase(this.txtPassword.Text.Trim()))
			{
				FormsAuthentication.SetAuthCookie(login.LoginID, false);
				base.Response.Cookies["portalroles"].Value = string.Empty;
				this.person = new Person(login.PersonID);
				this.SetInfo();
				this.tdLogin.Visible = false;
				return;
			}
			this.lblLoginMessage.Text = "The Password you entered does not match the correct password for this Login ID!  Please verify that your Login ID and Password have been entered correctly.";
		}

		private void btnSubmit_Click(object sender, EventArgs e)
		{
			if (this.Page.IsValid)
			{
				this.UpdateAccount();
				return;
			}
			this.Page.FindControl("valSummary").Visible = true;
		}

		private void UpdateAccount()
		{
			int organizationID = base.CurrentPortal.OrganizationID;
			string text = base.CurrentUser.Identity.Name;
			if (text == string.Empty)
			{
				text = "UserConfirmation.ascx";
			}

			// New cccev code...
			if ( this.person.PersonID == -1 )
			{
				TryFindExistingPerson();
			}
			// End cccev code

			Person oldPerson = new Person(this.person.PersonID);
			bool isNewPerson = this.person.PersonID == -1;
			if ( isNewPerson )
			{
				this.person.RecordStatus = RecordStatus.Pending;
				Lookup lookup;
				try
				{
					lookup = new Lookup(int.Parse(this.MemberStatusIDSetting));
					if (lookup.LookupID == -1)
					{
						throw new ModuleException(base.CurrentPortalPage, base.CurrentModule, "Member Status setting must be a valid Member Status Lookup value.");
					}
				}
				catch (System.Exception inner)
				{
					throw new ModuleException(base.CurrentPortalPage, base.CurrentModule, "Member Status setting must be a valid Member Status Lookup value.", inner);
				}
				this.person.MemberStatus = lookup;
				if (this.CampusSetting != string.Empty)
				{
					try
					{
						this.person.Campus = new Campus(int.Parse(this.CampusSetting));
					}
					catch
					{
						this.person.Campus = null;
					}
				}
				else if ( RequireCampusSetting )
				{
					this.person.Campus = new Campus( int.Parse( this.ddlCampus.SelectedValue ) );
				}
			}

			this.person.FirstName = this.tbFirstName.Text.Trim();
			this.person.LastName = this.tbLastName.Text.Trim();
			this.person.Emails.FirstActive = this.tbEmail.Text.Trim();

			// Campus
			if ( RequireCampusSetting )
			{
				this.person.Campus = new Campus( int.Parse( this.ddlCampus.SelectedValue ) );
			}

			// Birth Date
			if ( RequireBirthDateSetting && this.tbBirthDate.Text.Trim() != string.Empty ) // Cccev
			{
				try
				{
					this.person.BirthDate = DateTime.Parse(this.tbBirthDate.Text);
				}
				catch
				{
				}
			}

			// Marital Status
			if ( RequireMaritalStatusSetting && this.ddlMaritalStatus.SelectedValue != string.Empty) // Cccev
			{
				this.person.MaritalStatus = new Lookup(int.Parse(this.ddlMaritalStatus.SelectedValue));
			}

			// Gender
			if ( RequireGenderSetting && this.ddlGender.SelectedValue != string.Empty) // Cccev
			{
				try
				{
					this.person.Gender = (Gender)Enum.Parse(typeof(Gender), this.ddlGender.SelectedValue);
				}
				catch
				{
				}
			}
			
			// Address
			Lookup lookup2 = new Lookup(SystemLookup.AddressType_Home);
			PersonAddress personAddress = this.person.Addresses.FindByType(lookup2.LookupID);
			if (personAddress == null)
			{
				personAddress = new PersonAddress();
				personAddress.AddressType = lookup2;
				this.person.Addresses.Add(personAddress);
			}
			if ( RequireAddressSetting ) // Cccev
			{
				personAddress.Address = new Address( this.tbStreetAddress.Text.Trim(), string.Empty, this.tbCity.Text.Trim(), this.ddlState.SelectedValue, this.tbZipCode.Text.Trim(), false );
				personAddress.Primary = true;
			}

			// Home Phone
			Lookup lookup3 = new Lookup(SystemLookup.PhoneType_Home);
			PersonPhone personPhone = this.person.Phones.FindByType(lookup3.LookupID);
			if (personPhone == null)
			{
				personPhone = new PersonPhone();
				personPhone.PhoneType = lookup3;
				this.person.Phones.Add(personPhone);
			}
			if ( RequireHomePhoneSetting ) // Cccev
			{
				personPhone.Number = this.tbHomePhone.PhoneNumber.Trim();
			}

			// Business Phone
			Lookup lookup4 = new Lookup(SystemLookup.PhoneType_Business);
			PersonPhone personPhone2 = this.person.Phones.FindByType(lookup4.LookupID);
			if (personPhone2 == null)
			{
				personPhone2 = new PersonPhone();
				personPhone2.PhoneType = lookup4;
				this.person.Phones.Add(personPhone2);
			}
			if ( RequireWorkPhoneSetting ) // Cccev
			{
				personPhone2.Number = this.tbWorkPhone.PhoneNumber.Trim();
			}

			// Cell Phone
			Lookup lookup5 = new Lookup(SystemLookup.PhoneType_Cell);
			PersonPhone personPhone3 = this.person.Phones.FindByType(lookup5.LookupID);
			if (personPhone3 == null)
			{
				personPhone3 = new PersonPhone();
				personPhone3.PhoneType = lookup5;
				this.person.Phones.Add(personPhone3);
			}
			if ( RequireCellPhoneSetting ) // Cccev
			{
				personPhone3.Number = this.tbCellPhone.PhoneNumber.Trim();
				personPhone3.SMSEnabled = this.cbCellSMS.Checked;
			}

			string personChanges = this.GetPersonChanges( oldPerson, this.person, isNewPerson );
			this.person.Save(organizationID, text, false);
			this.person.SaveAddresses(organizationID, text);
			this.person.SavePhones(organizationID, text);
			this.person.SaveEmails(organizationID, text);
			this.SaveAttributeValues(this.person);
			
			if ( isNewPerson )
			{
				string userName = new LoginData().CreateNewLogin(this.person.PersonID, text);
				FormsAuthentication.SetAuthCookie(userName, false);
				base.Response.Cookies["portalroles"].Value = string.Empty;
				Family family = new Family();
				family.OrganizationID = organizationID;
				family.FamilyName = this.tbLastName.Text.Trim() + " Family";
				family.Save(text);
				new FamilyMember(family.FamilyID, this.person.PersonID)
				{
					FamilyID = family.FamilyID, 
					FamilyRole = new Lookup(SystemLookup.FamilyRole_Adult)
				}.Save(text);
				
				if (this.ProfileIDSetting != string.Empty)
				{
					int profileId = -1;
					int lookupID = -1;
					int lookupID2 = -1;
					try
					{
						if (this.ProfileIDSetting.Contains("|"))
						{
							profileId = int.Parse(this.ProfileIDSetting.Split(new char[]
							{
								'|'
							})[1]);
						}
						else
						{
							profileId = int.Parse(this.ProfileIDSetting);
						}
						lookupID = int.Parse(this.SourceLUIDSetting);
						lookupID2 = int.Parse(this.StatusLUIDSetting);
					}
					catch (System.Exception inner2)
					{
						throw new ModuleException(base.CurrentPortalPage, base.CurrentModule, "If using a ProfileID setting for the NewAccount module, then a valid numeric 'ProfileID', 'SourceLUID', and 'StatusLUID' setting must all be used!", inner2);
					}
					Profile profile = new Profile(profileId);
					Lookup lookup6 = new Lookup(lookupID);
					Lookup lookup7 = new Lookup(lookupID2);
					if (profile.ProfileID == -1 || lookup6.LookupID == -1 || lookup7.LookupID == -1)
					{
						throw new ModuleException(base.CurrentPortalPage, base.CurrentModule, "'ProfileID', 'SourceLUID', and 'StatusLUID' must all be valid IDs");
					}
					ProfileMember profileMember = new ProfileMember();
					profileMember.ProfileID = profile.ProfileID;
					profileMember.PersonID = this.person.PersonID;
					profileMember.Source = lookup6;
					profileMember.Status = lookup7;
					profileMember.DatePending = DateTime.Now;
					profileMember.Save(text);
					if (profile.ProfileType == ProfileType.Serving)
					{
						ServingProfile servingProfile = new ServingProfile(profile.ProfileID);
						new ServingProfileMember(profileMember.ProfileID, profileMember.PersonID)
						{
							HoursPerWeek = servingProfile.DefaultHoursPerWeek
						}.Save();
					}
				}
			}

			if (this.NotifySetting != string.Empty)
			{
				this.SendNotification(this.person, personChanges);
			}

			string text2 = base.Session["RedirectValue"].ToString().Trim();
			if (this.tbNotes.Text.Trim() != string.Empty)
			{
				text2 = text2 + "&Notes=" + (this.tbNotes.Text.Trim());
			}
			if (text2 != string.Empty)
			{
				AddToTag( text2 );
				base.Session["RedirectValue"] = null;
				//text2 += "&confirmed=true";
				//base.Response.Redirect(text2, true);
			}
		}

		/// <summary>
		/// Adds the person to the tag provided in the RedirectValue
		/// (similar to Arena's ProfileMemberAdd module)
		/// </summary>
		private void AddToTag(string queryString)
		{
			var activityNote = "Person added themself through web interface.";

			// Just in case there's no profile in the querystring AND in case it's not a number...
			try
			{
				var userID = ( base.CurrentUser.Identity.Name != null && base.CurrentUser.Identity.Name != "" ) ? base.CurrentUser.Identity.Name : "UserConfirmation.ascx";

				string[] values = queryString.Split( '&' );

				var item = (from string q in values where q.StartsWith("profile=") select q).FirstOrDefault();
				if ( item == null )
					throw new ModuleException( base.CurrentPortalPage, base.CurrentModule, "Profile id was missing from querystring." );

				var notes = ( from string q in values where q.StartsWith( "Notes=" ) select q ).FirstOrDefault();
				var moreInfo = ( from string q in values where q.StartsWith( "MoreInfo" ) select q ).FirstOrDefault();
				
				int profileId = int.Parse( item.Split( '=' )[1] );
				Profile profile = new Profile( profileId );
				ProfileMember profileMember = new ProfileMember( profile.ProfileID, person );

				if ( profileMember.ProfileID == -1 )
				{
					int lookupID = -1;
					int lookupID2 = -1;
					try
					{
						lookupID = int.Parse( this.SourceLUIDSetting );
						lookupID2 = int.Parse( this.StatusLUIDSetting );
					}
					catch ( Exception inner )
					{
						throw new ModuleException( base.CurrentPortalPage, base.CurrentModule, "A valid numeric 'Default Source ID', and 'Default Status ID' setting are required!", inner );
					}
					if ( profile.ProfileType == ProfileType.Event )
					{
						throw new ModuleException( base.CurrentPortalPage, base.CurrentModule, "Event tags are not supported." );
					}
					else
					{
						profileMember.ProfileID = profile.ProfileID;
						profileMember.PersonID = person.PersonID;
						profileMember.Source = new Lookup( lookupID );
						profileMember.Status = new Lookup( lookupID2 );
						profileMember.DatePending = DateTime.Now;
						if ( moreInfo != null )
						{
							profileMember.MemberNotes += "User Requested More Information! ";
						}
						if ( notes != null )
						{
							profileMember.MemberNotes += HttpUtility.UrlDecode( notes.Split( '=' )[1] );
						}
						profileMember.Save( userID );
						if ( profile.ProfileType == ProfileType.Serving )
						{
							ServingProfile servingProfile = new ServingProfile( profile.ProfileID );
							new ServingProfileMember( profileMember.ProfileID, profileMember.PersonID )
							{
								HoursPerWeek = servingProfile.DefaultHoursPerWeek
							}.Save();
						}
					}
				}
				else if ( notes != null )
				{
					activityNote = HttpUtility.UrlDecode( notes.Split( '=' )[1] );
				}

				int lookupID3 = new Lookup( SystemLookup.ServingActivityType_StatusChange ).LookupID;
				new ProfileMemberActivityData().SaveProfileMemberActivity( profile.ProfileID, person.PersonID, userID, lookupID3, activityNote );

				Response.Redirect( RedirectAfterSuccessURLSetting, true);
			}
			catch( Exception )
			{
				lblMessage.Text = "An error occurred which prevented us from adding you to that opportunity.  Please contact the church office.";
				lblMessage.Visible = true;
				pnlMessage.Visible = true;
			}
		}

		/// <summary>
		/// Method to try to find an existing person given an exact match with:
		///   * email address
		///   * first name
		///   * last name
		///   * birthdate
		/// </summary>
		/// <param name="person"></param>
		private void TryFindExistingPerson()
		{
			PersonCollection people = new PersonCollection();
			if ( ! string.IsNullOrEmpty( this.tbFirstName.Text ) && ! string.IsNullOrEmpty( this.tbLastName.Text ) && ! string.IsNullOrEmpty( this.tbBirthDate.Text.Trim() ) )
			{
				DateTime birthdate = DateTime.Parse( this.tbBirthDate.Text );
				people.LoadByNameAndBirthdate( this.tbFirstName.Text.Trim(), this.tbLastName.Text.Trim(), birthdate );

				foreach ( Person p in people )
				{
					PersonEmail email = p.Emails.FindByEmail( this.tbEmail.Text );
					if ( email != null )
					{
						this.person = p;
						return;
					}
				}
			}
		}

		private void SaveAttributeValues(Person p)
		{
			AttributeHelper attributeHelper = new AttributeHelper();
			if (!string.IsNullOrEmpty(this.AttributesSetting))
			{
				string[] array = this.AttributesSetting.Split(new char[]{','}, StringSplitOptions.RemoveEmptyEntries);
				string[] array2 = array;
				for (int i = 0; i < array2.Length; i++)
				{
					string s = array2[i];
					PersonAttribute personAttribute = (PersonAttribute)this.person.Attributes.FindByID(int.Parse(s));
					if (personAttribute == null)
					{
						personAttribute = new PersonAttribute(this.person.PersonID, int.Parse(s));
					}
					TableCell parent = null;
					foreach (TableRow tableRow in this.tbl.Rows)
					{
						if (tableRow.ID == "trAttribute_" + personAttribute.AttributeId.ToString())
						{
							IEnumerator enumerator2 = tableRow.Cells.GetEnumerator();
							try
							{
								while (enumerator2.MoveNext())
								{
									TableCell tableCell = (TableCell)enumerator2.Current;
									if (tableCell.ID == "tcAttribute_" + personAttribute.AttributeId.ToString())
									{
										parent = tableCell;
										break;
									}
								}
								break;
							}
							finally
							{
								IDisposable disposable = enumerator2 as IDisposable;
								if (disposable != null)
								{
									disposable.Dispose();
								}
							}
						}
					}
					attributeHelper.PopulateAttribute(parent, personAttribute);
					personAttribute.Save(base.CurrentOrganization.OrganizationID, base.CurrentUser.Identity.Name);
				}
			}
		}

		private string GetPersonChanges(Person oldPerson, Person updatedPerson, bool newPerson)
		{
			StringBuilder stringBuilder = new StringBuilder();
			if (!newPerson)
			{
				if (oldPerson.FirstName != updatedPerson.FirstName)
				{
					stringBuilder.AppendLine(string.Format("First Name changed from '{0}' to '{1}'", oldPerson.FirstName, updatedPerson.FirstName));
				}
				if (oldPerson.LastName != updatedPerson.LastName)
				{
					stringBuilder.AppendLine(string.Format("Last Name changed from '{0}' to '{1}'", oldPerson.LastName, updatedPerson.LastName));
				}
				if (oldPerson.Emails.FirstActive != updatedPerson.Emails.FirstActive)
				{
					stringBuilder.AppendLine(string.Format("Email changed from '{0}' to '{1}'", oldPerson.Emails.FirstActive, updatedPerson.Emails.FirstActive));
				}
				if (oldPerson.BirthDate != updatedPerson.BirthDate)
				{
					stringBuilder.AppendLine(string.Format("Birth Date changed from '{0}' to '{1}'", oldPerson.BirthDate.ToShortDateString(), updatedPerson.BirthDate.ToShortDateString()));
				}
				if (oldPerson.MaritalStatus.Value != updatedPerson.MaritalStatus.Value)
				{
					stringBuilder.AppendLine(string.Format("Marital Status changed from '{0}' to '{1}'", oldPerson.MaritalStatus.Value, updatedPerson.MaritalStatus.Value));
				}
				if (oldPerson.Gender != updatedPerson.Gender)
				{
					stringBuilder.AppendLine(string.Format("Gender changed from '{0}' to '{1}'", oldPerson.Gender.ToString(), updatedPerson.Gender.ToString()));
				}
				Lookup lookup = new Lookup(SystemLookup.AddressType_Home);
				PersonAddress personAddress = oldPerson.Addresses.FindByType(lookup.LookupID);
				if (personAddress == null)
				{
					personAddress = new PersonAddress();
				}
				PersonAddress personAddress2 = updatedPerson.Addresses.FindByType(lookup.LookupID);
				if (personAddress.Address.StreetLine1 != personAddress2.Address.StreetLine1)
				{
					stringBuilder.AppendLine(string.Format("Street Line changed from '{0}' to '{1}'", personAddress.Address.StreetLine1, personAddress2.Address.StreetLine1));
				}
				if (personAddress.Address.City != personAddress2.Address.City)
				{
					stringBuilder.AppendLine(string.Format("City changed from '{0}' to '{1}'", personAddress.Address.City, personAddress2.Address.City));
				}
				if (personAddress.Address.PostalCode != personAddress2.Address.PostalCode)
				{
					stringBuilder.AppendLine(string.Format("Postal Code changed from '{0}' to '{1}'", personAddress.Address.StreetLine1, personAddress2.Address.StreetLine1));
				}
				Lookup lookup2 = new Lookup(SystemLookup.PhoneType_Home);
				PersonPhone personPhone = oldPerson.Phones.FindByType(lookup2.LookupID);
				if (personPhone == null)
				{
					personPhone = new PersonPhone();
				}
				PersonPhone personPhone2 = updatedPerson.Phones.FindByType(lookup2.LookupID);
				if (personPhone.Number != personPhone2.Number)
				{
					stringBuilder.AppendLine(string.Format("Home Phone changed from '{0}' to '{1}'", personPhone.Number, personPhone2.Number));
				}
				Lookup lookup3 = new Lookup(SystemLookup.PhoneType_Business);
				PersonPhone personPhone3 = oldPerson.Phones.FindByType(lookup3.LookupID);
				if (personPhone3 == null)
				{
					personPhone3 = new PersonPhone();
				}
				PersonPhone personPhone4 = updatedPerson.Phones.FindByType(lookup3.LookupID);
				if (personPhone3.Number != personPhone4.Number)
				{
					stringBuilder.AppendLine(string.Format("Business Phone changed from '{0}' to '{1}'", personPhone3.Number, personPhone4.Number));
				}
				Lookup lookup4 = new Lookup(SystemLookup.PhoneType_Cell);
				PersonPhone personPhone5 = oldPerson.Phones.FindByType(lookup4.LookupID);
				if (personPhone5 == null)
				{
					personPhone5 = new PersonPhone();
				}
				PersonPhone personPhone6 = updatedPerson.Phones.FindByType(lookup4.LookupID);
				if (personPhone5.Number != personPhone6.Number)
				{
					stringBuilder.AppendLine(string.Format("Cell Phone changed from '{0}' to '{1}'", personPhone5.Number, personPhone6.Number));
				}

				// Campus
				if ( oldPerson.Campus != null && oldPerson.Campus == updatedPerson.Campus )
				{
					stringBuilder.AppendLine( string.Format( "Campus changed from '{0}' to '{1}'", oldPerson.Campus.Name, updatedPerson.Campus.Name ) );
				}
			}
			else
			{
				stringBuilder.AppendLine("New Person Created");
			}
			return stringBuilder.ToString();
		}

		private void SendNotification(Person updatedPerson, string changedContent)
		{
			char[] separator = new char[]{';'};
			string[] array = this.NotifySetting.Split(separator);
			if (array.Length > 0)
			{
				UserConfirmationNotification userConfirmationNotification = new UserConfirmationNotification();
				Dictionary<string, string> dictionary = new Dictionary<string, string>();
				dictionary.Add("##PersonName##", updatedPerson.FullName);
				dictionary.Add("##PersonLink##", string.Format("http://{0}/default.aspx?page=7&guid={1}", base.Request.Url.Host, updatedPerson.Guid.ToString()));
				dictionary.Add("##ChangedContent##", changedContent.ToString());
				dictionary.Add("##DateChanged##", DateTime.Today.ToShortDateString());
				string[] array2 = array;
				for (int i = 0; i < array2.Length; i++)
				{
					string toEmail = array2[i];
					userConfirmationNotification.Send(toEmail, dictionary);
				}
			}
		}

		protected override void OnInit(EventArgs e)
		{
			this.InitializeComponent();
			base.OnInit(e);
		}

		private void InitializeComponent()
		{
			this.btnSubmit.Click += new EventHandler(this.btnSubmit_Click);
		}
	}
}
