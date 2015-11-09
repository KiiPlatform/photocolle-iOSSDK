#import "DCAuthenticationContextTest.h"

#import "DCAuthenticationContext_Private.h"
#import "DCOAuth2Authentication.h"

#import "GTMOAuth2Authentication.h"
#import "GTMSessionFetcherService.h"

#import "OCMock/OCMock.h"

// https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dFlGYk03MTNTd0FHdzNHSm1KeExJVkE&usp=drive_web&pli=1#gid=4
@implementation DCAuthenticationContextTest

- (void)testHasSavedByKeyParamterError
{
    // ID0001
    BOOL exceptionOccured = NO;
    @try {
        [DCAuthenticationContext hasSavedByKey:nil error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"nil was assigned: key must not be nil.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0002
    exceptionOccured = NO;
    @try {
        [DCAuthenticationContext hasSavedByKey:@"" error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"out of range: key must not be empty.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0003
    GHAssertNoThrow(
        [DCAuthenticationContext hasSavedByKey:@"storeKey" error:nil],
        @"this test must not throw exception.");

    // ID0004
    {
        NSError *error = nil;
        GHAssertNoThrow(
            [DCAuthenticationContext hasSavedByKey:@"storeKey" error:&error],
            @"this test must not throw exception.");
    }
}

- (void)testSaveByKeyAccessibilityErrorParameter
{
    // ID0005
    BOOL exceptionOccured = NO;
    @try {
        DCAuthenticationContext *context =
            [[DCAuthenticationContext alloc] init];
        [context saveByKey:nil
             accessibility:kSecAttrAccessibleAfterFirstUnlock
                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"nil was assigned: key must not be nil.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0006
    exceptionOccured = NO;
    @try {
        DCAuthenticationContext *context =
            [[DCAuthenticationContext alloc] init];
        [context saveByKey:@""
             accessibility:kSecAttrAccessibleAfterFirstUnlock
                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"out of range: key must not be empty.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0007
    exceptionOccured = NO;
    @try {
        DCAuthenticationContext *context =
            [[DCAuthenticationContext alloc] init];
        [context saveByKey:@"storeKey" accessibility:NULL error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"out of range: accessibility is out of range.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0008
    exceptionOccured = NO;
    @try {
        DCAuthenticationContext *context =
            [[DCAuthenticationContext alloc] init];
        [context saveByKey:@"storeKey"
             accessibility:(__bridge CFStringRef)@"testref"
                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"out of range: accessibility is out of range.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0009
    exceptionOccured = NO;
    {
        DCOAuth2Authentication *authentication =
            [[DCOAuth2Authentication alloc] init];
        DCGTMSessionFetcherService *fecherService =
            [[DCGTMSessionFetcherService alloc] init];
        DCAuthenticationContext *context =
            [DCAuthenticationContext
              authenticationContextWithAuthentication:authentication
                                       fetcherService:fecherService
                                             storeKey:@"storeKey"];

        GHAssertNoThrow([context saveByKey:@"storeKey"
                             accessibility:kSecAttrAccessibleAfterFirstUnlock
                                     error:nil],
                @"this test must not throw exception.");
    }

    // ID0010
    {
        DCOAuth2Authentication *authentication =
            [[DCOAuth2Authentication alloc] init];
        DCGTMSessionFetcherService *fecherService =
            [[DCGTMSessionFetcherService alloc] init];
        DCAuthenticationContext *context =
            [DCAuthenticationContext
              authenticationContextWithAuthentication:authentication
                                       fetcherService:fecherService
                                             storeKey:@"storeKey"];
        NSError *error = nil;
        GHAssertNoThrow([context saveByKey:@"storeKey"
                             accessibility:kSecAttrAccessibleAfterFirstUnlock
                                     error:&error],
                @"this test must not throw exception.");
    }

}

- (void)testLoadByKeyClientIdClientSecretErrorParameter
{
    // ID0011
    BOOL exceptionOccured = NO;
    @try {
        [DCAuthenticationContext loadByKey:nil
                                  clientId:@"clientId"
                              clientSecret:@"clientSecret"
                                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"nil was assigned: key must not be nil.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0012
    exceptionOccured = NO;
    @try {
        [DCAuthenticationContext loadByKey:@""
                                  clientId:@"clientId"
                              clientSecret:@"clientSecret"
                                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"out of range: key must not be empty.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0013
    exceptionOccured = NO;
    @try {
        [DCAuthenticationContext loadByKey:@"storeKey"
                                  clientId:nil
                              clientSecret:@"clientSecret"
                                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"nil was assigned: clientId must not be nil.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0014
    exceptionOccured = NO;
    @try {
        [DCAuthenticationContext loadByKey:@"storeKey"
                                  clientId:@""
                              clientSecret:@"clientSecret"
                                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"out of range: clientId must not be empty.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0015
    exceptionOccured = NO;
    @try {
        [DCAuthenticationContext loadByKey:@"storeKey"
                                  clientId:@"clientId"
                              clientSecret:nil
                                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"nil was assigned: clientSecret must not be nil.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0016
    exceptionOccured = NO;
    @try {
        [DCAuthenticationContext loadByKey:@"storeKey"
                                  clientId:@"clientId"
                              clientSecret:@""
                                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"out of range: clientSecret must not be empty.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0017
    GHAssertNoThrow(
        [DCAuthenticationContext loadByKey:@"storeKey"
                                  clientId:@"clientId"
                              clientSecret:@"clientSecret"
                                     error:nil],
        @"this test must not throw exception.");

    // ID0018
    {
        NSError *error = nil;
        GHAssertNoThrow(
            [DCAuthenticationContext loadByKey:@"storeKey"
                                      clientId:@"clientId"
                                  clientSecret:@"clientSecret"
                                         error:&error],
            @"this test must not throw exception.");
    }
}

- (void)testRemoveByKeyErrorParameter
{
    // ID0019
    BOOL exceptionOccured = NO;
    @try {
        [DCAuthenticationContext removeByKey:nil error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"nil was assigned: key must not be nil.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0020
    exceptionOccured = NO;
    @try {
        [DCAuthenticationContext removeByKey:@"" error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"out of range: key must not be empty.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0021
    exceptionOccured = NO;
    GHAssertNoThrow(
        [DCAuthenticationContext removeByKey:@"storeKey" error:nil],
        @"this test must not throw exception.");

    // ID0022
    {
        NSError *error = nil;
        GHAssertNoThrow(
            [DCAuthenticationContext removeByKey:@"storeKey" error:&error],
            @"this test must not throw exception.");
    }
}

- (void)testRemoveAddWithError
{
    // ID0023
    GHAssertNoThrow([DCAuthenticationContext removeAllWithError:nil],
            @"this test must not throw exception.");

    // ID0024
    {
        NSError *error = nil;
        GHAssertNoThrow([DCAuthenticationContext removeAllWithError:&error],
                @"this test must not throw exception.");
    }
}

- (void)testLoadByKeyError
{
    // ID0025
    BOOL exceptionOccured = NO;
    @try {
        [DCAuthenticationContext loadByKey:nil
                                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"nil was assigned: key must not be nil.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0026
    exceptionOccured = NO;
    @try {
        [DCAuthenticationContext loadByKey:@""
                                     error:nil];
    } @catch (NSException *actual) {
        exceptionOccured = YES;
        GHAssertEqualStrings(NSInvalidArgumentException, actual.name,
                @"name is invalid");
        GHAssertEqualStrings(@"out of range: key must not be empty.",
                actual.reason, @"reason is invalid");
    } @catch (id exception) {
        GHFail(@"invalid exception: expected=%@, actual=%@",
            NSInvalidArgumentException, NSStringFromClass([exception class]));
    }
    GHAssertTrue(exceptionOccured, @"exception must be occurred");

    // ID0027
    GHAssertNoThrow(
        [DCAuthenticationContext loadByKey:@"storeKey"
                                     error:nil],
        @"this test must not throw exception.");

    // ID0028
    {
        NSError *error = nil;
        GHAssertNoThrow(
            [DCAuthenticationContext loadByKey:@"storeKey"
                                      clientId:@"clientId"
                                  clientSecret:@"clientSecret"
                                         error:&error],
            @"this test must not throw exception.");
    }
}

- (void)testRemainingTime
{
    // ID0009
    {
        id mockAuth = [OCMockObject mockForClass:[DCOAuth2Authentication class]];
        [[[mockAuth stub] andReturn:[NSDate dateWithTimeIntervalSinceNow:300L]] expirationDate];
        DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
        context.authentication = mockAuth;
        GHAssertTrue([context remainingTimeInSeconds] > 0,
                @"remainingTime must return positive number.");
    }

    // ID0009
    {
        id mockAuth = [OCMockObject mockForClass:[DCOAuth2Authentication class]];
        [[[mockAuth stub] andReturn:[NSDate dateWithTimeIntervalSinceNow:-300L]] expirationDate];
        DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
        context.authentication = mockAuth;
        GHAssertTrue([context remainingTimeInSeconds] < 0,
                @"remainingTime must return negative number.");
    }
}
@end
