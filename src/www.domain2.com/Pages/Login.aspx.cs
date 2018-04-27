using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using SSOLib;

public partial class Login : PrivatePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        bool loginSuccessful = Login(txtUser.Text.Trim(), txtPassword.Text.Trim());
        if (!loginSuccessful)
        {
            lblLoginFailed.Text = "Invalid credentials";
        }
    }
}
