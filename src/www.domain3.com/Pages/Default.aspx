<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home page</title>
    <link rel="Stylesheet" href="/style/style.css"type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    
    <div class="profile">
        Hello <asp:Label ID="lblUser" CssClass="message" runat="server"></asp:Label>, You are at home page of <asp:Label ID="lblServer" CssClass="green" runat="server"></asp:Label>"
        <br /><br />
        Go to <asp:HyperLink NavigateUrl="~/pages/Profile.aspx" Text="Profile Page" runat="server"></asp:HyperLink>
        <br />
        Click to <asp:LinkButton ID="lnkLogout" CssClass="anchor" runat="server" onclick="lnkLogout_Click">Log out</asp:LinkButton>
    </div>
    </form>
</body>
</html>
