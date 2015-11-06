/* Copyright (c) 2011 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* 2013 Kii corp.
 *
 * Prefixes are changed from GTM to DCGTM.
 *
 * Targets of changing prefix are all classes, protocols, extensions,
 * categoriesconst values, comments and etc.
 */

//
// This sign-in object opens and closes the web view window as needed for
// users to sign in. For signing in to Google, it also obtains
// the authenticated user's email address.
//
// Typically, this will be managed for the application by
// DCGTMOAuth2ViewControllerTouch or DCGTMOAuth2WindowController, so this
// class's interface is interesting only if
// you are creating your own window controller for sign-in.
//
//
// Delegate methods implemented by the window controller
//
// The window controller implements two methods for use by the sign-in object,
// the webRequestSelector and the finishedSelector:
//
// webRequestSelector has a signature matching
//   - (void)signIn:(DCGTMOAuth2SignIn *)signIn displayRequest:(NSURLRequest *)request
//
// The web request selector will be invoked with a request to be displayed, or
// nil to close the window when the final callback request has been encountered.
//
//
// finishedSelector has a signature matching
//  - (void)signin:(DCGTMOAuth2SignIn *)signin finishedWithAuth:(DCGTMOAuth2Authentication *)auth error:(NSError *)error
//
// The finished selector will be invoked when sign-in has completed, except
// when explicitly canceled by calling cancelSigningIn
//

#if DCGTM_INCLUDE_OAUTH2 || !GDATA_REQUIRE_SERVICE_INCLUDES

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

// DCGTMHTTPFetcher brings in GTLDefines/GDataDefines
#import "GTMHTTPFetcher.h"

#import "GTMOAuth2Authentication.h"

@interface DCGTMOAuth2SignIn : NSObject {
 @private
  DCGTMOAuth2Authentication *auth_;

  // the endpoint for displaying the sign-in page
  NSURL *authorizationURL_;
  NSDictionary *additionalAuthorizationParameters_;

  id delegate_;
  SEL webRequestSelector_;
  SEL finishedSelector_;

  BOOL hasHandledCallback_;

  DCGTMHTTPFetcher *pendingFetcher_;

#if !DCGTM_OAUTH2_SKIP_GOOGLE_SUPPORT
  BOOL shouldFetchGoogleUserEmail_;
  BOOL shouldFetchGoogleUserProfile_;
  NSDictionary *userProfile_;
#endif

  SCNetworkReachabilityRef reachabilityRef_;
  NSTimer *networkLossTimer_;
  NSTimeInterval networkLossTimeoutInterval_;
  BOOL hasNotifiedNetworkLoss_;

  id userData_;
}

@property (nonatomic, retain) DCGTMOAuth2Authentication *authentication;

@property (nonatomic, retain) NSURL *authorizationURL;
@property (nonatomic, retain) NSDictionary *additionalAuthorizationParameters;

// The delegate is released when signing in finishes or is cancelled
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) SEL webRequestSelector;
@property (nonatomic, assign) SEL finishedSelector;

@property (nonatomic, retain) id userData;

// By default, signing in to Google will fetch the user's email, but will not
// fetch the user's profile.
//
// The email is saved in the auth object.
// The profile is available immediately after sign-in.
#if !DCGTM_OAUTH2_SKIP_GOOGLE_SUPPORT
@property (nonatomic, assign) BOOL shouldFetchGoogleUserEmail;
@property (nonatomic, assign) BOOL shouldFetchGoogleUserProfile;
@property (nonatomic, retain, readonly) NSDictionary *userProfile;
#endif

// The default timeout for an unreachable network during display of the
// sign-in page is 30 seconds; set this to 0 to have no timeout
@property (nonatomic, assign) NSTimeInterval networkLossTimeoutInterval;

// The delegate is retained until sign-in has completed or been canceled
//
// designated initializer
- (id)initWithAuthentication:(DCGTMOAuth2Authentication *)auth
            authorizationURL:(NSURL *)authorizationURL
                    delegate:(id)delegate
          webRequestSelector:(SEL)webRequestSelector
            finishedSelector:(SEL)finishedSelector;

// A default authentication object for signing in to Google services
#if !DCGTM_OAUTH2_SKIP_GOOGLE_SUPPORT
+ (DCGTMOAuth2Authentication *)standardGoogleAuthenticationForScope:(NSString *)scope
                                                         clientID:(NSString *)clientID
                                                     clientSecret:(NSString *)clientSecret;
#endif

#pragma mark Methods used by the Window Controller

// Start the sequence of fetches and sign-in window display for sign-in
- (BOOL)startSigningIn;

// Stop any pending fetches, and close the window (but don't call the
// delegate's finishedSelector)
- (void)cancelSigningIn;

// Window controllers must tell the sign-in object about any redirect
// requested by the web view, and any changes in the webview window title
//
// If these return YES then the event was handled by the
// sign-in object (typically by closing the window) and should be ignored by
// the window controller's web view

- (BOOL)requestRedirectedToRequest:(NSURLRequest *)redirectedRequest;
- (BOOL)titleChanged:(NSString *)title;
- (BOOL)cookiesChanged:(NSHTTPCookieStorage *)cookieStorage;
- (BOOL)loadFailedWithError:(NSError *)error;

// Window controllers must tell the sign-in object if the window was closed
// prematurely by the user (but not by the sign-in object); this calls the
// delegate's finishedSelector
- (void)windowWasClosed;

// Start the sequences for signing in with an authorization code. The
// authentication must contain an authorization code, otherwise the process
// will fail.
- (void)authCodeObtained;

#pragma mark -

#if !DCGTM_OAUTH2_SKIP_GOOGLE_SUPPORT
// Revocation of an authorized token from Google
+ (void)revokeTokenForGoogleAuthentication:(DCGTMOAuth2Authentication *)auth;

// Create a fetcher for obtaining the user's Google email address or profile,
// according to the current auth scopes.
//
// The auth object must have been created with appropriate scopes.
//
// The fetcher's response data can be parsed with NSJSONSerialization.
+ (DCGTMHTTPFetcher *)userInfoFetcherWithAuth:(DCGTMOAuth2Authentication *)auth;
#endif

#pragma mark -

// Standard authentication values
+ (NSString *)nativeClientRedirectURI;
#if !DCGTM_OAUTH2_SKIP_GOOGLE_SUPPORT
+ (NSURL *)googleAuthorizationURL;
+ (NSURL *)googleTokenURL;
+ (NSURL *)googleUserInfoURL;
#endif

@end

#endif // #if DCGTM_INCLUDE_OAUTH2 || !GDATA_REQUIRE_SERVICE_INCLUDES
