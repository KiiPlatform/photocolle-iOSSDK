#import "DCAuthority.h"
#import "DCAuthority_Private.h"
#import "DCAuthenticationContext_Private.h"
#import "DCEnumerationsUtils.h"
#import "DCMiscUtils.h"
#import "DCExceptionUtils.h"
#import "DCOAuth2ViewController.h"
#import "DCErrorUtils.h"
#import "DCOAuth2Authentication.h"
#import "DCHTTPFetcherService.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2SignIn.h"

static NSString * const SERVICE_NAME = @"PhotoColle Service";
static NSString * const DEFAULT_AUTHORIZATION_URL =
    @"https://api.smt.docomo.ne.jp";
static NSString * const DEFAULT_TOKEN_URL =
    @"https://api.smt.docomo.ne.jp";

@implementation DCAuthority

+ (void)authenticateOnNavigationController:(UINavigationController *)controller
                              withClientId:(NSString *)clientId
                              clientSecret:(NSString *)clientSecret
                               redirectUri:(NSString *)redirectUri
                                    scopes:(NSArray *)scopes
                                  storeKey:(NSString *)storeKey
                             accessibility:(CFTypeRef)accessibility
                                     block:(DCAuthenticateBlock)block
{
    if (controller == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"controller must not be nil."];
    } else if (clientId == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"clientId must not be nil."];
    } else if ([clientId length] <= 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"clientId must not be empty."];
    } else if (clientSecret == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"clientSecret must not be nil."];
    } else if ([clientSecret length] <= 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:
            @"clientSecret must not be empty."];
    } else if (redirectUri == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"redirectUri must not be nil."];
    } else if ([redirectUri length] <= 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"redirectUri must not be empty."];
    } else if ([DCAuthority isValidScopes:scopes] == NO) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"scope is invalid."];
    } else if ([DCMiscUtils isNilOrEmptyStrig:storeKey] == NO &&
            [DCAuthenticationContext
              isValidAccessibility:accessibility] == NO) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"accessibility is invalid."];
    } else if (block == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"block must not be nil."];
    }

    DCAuthenticateBlock copied = [block copy];
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DCAuthenticationContext *context =
                [DCMiscUtils isNilOrEmptyStrig:storeKey] != NO ? nil :
                    [DCAuthenticationContext loadByKey:storeKey
                                              clientId:clientId
                                          clientSecret:clientSecret
                                                 error:nil];
            switch ([DCAuthority tryToRefresh:context]) {
                case DCREFRESHRESULT_NOTEXPIRED:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                          copied(context, nil);
                    });
                    break;
                }
                case DCREFRESHRESULT_REFRESHED:
                {
                    if ([DCMiscUtils isNilOrEmptyStrig:storeKey] == NO) {
                        [context saveByKey:storeKey
                             accessibility:accessibility
                                     error:nil];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                          copied(context, nil);
                    });
                    break;
                }
                case DCREFRESHRESULT_CANTREFRESH:
                case DCREFRESHRESULT_FAIL:
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [DCAuthority
                          authenticateInnerOnNavigationController:controller
                                                     withClientId:clientId
                                                     clientSecret:clientSecret
                                                      redirectUri:redirectUri
                                                           scopes:scopes
                                                         storeKey:storeKey
                                                    accessibility:accessibility
                                                            block:copied];
                    });
                    break;
            }
        }
    );
}

+ (void)
    authenticateInnerOnNavigationController:(UINavigationController *)controller
                               withClientId:(NSString *)clientId
                               clientSecret:(NSString *)clientSecret
                                redirectUri:(NSString *)redirectUri
                                     scopes:(NSArray *)scopes
                                   storeKey:(NSString *)storeKey
                              accessibility:(CFTypeRef)accessibility
                                      block:(DCAuthenticateBlock)block
{
    NSAssert(controller != nil, @"controller must not be nil");
    NSAssert([DCMiscUtils isNilOrEmptyStrig:clientId] == NO,
            @"clientId must not nil or empty.");
    NSAssert([DCMiscUtils isNilOrEmptyStrig:clientSecret] == NO,
            @"clientSecret must not nil or empty.");
    NSAssert([DCMiscUtils isNilOrEmptyStrig:redirectUri] == NO,
            @"redirectUri must not nil or empty.");
    NSAssert([DCAuthority isValidScopes:scopes] != NO, @"invalid scopes");
    if ([DCMiscUtils isNilOrEmptyStrig:storeKey] == NO) {
        NSAssert(
            [DCAuthenticationContext isValidAccessibility:accessibility] != NO,
            @"invalid accessibility");
    }
    NSAssert(block != nil, @"block must not be nil.");

    DCGTMOAuth2Authentication *authentication =
        [DCAuthority authenticationWithClientId:clientId
                                   clientSecret:clientSecret
                                    redirectUri:redirectUri
                                         scopes:scopes
                                  accessibility:accessibility];
    DCGTMOAuth2ViewControllerTouch *viewController =
        [DCAuthority OAuth2ViewControllerTouchWithAuthentication:authentication
                                                        storeKey:storeKey
                                                   accessibility:accessibility
                                                           block:block];
    if (controller == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"controller must not be nil"];
    }
    [controller pushViewController:viewController animated:YES];
}

+ (DCGTMOAuth2ViewControllerTouch*)
         OAuth2ViewControllerTouchWithAuthentication:(DCGTMOAuth2Authentication*)authentication
                                            storeKey:(NSString *)storeKey
                                       accessibility:(CFTypeRef)accessibility
                                               block:(DCAuthenticateBlock)block
{
    if (authentication == nil) {
        [DCExceptionUtils
          raiseUnexpectedExceptionWithReason:@"authentication must not be nil"];
    } else if (block == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"block must not be nil"];
    }
    if ([DCMiscUtils isNilOrEmptyStrig:storeKey] == NO) {
        NSAssert([DCAuthenticationContext isValidAccessibility:accessibility] != NO,
                 @"invalid accessibility");
    }

    DCAuthenticateBlock copied = [block copy];
    DCSessionFetcherService *fetcherService =
        [DCSessionFetcherService fetcherServiceWithAuthentication:authentication];
    authentication.fetcherService = fetcherService;
    DCGTMOAuth2ViewControllerTouch *retval =
        [DCOAuth2ViewController
          controllerWithAuthentication:authentication
                      authorizationURL:[DCAuthority authorizationURL]
                      keychainItemName:nil
                     completionHandler:^(
                             DCGTMOAuth2ViewControllerTouch *viewController,
                             DCGTMOAuth2Authentication *auth,
                             NSError *error) {
                [fetcherService clearHistory];
                if (copied != nil) {
                    if (error != nil) {
                        copied(nil,
                            [DCErrorUtils toAuthenticationRelatedError:error]);
                    } else {
                        DCAuthenticationContext *context =
                            [DCAuthenticationContext
                                 authenticationContextWithAuthentication:auth
                                                          fetcherService:fetcherService
                                                                storeKey:storeKey];
                        if ([DCMiscUtils isNilOrEmptyStrig:storeKey] == NO) {
                            [context saveByKey:storeKey
                                 accessibility:accessibility
                                         error:nil];
                        }
                        copied(context, nil);
                    }
                } else {
                    [NSException raise:NSGenericException format:nil];
                }
            }
         ];
    retval.signIn.additionalAuthorizationParameters =
        [NSDictionary dictionaryWithObjectsAndKeys:
                        [DCAuthority generateState],
                        @"state", nil];
    if ([DCAuthenticationContext isValidAccessibility:accessibility] != NO) {
        retval.keychainItemAccessibility = accessibility;
    }
    // if browserCookiesURL set non-nil, the URL for which cookies will be
    // deleted when the browser view is dismissed
    retval.browserCookiesURL = [DCAuthority authorizationURL];
    return retval;
}

+ (NSURL *)authorizationURL
{
    NSURL *url = [DCMiscUtils urlForAuthorization];
    if (url == nil) {
        url = [NSURL URLWithString:DEFAULT_AUTHORIZATION_URL];
    }
    return [url URLByAppendingPathComponent:@"cgi11d/authorization"];
}

+ (DCGTMOAuth2Authentication*)
        authenticationWithClientId:(NSString *)clientId
                      clientSecret:(NSString *)clientSecret
                       redirectUri:(NSString *)redirectUri
                            scopes:(NSArray *)scopes
                     accessibility:(CFTypeRef)accessibility
{
    NSAssert([DCMiscUtils isNilOrEmptyStrig:clientId] == NO,
            @"clientId must not nil or empty.");
    NSAssert([DCMiscUtils isNilOrEmptyStrig:clientSecret] == NO,
            @"clientSecret must not nil or empty.");
    NSAssert([DCMiscUtils isNilOrEmptyStrig:redirectUri] == NO,
            @"redirectUri must not nil or empty.");
    NSAssert([DCAuthority isValidScopes:scopes] != NO, @"invalid scopes");

    // Server redirect scheme://host/?code=... whenever path is empty.
    // We need to add '/' to the end.
    NSURL *url = [NSURL URLWithString:redirectUri];
    if (url.path.length == 0) {
        redirectUri = [redirectUri stringByAppendingString:@"/"];
    }

    DCOAuth2Authentication *retval = [DCOAuth2Authentication
             authenticationWithServiceProvider:SERVICE_NAME
                                      tokenURL:[DCAuthority tokenURL]
                                   redirectURI:redirectUri
                                      clientID:clientId
                                  clientSecret:clientSecret];
    retval.scope =
        [DCAuthority toScopeString:[DCMiscUtils removeDuplicatedItems:scopes]];
    retval.accessibility = accessibility;
    return retval;
}

+ (NSURL *)tokenURL
{
    NSURL *url = [DCMiscUtils urlForToken];
    if (url == nil) {
        url = [NSURL URLWithString:DEFAULT_TOKEN_URL];
    }
    return [url URLByAppendingPathComponent:@"cgi12/token"];
}

+ (BOOL)isValidScopes:(NSArray *)scopes
{
    if (scopes == nil) {
        return NO;
    } else if ([scopes count] == 0) {
        return NO;
    }
    for (id scope in scopes) {
        if (scope == nil) {
            return NO;
        } else if ([scope isKindOfClass:[NSString class]] == NO) {
            return NO;
        } else if ([scope length] == 0) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)toScopeString:(NSArray *)scopes
{
    NSAssert([DCAuthority isValidScopes:scopes], @"invaid scopes");
    return [scopes componentsJoinedByString:@" "];
}

+ (DCRefreshResult)tryToRefresh:(DCAuthenticationContext *)context
{
    NSError *error = nil;
    return [DCAuthority tryToRefresh:context error:&error];
}

+ (DCRefreshResult)tryToRefresh:(DCAuthenticationContext *)context
                          error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil");
    if (context == nil) {
        return DCREFRESHRESULT_CANTREFRESH;
    } else if ([context isExpired] == NO) {
        return DCREFRESHRESULT_NOTEXPIRED;
    } else if ([context canRefresh] == NO) {
        return DCREFRESHRESULT_CANTREFRESH;
    }
    BOOL isTimeout = [DCAuthority doRefreshToken:context error:error];
    if (isTimeout != NO || *error != nil) {
        return DCREFRESHRESULT_FAIL;
    }
    return DCREFRESHRESULT_REFRESHED;
}

+ (BOOL)doRefreshToken:(DCAuthenticationContext *)context
                 error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil");
    __block NSError *outError = nil;;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSString *oldAccessToken = context.authentication.accessToken;
    context.authentication.accessToken = nil;
    [context.authentication authorizeRequest:nil
                           completionHandler:^(NSError *error) {
            outError = error;
            dispatch_semaphore_signal(semaphore);
        }];
    BOOL isTimeout = dispatch_semaphore_wait(semaphore,
            dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC )) == 0
            ? NO : YES;
    [context.fetcherService clearHistory];
    if (outError != nil) {
        *error = outError;
        NSLog(@"refresh token was failed: %@", [outError description]);
    }
    if (isTimeout != NO || outError != nil) {
        context.authentication.accessToken = oldAccessToken;
    }
    return isTimeout;
}

+ (NSString *)serviceProviderName
{
    return SERVICE_NAME;
}

+ (NSString *)generateState
{
    unsigned long long millisec = [[NSDate date] timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%llx", millisec];
}

+ (void)refreshTokenWithAuthenticationContext:(DCAuthenticationContext *)authenticationContext
                                        block:(DCAuthenticateBlock)block
{
    if (authenticationContext == nil) {
        [DCExceptionUtils raiseNilAssignedExceptionWithReason:
            @"authenticationContext must not be nil."];
    } else if ([DCMiscUtils isNilOrEmptyStrig:authenticationContext.authentication.clientID] != NO ||
               [DCMiscUtils isNilOrEmptyStrig:authenticationContext.authentication.clientSecret] != NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
            @"DCAuthenticationContext which loaded by deprecated loadBy method can't refresh."];
    } else if (block == nil) {
        [DCExceptionUtils raiseNilAssignedExceptionWithReason:
            @"block must not be nil."];
    }

    DCAuthenticateBlock copied = [block copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([DCMiscUtils isNilOrEmptyStrig:authenticationContext.authentication.refreshToken] != NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                  copied(nil,
                      [DCErrorUtils
                        authenticationErrorWithReason:DCAUTHENTICATIONERRORREASON_NO_REFRESH_TOKEN]);
              });
            return;
        }

        NSError *error = nil;
        BOOL isTimeout = [DCAuthority doRefreshToken:authenticationContext
                                               error:&error];
        if (isTimeout != NO && error == nil) {
            error = [[NSError alloc] initWithDomain:DCAuthenticationErrorDomain
                                               code:DCAUTHENTICATIONERRORREASON_TEMPORARILY_UNAVAILABLE
                                           userInfo:nil];
        }
        if (error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                copied(nil, error);
            });
        } else {
            // TODO: move storeKey check into save method.
            if ([DCMiscUtils isNilOrEmptyStrig:authenticationContext.storeKey] == NO) {
                [authenticationContext save];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                copied(authenticationContext, nil);
            });
        }
    });
}

@end
