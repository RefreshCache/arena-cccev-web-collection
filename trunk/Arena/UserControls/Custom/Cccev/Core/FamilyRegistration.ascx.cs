/**********************************************************************
* Description:  This is a public facing family registration module which
*				which was created by CCV and then adapted for us in our
*				versions of Arena.
* Created By:   David Turner @ Christ's Church of the Valley
* Modified By:  Nick Airdo @ Central Christian Church (Arizona)
* Date Created: 3/10/2011
*
* $Workfile: FamilyRegistration.ascx.cs $
* $Revision: 3 $
* $Header: /trunk/Arena/UserControls/Custom/Cccev/Core/FamilyRegistration.ascx.cs   3   2013-11-25 11:43:04-07:00   nicka $
*
* $Log: /trunk/Arena/UserControls/Custom/Cccev/Core/FamilyRegistration.ascx.cs $
*  
*  Revision: 3   Date: 2013-11-25 18:43:04Z   User: nicka 
*  Added ability to tag new people into configured tag, tag source and tag 
*  member status. 
*  
*  Revision: 2   Date: 2011-03-11 15:57:22Z   User: nicka 
*  Only add a new child field row if there are no children in the family 
*  already. 
*  
*  Revision: 1   Date: 2011-03-11 00:47:13Z   User: nicka 
*  A public facing Family Registration module adapted from CCV's system. 
**********************************************************************/

namespace ArenaWeb.UserControls.Custom.Cccev.Core
{
	using System;
	using System.Web.UI;
	using System.Web.UI.WebControls;

	using Arena.Core;
	using Arena.Portal;
	using Arena.Portal.UI;
	using Arena.Custom.CCV.Core;
	using Arena.Enums;

	/// <summary>
	///		Summary description for UserLogin.
	/// </summary>
	public partial class FamilyRegistration : PortalControl
	{
		#region Module Settings

		// Module Settings

		[LookupSetting("Member Status", "The Member Status to set a user to when they add themself through this form.", true, "0B4532DB-3188-40F5-B188-E7E6E4448C85")]
		public string MemberStatusIDSetting { get { return Setting("MemberStatusID", "", true); } }

		[CampusSetting("Default Campus", "The campus to assign a user to when they add themself through this form.", false)]
		public string CampusSetting { get { return Setting("Campus", "", false); } }

		//[BooleanSetting("Use Campus Preference", "Should user's campus preference be used if it exists?", false, true)]
		//public string UseCampusPreferenceSetting { get { return Setting("UseCampusPreference", "true", false); } }

		[PageSetting( "Redirect Page", "The page to redirect to after a completed registration", true )]
		public string RedirectPageSetting { get { return Setting( "RedirectPage", "", true ); } }

		[TagSetting( "Profile ID", "An optional profile ID that the user will be automatically added to when they complete this new account form.", false )]
		public string ProfileIDSetting { get { return base.Setting( "ProfileID", "", false ); } }

		[LookupSetting( "Profile Source", "If using the Profile ID setting, then this value must be set to a valid Profile Source Lookup value.", false, "43DB58F9-C43F-4913-84FF-2E3CEA59C134" )]
		public string SourceLUIDSetting	{ get { return base.Setting( "SourceLUID", "", false ); } }

		[LookupSetting( "Profile Status", "If using the Profile ID setting, then this value must be set to a valid Profile Status Lookup value.", false, "705F785D-36DB-4BF2-9C35-2A7F72A55731" )]
		public string StatusLUIDSetting { get { return base.Setting( "StatusLUID", "", false ); } }

		#endregion

		#region Private Variables

		private Family _family = null;

		#endregion

		#region Events

		#region Page Events

		protected void Page_Load(object sender, System.EventArgs e)
		{
			if (_family == null)
			{
				FamilyMember you = null;
				FamilyMember spouse = null;

				if (CurrentPerson != null)
				{
					_family = CurrentPerson.Family();

					you = _family.FamilyMembers.FindByGuid(CurrentPerson.PersonGUID);

					spouse = _family.Spouse(CurrentPerson);
				}
				else
				{
					_family = new Family();

					you = new FamilyMember();
					you.PersonGUID = Guid.NewGuid();
					you.FamilyRole = new Lookup(SystemLookup.FamilyRole_Adult);
					you.Gender = Arena.Enums.Gender.Unknown;
					_family.FamilyMembers.Add(you);
				}

				// Save Spouse
				if (spouse == null)
				{
					spouse = new FamilyMember();
					spouse.PersonGUID = Guid.NewGuid();
					spouse.FamilyRole = new Lookup(SystemLookup.FamilyRole_Adult);
					if (CurrentPerson != null && CurrentPerson.Gender == Arena.Enums.Gender.Male)
						you.Gender = Arena.Enums.Gender.Female;
					else if (CurrentPerson != null && CurrentPerson.Gender == Arena.Enums.Gender.Female)
						you.Gender = Arena.Enums.Gender.Male;
					else
						you.Gender = Arena.Enums.Gender.Unknown;
					_family.FamilyMembers.Add(spouse);
				}

				// Save Guids
				hfYouGuid.Value = you.PersonGUID.ToString();
				hfSpouseGuid.Value = spouse.PersonGUID.ToString();
			}

			if (Page.IsPostBack)
				UpdateChanges();
			else
				ShowYou();
		}

		protected override void LoadViewState(object savedState)
		{
			base.LoadViewState(savedState);

			if (ViewState["Family"] != null)
				_family = (Family)ViewState["Family"];
		}

		protected override object SaveViewState()
		{
			ViewState["Family"] = _family;

			return base.SaveViewState();
		}

		#endregion

		#region You Events

		protected void lbYouNext_Click(object sender, EventArgs e)
		{
			ShowSpouse();
		}

		#endregion

		#region Sposue Events

		protected void lbSpousePrev_Click(object sender, EventArgs e)
		{
			ShowYou();
		}

		protected void lbSpouseNext_Click(object sender, EventArgs e)
		{
			ShowFamilyMembers();
		}

		#endregion

		#region Family Member Events

		protected void lvFamilyMembers_OnItemDataBound( object sender, ListViewItemEventArgs e )
		{
			if ( e.Item.ItemType == ListViewItemType.DataItem )
			{
				TextBox textbox = (TextBox)e.Item.FindControl( "tbFirstName" );
				if ( textbox != null )
				{
					textbox.Focus();
				}
			}
		}

		protected void lvFamilyMembers_OnItemCommand(object sender, ListViewCommandEventArgs e)
		{
			if (e.CommandName == "Add")
			{
				FamilyMember you = _family.FamilyMembers.FindByGuid(new Guid(hfYouGuid.Value));

				FamilyMember fm = new FamilyMember();
				fm.PersonGUID = Guid.NewGuid();
				fm.FamilyRole = new Lookup(SystemLookup.FamilyRole_Child);
				fm.LastName = you != null ? you.LastName : string.Empty;
				_family.FamilyMembers.Add(fm);

				ShowFamilyMembers();
			}

			if (e.CommandName == "Remove")
			{
				HiddenField hfPersonGuid = (HiddenField)e.Item.FindControl("hfPersonGuid");
				_family.FamilyMembers.Remove(new Guid(hfPersonGuid.Value));

				ShowFamilyMembers();
			}
		}

		protected void lvEmailCell_OnItemDataBound( object sender, ListViewItemEventArgs e )
		{
			if ( e.Item.ItemType == ListViewItemType.DataItem )
			{
				TextBox textbox = (TextBox)e.Item.FindControl( "tbEmail" );
				if ( textbox != null )
				{
					textbox.Focus();
				}
			}
		}

		protected void lbFamilyMembersPrev_Click(object sender, EventArgs e)
		{
			ShowSpouse();
		}

		protected void lbFamilyMembersNext_Click(object sender, EventArgs e)
		{
			ShowContactInfo();
		}

		#endregion

		#region Contact Info Events

		protected void lbContactInfoPrev_Click(object sender, EventArgs e)
		{
			ShowFamilyMembers();
		}
		protected void lbContactInfoNext_Click(object sender, EventArgs e)
		{
			SaveChanges();
			Response.Redirect(string.Format("default.aspx?page={0}&p={1}", RedirectPageSetting, hfYouGuid.Value), true);
		}

		#endregion

		#endregion

		#region Private Methods

		private void UpdateChanges()
		{
			if (pnlYou.Visible)
			{
				FamilyMember fm = _family.FamilyMembers.FindByGuid(new Guid(hfYouGuid.Value));
				if (fm != null)
				{
					fm.NickName = tbYouFirstName.Text;
					fm.LastName = tbYouLastName.Text;

					PersonAddress homeAddress = fm.Addresses.FindByType(SystemLookup.AddressType_Home);
					if (homeAddress == null)
					{
						homeAddress = new PersonAddress();
						homeAddress.AddressType = new Lookup(SystemLookup.AddressType_Home);
						homeAddress.Address = new Address();

						if (fm.PrimaryAddress == null)
							homeAddress.Primary = true;

						fm.Addresses.Add(homeAddress);
					}

					homeAddress.Address.StreetLine1 = tbAddress.Text;
					homeAddress.Address.City = tbCity.Text;
					homeAddress.Address.State = tbState.Text;
					homeAddress.Address.PostalCode = tbZip.Text;

					PersonPhone homePhone = fm.Phones.FindByType(SystemLookup.PhoneType_Home);
					if (homePhone == null)
					{
						homePhone = new PersonPhone();
						homePhone.PhoneType = new Lookup(SystemLookup.PhoneType_Home);
						fm.Phones.Add(homePhone);
					}
					homePhone.Number = ptbYouHomeNum.PhoneNumber;

					fm.BirthDate = dtYouBirthDate.SelectedDate;

					if (ddlYouGender.SelectedValue == "Male")
						fm.Gender = Arena.Enums.Gender.Male;
					else if (ddlYouGender.SelectedValue == "Female")
						fm.Gender = Arena.Enums.Gender.Female;
					else
						fm.Gender = Arena.Enums.Gender.Unknown;
				}
			}

			if (pnlSpouse.Visible)
			{
				FamilyMember fm = _family.FamilyMembers.FindByGuid(new Guid(hfSpouseGuid.Value));
				if (fm != null)
				{
					fm.NickName = tbSpouseFirstName.Text;
					fm.LastName = tbSpouseLastName.Text;

					fm.BirthDate = dtSpouseBirthDate.SelectedDate;

					FamilyMember spouse = _family.Spouse(fm);
					if (spouse != null)
					{
						if (spouse.Gender == Arena.Enums.Gender.Male)
							fm.Gender = Arena.Enums.Gender.Female;
						else if (spouse.Gender == Arena.Enums.Gender.Female)
							fm.Gender = Arena.Enums.Gender.Male;
					}
				}
			}

			if (pnlFamilyMembers.Visible)
			{
				foreach (ListViewDataItem item in lvFamilyMembers.Items)
				{
					HiddenField hfPersonGuid = (HiddenField)item.FindControl("hfPersonGuid");
					FamilyMember fm = _family.FamilyMembers.FindByGuid(new Guid(hfPersonGuid.Value));

					fm.NickName = ((TextBox)item.FindControl("tbFirstName")).Text;
					fm.LastName = ((TextBox)item.FindControl("tbLastName")).Text;
					fm.BirthDate = ((DateTextBox)item.FindControl("dtbBirthDate")).SelectedDate;

					string gender = ((DropDownList)item.FindControl("ddlGender")).SelectedValue;
					switch (gender)
					{
						case "Male": fm.Gender = Arena.Enums.Gender.Male; break;
						case "Female": fm.Gender = Arena.Enums.Gender.Female; break;
						default: fm.Gender = Arena.Enums.Gender.Unknown; break;
					}

					int grade = Convert.ToInt32(((DropDownList)item.FindControl("ddlGrade")).SelectedValue);
					fm.GraduationDate = Person.CalculateGraduationYear(grade, CurrentOrganization.GradePromotionDate);
				}
			}

			if (pnlContactInfo.Visible)
			{
				foreach (ListViewDataItem item in lvEmailCell.Items)
				{
					HiddenField hfPersonGuid = (HiddenField)item.FindControl("hfPersonGuid");
					FamilyMember fm = _family.FamilyMembers.FindByGuid(new Guid(hfPersonGuid.Value));
					fm.Emails.FirstActive = ((TextBox)item.FindControl("tbEmail")).Text;

					PersonPhone cellPhone = fm.Phones.FindByType(SystemLookup.PhoneType_Cell);
					PhoneTextBox ptbCellNum = ((PhoneTextBox)item.FindControl("ptbCellNum"));
					if (cellPhone == null && ptbCellNum.PhoneNumber.Trim() != string.Empty)
					{
						cellPhone = new PersonPhone();
						cellPhone.PhoneType = new Lookup(SystemLookup.PhoneType_Cell);
						fm.Phones.Add(cellPhone);
					}
					if (cellPhone != null)
						cellPhone.Number = ptbCellNum.PhoneNumber;
				}
			}
		}

		private void SaveChanges()
		{
			string userId = CurrentUser != null ? CurrentUser.Identity.Name : "PreRegistration";

			// Default Member Status
			Lookup memberStatus;
			try
			{
				memberStatus = new Lookup(Int32.Parse(MemberStatusIDSetting));
				if (memberStatus.LookupID == -1)
					throw new ModuleException(CurrentPortalPage, CurrentModule, "Member Status setting must be a valid Member Status Lookup value.");
			}
			catch (System.Exception ex)
			{
				throw new ModuleException(CurrentPortalPage, CurrentModule, "Member Status setting must be a valid Member Status Lookup value.", ex);
			}

			// Default Campus
			int campusId = CampusSetting.Trim() != string.Empty ? int.Parse(CampusSetting) : -1;
			//if (Boolean.Parse(UseCampusPreferenceSetting) && CurrentArenaContext.CampusPreference != null)
			//    campusId = CurrentArenaContext.CampusPreference.CampusId;

			Arena.Organization.Campus campus = null;
			if (campusId != -1)
				campus = new Arena.Organization.Campus(campusId);

			FamilyMember you = _family.FamilyMembers.FindByGuid(new Guid(hfYouGuid.Value));

			if (_family.FamilyID == -1)
			{
				_family.OrganizationID = CurrentOrganization.OrganizationID;
				_family.FamilyName = you.LastName.Trim() + " Family";
				_family.Save(userId);
			}

			foreach (FamilyMember fm in _family.FamilyMembers)
			{
				//*******Marital Status
				if (fm.PersonID == -1)
				{
					fm.FamilyID = _family.FamilyID;
					fm.MemberStatus = memberStatus;
					fm.Campus = campus;
					fm.OrganizationID = CurrentOrganization.OrganizationID;
				}

				if (fm.PersonID != -1 || fm.NickName != string.Empty)
				{
					if (fm.PersonGUID != you.PersonGUID)
					{
						PersonAddress homeAddress = fm.Addresses.FindByType(SystemLookup.AddressType_Home);
						if (homeAddress == null)
						{
							homeAddress = new PersonAddress();
							homeAddress.AddressType = new Lookup(SystemLookup.AddressType_Home);
							fm.Addresses.Add(homeAddress);
							if (fm.Addresses.PrimaryAddress() == null)
								homeAddress.Primary = true;
						}
						homeAddress.Address = you.Addresses.FindByType(SystemLookup.AddressType_Home).Address;

						PersonPhone homePhone = fm.Phones.FindByType(SystemLookup.PhoneType_Home);
						if (homePhone == null)
						{
							homePhone = new PersonPhone();
							homePhone.PhoneType = new Lookup(SystemLookup.PhoneType_Home);
							fm.Phones.Add(homePhone);
						}
						homePhone.Number = you.Phones.FindByType(SystemLookup.PhoneType_Home).Number;
					}


					// Save Person
					fm.Save(CurrentOrganization.OrganizationID, userId, false);
					fm.SaveAddresses(CurrentOrganization.OrganizationID, userId);
					fm.SavePhones(CurrentOrganization.OrganizationID, userId);
					fm.SaveEmails(CurrentOrganization.OrganizationID, userId);
					fm.Save(userId);

					if ( this.ProfileIDSetting != string.Empty )
					{
						AddToTag( fm );
					}
				}
			}
		}

		/// <summary>
		/// Adds the given family member to the configured tag (and tag member status).
		/// This logic was harvested dirctly from our custom UserConfirmation.ascx module
		/// which is a variant of Arena's UserConfirmation.
		/// </summary>
		/// <param name="fm">a family member</param>
		private void AddToTag( FamilyMember fm )
		{
			string text = base.CurrentUser.Identity.Name;
			if ( text == string.Empty )
			{
				text = "Cccev.Core.FamilyRegistration.ascx";
			}

			int profileId = -1;
			int lookupID = -1;
			int lookupID2 = -1;
			try
			{
				if ( this.ProfileIDSetting.Contains( "|" ) )
				{
					profileId = int.Parse( this.ProfileIDSetting.Split( new char[]
						{
							'|'
						} )[1] );
				}
				else
				{
					profileId = int.Parse( this.ProfileIDSetting );
				}
				lookupID = int.Parse( this.SourceLUIDSetting );
				lookupID2 = int.Parse( this.StatusLUIDSetting );
			}
			catch ( System.Exception inner2 )
			{
				throw new ModuleException( base.CurrentPortalPage, base.CurrentModule, "If using a ProfileID setting for this module, then a valid numeric 'ProfileID', 'SourceLUID', and 'StatusLUID' setting must all be used!", inner2 );
			}
			Profile profile = new Profile( profileId );
			Lookup lookup6 = new Lookup( lookupID );
			Lookup lookup7 = new Lookup( lookupID2 );
			if ( profile.ProfileID == -1 || lookup6.LookupID == -1 || lookup7.LookupID == -1 )
			{
				throw new ModuleException( base.CurrentPortalPage, base.CurrentModule, "'ProfileID', 'SourceLUID', and 'StatusLUID' must all be valid IDs" );
			}
			ProfileMember profileMember = new ProfileMember();
			profileMember.ProfileID = profile.ProfileID;
			profileMember.PersonID = fm.PersonID;
			profileMember.Source = lookup6;
			profileMember.Status = lookup7;
			profileMember.DatePending = DateTime.Now;
			profileMember.Save( text );
			if ( profile.ProfileType == ProfileType.Serving )
			{
				ServingProfile servingProfile = new ServingProfile( profile.ProfileID );
				new ServingProfileMember( profileMember.ProfileID, profileMember.PersonID )
				{
					HoursPerWeek = servingProfile.DefaultHoursPerWeek
				}.Save();
			}
		}

		private void ShowYou()
		{
			FamilyMember fm = _family.FamilyMembers.FindByGuid(new Guid(hfYouGuid.Value));
			if (fm != null)
			{
				tbYouFirstName.Text = fm.NickName;
				tbYouLastName.Text = fm.LastName;

				PersonAddress homeAddress = fm.Addresses.FindByType(SystemLookup.AddressType_Home);
				tbAddress.Text = homeAddress != null ? homeAddress.Address.StreetLine1 : string.Empty;
				tbCity.Text = homeAddress != null ? homeAddress.Address.City : string.Empty;
				tbState.Text = homeAddress != null ? homeAddress.Address.State : string.Empty;
				tbZip.Text = homeAddress != null ? homeAddress.Address.PostalCode : string.Empty;


				PersonPhone homePhone = fm.Phones.FindByType(SystemLookup.PhoneType_Home);
				ptbYouHomeNum.PhoneNumber = homePhone != null ? homePhone.Number : string.Empty;
				ptbYouHomeNum.ShowExtension = false;

				dtYouBirthDate.SelectedDate = fm.BirthDate;
				if (fm.Gender == Arena.Enums.Gender.Male)
					ddlYouGender.SelectedValue = "Male";
				else if (fm.Gender == Arena.Enums.Gender.Female)
					ddlYouGender.SelectedValue = "Female";
				else
					ddlYouGender.SelectedValue = "Unknown";
			}
			ShowPanel(pnlYou);
		}

		private void ShowSpouse()
		{
			FamilyMember fm = _family.FamilyMembers.FindByGuid(new Guid(hfSpouseGuid.Value));
			if (fm != null)
			{
				tbSpouseFirstName.Text = fm.NickName;
				tbSpouseLastName.Text = fm.LastName;
				dtSpouseBirthDate.SelectedDate = fm.BirthDate;
			}
			ShowPanel(pnlSpouse);
		}

		private void ShowFamilyMembers()
		{
			if ( _family.Children() != null && _family.Children().Count == 0 )
			{
				FamilyMember you = _family.FamilyMembers.FindByGuid( new Guid( hfYouGuid.Value ) );

				FamilyMember fm = new FamilyMember();
				fm.PersonGUID = Guid.NewGuid();
				fm.FamilyRole = new Lookup( SystemLookup.FamilyRole_Child );
				fm.LastName = you != null ? you.LastName : string.Empty;
				_family.FamilyMembers.Add( fm );
			}

			lvFamilyMembers.DataSource = _family.Children();
			lvFamilyMembers.DataBind();

			ShowPanel(pnlFamilyMembers);
		}

		private void ShowContactInfo()
		{
			lvEmailCell.DataSource = _family.FamilyMembers;
			lvEmailCell.DataBind();

			ShowPanel(pnlContactInfo);
		}

		private void ShowPanel(Panel panel)
		{
			pnlYou.Visible = pnlYou.Equals(panel);
			pnlSpouse.Visible = pnlSpouse.Equals(panel);
			pnlFamilyMembers.Visible = pnlFamilyMembers.Equals(panel);
			pnlContactInfo.Visible = pnlContactInfo.Equals(panel);
		}

		#endregion

		#region Protected Methods

		protected string GetGrade(DateTime graduationDate)
		{
			return Person.CalculateGradeLevel(graduationDate, CurrentOrganization.GradePromotionDate).ToString();
		}

		#endregion
	}
}

/*
*  These items below were harvested from CCVs newest Arena.Custom.CCV.dll which
*  conflicts with our version therefore we're just including the functionality
*  here.
*/
namespace Arena.Custom.CCV.Core
{
	using Arena.Core;
	using System;
	using System.ComponentModel;
	using System.Web.UI;
	using System.Web.UI.WebControls;

	[Serializable, Description("CCV Address")]
		public class AddressField : Arena.Portal.UI.FieldTypes.AddressField
		{
			// Methods
			public override void RenderPrompt(PlaceHolder placeHolder, ArenaContext currentContext, IFieldInfo fieldInfo, bool setValues, string formCssClass)
			{
				RenderPrompt(placeHolder, currentContext, fieldInfo, setValues, formCssClass);
				foreach (Control control in placeHolder.Controls)
				{
					if (control is LiteralControl)
					{
						LiteralControl control2 = (LiteralControl) control;
						control2.Text = control2.Text.Replace("<b>City</b>", "").Replace("&nbsp;<b>State</b>", "").Replace("&nbsp;<b>Zip</b>", "");
					}
				}
			}
		}

		public static class FamilyExtensions
		{
			// Methods
			public static FamilyMember FindByGuid(this FamilyMemberCollection familyMembers, Guid guid)
			{
				foreach (FamilyMember member in familyMembers)
				{
					if (member.Guid == guid)
					{
						return member;
					}
				}
				return null;
			}
		}

		public static class PersonExtensions
		{
			// Methods
			public static string PhoneNumber(this Person person, Guid phoneType)
			{
				foreach (PersonPhone phone in person.Phones)
				{
					if (phone.PhoneType.Guid == phoneType)
					{
						return phone.ToString();
					}
				}
				return string.Empty;
			}
		}
}

