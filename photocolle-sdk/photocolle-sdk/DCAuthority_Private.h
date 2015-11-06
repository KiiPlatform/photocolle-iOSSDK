#import "DCAuthority.h"

@class DCGTMOAuth2Authentication;
@class DCGTMOAuth2ViewControllerTouch;

/**
   Return value of tryToRefresh: method.
*/
typedef NS_ENUM(NSInteger, DCRefreshResult) {
    /** token is not expired, so no need to refresh. */
    DCREFRESHRESULT_NOTEXPIRED = 0,

    /** token is refreshed. */
    DCREFRESHRESULT_REFRESHED = 1,

    /** can not refresh this token. */
    DCREFRESHRESULT_CANTREFRESH = 2,

    /** refresh token is failed. */
    DCREFRESHRESULT_FAIL = 3
};

@interface DCAuthority ()

+ (void)
    authenticateInnerOnNavigationController:(UINavigationController *)controller
                               withClientId:(NSString *)clientId
                               clientSecret:(NSString *)clientSecret
                                redirectUri:(NSString *)redirectUri
                                     scopes:(NSArray *)scopes
                                   storeKey:(NSString *)storeKey
                              accessibility:(CFTypeRef)accessibility
                                      block:(DCAuthenticateBlock)block;
+ (DCGTMOAuth2ViewControllerTouch*)
         OAuth2ViewControllerTouchWithAuthentication:(DCGTMOAuth2Authentication*)authentication
                                            storeKey:(NSString *)storeKey
                                       accessibility:(CFTypeRef)accessibility
                                               block:(DCAuthenticateBlock)block;
+ (NSURL *)authorizationURL;
+ (DCGTMOAuth2Authentication*)
        authenticationWithClientId:(NSString *)clientId
                      clientSecret:(NSString *)clientSecret
                       redirectUri:(NSString *)redirectUri
                            scopes:(NSArray *)scopes
                     accessibility:(CFTypeRef)accessibility;
+ (NSURL *)tokenURL;
+ (BOOL)isValidScopes:(NSArray *)scopes;
+ (NSString *)toScopeString:(NSArray *)scopes;
+ (DCRefreshResult)tryToRefresh:(DCAuthenticationContext *)context;
+ (DCRefreshResult)tryToRefresh:(DCAuthenticationContext *)context
                          error:(NSError **)error;
+ (NSString *)serviceProviderName;

@end
