# SSO
**Single Sign On (SSO) for cross-domain ASP.NET applications: Part-II - The implementation**

Original source ccan be located at http://www.codeproject.com/Articles/114484/Single-Sign-On-SSO-for-cross-domain-ASP-NET-appl


Al-Farooque Shubho, 4 Oct 2010

Implementation approach of a domain independent Single Sign On (SSO) for ASP.NET applications.

​                																																																						

## Introduction

In today's world wide web, Single Sign On for multiple web applications is a common requirement, and it is not an easy thing to implement when these web applications are deployed under different domains. Why? Because user authentication and maintenance of user's "logged on" status on web applications (specially in ASP.NET applications) is something which is totally dependent on HTTP cookies, and two web applications cannot simply share a single cookie if they are deployed under different domains.

The following article has a detailed discussion on user authentication in ASP.NET and its internal implementation strategy. It also has a thorough analysis on some Single Sign On implementation approaches in ASP.NET and their goods and bads. Take a look at this article if you haven't already:

- [Single Sign On (SSO) for cross-domain ASP.NET applications: Part-I - The design blue print](https://www.codeproject.com/KB/aspnet/CrossDomainSSOModel.aspx)

## The implementation

Yes, I have done a sample SSO application based on the proposed model. It's not just another "Hello world", it's a working application that implements SSO across three different sites under three different domains. The hard work is done, and the soft output is, you just need to extend a class for making an ASPX page a "Single Sign On" enabled one in your ASP.NET application. You, of course, have to set up an SSO site and configure your client applications to use the SSO site, that's all (merely a 10 minute work).

The SSO implementation is based on the following high level architecture:

![CrossDomainSSOExample/Proposed_SSO_model_overview.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Proposed_SSO_model_overview.png)

Figure : The Single Sign On implementation model

There may be unlimited number of client sites (in our example, 3 sites) which could participate under a "Single Sign On" umbrella, with the help of a single "Single Sign On" server (call this the SSO site, *www.sso.com*). As described in the previous article, the browser will not store an authentication cookie for each different client site in this model. Rather, it will store an authentication cookie for only the SSO site (*www.sso.com*) which will be used by the other sites to implement Single Sign On.

In this model, each and every request to any client site (which takes part in the SSO model) will internally be redirected to the SSO site (*www.sso.com*) for setting and checking the existence of the authentication cookie. If the cookie is found, the authenticated pages for the client sites (that are currently requested by the browser) are served to the browser, and if not found, the user is redirected to the login page of the corresponding site.

## How it works

Initially, the browser doesn't have any authentication cookie stored for *www.sso.com*. So, hitting any authenticated page in the browser for *www.domain1.com*, or *www.domain2.com*, or *www.domain3.com* redirects the user to the login page (via an internal redirection to *www.sso.com* for checking the existence of the authentication cookie). Once a user is logged onto a site, the authentication cookie for *www.sso.com* is set in the browser with the logged in user information (most importantly, the user Token, which is valid only for the user's login session).

Now, if the user hits any authenticated page URL of *www.domain1.com*, or *www.domain2.com* or *www.domain3.com*, the request is internally redirected to *www.sso.com* in the user's browser and the browser sends the authentication cookie, which is already set. *www.sso.com* finds the authentication cookie, extracts the user Token, and redirects to the originally requested URL in the browser with the user token, and the originally requested site validates the Token and serves the page that was originally requested by the user.

Once the user is logged onto any site under this SSO model, hitting any authenticated page on *www.domain1.com*, or *www.domain2.com*, or *www.domain3.com* results in an internal redirection to *www.sso.com* (for checking the authentication cookie and retrieving the user Token) and then serving the authentication page in the browser output.

## OK, show me what you implemented

I have developed a sample Single Sign On application that incorporates three different sites (*www.domain1.com*, *www.domain2.com*, and *www.domain3.com*) and an SSO server site (*www.sso.com*). The sample SSO implementation code is available for download with this article. You just need to download and set up the sites as instructed in the next section. Once you are done with that, you can test the implementation in different scenarios.

The following section has step by step instructions to test the Single Sign On functionality in different scenarios, and each testing scenario has a Firebug network traffic information that depicts the total number of requests (including the lightweight redirect requests) and their length in size. The number of redirect requests and their length in size are marked within green for easy understandability.

## Scenario1: Before authentication

Hit the following three URLs in the browser in three different tabs of the same browser window.

- *www.domain1.com*
- *www.domain2.com*
- *www.domain3.com*

![CrossDomainSSOExample/LoginUrlSSO.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/LoginUrlSSO.png)

Three different login screens will be presented in each different tabs, for each different site:

![CrossDomainSSOExample/Login1.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Login1.png)

![CrossDomainSSOExample/Login2.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Login2.png)

![CrossDomainSSOExample/Login3.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Login3.png)

#### Traffic info

For presenting the login screen, in total, four requests are sent to the servers, among which three are redirect requests (marked in green). The redirect request sizes are very small (in terms of bytes), and are negligible even considering network latency.

![CrossDomainSSOExample/TrafficLogin.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/TrafficLogin.png)

## Scenario 2: Authentication

Use one of any following credentials in any one of the login screens to log on. Let's log onto *www.domain1.com* with *user1/123*.

Available credentials:

- user1/123
- user2/123
- user3/123

After login, the following screen will be provided for *user1* onto *www.domain1.com*.

![CrossDomainSSOExample/Home1.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Home1.png)

#### Traffic info

For login, in total, three requests are sent to the servers, among which two are redirect requests (marked in green). The redirect request sizes are very small (in terms of bytes), and are negligible even considering network latency.

![CrossDomainSSOExample/TrafficAuthentication.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/TrafficAuthentication.png)

## Scenario 3: After authentication

As *user1* has logged on to *www.domain1.com*, he should be logged onto the other remaining sites: *www.domain2.com* and *www.domain3.com* at the same time, if those sites are browsed in the same window or in different tabs in the same window. Hitting an authenticated page in *www.domain2.com* and *www.domain3.com* should not present a login screen.

Let's just refresh the current page at *www.domain2.com* and *www.domain3.com* in their corresponding window (currently, the login screen is being shown in the browser):

![CrossDomainSSOExample/Home2.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Home2.png)

![CrossDomainSSOExample/Home3.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Home3.png)

You will see that instead of showing the login screen, the authenticated home page is being shown. So, *user1* is logged onto all three sites: *www.domain2.com*, *www.domain2.com*, and *www.domain3.com*.

Each home page shows a "Go to Profile Page" link which you can click to navigate to another page. This demonstrates that clicking on hyperlinks and navigating to other pages in the application also works without any problem.

#### Traffic info

For browsing authenticated pages after login, in total, 3 requests are sent to the servers, among which 2 are redirect requests (marked in green). The redirect request sizes are also very small (in terms of bytes), and are negligible even considering network latency.

![CrossDomainSSOExample/TrafficAuthentication.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/TrafficAuthentication.png)

## Scenario 4: Hit the authenticated page on a different session

As expected, the user's "Sign on" status should only be valid for the current session ID, and any authenticated page URL hit to any one of the three sites will be successful if the URL is hit in the same browser window or in a different tab of the same browser window. But, if a new browser window is opened, and an authenticated URL is hit there, it should not be successful and the request should be redirected to the login page (because that is a different browser session).

To test this, open a new browser window and hit any URL of the three sites that points to an authenticated page (you can copy and paste the existing URL addresses). This time, instead of showing the page output, you will see the request will be redirected to the login page as follows (assuming that you hit a URL of *www.domain3.com*):

![CrossDomainSSOExample/Login3.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Login3.png)

 Traffic info

For hitting an authenticated page on a different session, in total, 4 requests are sent to the servers, among which 3 are redirect requests (marked in green). The redirect request sizes are very small (in terms of bytes), and are negligible even considering network latency.

![CrossDomainSSOExample/TrafficLogin.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/TrafficLogin.png)

## Log out

To log out of the sites, click on the "Log out" link of the home page of *www.domain1.com*. The system will log out *user1* from the site *www.domain1.com* and will redirect to the login screen again:

![CrossDomainSSOExample/Login1.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Login1.png)

#### Traffic info

For logging out, in total, 4 requests are sent to the servers, among which 3 are redirect requests (marked in green). The redirect request sizes are very small (in terms of bytes), and are negligible even considering network latency.

![CrossDomainSSOExample/TrafficLogout.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/TrafficLogout.png)

## After log out

As *user1* is logged out of the site *www.domain1.com*, he should be logged out from *www.domain2.com* and *www.domain3.com* at the same time. So, hitting any authenticated page URL of *www.domain2.com* and *www.domain3.com* should now redirect to their corresponding login screens.

To test this, refresh the current page of *www.domain2.com* and *www.domain3.com*. Instead of refreshing the page, the system will now redirect the requests to their login pages:

![CrossDomainSSOExample/Login2.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Login2.png)

![CrossDomainSSOExample/Login3.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/Login3.png) 

#### Traffic info

Same as login.

## Great... this seems to be working! How do I set up the sites?

The sample SSO implementation has been developed using Visual Studio 2010, .NET 4.0 Framework, and tested in IIS 7 under a Windows Vista machine. However, it doesn't use any 4.0 framework specific technology or class library and hence, it can be converted to use for a lower level framework without much effort, if required.

Follow these steps to set up the example SSO implementation in your machine:

- Download *SSO.zip* and extract to any convenient location in your PC. The following folders/files will be extracted within the folder "*SSO*":

- [![img](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/DirectoryStructure_small.png)](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/DirectoryStructure.png)

- Click on "*SSO.sln*" to open the solution in Visual Studio, to understand "Who is What" in the solution structure:

- ![CrossDomainSSOExample/SolutionExplorer.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/SolutionExplorer.png)

- As the names imply:

- - **C:\...\www.domain1.com** is the website for *www.domain1.com*
  - **C:\...\www.domain2.com** is the website for *www.domain2.com*
  - **C:\...\www.domain3.com** is the website for *www.domain3.com*
  - **C:\...\www.sso.com** is the web site for *www.sso.com*
  - **SSOLib** is a Class Library that handles all the Single Sign On related logic along with communicating with the SSO site via a Web Service, on behalf of the client sites.

- Type "**inetmgr**" in the Run command to launch the IIS Manager (alternatively, you can navigate to the IIS Manager from **Start->Program files**) and create a site there named "*www.domain1.com*":

- Right click on "*Sites*" and click on "*Add Web Site...*":

- ![CrossDomainSSOExample/AddNewSite.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/AddNewSite.png)

- Provide the necessary inputs in the following input form and click "OK":

- ![CrossDomainSSOExample/CreateSiteDomain1.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/CreateSiteDomain1.png)

- The site "*www.domain1.com*" will be created in IIS. After creating the site, the site might be shown with a red cross sign in IIS Explorer, indicating that the site is not started yet (this happens in my IIS in Windows Vista Home Premium). In this case, you need to select the site and click on the Restart icon to make sure it starts (the Restart icon is available in the right-middle portion of the screen in IIS Explorer).

- ![CrossDomainSSOExample/RestartSite.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/RestartSite.png)


- ![CrossDomainSSOExample/RestartSite.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/RestartSite.png)

- Following the same previous steps, create the following three sites pointing to their corresponding correct physical folder location:

- - *www.domain2.com*
  - *www.domain3.com*
  - *www.sso.com*

- ![CrossDomainSSOExample/CreateAllSites.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/CreateAllSites.png)

- Click on the "Application Pool" node in IIS Explorer. The application pool listing will be shown in the right pane, and you will see the application pools for the corresponding sites that you've just created in IIS.

- Make sure all application pools are running under .NET Framework 4.0 (as the web application has been built in Framework 4.0). To do that, right click on the corresponding application pools (that have the same names as the site names) and select the .NET Framework version in the form:

- ![CrossDomainSSOExample/ApplicationPool.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/ApplicationPool.png)

- Edit the Hosts file (*C:\Windows\System32\drivers\etc\hosts*) so that the site names are mapped to the localhost loopback address (*127.0.0.1*):


- Hide    Copy Code

- ```
  127.0.0.1       localhost
  127.0.0.1       www.domain1.com
  127.0.0.1       www.domain2.com
  127.0.0.1       www.domain3.com
  127.0.0.1       www.sso.com
  ```

If things are correctly done, you should be able to run the sites and test correctly as shown above. Otherwise, please verify if there is any thing missing or misconfigured by reviewing the steps from the start.

## OK, how do I implement SSO for my sites?

Good question. The sample SSO implementation works fine. But, as a developer, you would likely be more interested in how to implement SSO in your ASP.NET sites using the things developed. While implementing the SSO model, I tried to make a pluggable component (*SSOLib.dll*) so that it requires minimum programmatic change and configuration. Assuming that you have some existing ASP.NET applications, you need the following steps to implement "Single Sign On" across them:

- Add a reference to "*SSOLib.dll*", or add a reference to the "SSOLib" project to each ASP.NET application.

- Set up the SSO site (see previous steps).

- Configure your ASP.NET applications to use the SSO site. To do this, just add the following configurations in the *web.confing* of each ASP.NET application:

- Hide    Shrink ![img](https://www.codeproject.com/images/arrow-up-16.png)    Copy Code

- ```
  <!--Configuration section for SSOLib-->
   <configSections>
      <sectionGroup name="applicationSettings" 

           type="System.Configuration.ApplicationSettingsGroup, System, 
                 Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089">
       <section name="SSOLib.Properties.Settings" 

          type="System.Configuration.ClientSettingsSection, System, 
                Version=4.0.0.0, Culture=neutral, 
                PublicKeyToken=b77a5c561934e089" 

          requirePermission="false" />
      </sectionGroup>
   </configSections>
   <applicationSettings>
      <SSOLib.Properties.Settings>
       <setting name="SSOLib_Service_AuthService" serializeAs="String">
         <value>http://www.sso.com/AuthService.asmx</value>
       </setting>
      </SSOLib.Properties.Settings>
   </applicationSettings>
   <appSettings>
         <add key="SSO_SITE_URL" 

           value="http://www.sso.com/Authenticate.aspx?ReturnUrl={0}" />
         <add key="LOGIN_URL" value="~/Login.aspx" />
         <add key="DEFAULT_URL" value="~/Page.aspx" />
     </appSettings>
  <!--End Configuration section for SSOLib-->
  ```

- **Note**: Modify the configuration values according to the SSO site URL of your setup and your application specific needs.

- Modify the code-behind classes (**.aspx.cs*) of the login page and other private pages (pages which are accessible only to authenticated users) so that instead of extending `System.Web.UI.Page`, they will extend the `SSOLib.PrivatePage` class.

- In addition to existing codes that perform the log out functionality, call the `Logout()` method that is already available to the code-behind classes from the `SSOLib.PrivatePage` base class. Also, instead of executing existing login functionality, call the `Login()` method of `SSOLib.PrivatePage` and execute other post-login codes if they exist already.

That's it! You should be done with your SSO implementation.

## Hold on! My pages already extend a base class

OK, there is a high chance that you already have a base class which is extended by the code-behind classes in your ASP.NET applications. If that is so, integrating the `SSOLib.PrivatePage` may become even easier for you.

Let's say there is already a `BasePage` class which is extended by the code-behind classes of the authenticated page (pages which are accessible onto to the authenticated users) in one of your applications. In this case, instead of modifying the code-behind classes of all the ASPX pages, you might just need to modify the `BasePage` so that it extends `SSOLib.PrivatePage`, and you are done.

Hide    Copy Code

```
class BasePage : SSOLib.PrivatePage
{
    ...
}
```

Another alternative is to modify `SSOLib.PrivatePage` to extend the existing `BasePage` (you have the source code, you can do it) and modify all the existing *aspx.cs* classes of the authenticated pages to extend `SSOLib.PrivatePage` as suggested. That is:

Hide    Copy Code

```
class PrivatePage : BasePage 
{
    ...
}
```

If there is any conflicting code or method between the existing `BasePage` class and the `SSOLib.PrivatePage` class, you might need to modify some code in these two classes. It would be preferable not to change the code of `SSOLib.PrivatePage` unless any bug is discovered, and it would be better to change the existing `BasePage` code as required. But, feel free to change the code of `SSOLib.PrivatePage` if you really need to, it's all yours!

## Hmm.. so who does all the SSO things? Where is the magic?

Good question. In the ideal case, using this example SSO model, you won't have to write a single line of Sign On oriented code to implement SSO in your ASP.NET applications (except some configuration and inheritance changes). How is this possible? Who is managing all the dirty SSO stuff?

SSOLib and the SSO site are the two magicians doing all the tricks. SSOLib is a DLL which is used by each client site to carry out the following things:

- Communicate to SSO site via a Web Service.
- Redirect to the SSO site or login page or serve the requested page.

The following diagram depicts the role of SSOLib in the SSO model:

![CrossDomainSSOExample/SSOLib.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/SSOLib.png)

The most important thing inside SSOLib is the `PrivatePage` class which is inherited by the code-behind pages of the authenticated classes. This class inherits the `System.Web.UI.Page` class, and overrides the `OnLoad()` method, as follows:

```
public class PrivatePage : Page
{
      protected override void OnLoad(EventArgs e)
      {
           //Set caching preferences
           SetCachingPreferences();
                      
           //Read QueryString parameter values
           LoadParameters();

           if (IsPostBack)
           {
               //If this is a postback, do not redirect to SSO site.
               //Rather, hit a web method to the SSO site 
               //to know user's logged in status
               //and proceed based on the status
               HandlePostbackRequest();
               base.OnLoad(e);
               return;
           }

           //If the current request is marked not 
           //to be redirected to SSO site, do not proceed
           if (SessionAPI.RequestRedirectFlag == false)
           {
               SessionAPI.ClearRedirectFlag();
               base.OnLoad(e);
               return;
           }

           if (string.IsNullOrEmpty(RequestId))
           {
               //Absence of Request Paramter "RequestId" means 
               //current request is not redirected from SSO site.
               //So, redirect to SSO site with ReturnUrl
               RedirectToSSOSite();
               return;
           }
           else
           {
               //Current request is redirected from 
               //the SSO site. So, check user status
               //And redirect to appropriate page
               ValidateUserStatusAndRedirect();
           }

           base.OnLoad(e);
       }
}
```

Basically, `OnLoad()` is called whenever a `Page` object is loaded as a result of a URL hit in the browser, and the core SSO logic is implemented inside this method. All the codes is self descriptive and documented to depict what is going on.

More on the SSOLib functionality in the following sections.

## What does www.sso.com do?

The SSO site has the following two important functionalities:

- User authentication and user retrieval Web Services which are accessed by the client sites via the SSOLib DLL to authenticate the user and to know the user's logged-in status on the SSO site. The following services are available:

- ![CrossDomainSSOExample/SSOWebServices.png](https://www.codeproject.com/KB/aspnet/CrossDomainSSOExample/SSOWebServices.png)

- Setting and retrieving user authentication cookie using an ASPX page (*Authenticate.aspx*) which is redirected by SSOLib for setting / checking or removing the cookie based upon the type of request.

- Following is the core functionality that is performed by *Authenticate.aspx*. The codes is self-descriptive and documented for easy understandability.

- ```
  protected void Page_Load(object sender, EventArgs e)
  {
     //Read request paramters and populate variables
     LoadRequestParams();

     if (Utility.StringEquals(Action, AppConstants.ParamValues.LOGOUT))
     {
         //A Request paramter value Logout indicates
         //this is a request to log out the current user
         LogoutUser();
         return;
     }
     else
     {
         if (Token != null)
         {
             //Token is present in URL request. That means, 
             //user is authenticated at the client site 
             //using the Login screen and it redirected
             //to the SSO site with the Token in the URL parameter, 
             //so set the Authentication Cookie
             SetAuthCookie();
         }
         else
         {
             //User Token is not available in URL. So, check 
             //whether the authentication Cookie is available in the Request
             HttpCookie AuthCookie = 
                Request.Cookies[AppConstants.Cookie.AUTH_COOKIE];
             if (AuthCookie != null)
             {
                 //Authentication Cookie is available 
                 //in Request. So, check whether it is expired or not.
                 //and redirect to appropriate location based upon the cookie status
                 CheckCookie(AuthCookie, ReturnUrl);
             }
             else
             {
                 //Authentication Cookie is not available 
                 //in the Request. That means, user is logged out of the system
                 //So, mark user as being logged out
                 MarkUserLoggedOut();
             }
         }
     }
  }
  ```



## Looks pretty good. Did you have to handle any critical issues?

Another good question. The core SSO logic seems pretty straightforward. That is:

```
If current request is a PostBack, 
    If this is a PostBack in Login page (For Login)
        Do Nothing
    Else
        Do not redirect to SSO site. Rather, invoke a web service at SSO site 
        to know user's logged in status, using the User *Token. 
    If user is not logged out 
        Proceed the normal PostBack operation.
    Else 
        Redirect to login page
Else
    If current request is not redirected from the SSO Site, 
        Redirect it to SSO site with   setting ReturnUrl with 
        the current Request URL and parameters.
    Else
        Get user's Logged in status on SSO Site 
        by invoking a web service with user *Token

        If user is logged out there, 
            Redirect to Login page
        If current request is a page refresh, 
            Redirect to SSO site with ReturnUrl
        Else 
            Redirect to the originally requested URL
    End If
End If
```

*User token is a hash code of a GUID that identifies a user's login onto the SSO site uniquely. Each time a user is logged onto the SSO site, the token is generated at the SSO site, and this token`` is used later to set the authentication cookie and to retrieve the user object by the client sites.

But there are some obvious issues that were needed to be handled to implement the SSO logic. These are marked in bold in the above logic:

Implement "**Redirect to login page**" and "**Redirect to the originally requested URL**"

`SSOLib.PrivatePage` redirects to the SSO site, or redirects to the currently requested page at the client site, based upon the situation. But, there is a problem if `SSOLib.PrivatePage` redirects to a page of the current site. As each authenticated page extends the `SSOLib.PrivatePage` class, a redirect to a page in the current site from `SSOLib.PrivatePage` would redirect to itself again and again, and will cause an infinite redirect loop.

To solve this issue, an easy fix could be to add a request parameter (say, `Redirect=false`) to indicate that the request should not be redirected any further. But, this would allow the user to see the `Request` parameter and allow the user to "hack" the system by altering its value. So, instead of using a `Request` parameter, I used a Session variable to stop further redirection, before redirecting to any URL of the current site from `SSOLib.PrivatePage`. In `OnLoad``()`, I check the Session variable and reset it and return as follows:

```
//If the current request is marked not to be redirected to SSO site, do not proceed
if (SessionAPI.RequestRedirectFlag == false)
{
   SessionAPI.ClearRedirectFlag();
   return;
}
```

Detect whether "**Current request is not redirected from the SSO Site**", and whether "**current request is a page refresh**"

`SSOLib.PrivatePage` redirects to the SSO site for setting or checking the authentication cookie. After the SSO site is done with its work, it redirects back to the calling site using the URL that is set in `ReturnUrl`.

This also creates a scenario where the client site might again redirect to the SSO site and the SSO site again redirects to client site and creates an infinite redirection loop. Unlike the previous situation, this time, a Session variable could not be used because the redirection is occurring from the SSO site, and the client site and the SSO site have different Session states. So, a `Request` parameter value should be used to prevent further redirect to the SSO site once the SSO site redirects to the client site.

But again, using a `Request` parameter to prevent redirection would allow the user to alter it and break the normal functionality. To work-around this, the `Request` parameter value is set with a hash of a GUID `(RequestId=Hash(New GUID)`), and this is appended from the SSO site before redirecting back to the client-site URL.

The redirect request executes the `OnLoad()` method of `SSOLib.PrivatePage` again, and this time, it finds the `RequestId`, and this indicates that this request is redirected back from the SSO site and hence this should not be redirected to the SSO site further.

But, what if the user alters the value of the `RequestId` in the query string and hits the URL, or the user just refreshes the current page?

As each different request is to be redirected to the SSO site (except the postback hits), in this case, this request should be redirected to the SSO site as usual. But, the request URL already contains a `RequestId`, and despite this, the request should be redirected to the SSO site. So, how should `SSOLib.PrivatePage` understand this?

There is only one way. A specific `RequestId` should be valid for each particular redirect from the SSO site only, and once the `RequestId` is received at the client site from the `Request` parameter, it should expire instantly so that even if the next URL hit contains the same `RequstId`, or if the next URL contains an invalid value, it redirects to the SSO site.

The following logic has been used to handle this scenario:

```
if (string.IsNullOrEmpty(RequestId))
{
   //Absence of Request Paramter RequestId means current 
   //request is not redirected from SSO site.
   //So, redirect to SSO site with ReturnUrl
   RedirectToSSOSite();
   return;
}
else
{
   //Current request is redirected from the SSO site. So, check user status
   //And redirect to appropriate page
   ValidateUserStatusAndRedirect();
}

//And,

UserStatus userStatus = AuthUtil.Instance.GetUserStauts(Token, RequestId);
if (!userStatus.UserLoggedIn)
{
   //User is not logged in at SSO site. So, return the Login page to user
   RedirectToLoginPage();
   return;
}
if (!userStatus.RequestIdValid)
{
   //Current RequestId is not valid. That means, 
   //this is a page refresh and hence, redirect to SSO site
   RedirectToSSOSite();
   return;
}
if (CurrentUser == null || CurrentUser.Token != Token)
{
   //Retrieve the user if the user is not found 
   //in session, or, the current user in session
   //is not the one who is currently logged onto the SSO site
   CurrentUser = AuthUtil.Instance.GetUserByToken(Token);
   if (CurrentUser.Token != Token || CurrentUser == null)
   {
       RedirectToSSOSite();
       return;
   }
}
```

On the other hand, before redirecting to the client site, the SSO site generates a `RequestId`, appends it with the query string, and puts it in `Application` using the `RequestId` as the key and value. Following is how the SSO site redirects back to the client site:

```
/// <summary>
/// Append a request ID to the URl and redirect
/// </summary>
/// <param name="Url"></param>
private void Redirect(string Url)
{
    //Generate a new RequestId and append to the Response URL.
    //This is requred so that, the client site can always
    //determine whether the RequestId is originated from the SSO site or not
    string RequestId = Utility.GetGuidHash();
    string redirectUrl = Utility.GetAppendedQueryString(Url, 
              AppConstants.UrlParams.REQUEST_ID, RequestId);
    
    //Save the RequestId in the Application
    Application[RequestId] = RequestId;

    Response.Redirect(redirectUrl);
}
```

Note that, before redirection, `RequestId` is stored in the `Application` scope to mark that this `RequestId` is valid for this particular response to the client site. Once the client site receives the redirected request, it executes the `GetUserStatus()` Web Service method, and following is how the `GetUserStatus()` web method clears the `RequestId` from the `Application` scope so that any subsequent requests with the same `RequestId` or any request with an invalid `RequestId` can be tracked as an invalid `RequestId`:

```
/// <summary>
/// Determines whether the current request is valid or not
/// </summary>
/// <param name="RedirectId"></param>
/// <returns></returns>
[WebMethod]
public UserStatus GetUserStauts(string Token, string RequestId)
{
      UserStatus userStatus = new UserStatus();

      if (!string.IsNullOrEmpty(RequestId))
      {
          if ((string)Application[RequestId] == RequestId)

          {
              Application[RequestId] = null;
              userStatus.RequestIdValid = true;
          }
      }

      userStatus.UserLoggedIn = 
        HttpContext.Current.Application[Token] == null ? false : true;

      return userStatus;
}
```

## Get user's logged in status on the SSO site

The `GetUserStauts()` Web Service method returns the user's status inside a `UserStatus` object, which has two properties: `UserLoggedIn` and `RequestIdValid`.

Once a user is logged onto the SSO site via the `Authenticate` Web Service method, it generates a User Token (hash code of a new GUID) and stores the user Token`` inside an `Application` variable using the Token as the Key:

```
/// <summary>
/// Authenticates user by UserName and Password
/// </summary>
/// <param name="UserName"></param>
/// <param name="Password"></param>
/// <returns></returns>
[WebMethod]
public WebUser Authenticate(string UserName, string Password)
{
   WebUser user = UserManager.AuthenticateUser(UserName, Password);
   if (user != null)
   {
       //Store the user object in the Application scope, 
       //to mark the user as logged onto the SSO site
       //Along with the cookie, this is a supportive way 
       //to trak user's logged in status
       //In order to track a user as logged onto the SSO site 
       //user token has to be presented in the cookie as well as
       //he/she has to be presented in teh Application scope
       HttpContext.Current.Application[user.Token] = user;
   }
   return user;
}
```

When the user logs out of the system from any client site, the authentication cookie is removed, and also the user object is removed from the `Application` scope (inside *Authenticate.aspx.cs* in the SSO site):

When the user logs out of the system from any client site, the authentication cookie is removed, and also the user object is removed from the `Application` scope (inside *Authenticate.aspx.cs* in the SSO site):

```
/// <summary>
/// Logs out current user;
/// </summary>
private void LogoutUser()
{
   //This is a logout request. So, remove the authentication Cookie from the response
   if (Token != null)
   {
       HttpCookie Cookie = Request.Cookies[AppConstants.Cookie.AUTH_COOKIE];

       if (Cookie.Value == Token)
       {
           RemoveCookie(Cookie);
       }
   }
   //Also, mark the user at the application scope as null
   Application[Token] = null;

   //Redirect user to the desired location
   //ReturnUrl = GetAppendedQueryString(ReturnUrl, 
   //   AppConstants.UrlParams.ACTION, AppConstants.ParamValues.LOGOUT);
   Redirect(ReturnUrl);
}
```

So, without redirecting to the SSO site, it is possible to know the user's logged in status just by checking the user's presence in the `Application` scope of the SSO site. The client sites invoke the Web Service method of the SSO site, and the SSO site returns the user's logged in status inside the `UserStatus` object.

This method of knowing the user's logged in status is handy because when a postback occurs, the client sites would not want to redirect to the SSO site (because, if they do that, the postback event methods cannot be executed).

In such cases, they invoke the web method to know the user's logged in status, and if the user is not available at the SSO site, the current request is redirected to the login page. Otherwise, the normal postback event method is executed.

## Wait a minute, storing the user in the Application scope should mark the user logged in for all sessions. How do you handle that?

True. Once a user is authenticated, he/she is stored in the `Application` scope to mark as logged in. But, the `Application` scope is a global scope irrespective of the site and user sessions. So, there is a risk that the user might also get marked as logged in for all browser sessions.

This sounds risky. But, this is handled with care so that the user object of a particular browser session is not available to other browser sessions. Let us now see how this has been handled.

Once a user logs onto the SSO site, the user is stored in the `Application`scope against the user `Token`, which is valid only for a particular user Login session.

If some direct request is hit in a new window (hence with a new `Session`) with the user Token (with or without the `RequestId`) by copying the URL from the address bar, the system will not let the URL request bypass the login screen. Why? Because the authentication cookie that is set by the SSO site is a "non-persistent" cookie, and hence this cookie is sent by the browser to the SSO site only if subsequent requests are hit in the same browser session (from the same browser window or different tabs in the same window). That means, if a new browser window is opened, it does not have any authentication cookie to send to the SSO site, and naturally, the request is redirected to the login page of the client site. So, even if a user is stored in the `Application` scope in the SSO site, that user object is stored against a different user Token as a key, that can never be accessed for any new request in the new session, because this request does not know about the existing user Token, and once the user logs onto this new browser session, it gets a new user Token which never matches with the existing ones.

## How cookie timeout and sliding expiration is maintained?

The *web.config* of the SSO site has configuration options for configuring the cookie timeout value and for enabling/disabling the sliding expiration of the cookie.

The *web.config* of the SSO site has configuration options for configuring the cookie timeout value and for enabling/disabling the sliding expiration of the cookie.

```
<appSettings>
    <add key="AUTH_COOKIE_TIMEOUT_IN_MINUTES" value="30"/>
    <add key="SLIDING_EXPIRATION" value="true"/>
</appSettings>
```

The cookie timeout value can be configured in the *web.config* of the SSO site and the timeout value applies to all client sites under the SSO. That is, if the cookie timeout value is specified in the *web.config* as 30 minutes and if *user1* logs onto *www.domain1.com*, the cookie is available for the next 30 minutes in the browser, and hence *user1* is signed on the other two sites for this 30 minutes, unless *user1* is logged out of the site.

Now, how is this cookie timeout implemented? Simple, by setting the cookie expiration time, of course.

Unfortunately, I couldn't do that. Why? Because, by default, when a cookie is set in the `Response`, it is created as a non-persistent cookie (the cookie is stored only in the browser's memory for the current session, not in the client's disk). If the expiry date is specified for the cookie, ASP.NET runtime automatically instructs the browser to store the cookie as a persistent cookie.

In our case, we don't want to create a persistent cookie, because this will let the other sessions to also send the authentication cookie to the SSO site and eventually mark the user as logged in. We do not want that to happen.

But, the expiration datetime has to be set somehow. So, I stored the expiration value in the cookie's value, along with appending to the user's Token, as follows:

```
/// <summary>
/// Set authentication cookie in Response
/// </summary>
private void SetAuthCookie()
{
   HttpCookie AuthCookie = new HttpCookie(AppConstants.Cookie.AUTH_COOKIE);

   //Set the Cookie's value with Expiry time and Token
   int CookieTimeoutInMinutes = Config.AUTH_COOKIE_TIMEOUT_IN_MINUTES;

   AuthCookie.Value = Utility.BuildCookueValue(Token, CookieTimeoutInMinutes);
   //Appens the Token and expiration DateTime to build cookie value

   Response.Cookies.Add(AuthCookie);

   //Redirect to the original site request
   ReturnUrl = Utility.GetAppendedQueryString(ReturnUrl, 
                        AppConstants.UrlParams.TOKEN, Token);
   Redirect(ReturnUrl);
}

/// <summary>
/// Set cookie value using the token and the expiry date
/// </summary>
/// <param name="Value"></param>
/// <param name="Minutes"></param>
/// <returns></returns>
public static string BuildCookueValue(string Value, int Minutes)
{
    return string.Format("{0}|{1}", Value, 
       DateTime.Now.AddMinutes(Minutes).ToString());
}
```

Eventually, when the cookie is received at the SSO site, its value is retrieved as follows:

```
/// <summary>
/// Reads cookie value from the cookie
/// </summary>
/// <param name="cookie"></param>
/// <returns></returns>
public static string GetCookieValue(HttpCookie Cookie)
{
   if (string.IsNullOrEmpty(Cookie.Value))
   {
       return Cookie.Value;
   }
   return Cookie.Value.Substring(0, Cookie.Value.IndexOf("|"));
}
```

And, the expiration date time is retrieved as follows:

```
/// <summary>
/// Get cookie expiry date that was set in the cookie value
/// </summary>
/// <param name="cookie"></param>
/// <returns></returns>
public static DateTime GetExpirationDate(HttpCookie Cookie)
{
   if (string.IsNullOrEmpty(Cookie.Value))
   {
       return DateTime.MinValue;
   }
   string strDateTime = 
     Cookie.Value.Substring(Cookie.Value.IndexOf("|") + 1);
   return Convert.ToDateTime(strDateTime);
}
```

If `SLIDING_EXPIRATION` is set to `true` in the *web.config*, the cookie expiration date-time value is increased with each request, with the minute value specified in `AUTH_COOKIE_TIMEOUT_IN_MINUTES` in the *web.config*. The following code does that:

```
/// <summary>
/// Increases Cookie expiry time
/// </summary>
/// <param name="AuthCookie"></param>
/// <returns></returns>
private HttpCookie IncreaseCookieExpiryTime(HttpCookie AuthCookie)
{
   string Token = Utility.GetCookieValue(AuthCookie);
   DateTime Expirytime = Utility.GetExpirationDate(AuthCookie);
   DateTime IncreasedExpirytime = 
     Expirytime.AddMinutes(Config.AUTH_COOKIE_TIMEOUT_IN_MINUTES);

   Response.Cookies.Remove(AuthCookie.Name);

   HttpCookie NewCookie = new HttpCookie(AuthCookie.Name);
   NewCookie.Value = 
     Utility.BuildCookueValue(Token, Config.AUTH_COOKIE_TIMEOUT_IN_MINUTES);

   Response.Cookies.Add(NewCookie);

   return NewCookie;
}
```

## Can this implementation be used for production systems?

Yes! It surely can be used, **but before that, some security and other cross-cutting issues have to be addressed**. This is just a basic implementation, and I didn't verify the model with a professional Quality Assurance process (though I did some basic acceptance testing myself). Also, this authentication does not offer the full flexibility and powers that Forms authentication provides. Additionally, it does not have the built-in authorization mechanism of Forms authentication, and hence you might need to write some more customization on the current SSO implementation, based upon your specific requirements.

However, I'll try to update the SSO model to enrich it with more features and make it robust so that this could be used in commercial systems without requiring any customization.

Any suggestion or feedback is highly welcome. Adios!

## License

​						

This article, along with any associated source code and files, is licensed under [The Code Project Open License (CPOL)](http://www.codeproject.com/info/cpol10.aspx)