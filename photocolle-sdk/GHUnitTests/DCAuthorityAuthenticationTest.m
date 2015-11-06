#import "DCAuthorityAuthenticationTest.h"

#import "OCMock/OCMock.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "DCTestUtils.h"
#import "DCAuthority_Private.h"
#import "DCAuthenticationContext.h"
#import "DCTypeRefHolder.h"

@class DCGTMOAuth2SignIn;
@class DCGTMOAuth2Authentication;

@interface DCGTMOAuth2ViewControllerTouch(AccessingPrivate)

- (void)signIn:(DCGTMOAuth2SignIn *)signIn
finishedWithAuth:(DCGTMOAuth2Authentication *)auth
         error:(NSError *)error;

@end

@implementation DCAuthorityAuthenticationTest

- (void)setUp
{
    [DCTestUtils removeAllAuthenticationContext];
}

- (void)tearDown
{
    [DCTestUtils removeAllAuthenticationContext];
}

- (void)testID0001
{
    id mockController =
        [OCMockObject mockForClass:[UINavigationController class]];

    __block DCGTMOAuth2ViewControllerTouch *viewController = nil;
    [[[mockController stub] andDo:^(NSInvocation *invocation) {
                [invocation getArgument:&viewController atIndex:2];
                viewController.authentication.accessToken = @"accessToken";
                viewController.authentication.refreshToken = @"refreshToken";
                viewController.authentication.expirationDate = [NSDate date];
                [viewController signIn:nil
                      finishedWithAuth:viewController.authentication
                                 error:nil];
            }
          ]
      pushViewController:[OCMArg any]
                animated:YES];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [DCAuthority
      authenticateOnNavigationController:mockController
                            withClientId:@"clientId"
                            clientSecret:@"clientSecret"
                             redirectUri:@"redirectUri"
                                  scopes:@[ @"scope", @"scope" ]
                                storeKey:@"storeKey"
                           accessibility:kSecAttrAccessibleWhenUnlocked
                                   block:^(DCAuthenticationContext *context,
                                           NSError *error) {
            dispatch_semaphore_signal(semaphore);
        }
     ];
    BOOL isTimeout =
        [DCAuthorityAuthenticationTest waitUntilTimeOut:10 semaphore:semaphore];
    GHAssertFalse(isTimeout, @"time out.");
    GHAssertEqualStrings(@"scope", viewController.authentication.scope,
            @"scope is invalid.");
}

- (void)testID0002
{
    id mockController =
        [OCMockObject mockForClass:[UINavigationController class]];

    __block DCGTMOAuth2ViewControllerTouch *viewController = nil;
    [[[mockController stub] andDo:^(NSInvocation *invocation) {
                [invocation getArgument:&viewController atIndex:2];
                viewController.authentication.accessToken = @"accessToken";
                viewController.authentication.refreshToken = @"refreshToken";
                viewController.authentication.expirationDate = [NSDate date];
                [viewController signIn:nil
                      finishedWithAuth:viewController.authentication
                                 error:nil];
            }
          ]
      pushViewController:[OCMArg any]
                animated:YES];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [DCAuthority
      authenticateOnNavigationController:mockController
                            withClientId:@"clientId"
                            clientSecret:@"clientSecret"
                             redirectUri:@"redirectUri"
                                  scopes:@[ @"scope" ]
                                storeKey:nil
                           accessibility:NULL
                                   block:^(DCAuthenticationContext *context,
                                           NSError *error) {
            dispatch_semaphore_signal(semaphore);
        }
     ];
    BOOL isTimeout =
        [DCAuthorityAuthenticationTest waitUntilTimeOut:10 semaphore:semaphore];
    GHAssertFalse(isTimeout, @"time out.");
    GHAssertFalse([DCTestUtils keychainHasAuthentication],
            @"some authentication exists");
    GHAssertFalse([DCTestUtils keychainHasStoreKeys],
            @"some storeKey exists");
}

- (void)testID0003
{
    [DCTestUtils removeAllAuthenticationContext];

    id mockController =
        [OCMockObject mockForClass:[UINavigationController class]];

    __block DCGTMOAuth2ViewControllerTouch *viewController = nil;
    [[[mockController stub] andDo:^(NSInvocation *invocation) {
                [invocation getArgument:&viewController atIndex:2];
                viewController.authentication.accessToken = @"accessToken";
                viewController.authentication.refreshToken = @"refreshToken";
                viewController.authentication.expirationDate = [NSDate date];
                [viewController signIn:nil
                      finishedWithAuth:viewController.authentication
                                 error:nil];
            }
          ]
      pushViewController:[OCMArg any]
                animated:YES];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [DCAuthority
      authenticateOnNavigationController:mockController
                            withClientId:@"clientId"
                            clientSecret:@"clientSecret"
                             redirectUri:@"redirectUri"
                                  scopes:@[ @"scope" ]
                                storeKey:nil
                           accessibility:kSecAttrAccessibleWhenUnlocked
                                   block:^(DCAuthenticationContext *context,
                                           NSError *error) {
            dispatch_semaphore_signal(semaphore);
        }
     ];
    BOOL isTimeout =
        [DCAuthorityAuthenticationTest waitUntilTimeOut:10 semaphore:semaphore];
    GHAssertFalse(isTimeout, @"time out.");
    GHAssertFalse([DCTestUtils keychainHasAuthentication],
            @"some authentication exists");
    GHAssertFalse([DCTestUtils keychainHasStoreKeys],
            @"some storeKey exists");
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
