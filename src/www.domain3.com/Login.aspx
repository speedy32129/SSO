<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link rel="Stylesheet" href="/style/style.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <table align="center" width="350px" style="align: center; margin-top: 150px;">
        <tr>
            <td>
                <fieldset style="width: 350px;" align="middle">
                    <legend>Login to site "<%=Request.Url.Host %>"</legend>
                    <table style="margin-left: 20px" align="left">
                        <tr>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text="User"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtUser" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label2" runat="server" Text="Password"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtPassword" TextMode="Password" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <asp:Button runat="server" Text="Login" ID="btnLogin" OnClick="btnLogin_Click"></asp:Button>
                                <asp:Label ID="lblLoginFailed" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </td>
        </tr>
       
    </table>
    </form>
</body>
</html>
