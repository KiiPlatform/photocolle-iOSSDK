#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DCEnumerations.h"

@class DCAuthenticationContext;

/*!
 * The callback for receiving a result of authenticate.
 *
 * @param context Authentication context. @link DCAuthenticationContext @/link .
 * @param error If an error occurs, upon returns contains an
 * NSError object that describes the problem. nil can be
 * passed but not recommended to handle errors property.
 */
typedef void (^DCAuthenticateBlock)(
        DCAuthenticationContext *context,
        NSError *error);

/*!
  Execute authentication.

  The authority provides interfaces to authenticate with server
  according to OAuth.
  Use the methods declared here to authenticate with server and to
  get DCAuthenticationContext object.
 */
@interface DCAuthority : NSObject

/*!
  Invoke authentication process to get DCAuthenticationContext object.

  Access token is saved with specified storeKey. If valid access token
  is stored with specified storedKey, this method skips authentication
  and uses stored access token. Otherwise this method authenticate
  with PhotoColle network by OAuth2.0. After success of
  authentication, PhotoColleSDK saves retrieved access token with
  specified storeKey.

  PhotoColleSDK refreshes access token if the stored token is going to
  be expired. Calling this method or method in DCPhotoColle requires
  authentication triggers refresh token. After the refresh token
  succeeded, stored token will be overwritten with the storeKey given
  to this method.

  If refresh token fails in this method, this method start to
  authenticate with PhotoColle network.

  If refresh token fails in the method of DCPhotoColle, PhotoColleSDK
  removes stored access token bound to specified storeKey.

  Applications must request permissions with scopes. Applications must
  send at least one scope to docomo authentication server.

  The callback block is called when receiving a result of authenticate.

       NSArray *scopes = @[
                   [DCScope photoGetContentsList],
                   [DCScope photoGetContent],
                   [DCScope photoUploadContent],
                   [DCScope photoGetVacantSize],
                   [DCScope photoUpdateRotateInfo],
                   [DCScope photoUpdateTrashInfo],
                   [DCScope photoGetGroupInfo],
                   [DCScope phonebookAllowedFriendsBidirectional],
                   [DCScope phonebookPostFeed],
                   [DCScope phonebookAddContact],
                   [DCScope databoxAll],
                   [DCScope userid]
              ];

       [DCAuthority authenticateOnNavigationController:controller
                                          withClientId:CLIENT_ID
                                          clientSecret:CLIENT_SECRET
                                           redirectUri:REDIRECT_URI
                                              storeKey:STORE_KEY
                                                scopes:scopes
                                                 block:^(DCAuthenticationContext *context, NSError *error) {
           if (error != nil) {
               // check error.
           } else {
               // use context.
           }
       }];

#### Errors notified by DCAuthenticateBlock

##### Error domains

  This DCAuthenticateBlock notifies NSError at error
  situation. Domains notified by this DCAuthenticateBlock are
  followings:

  Domain name                         | Explanation
  ------------------------------------|----------------------------------------
  DCAuthenticationErrorDomain         | this error is raised when authentication is failed.
  DCAuthenticationCanceledErrorDomain | This error is raised when authentication is canceled by user.

##### Error codes

  DCAuthenticationErrorDomain has error code to show detail of the
  error. Type of error code is DCAuthenticationErrorReason.

##### User information

  DCAuthenticationErrorDomain and DCAuthenticationCanceledErrorDomain
  does not have userInfo.

  @param controller UINavidationController.
  @param clientId The client key string which is issued for your
  service. must not be nil or empty.
  @param clientSecret The client secret string which is issued for
  your service. must not be nil or empty
  @param redirectUri The redirect URI which you registered. must not
  be nil or empty.
  @param scopes Scopes to request permissions to docomo authentication
  server. must not be nil or empty. Elements of this array must be
  NSString. Elements of this array must not be nil or
  empty. Applications can get scopes defined in a specification of
  docomo Developer support version 2.0.0 with class methods in
  DCScope. Applications also use scopes defined after a specification
  of docomo Developer support version 2.0.0 by appending scope string
  defined in a newer specification to this array. Even if applications
  set same scope strings into this array, PhotoColleSDK sends only one
  scope and ignore other same scopes.
  @param storeKey A key to save and load DCAuthenticationContext
  automatically. If nil or empty, automatic saving and loading does
  not occur.
  @param accessibility Accessibility of saved authentication. Detail
  of accessibility are described at [DCAuthenticationContext
  saveByKey:accessibility:error:]. If storeKey is not nil or empty,
  accessibility must not be NULL. Otherwise, accessibility is ignored
  and can be NULL. If storeKey is nil or empty, PhotoColleSDK does not
  save access token automatically, so accessibility is not required.
  @param block The callback for receiving a result of authentication
  process.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
+ (void)authenticateOnNavigationController:(UINavigationController *)controller
                              withClientId:(NSString *)clientId
                              clientSecret:(NSString *)clientSecret
                               redirectUri:(NSString *)redirectUri
                                    scopes:(NSArray *)scopes
                                  storeKey:(NSString *)storeKey
                             accessibility:(CFTypeRef)accessibility
                                     block:(DCAuthenticateBlock)block;

/**
   Invoke refresh token process to update AuthenticationContext
   object.

   This method refreshes access token with PhotoColle network by
   OAuth2.0. If refresh token process succeed and automatic saving is
   enabled on authenticationContext, then updated
   authenticationContext is saved
   automatically. DCAuthenticationContext satisfying one or more
   following conditions is automatic saving enabled.

   * DCAuthenticationContext created by <[DCAuthority authenticateOnNavigationController:withClientId:clientSecret:redirectUri:scopes:storeKey:accessibility:block:]> with valid storeKey.
   * DCAuthenticationContext loaded by <[DCAuthenticationContext loadByKey:clientId:clientSecret:error:]>
   * DCAuthenticationContext saved by <[DCAuthenticationContext saveByKey:accessibility:error:]>

   You can check remaining time of access token by
   <[DCAuthenticationContext remainingTimeInSeconds]>.

   @param authenticationContext the authentication context to be
   updated. must not be nil. authenticationContext loaded by
   <[DCAuthenticationContext loadByKey:error:]> can not be refreshed.
   @param block The callback for receiving a result of authentication
   process. must not be nil.
   @exception NSInvalidArgumentException One or more arguments are invalid.
 */
+ (void)refreshTokenWithAuthenticationContext:(DCAuthenticationContext *)authenticationContext
                                        block:(DCAuthenticateBlock)block;

@end
