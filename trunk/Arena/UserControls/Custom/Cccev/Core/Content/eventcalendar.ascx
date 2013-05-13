<%@ Control Language="c#" Inherits="ArenaWeb.UserControls.Custom.Cccev.Core.EventCalendar" CodeFile="EventCalendar.ascx.cs" %>
<asp:Panel ID="pnlCalendar" runat="server" DefaultButton="btnSearch">
<div class="calendarWrap">
<asp:Label id="lblCalendarTitle" runat="server" CssClass="calendarTitle"></asp:Label>

<table width="100%" runat="server" id="tblCalendarControls">
	<tr>
		<td valign="center">
			<asp:Label id=lblCalendarDesc runat="server" CssClass="calendarDateTitle"></asp:Label>
		</td>
		<td align="right" valign="center">
			<asp:DropDownList id="ddTopicArea" runat="server" CssClass="formItem"></asp:DropDownList>
			<asp:DropDownList id="ddMonth" runat="server" CssClass="formItem"></asp:DropDownList>
			<asp:DropDownList id="ddYear" runat="server" CssClass="formItem"></asp:DropDownList>
			<asp:Button ID="btnSearch" Runat="server" CssClass="smallText" Text="Search"></asp:Button>
		</td>
	</tr>
</table>


<asp:Table Width="100%" ID="tblCalendar" CellPadding="0" CellSpacing="0" Runat="server" CssClass="calendarTable"></asp:Table>
</div>

<asp:Label id=lblError runat="server" CssClass="normalText"></asp:Label>
</asp:Panel>