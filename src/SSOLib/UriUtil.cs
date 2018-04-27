using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Text.RegularExpressions;

namespace SSOLib
{
    /// <summary>
    /// Summary description for UriUtil
    /// </summary>
    public class UriUtil
    {
        public static string RemoveParameter(string url, string key)
        {
            url = url.ToLower();
            key = key.ToLower();
            if (HttpContext.Current.Request[key] == null) return url;

            string fragmentToRemove = string.Format("{0}={1}",key , HttpContext.Current.Request[key].ToLower());

            String result = url.ToLower().Replace("&" + fragmentToRemove, string.Empty).Replace("?" + fragmentToRemove, string.Empty);
            return result;
        }

        public static string GetAbsolutePathForRelativePath(string relativePath)
        {
            HttpRequest Request = HttpContext.Current.Request;
            string returnUrl = string.Format("{0}{1}",Request.Url.AbsoluteUri.Replace(Request.Url.PathAndQuery, string.Empty) , VirtualPathUtility.ToAbsolute(relativePath));
            return returnUrl;
        }
    }
}