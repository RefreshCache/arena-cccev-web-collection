/**********************************************************************
* Description:  Alternative version of Arena's NewAccount module.
*				- added module settings for making certain fields optional
*				- added optional campus lookup
*				- bootstrap-ified the form to a fluid row of three columns
*
* Created By:   Nick Airdo @ Central Christian Church (Cccev)
* Date Created: 10/31/2012
*
* $Workfile: $
* $Revision: $
* $Header: $
*
* $Log: $
**********************************************************************/

namespace ArenaWeb.UserControls.Custom.Cccev.Core
{
	using System;
	using System.Collections.Generic;
	using System.ComponentModel;
	using System.Security.Cryptography;
	using System.Text;
	using System.Web.Security;
	using System.Web.UI;

	using Arena.Core;
	using Arena.Core.Communications;
	using Arena.Enums;
	using Arena.Organization;
	using Arena.Portal;

	public partial class NewAccount : PortalControl
	{
		private const string REDIRECT_SESSION = "RedirectValue";
		
		#region Module Settings

		// Cccev new settings vvv
		[BooleanSetting( "Require Birth Date", "Flag indicating whether or not to show and require this field.", false, true ), Category( "Show Fields" )]
		public bool RequireBirthDateSetting { get { return Boolean.Parse( base.Setting( "RequireBirthDate", "true", false ) ); } }

		[BooleanSetting( "Require Marital Status", "Flag indicating whether or not to show and require this field", false, true ), Category( "Show Fields" )]
		public bool RequireMaritalStatusSetting { get { return Boolean.Parse( base.Setting( "RequireMaritalStatus", "true", false ) ); } }

		[BooleanSetting( "Require Gender", "Flag indicating whether or not to show and require this field", false, true ), Category( "Show Fields" )]
		public bool RequireGenderSetting { get { return Boolean.Parse( base.Setting( "RequireGender", "true", false ) ); } }

		[BooleanSetting( "Require Address", "Flag indicating whether or not to show and require this field", false, true ), Category( "Show Fields" )]
		public bool RequireAddressSetting { get { return Boolean.Parse( base.Setting( "RequireAddress", "true", false ) ); } }

		[BooleanSetting( "Require Home Phone", "Flag indicating whether or not to show and require this field", false, true ), Category( "Show Fields" )]
		public bool RequireHomePhoneSetting { get { return Boolean.Parse( base.Setting( "RequireHomePhone", "true", false ) ); } }

		[BooleanSetting( "Require Work Phone", "Flag indicating whether or not to show and require this field", false, true ), Category( "Show Fields" )]
		public bool RequireWorkPhoneSetting { get { return Boolean.Parse( base.Setting( "RequireWorkPhone", "true", false ) ); } }

		[BooleanSetting( "Require Cell Phone", "Flag indicating whether or not to show and require this field", false, true ), Category( "Show Fields" )]
		public bool RequireCellPhoneSetting { get { return Boolean.Parse( base.Setting( "RequireCellPhone", "true", false ) ); } }

		[BooleanSetting( "Require Campus", "Flag indicating whether or not to show and require this field", false, false ), Category( "Show Fields" )]
		public bool RequireCampusSetting { get { return Boolean.Parse( base.Setting( "RequireCampus", "false", false ) ); } }

		[TextSetting( "'Select Campus' Placeholder Text", "The text used as the placeholder/empty value in the Campus drop down selector.", false )]
		public string SelectCampusPlaceholderSetting { get { return base.Setting( "SelectCampusPlaceholder", "- select a campus -", false ); } }

		[TextSetting( "1 Prefix HTML", "Any custom HTML to prepend before the 'form'.", false ), Category( "HTML Wrapping" )]
		public string PrefixHTMLSetting { get { return base.Setting( "PrefixHTML", "", false ); } }

		[TextSetting( "2 Postfix HTML", "Any custom HTML to append after the 'form'.", false ), Category( "HTML Wrapping" )]
		public string PostfixHTMLSetting { get { return base.Setting( "PostfixHTML", "", false ); } }

		// Cccev new settings ^^^

		[PageSetting( "Redirect Page", "The page that the user will be redirected to after creating their account.", true )]
		public string RedirectPageIDSetting
		{
			get
			{
				return base.Setting( "RedirectPageID", "", true );
			}
		}

		[PageSetting("Request Login Info Page", "The page that the user can use to request their login information.", true)]
		public string RequestInfoPageIDSetting
		{
			get
			{
				return base.Setting("RequestInfoPageID", "", true);
			}
		}
		[LookupSetting("Member Status", "The Member Status Lookup value to set a user to when they add themself through this form.", true, "0B4532DB-3188-40F5-B188-E7E6E4448C85")]
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
		[TagSetting("Profile ID", "An optional profile ID that the user will be automatically added to when they complete this new account form.", false)]
		public string ProfileIDSetting
		{
			get
			{
				return base.Setting("ProfileID", "", false);
			}
		}
		[LookupSetting("Source ID", "If using the Profile ID setting, then this value must be set to a valid Profile Source lookup value.", false, "43DB58F9-C43F-4913-84FF-2E3CEA59C134")]
		public string SourceLUIDSetting
		{
			get
			{
				return base.Setting("SourceLUID", "", false);
			}
		}
		[LookupSetting("Status ID", "If using the Profile ID setting, then this value must be set to a valid Profile Status lookup value.", false, "705F785D-36DB-4BF2-9C35-2A7F72A55731")]
		public string StatusLUIDSetting
		{
			get
			{
				return base.Setting("StatusLUID", "", false);
			}
		}
		[BooleanSetting("Email Verification", "If using this setting, the new user account will not become active until the user verifies their new account by clicking on the link sent in the email (Note: If set to true, make sure you include the ##VerificationURL## merge field in the system email template, otherwise the user will not receive the verification link).", false, false)]
		public string EmailVerificationSetting
		{
			get
			{
				return base.Setting("EmailVerification", "false", false);
			}
		}
		[PageSetting("New User Verification Page", "The page id of the page that the user is sent to from the email verification email to verify their new account. IMPORTANT: This must be set if Email Verification is true.", false)]
		public string NewUserVerificationPageSetting
		{
			get
			{
				return base.Setting("NewUserVerificationPage", "", false);
			}
		}

		#endregion

		protected void Page_Load(object sender, EventArgs e)
		{
			// Cccev vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

			if ( PrefixHTMLSetting != string.Empty )
			{
				litPrefixHTML.Text = PrefixHTMLSetting;
			}

			if ( PostfixHTMLSetting != string.Empty )
			{
				litPostfixHTML.Text = PostfixHTMLSetting;
			}

			if ( !RequireBirthDateSetting )
			{
				reqBirthDate.Enabled = cgBirthDate.Visible = false;
			}

			if ( !RequireGenderSetting )
			{
				reqGender.Enabled = cgGender.Visible = false;
			}

			if ( !RequireMaritalStatusSetting )
			{
				reqMaritalStatus.Enabled = cgMaritalStatus.Visible = false;
			}

			if ( !RequireAddressSetting )
			{
				reqStreetAddress.Enabled = reqCity.Enabled = reqState.Enabled = reqZipCode.Enabled = false;
				cgAddress.Visible = false;
			}

			if ( !RequireHomePhoneSetting )
			{
				tbHomePhone.Enabled = cgHomePhone.Visible = false;
			}

			if ( !RequireWorkPhoneSetting )
			{
				tbWorkPhone.Enabled = cgWorkPhone.Visible = false;
			}

			if ( !RequireCellPhoneSetting )
			{
				tbCellPhone.Enabled = cgCellPhone.Visible = false;
			}

			if ( !RequireCampusSetting )
			{
				ddlCampus.Enabled = cgCampus.Visible = false;
			}
			// Cccev ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

			this.pnlMessage.Visible = false;
			this.lblMessage.Visible = false;
			this.pnlEmailExists.Visible = false;
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
				if (base.Session["RedirectValue"].ToString() == string.Empty)
				{
					base.Session["RedirectValue"] = string.Format("default.aspx?page={0}", this.RedirectPageIDSetting);
				}
				LookupType lookupType = new LookupType(SystemLookupType.MaritalStatus);
				lookupType.Values.LoadDropDownList(this.ddlMaritalStatus);
				this.tbFirstName.Focus();
				this.tbHomePhone.PhoneNumberTextBox.TabIndex = 11;
				this.tbWorkPhone.PhoneNumberTextBox.TabIndex = 12;
				this.tbWorkPhone.PhoneExtensionTextBox.TabIndex = 13;
				this.tbCellPhone.PhoneNumberTextBox.TabIndex = 14;

				this.ddlCampus.Items.Clear();
				CampusCollection campusCollection = new CampusCollection( base.CurrentOrganization.OrganizationID );
				campusCollection.LoadDropDownList( this.ddlCampus, SelectCampusPlaceholderSetting );
				// pre-select the default campus setting
				if ( CampusSetting != string.Empty )
				{
					ddlCampus.SelectedValue = CampusSetting;
				}
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append("\n\n<script language=\"javascript\" FOR=\"document\" EVENT=\"onreadystatechange\">\n");
			stringBuilder.Append("\tif(document.readyState==\"complete\");\n");
			stringBuilder.Append("\t{\n");
			stringBuilder.AppendFormat("\t\tdocument.frmMain.{0}.value = document.frmMain.{1}.value;\n", this.tbPassword.ClientID, this.iPassword.ClientID);
			stringBuilder.AppendFormat("\t\tdocument.frmMain.{0}.value = document.frmMain.{1}.value;\n", this.tbPassword2.ClientID, this.iPassword.ClientID);
			stringBuilder.Append("\t}\n");
			stringBuilder.Append("</script>\n\n");
			this.Page.ClientScript.RegisterClientScriptBlock(base.GetType(), "setPassword", stringBuilder.ToString());
			this.Page.ClientScript.RegisterClientScriptBlock(base.GetType(), "setPassword", stringBuilder.ToString());
		}
		protected void Page_PreRender(object sender, EventArgs e)
		{
			this.iPassword.Value = this.tbPassword.Text;
		}
		private void btnSubmit_Click(object sender, EventArgs e)
		{
			if (!this.Page.IsValid)
			{
				this.Page.FindControl("valSummary").Visible = true;
				return;
			}
			if (!(this.tbEmail.Text.Trim().ToLower() != this.iEmail.Value))
			{
				this.CreateAccount();
				return;
			}
			PersonCollection personCollection = new PersonCollection();
			personCollection.LoadByEmail(this.tbEmail.Text.Trim());
			if (personCollection.Count <= 0)
			{
				this.CreateAccount();
				return;
			}
			this.phExistingAccounts.Controls.Clear();
			StringBuilder stringBuilder = new StringBuilder();
			foreach (Person current in personCollection)
			{
				using (List<Arena.Security.Login>.Enumerator enumerator2 = current.Logins.GetEnumerator())
				{
					if (enumerator2.MoveNext())
					{
						Arena.Security.Login arg_A5_0 = enumerator2.Current;
						stringBuilder.AppendFormat("{0} - <a href='default.aspx?page={1}&email={2}'>Send Info</a><br>", current.FullName, this.RequestInfoPageIDSetting, this.tbEmail.Text.Trim());
					}
				}
			}
			if (stringBuilder.Length > 0)
			{
				this.phExistingAccounts.Controls.Add(new LiteralControl(stringBuilder.ToString()));
				this.pnlMessage.Visible = true;
				this.pnlEmailExists.Visible = true;
				this.iEmail.Value = this.tbEmail.Text.Trim().ToLower();
				return;
			}
			this.CreateAccount();
		}
		private void btnCreate_Click(object sender, EventArgs e)
		{
			if (this.Page.IsValid)
			{
				this.CreateAccount();
				return;
			}
			this.Page.FindControl("valSummary").Visible = true;
		}
		private void CreateAccount()
		{
			Arena.Security.Login login = new Arena.Security.Login(this.tbLoginID.Text);
			if (login.PersonID != -1)
			{
				int num = 0;
				string text = this.tbFirstName.Text.Substring(0, 1).ToLower() + this.tbLastName.Text.Trim().ToLower();
				if (text != this.tbLoginID.Text.Trim().ToLower())
				{
					login = new Arena.Security.Login(text);
				}
				while (login.PersonID != -1)
				{
					num++;
					login = new Arena.Security.Login(text + num.ToString());
				}
				this.lblMessage.Text = "The Desired Login ID you selected is already in use in our system.  Please select a different Login ID.  Suggestion: <b>" + text + num.ToString() + "</b>";
				this.pnlMessage.Visible = true;
				this.lblMessage.Visible = true;
				return;
			}
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
			int organizationID = base.CurrentPortal.OrganizationID;
			string text2 = base.CurrentUser.Identity.Name;
			if (text2 == string.Empty)
			{
				text2 = "NewAccount.ascx";
			}
			Person person = new Person();
			person.RecordStatus = RecordStatus.Pending;
			person.MemberStatus = lookup;
			if (ddlCampus.SelectedValue != string.Empty || this.CampusSetting != string.Empty)
			{
				// use the user set value if it exists, otherwise use the admin configured module setting
				string campusString = ( ddlCampus.SelectedValue != string.Empty ) ? ddlCampus.SelectedValue : this.CampusSetting;
				try
				{
					person.Campus = new Campus( int.Parse( campusString ) );
				}
				catch
				{
					person.Campus = null;
				}
			}
			person.FirstName = this.tbFirstName.Text.Trim();
			person.LastName = this.tbLastName.Text.Trim();
			if (this.tbBirthDate.Text.Trim() != string.Empty)
			{
				try
				{
					person.BirthDate = DateTime.Parse(this.tbBirthDate.Text);
				}
				catch
				{
				}
			}
			if (this.ddlMaritalStatus.SelectedValue != string.Empty)
			{
				person.MaritalStatus = new Lookup(int.Parse(this.ddlMaritalStatus.SelectedValue));
			}
			if (this.ddlGender.SelectedValue != string.Empty)
			{
				try
				{
					person.Gender = (Gender)Enum.Parse(typeof(Gender), this.ddlGender.SelectedValue);
				}
				catch
				{
				}
			}
			PersonAddress personAddress = new PersonAddress();
			personAddress.Address = new Address(this.tbStreetAddress.Text.Trim(), string.Empty, this.tbCity.Text.Trim(), this.ddlState.SelectedValue, this.tbZipCode.Text.Trim(), false);
			personAddress.AddressType = new Lookup(SystemLookup.AddressType_Home);
			personAddress.Primary = true;
			person.Addresses.Add(personAddress);
			PersonPhone personPhone = new PersonPhone();
			personPhone.Number = this.tbHomePhone.PhoneNumber.Trim();
			personPhone.PhoneType = new Lookup(SystemLookup.PhoneType_Home);
			person.Phones.Add(personPhone);
			if (this.tbWorkPhone.PhoneNumber.Trim() != string.Empty)
			{
				personPhone = new PersonPhone();
				personPhone.Number = this.tbWorkPhone.PhoneNumber.Trim();
				personPhone.Extension = this.tbWorkPhone.Extension;
				personPhone.PhoneType = new Lookup(SystemLookup.PhoneType_Business);
				person.Phones.Add(personPhone);
			}
			if (this.tbCellPhone.PhoneNumber.Trim() != string.Empty)
			{
				personPhone = new PersonPhone();
				personPhone.Number = this.tbCellPhone.PhoneNumber.Trim();
				personPhone.PhoneType = new Lookup(SystemLookup.PhoneType_Cell);
				personPhone.SMSEnabled = this.cbSMS.Checked;
				person.Phones.Add(personPhone);
			}
			if (this.tbEmail.Text.Trim() != string.Empty)
			{
				PersonEmail personEmail = new PersonEmail();
				personEmail.Active = true;
				personEmail.Email = this.tbEmail.Text.Trim();
				person.Emails.Add(personEmail);
			}
			person.Save(organizationID, text2, false);
			person.SaveAddresses(organizationID, text2);
			person.SavePhones(organizationID, text2);
			person.SaveEmails(organizationID, text2);
			Family family = new Family();
			family.OrganizationID = organizationID;
			family.FamilyName = this.tbLastName.Text.Trim() + " Family";
			family.Save(text2);
			new FamilyMember(family.FamilyID, person.PersonID)
			{
				FamilyID = family.FamilyID, 
				FamilyRole = new Lookup(SystemLookup.FamilyRole_Adult)
			}.Save(text2);
			Arena.Security.Login login2 = new Arena.Security.Login();
			login2.PersonID = person.PersonID;
			login2.LoginID = this.tbLoginID.Text.Trim();
			login2.Password = this.tbPassword.Text.Trim();
			if (bool.Parse(this.EmailVerificationSetting))
			{
				login2.Active = false;
			}
			else
			{
				login2.Active = true;
			}
			login2.Save(text2);
			login2 = new Arena.Security.Login(login2.LoginID);
			if (bool.Parse(this.EmailVerificationSetting))
			{
				NewUserAccountEmailVerification newUserAccountEmailVerification = new NewUserAccountEmailVerification();
				Dictionary<string, string> dictionary = new Dictionary<string, string>();
				dictionary.Add("##FirstName##", person.FirstName);
				dictionary.Add("##LastName##", person.LastName);
				dictionary.Add("##Birthdate##", person.BirthDate.ToShortDateString());
				dictionary.Add("##MaritalStatus##", person.MaritalStatus.Value);
				dictionary.Add("##Gender##", person.Gender.ToString());
				dictionary.Add("##StreetAddress##", (person.Addresses.Count > 0) ? person.Addresses[0].Address.StreetLine1 : "N/A");
				dictionary.Add("##City##", (person.Addresses.Count > 0) ? person.Addresses[0].Address.City : "N/A");
				dictionary.Add("##State##", (person.Addresses.Count > 0) ? person.Addresses[0].Address.State : "N/A");
				dictionary.Add("##ZipCode##", (person.Addresses.Count > 0) ? person.Addresses[0].Address.PostalCode : "N/A");
				dictionary.Add("##HomePhone##", this.tbHomePhone.PhoneNumber);
				dictionary.Add("##WorkPhone##", this.tbWorkPhone.PhoneNumber);
				dictionary.Add("##CellPhone##", this.tbCellPhone.PhoneNumber);
				dictionary.Add("##Login##", this.tbLoginID.Text);
				dictionary.Add("##Password##", this.tbPassword.Text);
				dictionary.Add("##VerificationURL##", string.Format(base.CurrentOrganization.Url + (base.CurrentOrganization.Url.EndsWith("/") ? "" : "/") + "default.aspx?page={0}&pid={1}&un={2}&org={3}&h={4}", new object[]
				{
					string.IsNullOrEmpty(this.NewUserVerificationPageSetting) ? "" : this.NewUserVerificationPageSetting, 
					person.PersonID.ToString(), 
					login2.LoginID, 
					base.CurrentOrganization.OrganizationID.ToString(), 
					this.CreateHash(login2.PersonID.ToString() + login2.DateCreated.ToString() + login2.LoginID)
				}));
				newUserAccountEmailVerification.Send(person.Emails.FirstActive, dictionary, login2.PersonID);
			}
			else
			{
				FormsAuthentication.SetAuthCookie(login2.LoginID, false);
				base.Response.Cookies["portalroles"].Value = string.Empty;
			}
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
				Lookup lookup2 = new Lookup(lookupID);
				Lookup lookup3 = new Lookup(lookupID2);
				if (profile.ProfileID == -1 || lookup2.LookupID == -1 || lookup3.LookupID == -1)
				{
					throw new ModuleException(base.CurrentPortalPage, base.CurrentModule, "'ProfileID', 'SourceLUID', and 'StatusLUID' must all be valid IDs");
				}
				ProfileMember profileMember = new ProfileMember();
				profileMember.ProfileID = profile.ProfileID;
				profileMember.PersonID = person.PersonID;
				profileMember.Source = lookup2;
				profileMember.Status = lookup3;
				profileMember.DatePending = DateTime.Now;
				profileMember.Save(text2);
				if (profile.ProfileType == ProfileType.Serving)
				{
					ServingProfile servingProfile = new ServingProfile(profile.ProfileID);
					new ServingProfileMember(profileMember.ProfileID, profileMember.PersonID)
					{
						HoursPerWeek = servingProfile.DefaultHoursPerWeek
					}.Save();
				}
			}
			string text3 = base.Session["RedirectValue"].ToString();
			if (!string.IsNullOrEmpty(text3))
			{
				base.Session["RedirectValue"] = null;
				base.Response.Redirect(text3);
			}
		}
		private string CreateHash(string sCreateHashFrom)
		{
			SHA1 sHA = new SHA1CryptoServiceProvider();
			string text = string.Empty;
			byte[] array = Encoding.ASCII.GetBytes(sCreateHashFrom);
			array = sHA.ComputeHash(array);
			byte[] array2 = array;
			for (int i = 0; i < array2.Length; i++)
			{
				byte b = array2[i];
				text += b.ToString("x2");
			}
			return text;
		}
		protected override void OnInit(EventArgs e)
		{
			this.InitializeComponent();
			base.OnInit(e);
		}
		private void InitializeComponent()
		{
			this.btnSubmit.Click += new EventHandler(this.btnSubmit_Click);
			this.btnCreate.Click += new EventHandler(this.btnCreate_Click);
		}
	}
}
