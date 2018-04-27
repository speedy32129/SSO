<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="_Profile" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Profiles page</title>
    <link rel="Stylesheet" href="../style/style.css"type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    
    <div class="profile">
        Hello <asp:Label ID="lblUser" CssClass="message" runat="server"></asp:Label>, Following is your profile at <asp:Label ID="lblServer" CssClass="green" runat="server"></asp:Label>"
       
        <br /><br /> 
        First Name : <asp:Label ID="lblFirstName" runat="server"></asp:Label> 
        <br />
        Last Name : <asp:Label ID="lblLastName" runat="server"></asp:Label> 
        <br />
        UserName : <asp:Label ID="lblUserName" runat="server"></asp:Label> 

        <br /><br />
        Go to <asp:HyperLink NavigateUrl="~/Default.aspx" Text="Home Page" runat="server"></asp:HyperLink>
        <br />
        Click to <asp:LinkButton ID="lnkLogout" CssClass="anchor" runat="server" onclick="lnkLogout_Click">Log out</asp:LinkButton>
    </div>
    </form>
</body>
</html>
