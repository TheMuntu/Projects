[](#Identity-and-Access-Management-IAM---1 "Identity-and-Access-Management-IAM---1")Identity and Access Management (IAM)
========================================================================================================================

#### [](#AS-Lab-Assignment "AS-Lab-Assignment")Lab 6 Assignment

[](#Intro "Intro")Intro
-----------------------

In this assignment, you will get familiar with modern Identity and Access Management systems. An example of such a system is Keycloak.  
Keycloak is a feature-rich solution that utilizes standard well-known protocols such as OAuth 2.0, OIDC (OpenID Connect) and UMA (User-Managed Access).  
What makes it special and loved by companies is that it is open-source and self-hosted.

During the assignment you will install your own instance of Keycloak and take a look at the features it can provide on a simple sample application.  
It will demonstrate what IMA systems can do and you will get familiar with the underlying standards.

Submission requirements:

*   Report should contain:
    *   a detailed log of your actions backed-up with screenshots
    *   answers for questions in your **own** words (with concrete explanation on your particular setup if needed)

[](#Preparation "Preparation")Preparation
-----------------------------------------

*   Setup Keycloak
    
    *   Install keycloak using docker image [https://www.keycloak.org/getting-started/getting-started-docker](https://www.keycloak.org/getting-started/getting-started-docker)
        
        *   To run the container use the following command:
        
         ```
        docker run -p 8081:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:17.0.1 start-dev -Dkeycloak.profile.feature.upload_scripts=enabled
         ```
        
    *   Make your hostname `sso` point to 127.0.0.1, that will be used to access keycloak services (basicaly it is aliasing localhost. Your IP stays the same but the browsers will treat it as a separate domain - this is important for cookies)
    *   Access keycloak at `sso:8081`
    *   Create realm named `as_lab`
    *   Create sample user in this realm
*   Launch the sample app attached to this asignment. The installation instructions are inside `iam-lab.zip`
    

### [](#Authentication-and-Single-Sign-On "Authentication-and-Single-Sign-On")Authentication and Single-Sign On

For this task you will use 2 parts of the app:

*   `app-pokemon` - browser-side single page application that displays pokemon data.
    
    *   It is located at `http://localhost:3068/pokemon/:pokemon-name`
*   `app-trainer` - browser-side single page application that displays trainer pokemon decks.
    
    *   It is located at `http://localhost:3068/trainer`

In this task you need to achieve Single-Sign-On support for those 2 apps.

Applications are already pre-configured to work with Keycloak,  
but you need to deploy configuration on the Keycloak side.

Applications are using Keycloak JS adapter that follows OpenID Connect protocol.

Keycloak configs on the app side are located inside `public` directory (you do not need to edit them):  
`keycloak-pokemon.json` and `keycloak-trainer.json`

#### [](#1-Before-you-begin-you-must-get-familiar-with-terminology-and-concepts-of-OAuth-20-and-OpenID-Connect "1-Before-you-begin-you-must-get-familiar-with-terminology-and-concepts-of-OAuth-20-and-OpenID-Connect")1\. Before you begin you must get familiar with terminology and concepts of OAuth 2.0 and OpenID Connect.

*   a) What is `client`?
*   b) What `client` types exist?
*   c) What authentication flows exist?
*   d) Why is Authorization Code Flow preferred over the others?
*   e) What is Single-Sign On (SSO)?
*   f) What is the difference between OAuth 2.0 and OpenID Connect?

Here is a number of materials for reference:

*   [https://www.keycloak.org/docs/latest/server\_admin/#sso-protocols](https://www.keycloak.org/docs/latest/server_admin/#sso-protocols)
*   [https://connect2id.com/learn/openid-connect](https://connect2id.com/learn/openid-connect)
*   [https://developer.okta.com/blog/2017/07/25/oidc-primer-part-1](https://developer.okta.com/blog/2017/07/25/oidc-primer-part-1)
*   [https://datatracker.ietf.org/doc/html/rfc6749](https://datatracker.ietf.org/doc/html/rfc6749)
*   [https://datatracker.ietf.org/doc/html/rfc6750](https://datatracker.ietf.org/doc/html/rfc6750)
*   [https://openid.net/specs/openid-connect-core-1\_0.html](https://openid.net/specs/openid-connect-core-1_0.html)

#### [](#2-Setup-authentication "2-Setup-authentication")2\. Setup authentication

Сreate corresponding client for `app-pokemon` and show that you login is successful.  
Then create corresponding client for `app-trainer` and show that SSO works.

#### [](#3-Analyze-SSO-workflow "3-Analyze-SSO-workflow")3\. Analyze SSO workflow.

Take a look at full-login process and auto-login process in the network tab of browser devtools and describe what is happening. _Use “Preserve log” to prevent resetting on redirects_

*   a) What authentication flow is used?
*   b) What is the difference between id\_token and access\_token?
*   c) What is purpose of refresh\_token?
*   d) How is the session persisted? What will happen if you use incognito mode or another browser?

### [](#Resource-access-with-role-based-authorization "Resource-access-with-role-based-authorization")Resource access with role-based authorization

For this task you will use 2 parts of the app:

*   `app-pokemon` - browser-side single page application that displays pokemon data.
    *   It is located at `http://localhost:3068/pokemon/:pokemon-name`
*   `api-pokemon` - API that provides pokemon data.
    *   `GET http://localhost:3068/api/pokemon/:name` - get pokemon data - only users with `readonly` role allowed
    *   `PUT http://localhost:3068/api/pokemon/:name` - set pokemon date - only users with `editor` role allowed

#### [](#4-Enabling-authorization "4-Enabling-authorization")4\. Enabling authorization

In this part you will setup simple role-based authorization.

**4.1** Keycloak issues access tokens in JWT format. The advantage of JWT token is that all information that is required to make a decision about authorization can be extracted and verified from it.

*   a) What is the format of JWT token? How can you decode it, is there any standard tools?
*   b) How is JWT token issued and verified?
*   b) What is `claim` and what is `scope`?
*   c) What is `aud` claim?

**4.4** Verification in the application

Look at how the `api-pokemon` makes authorization decision and list the critical claims that are required for positive decision.  
File: `server/verify-access.ts`

**4.5** Create corresponding clients and add roles

Make changes to Keycloak such that correct required claims are included into access token.  
Show that `app-pokemon` successfully works.

Note that for `app-pokemon` you already have associated client in Keycloak. Also Keycloak provides a special `bearer-only` type of client - it is for services that do not initiate user login.

Also, for debugging purposes Keycloak’s Admin console provides Evaluation tool that shows you what is included inside access token.

For valid JWT verification do not forget to replace hardcoded cert (in `server/verify-access.ts`) with the cert of your realm.

*   a) What are realm roles and client roles in Keycloak?
*   b) What is a composite role?
*   c) How does browser-side app `app-pokemon` understand that form input should be enabled/disabled?
