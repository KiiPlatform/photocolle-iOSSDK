#import "DCAuthorityParameterTest.h"

#import "DCAuthenticationContext_Private.h"
#import "DCAuthority.h"
#import "DCErrors.h"
#import "DCOAuth2Authentication_Private.h"
#import "DCScope.h"

#import "OCMock/OCMock.h"

@implementation DCAuthorityParameterTest

- (void)testAuthenticateOnNavigationControllerParameter
{
    // ID0001
    {
        BOOL exceptionOccured = NO;
        @try {
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:nil
                                    withClientId:@"clientId"
                                    clientSecret:@"clientSecret"
                                     redirectUri:@"redirectUri"
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"nil was assigned: controller must not be nil.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0002
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:nil
                                    clientSecret:@"clientSecret"
                                     redirectUri:@"redirectUri"
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"nil was assigned: clientId must not be nil.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0003
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@""
                                    clientSecret:@"clientSecret"
                                     redirectUri:@"redirectUri"
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"out of range: clientId must not be empty.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0004
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:nil
                                     redirectUri:@"redirectUri"
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"nil was assigned: clientSecret must not be nil.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0005
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:@""
                                     redirectUri:@"redirectUri"
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"out of range: clientSecret must not be empty.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0006
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:@"clientSecret"
                                     redirectUri:@"redirectUri"
                                          scopes:nil
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"out of range: scope is invalid.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0007
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:@"clientSecret"
                                     redirectUri:@"redirectUri"
                                          scopes:@[]
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"out of range: scope is invalid.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0008
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[NSNumber numberWithBool:NO]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:@"clientSecret"
                                     redirectUri:@"redirectUri"
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"out of range: scope is invalid.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0009
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:@"clientSecret"
                                     redirectUri:@"redirectUri"
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:NULL
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"out of range: accessibility is invalid.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0010
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:@"clientSecret"
                                     redirectUri:@"redirectUri"
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:(__bridge CFStringRef)@"testref"
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"out of range: accessibility is invalid.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0011
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:@"clientSecret"
                                     redirectUri:@"redirectUri"
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:nil];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"nil was assigned: block must not be nil.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0012
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:@"clientSecret"
                                     redirectUri:nil
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"nil was assigned: redirectUri must not be nil.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0013
    {
        BOOL exceptionOccured = NO;
        @try {
            id mockController =
                [OCMockObject mockForClass:[UINavigationController class]];
            NSArray *scopes = @[[DCScope photoGetContentsList]];
            [DCAuthority
              authenticateOnNavigationController:mockController
                                    withClientId:@"clientId"
                                    clientSecret:@"clientSecret"
                                     redirectUri:@""
                                          scopes:scopes
                                        storeKey:@"storeKey"
                                   accessibility:kSecAttrAccessibleAfterFirstUnlock
                                           block:^(
                                            DCAuthenticationContext *context,
                                            NSError *error) {
                    // nothing to implement.
                }];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                @"out of range: redirectUri must not be empty.",
                actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                    NSInvalidArgumentException,
                    NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

}

- (void)testRefreshTokenParameter
{
    // ID0001
    {
        BOOL exceptionOccured = NO;
        @try {
            [DCAuthority refreshTokenWithAuthenticationContext:nil
                                                         block:^(
                    DCAuthenticationContext *refreshed,
                    NSError *error)
                {
                    GHFail(@"no call this block.");
                }
             ];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                    @"nil was assigned: authenticationContext must not be nil.",
                    actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                   NSInvalidArgumentException,
                   NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0002
    {
        BOOL exceptionOccured = NO;
        id mockAuth = [OCMockObject mockForClass:[DCOAuth2Authentication class]];
        [[[mockAuth stub] andReturn:nil] clientID];
        [[[mockAuth stub] andReturn:@"dummy"] clientSecret];
        [[[mockAuth stub] andReturn:@"dummy"] refreshToken];
        DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
        context.authentication = mockAuth;
        @try {
            [DCAuthority refreshTokenWithAuthenticationContext:context
                                                         block:^(
                    DCAuthenticationContext *refreshed,
                    NSError *error)
                {
                    GHFail(@"no call this block.");
                }
             ];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                    @"out of range: DCAuthenticationContext which loaded by deprecated loadBy method can't refresh.",
                    actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                   NSInvalidArgumentException,
                   NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0003
    {
        BOOL exceptionOccured = NO;
        id mockAuth = [OCMockObject mockForClass:[DCOAuth2Authentication class]];
        [[[mockAuth stub] andReturn:@""] clientID];
        [[[mockAuth stub] andReturn:@"dummy"] clientSecret];
        [[[mockAuth stub] andReturn:@"dummy"] refreshToken];
        DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
        context.authentication = mockAuth;
        @try {
            [DCAuthority refreshTokenWithAuthenticationContext:context
                                                         block:^(
                    DCAuthenticationContext *refreshed,
                    NSError *error)
                {
                    GHFail(@"no call this block.");
                }
             ];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                    @"out of range: DCAuthenticationContext which loaded by deprecated loadBy method can't refresh.",
                    actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                   NSInvalidArgumentException,
                   NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0004
    {
        BOOL exceptionOccured = NO;
        id mockAuth = [OCMockObject mockForClass:[DCOAuth2Authentication class]];
        [[[mockAuth stub] andReturn:@"dummy"] clientID];
        [[[mockAuth stub] andReturn:nil] clientSecret];
        [[[mockAuth stub] andReturn:@"dummy"] refreshToken];
        DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
        context.authentication = mockAuth;
        @try {
            [DCAuthority refreshTokenWithAuthenticationContext:context
                                                         block:^(
                    DCAuthenticationContext *refreshed,
                    NSError *error)
                {
                    GHFail(@"no call this block.");
                }
             ];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                    @"out of range: DCAuthenticationContext which loaded by deprecated loadBy method can't refresh.",
                    actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                   NSInvalidArgumentException,
                   NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0005
    {
        BOOL exceptionOccured = NO;
        id mockAuth = [OCMockObject mockForClass:[DCOAuth2Authentication class]];
        [[[mockAuth stub] andReturn:@"dummy"] clientID];
        [[[mockAuth stub] andReturn:@""] clientSecret];
        [[[mockAuth stub] andReturn:@"dummy"] refreshToken];
        DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
        context.authentication = mockAuth;
        @try {
            [DCAuthority refreshTokenWithAuthenticationContext:context
                                                         block:^(
                    DCAuthenticationContext *refreshed,
                    NSError *error)
                {
                    GHFail(@"no call this block.");
                }
             ];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                    @"out of range: DCAuthenticationContext which loaded by deprecated loadBy method can't refresh.",
                    actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                   NSInvalidArgumentException,
                   NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }

    // ID0006
    {
        id mockAuth = [OCMockObject mockForClass:[DCOAuth2Authentication class]];
        [[[mockAuth stub] andReturn:@"dummy"] clientID];
        [[[mockAuth stub] andReturn:@"dummy"] clientSecret];
        [[[mockAuth stub] andReturn:nil] refreshToken];
        DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
        context.authentication = mockAuth;
        @try {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [DCAuthority refreshTokenWithAuthenticationContext:context
                                                         block:^(
                    DCAuthenticationContext *refreshed,
                    NSError *error)
                {
                    GHAssertNil(refreshed, @"refreshed context must be nil.");
                    GHAssertNotNil(error, @"error must not be nil.");
                    GHAssertEquals((NSInteger)DCAUTHENTICATIONERRORREASON_NO_REFRESH_TOKEN,
                        error.code,
                        @"error.code must be DCAUTHENTICATIONERRORREASON_NO_REFRESH_TOKEN.");
                    GHAssertEquals(DCAuthenticationErrorDomain, error.domain,
                                   @"error.domain must be DCAuthenticationErrorDomain.");
                    dispatch_semaphore_signal(semaphore);
                }
             ];
            BOOL isTimeout = [DCAuthorityParameterTest waitUntilTimeOut:10
                                                              semaphore:semaphore];
            GHAssertFalse(isTimeout, @"time out.");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                   NSInvalidArgumentException,
                   NSStringFromClass([exception class]));
        }
    }

    // ID0007
    {
        id mockAuth = [OCMockObject mockForClass:[DCOAuth2Authentication class]];
        [[[mockAuth stub] andReturn:@"dummy"] clientID];
        [[[mockAuth stub] andReturn:@"dummy"] clientSecret];
        [[[mockAuth stub] andReturn:@""] refreshToken];
        DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
        context.authentication = mockAuth;
        @try {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [DCAuthority refreshTokenWithAuthenticationContext:context
                                                         block:^(
                    DCAuthenticationContext *refreshed,
                    NSError *error)
                {
                    GHAssertNil(refreshed, @"refreshed context must be nil.");
                    GHAssertNotNil(error, @"error must not be nil.");
                    GHAssertEquals((NSInteger)DCAUTHENTICATIONERRORREASON_NO_REFRESH_TOKEN,
                            error.code,
                            @"error.code must be DCAUTHENTICATIONERRORREASON_NO_REFRESH_TOKEN.");
                    GHAssertEquals(DCAuthenticationErrorDomain, error.domain,
                            @"error.domain must be DCAuthenticationErrorDomain.");
                    dispatch_semaphore_signal(semaphore);
                }
             ];
            BOOL isTimeout = [DCAuthorityParameterTest waitUntilTimeOut:10
                                                              semaphore:semaphore];
            GHAssertFalse(isTimeout, @"time out.");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                   NSInvalidArgumentException,
                   NSStringFromClass([exception class]));
        }
    }
    
    // ID0008
    {
        BOOL exceptionOccured = NO;
        id mockAuth = [OCMockObject mockForClass:[DCOAuth2Authentication class]];
        [[[mockAuth stub] andReturn:@"dummy"] clientID];
        [[[mockAuth stub] andReturn:@"dummy"] clientSecret];
        [[[mockAuth stub] andReturn:@"dummy"] refreshToken];
        DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
        context.authentication = mockAuth;
        @try {
            [DCAuthority refreshTokenWithAuthenticationContext:context
                                                         block:nil];
        } @catch (NSException *actual) {
            exceptionOccured = YES;
            GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                    @"name is invalid");
            GHAssertEqualStrings(
                    @"nil was assigned: block must not be nil.",
                    actual.reason, @"reason is invalid");
        } @catch (id exception) {
            GHFail(@"invalid exception: expected=%@, actual=%@",
                   NSInvalidArgumentException,
                   NSStringFromClass([exception class]));
        }
        GHAssertTrue(exceptionOccured, @"exception must be occurred");
    }
}

+ (BOOL)waitUntilTimeOut:(NSTimeInterval)interval
               semaphore:(dispatch_semaphore_t)semaphore
{
    BOOL retval = NO;
    if ([[NSThread currentThread] isMainThread] == NO) {
        retval = dispatch_semaphore_wait(semaphore, dispatch_time(
                                                                  DISPATCH_TIME_NOW, interval * NSEC_PER_SEC)) == 0 ? NO : YES;
    } else {
        for (int count = 0, amount = interval * 10;
             dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW);
             ++count) {
            [[NSRunLoop currentRunLoop]
             runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
            if (count >= amount) {
                retval = YES;
                break;
            }
        }
    }
    return retval;
}

@end
