using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SSOLib.Service;

namespace SSOLib
{
    public class AuthUtil
    {
        AuthService service = new AuthService();

        public static AuthUtil Instance
        {
            get
            {
                return new AuthUtil();
            }
        }

        /// <summary>
        /// Retrieves the user using the Token
        /// </summary>
        /// <param name="Token"></param>
        /// <returns></returns>
        public WebUser GetUserByToken(string Token)
        {

            WebUser user = service.GetUserByToken(Token);

            return user;
        }

        /// <summary>
        /// Determines whether the current user is logged onto the SSO site
        /// </summary>
        /// <param name="Token"></param>
        /// <returns></returns>
        public bool IsUserLoggedIn(string Token)
        {
            return service.IsUserLoggedIn(Token);
        }

        public UserStatus GetUserStauts(string Token, string RequestId)
        {
            return service.GetUserStauts(Token, RequestId);
        }

        /// <summary>
        /// Checks whether the redirect ID is expired or not
        /// </summary>
        /// <param name="RedirectId"></param>
        /// <returns></returns>
        public bool IsValidRequest(string RequestId)
        {
            return service.IsValidRequest(RequestId);
        }
      
        public WebUser Authenticate(string UserName, string Password)
        {

            WebUser user = service.Authenticate(UserName, Password);

            return user;
        }
    }
}
