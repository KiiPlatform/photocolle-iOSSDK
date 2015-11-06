#import "DCAuthenticationContext_Private.h"
#import "DCErrorUtils.h"
#import "DCExceptionUtils.h"
#import "DCOAuth2Authentication.h"
#import "DCAuthority_Private.h"
#import "DCMiscUtils.h"
#import "DCHTTPFetcherService.h"

#import "GTMOAuth2ViewControllerTouch.h"

static NSString * const DC_KEY_SUFFIX = @"-docomo";
static NSString * const DC_STOREKEY_SERVICE = @"dc-storekey-service";
static NSString * const DC_STOREKEY_ACCOUNT = @"dc-storekey-account";

@implementation DCAuthenticationContext

+ (id)authenticationContextWithAuthentication:(DCGTMOAuth2Authentication *)authentication
                               fetcherService:(id<DCGTMHTTPFetcherServiceProtocol>)fetcherService
{
    if (authentication == nil) {
        [DCExceptionUtils
          raiseUnexpectedExceptionWithReason:@"authentication must not be nil"];
    }
    return [[DCAuthenticationContext alloc]
             initWithAuthentication:authentication
                     fetcherService:fetcherService];
}

+ (instancetype)authenticationContextWithAuthentication:(DCGTMOAuth2Authentication *)authentication
                                         fetcherService:(id<DCGTMHTTPFetcherServiceProtocol>)fetcherService
                                               storeKey:(NSString *)storeKey
{
    if (authentication == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"authentication"];
    }
    return [[DCAuthenticationContext alloc]
             initWithAuthentication:authentication
                     fetcherService:fetcherService
                           storeKey:storeKey];
}

- (id)initWithAuthentication:(DCGTMOAuth2Authentication *)authentication
              fetcherService:(id<DCGTMHTTPFetcherServiceProtocol>)fetcherService
{
    self = [super init];
    if (self != nil) {
        self.authentication = authentication;
        self.authentication.fetcherService = fetcherService;
        self.fetcherService = fetcherService;
    }
    return self;
}

- (instancetype)
    initWithAuthentication:(DCGTMOAuth2Authentication *)authentication
            fetcherService:(id<DCGTMHTTPFetcherServiceProtocol>)fetcherService
                  storeKey:(NSString *)storeKey
{
    self = [super init];
    if (self != nil) {
        self.authentication = authentication;
        self.authentication.fetcherService = fetcherService;
        self.fetcherService = fetcherService;
        self.storeKey = storeKey;
    }
    return self;
}

- (NSString *)accessToken
{
    return self.authentication.accessToken;
}

+ (BOOL)hasSavedByKey:(NSString *)key
                error:(NSError **)error
{
    if (key == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"key must not be nil."];
    } else if ([key length] == 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"key must not be empty."];
    }

    DCGTMOAuth2Authentication *authentication =
        [[DCOAuth2Authentication alloc] init];
    NSError *cause = nil;
    if ([DCGTMOAuth2ViewControllerTouch
          authorizeFromKeychainForName:[key stringByAppendingString:
                                              DC_KEY_SUFFIX]
                        authentication:authentication
                                 error:&cause] == NO) {
        if (error != nil) {
            if (cause.code != errSecItemNotFound) {
                *error =
                    [DCErrorUtils
                      authenticationContextAccessErrorWithReason:
                        DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                           cause:cause];
            }
        }
        return NO;
    }
    return YES;
}

+ (DCAuthenticationContext *)loadByKey:(NSString *)key
                                 error:(NSError **)error
{
    if (key == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"key must not be nil."];
    } else if ([key length] == 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"key must not be empty."];
    }

    DCGTMOAuth2Authentication *authentication =
        [[DCOAuth2Authentication alloc] init];
    NSError *cause = nil;
    if ([DCGTMOAuth2ViewControllerTouch
          authorizeFromKeychainForName:[key stringByAppendingString:
                                              DC_KEY_SUFFIX]
                        authentication:authentication
                                 error:&cause] == NO) {
        if (error != nil) {
            *error = [DCErrorUtils
                       authenticationContextAccessErrorWithReason:
                         DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                            cause:cause];
        }
        return nil;
    }

    if ([authentication canAuthorize] == NO) {
        if (error != nil) {
            *error = [NSError errorWithDomain:DCAuthenticationContextNotFoundErrorDomain
                                         code:0
                                     userInfo:nil];
        }
        return nil;
    }

    return [DCAuthenticationContext
             authenticationContextWithAuthentication:authentication
                                      fetcherService:[DCHTTPFetcherService
                                                       fetcherServiceWithAuthentication:authentication]];
}

+ (DCAuthenticationContext *)loadByKey:(NSString *)key
                              clientId:(NSString *)clientId
                          clientSecret:(NSString *)clientSecret
                                 error:(NSError **)error
{
    if (key == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"key must not be nil."];
    } else if ([key length] == 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"key must not be empty."];
    } else if (clientId == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"clientId must not be nil."];
    } else if (clientId.length == 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"clientId must not be empty."];
    } else if (clientSecret == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"clientSecret must not be nil."];
    } else if (clientSecret.length == 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"clientSecret must not be empty."];
    }

    DCGTMOAuth2Authentication *authentication =
        [DCOAuth2Authentication
            authenticationWithServiceProvider:[DCAuthority serviceProviderName]
                                     tokenURL:[DCAuthority tokenURL]
                                  redirectURI:nil
                                     clientID:clientId
                                 clientSecret:clientSecret];

    NSError *cause = nil;
    if ([DCGTMOAuth2ViewControllerTouch
         authorizeFromKeychainForName:[key stringByAppendingString:
                                             DC_KEY_SUFFIX]
                       authentication:authentication
                                error:&cause] == NO) {
        if (error != nil) {
            *error = [DCErrorUtils
                       authenticationContextAccessErrorWithReason:
                         DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                            cause:cause];
        }
        return nil;
    }

    return [DCAuthenticationContext
             authenticationContextWithAuthentication:authentication
                                      fetcherService:[DCHTTPFetcherService
                                                       fetcherServiceWithAuthentication:authentication]
                                            storeKey:key];
}

+ (BOOL)removeByKey:(NSString *)key
              error:(NSError **)error
{
    if (key == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"key must not be nil."];
    } else if ([key length] == 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"key must not be empty."];
    }

    if ([DCGTMOAuth2ViewControllerTouch
                    removeAuthFromKeychainForName:
                     [key stringByAppendingString:DC_KEY_SUFFIX]] == NO) {
        if (error != nil) {
            *error =
                [DCErrorUtils
                  authenticationContextAccessErrorWithReason:
                    DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED];
        }
        return NO;
    }

    [DCAuthenticationContext removeStoreKey:key];
    return YES;
}

+ (BOOL)removeAllWithError:(NSError **)error
{
    @synchronized (self) {
        NSError *cause = nil;
        NSArray *storeKeys =
            [DCAuthenticationContext loadStoreKeysWithError:&cause];
        if (cause != nil) {
            if (error != nil) {
                *error = [DCErrorUtils
                           authenticationContextAccessErrorWithReason:
                             DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                                cause:cause];
            }
            return NO;
        }
        NSMutableArray *unstored = [NSMutableArray array];
        for (NSString *storeKey in storeKeys) {
            if ([DCAuthenticationContext hasSavedByKey:storeKey
                                                 error:&cause] == NO) {
                if (cause != nil) {
                    break;
                }
                [unstored addObject:storeKey];
                continue;
            }
            if ([DCAuthenticationContext removeByKey:storeKey
                                               error:&cause] == NO) {
                break;
            }
        }
        [DCAuthenticationContext removeStoreKeys:unstored];
        if (cause != nil) {
            if (error != nil) {
                *error = [DCErrorUtils
                           authenticationContextAccessErrorWithReason:
                             DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                                cause:cause];
            }
            return NO;
        }
        return YES;
    }
}

- (BOOL) saveByKey:(NSString *)key
     accessibility:(CFTypeRef)accessibility
             error:(NSError **)error
{
    return [self saveInnerByKey:key accessibility:accessibility error:error];
}

- (BOOL)saveInnerByKey:(NSString *)key
         accessibility:(CFTypeRef)accessibility
                 error:(NSError **)error
{
    if (key == nil) {
        [DCExceptionUtils
          raiseNilAssignedExceptionWithReason:@"key must not be nil."];
    } else if ([key length] == 0) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"key must not be empty."];
    } else if ([DCAuthenticationContext
                 isValidAccessibility:accessibility] == NO) {
        [DCExceptionUtils
          raiseOutOfRangeExceptionWithReason:@"accessibility is out of range."];
    }
    NSError *cause = nil;

    // Remove old record linked with self.storeKey if exists.
    if (self.storeKey == nil) {
        // Nothing to do.
    } else if ([self.storeKey isEqualToString:key] != NO) {
        // Nothing to do.
    } else if ([DCAuthenticationContext hasSavedByKey:self.storeKey
                                                error:&cause] == NO) {
        // If there is not a record linked with the self.storeKey,
        // then nothing to do. But fail to check existence of recored,
        // return error;
        if (cause != nil) {
            if (error != nil) {
                *error = cause;
            }
            return NO;
        }
    } else {
        if ([DCAuthenticationContext removeByKey:self.storeKey
                                           error:error] == NO) {
            // Removing an old record was failed.
            return NO;
        }
    }

    DCOAuth2Authentication *authentication = nil;
    if ([self.authentication isKindOfClass:[DCOAuth2Authentication class]]
            != NO) {
        // TODO: authentication proerty should changed to
        // DCOAuth2Authentication.

        authentication = (DCOAuth2Authentication *)self.authentication;
    }

    NSString *oldStoreKey = self.storeKey;
    CFTypeRef oldAccessibility =
        authentication == nil ? NULL : authentication.accessibility;
    self.storeKey = key;
    if (authentication != nil) {
        authentication.accessibility = accessibility;
    }
    if ([DCAuthenticationContext saveStoreKey:key
                               authentication:self.authentication
                                accessibility:accessibility
                                        error:&cause] == NO) {
        // rollback data if fails.
        self.storeKey = oldStoreKey;
        if (authentication != nil) {
            authentication.accessibility = oldAccessibility;
        }
        if (error != nil) {
            *error = cause;
        }
        return NO;
    }
    return YES;
}

- (BOOL)isExpired
{
    if (self.authentication.expirationDate == nil) {
        return YES;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60];
    return [self.authentication.expirationDate compare:date]
        == NSOrderedAscending ? YES : NO;
}

- (BOOL)canRefresh;
{
    if (self.authentication.clientID == nil ||
            self.authentication.clientSecret == nil) {
        // clientId and clientSecret are nil if the
        // DCAuthenticationContext object was generated by
        // [DCAuthenticationContext loadByKey:error:] If clientId
        // and/or clientSecret are nil, then PhotoColleSDK can not
        // refresh Token.
        return NO;
    } else if (self.authentication.refreshToken == nil) {
        // In specification
        // https://dev.smt.docomo.ne.jp/pdf/API_common_reference_v2.0.0.pdf,
        // Server may not send refresh token.
        return NO;
    }
    return YES;
}

- (void)save
{
    if ([self.authentication isKindOfClass:[DCOAuth2Authentication class]]
            != NO) {
        // TODO: authentication proerty should changed to
        // DCOAuth2Authentication.
        CFTypeRef accessibility =
            ((DCOAuth2Authentication *)self.authentication).accessibility;
        [self saveInnerByKey:self.storeKey
               accessibility:accessibility
                       error:nil];
    }
}

+ (BOOL)isValidAccessibility:(CFTypeRef)accessibility
{
    if (accessibility == kSecAttrAccessibleWhenUnlocked) {
        return YES;
    } else if (accessibility == kSecAttrAccessibleAfterFirstUnlock) {
        return YES;
    } else if (accessibility == kSecAttrAccessibleAlways) {
        return YES;
    } else if (accessibility == kSecAttrAccessibleWhenUnlockedThisDeviceOnly) {
        return YES;
    } else if (accessibility ==
               kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly) {
        return YES;
    } else if (accessibility == kSecAttrAccessibleAlwaysThisDeviceOnly) {
        return YES;
    }
    return NO;
}

+ (BOOL)saveStoreKey:(NSString *)storeKey
      authentication:(DCGTMOAuth2Authentication *)authentication
       accessibility:(CFTypeRef)accessibility
               error:(NSError **)error
{
    NSAssert([DCMiscUtils isNilOrEmptyStrig:storeKey] == NO,
            @"storeKey must not be nil or empty.");
    NSAssert(authentication != nil, @"authentication must not be nil.");
    NSAssert([DCAuthenticationContext isValidAccessibility:accessibility] != NO,
            @"accessibility is invalid.");
    NSAssert(error != nil, @"error must not be nil.");

    @synchronized (self) {
        NSError *cause = nil;
        NSArray *array = [DCAuthenticationContext
                           loadStoreKeysWithError:&cause];
        if (cause != nil) {
            *error = [DCErrorUtils
                       authenticationContextAccessErrorWithReason:
                         DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                            cause:cause];
            return NO;
        }

        NSMutableArray *storeKeys = [NSMutableArray arrayWithArray:array];
        if ([storeKeys containsObject:storeKey] == NO) {
            // if storeKey is not stored, then store it.
            [storeKeys addObject:storeKey];
            if ([DCAuthenticationContext saveStoreKeys:storeKeys
                                                 error:&cause] == NO) {
                *error = [DCErrorUtils
                           authenticationContextAccessErrorWithReason:
                             DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                                cause:cause];
                return NO;
            }
        }
        if ([DCGTMOAuth2ViewControllerTouch
                    saveParamsToKeychainForName:[storeKey stringByAppendingString:
                                                       DC_KEY_SUFFIX]
                                  accessibility:accessibility
                                 authentication:authentication
                                          error:&cause] == NO) {
            *error = [DCErrorUtils
                       authenticationContextAccessErrorWithReason:
                         DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                            cause:cause];
            return NO;
        }
        return YES;
    }
}

+ (void)removeStoreKey:(NSString *)storeKey
{
    NSAssert([DCMiscUtils isNilOrEmptyStrig:storeKey] == NO,
            @"storeKey must not be nil or empty.");
    @synchronized (self) {
        [DCAuthenticationContext
          removeStoreKeys:[NSArray arrayWithObject:storeKey]];
    }

}

+ (NSArray *)loadStoreKeysWithError:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");
    NSString *string = nil;
    {
        NSError *cause = nil;
        DCGTMOAuth2Keychain *keyChain = [DCGTMOAuth2Keychain defaultKeychain];
        string = [keyChain passwordForService:DC_STOREKEY_SERVICE
                                      account:DC_STOREKEY_ACCOUNT
                                        error:&cause];
        if (cause != nil && cause.code != errSecItemNotFound) {
            *error = [DCErrorUtils
                       authenticationContextAccessErrorWithReason:
                         DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                            cause:cause];
            return nil;
        }
    }

    NSMutableArray *array = nil;
    {
        NSError *cause = nil;
        array = [DCAuthenticationContext
                   toMutableArrayFromStoreKeyString:string
                                              error:&cause];
        if (cause != nil) {
            *error = [DCErrorUtils
                       authenticationContextAccessErrorWithReason:
                         DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                            cause:cause];
            return nil;
        }
    }
    return [NSArray arrayWithArray:array];
}

+ (void)removeStoreKeys:(NSArray *)storeKeys
{
    if (storeKeys == nil) {
        return;
    } else if ([storeKeys count] == 0) {
        return;
    }
    NSError *cause = nil;
    NSArray *array = [DCAuthenticationContext loadStoreKeysWithError:&cause];
    if (cause != nil) {
        return;
    }
    NSMutableArray *allKeys = [NSMutableArray arrayWithArray:array];
    [allKeys removeObjectsInArray:storeKeys];
    [DCAuthenticationContext saveStoreKeys:allKeys error:&cause];
}

+ (BOOL)saveStoreKeys:(NSArray *)storeKeys error:(NSError **)error
{
    NSAssert(storeKeys != nil, @"storeKeys must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSString *password =
        [DCAuthenticationContext toStoreKeyStringFromArray:storeKeys
                                                     error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils
                       authenticationContextAccessErrorWithReason:
                     DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                            cause:cause];
        return NO;
    }

    DCGTMOAuth2Keychain *keyChain = [DCGTMOAuth2Keychain defaultKeychain];
    if ([keyChain setPassword:password
                   forService:DC_STOREKEY_SERVICE
                accessibility:kSecAttrAccessibleAlways
                      account:DC_STOREKEY_ACCOUNT
                        error:&cause] == NO) {
        *error = [DCErrorUtils
                           authenticationContextAccessErrorWithReason:
                     DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED
                                                                cause:cause];
        return NO;
    }
    return YES;
}

+ (NSMutableArray *)toMutableArrayFromStoreKeyString:(NSString *)string
                                               error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil");
    if (string == nil) {
        return [NSMutableArray array];
    }
    NSError *cause = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id retval =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&cause];
    if (cause != nil) {
        *error = cause;
        return nil;
    }
    if ([retval isKindOfClass:[NSArray class]] == NO) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                                 @"JSON must be object."];
        return nil;
    }
    return [NSMutableArray arrayWithArray:(NSArray *)retval];
}

+ (NSString *)toStoreKeyStringFromArray:(NSArray *)array
                                  error:(NSError **)error
{
    NSAssert(array != nil, @"array must not be nil");
    NSAssert(error != nil, @"error must not be nil");
    NSError *cause = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:0
                                                     error:&cause];
    if (cause != nil) {
        *error = cause;
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSTimeInterval)remainingTimeInSeconds
{
    return [self.authentication.expirationDate timeIntervalSinceNow];
}

@end
