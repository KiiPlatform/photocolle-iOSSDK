#import "DCAuthenticationContextKeyChainTest.h"

#import "DCAuthenticationContext_Private.h"
#import "DCOAuth2Authentication.h"
#import "GTMHTTPFetcherService.h"
#import "DCErrors.h"
#import "DCTestUtils.h"
#import "DCTypeRefHolder.h"

static NSString * const KEY_STOREKEY = @"storeKey";
static NSString * const AUTHENTICATION = @"authentication";
static NSString * const ACCESSTOKEN = @"accessToken";
static NSString * const REFRESHTOKEN = @"refreshToken";
static NSString * const CLIENTID = @"clientId";
static NSString * const CLIENTSECRET = @"clientSecret";
static NSString * const ACCESSIBILITY = @"accessibility";

// https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dFlGYk03MTNTd0FHdzNHSm1KeExJVkE&usp=drive_web#gid=6
@implementation DCAuthenticationContextKeyChainTest

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
    NSString *storeKeyValue = @"storeKey";
    CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insertData = @{
                KEY_STOREKEY : storeKeyValue,
              AUTHENTICATION : @{
                        ACCESSTOKEN : @"accessToken",
                       REFRESHTOKEN : @"refreshToken",
                           CLIENTID : @"clientId",
                       CLIENTSECRET : @"clientSecret",
                      ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
                }
    };

    DCAuthenticationContext *context = [DCAuthenticationContextKeyChainTest
            createAuthenticationContext:insertData];
    GHAssertTrue([context saveByKey:insertData[KEY_STOREKEY]
                     accessibility:((DCTypeRefHolder *)insertData[AUTHENTICATION][ACCESSIBILITY]).ref
                             error:nil],
            @"fail to save");

    DCOAuth2Authentication *authentication = [DCTestUtils loadAuthentication:storeKeyValue];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:authentication
                                                     toDictionary:insertData[AUTHENTICATION]] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [insertData[AUTHENTICATION] description],
               [[DCAuthenticationContextKeyChainTest
                    toDictionaryWithOAuth:authentication] description]);
    }
}

- (void)testID0002
{
    NSString *storeKeyValue = @"storeKey";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
            ACCESSTOKEN : @"accessToken",
           REFRESHTOKEN : @"refreshToken",
          ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKeyValue];
    }

    CFTypeRef UPDATE_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *updateData = @{
            KEY_STOREKEY : storeKeyValue,
          AUTHENTICATION : @{
                    ACCESSTOKEN : @"accessToken_update",
                   REFRESHTOKEN : @"refreshToken_update",
                       CLIENTID : @"clientId",
                   CLIENTSECRET : @"clientSecret",
                  ACCESSIBILITY : [DCTypeRefHolder holder:UPDATE_REF]
            }
    };
    DCAuthenticationContext *context = [DCAuthenticationContextKeyChainTest
            createAuthenticationContext:updateData];
    GHAssertTrue([context saveByKey:updateData[KEY_STOREKEY]
                      accessibility:((DCTypeRefHolder *)updateData[AUTHENTICATION][ACCESSIBILITY]).ref
                              error:nil],
            @"fail to save");

    DCOAuth2Authentication *authentication = [DCTestUtils loadAuthentication:storeKeyValue];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:authentication
                                                     toDictionary:updateData[AUTHENTICATION]] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [updateData[AUTHENTICATION] description],
               [[DCAuthenticationContextKeyChainTest
                 toDictionaryWithOAuth:authentication] description]);
    }
}

- (void)testID0003
{
    NSString *anotherKey = @"storeKey_another";
    CFTypeRef ANOTHER_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *anotherData = @{
            ACCESSTOKEN : @"accessToken_another",
           REFRESHTOKEN : @"refreshToken_another",
          ACCESSIBILITY : [DCTypeRefHolder holder:ANOTHER_REF]
    };
    [DCTestUtils saveAuthenticationContextWithFields:anotherData
                                          toStoreKey:anotherKey];

    NSString *storeKeyValue = @"storeKey";
    CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insertData = @{
            KEY_STOREKEY : storeKeyValue,
          AUTHENTICATION : @{
                    ACCESSTOKEN : @"accessToken",
                   REFRESHTOKEN : @"refreshToken",
                       CLIENTID : @"clientId",
                   CLIENTSECRET : @"clientSecret",
                  ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
            }
    };
    DCAuthenticationContext *context = [DCAuthenticationContextKeyChainTest
            createAuthenticationContext:insertData];
    GHAssertTrue([context saveByKey:insertData[KEY_STOREKEY]
                      accessibility:((DCTypeRefHolder *)insertData[AUTHENTICATION][ACCESSIBILITY]).ref
                              error:nil],
                 @"fail to save");

    DCOAuth2Authentication *authentication = [DCTestUtils loadAuthentication:storeKeyValue];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:authentication
                                                     toDictionary:insertData[AUTHENTICATION]] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [insertData[AUTHENTICATION] description],
               [[DCAuthenticationContextKeyChainTest
                 toDictionaryWithOAuth:authentication] description]);
    }

    DCOAuth2Authentication *another = [DCTestUtils loadAuthentication:anotherKey];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:another
                                                     toDictionary:anotherData] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [anotherData description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:another] description]);
    }
}

- (void)testID0004
{
    NSString *anotherKey = @"storeKey_another";
    CFTypeRef ANOTHER_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *anotherData = @{
            ACCESSTOKEN : @"accessToken_another",
            REFRESHTOKEN : @"refreshToken_another",
            ACCESSIBILITY : [DCTypeRefHolder holder:ANOTHER_REF]
    };
    [DCTestUtils saveAuthenticationContextWithFields:anotherData
                                          toStoreKey:anotherKey];

    NSString *storeKeyValue = @"storeKey";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken",
               REFRESHTOKEN : @"refreshToken",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKeyValue];
    }

    CFTypeRef UPDATE_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *updateData = @{
            KEY_STOREKEY : storeKeyValue,
          AUTHENTICATION : @{
                    ACCESSTOKEN : @"accessToken",
                   REFRESHTOKEN : @"refreshToken",
                       CLIENTID : @"clientId",
                   CLIENTSECRET : @"clientSecret",
                  ACCESSIBILITY : [DCTypeRefHolder holder:UPDATE_REF]
            }
    };
    DCAuthenticationContext *context = [DCAuthenticationContextKeyChainTest
            createAuthenticationContext:updateData];
    GHAssertTrue([context saveByKey:updateData[KEY_STOREKEY]
                      accessibility:((DCTypeRefHolder *)updateData[AUTHENTICATION][ACCESSIBILITY]).ref
                              error:nil],
                 @"fail to save");

    DCOAuth2Authentication *authentication = [DCTestUtils loadAuthentication:storeKeyValue];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:authentication
                                                     toDictionary:updateData[AUTHENTICATION]] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [updateData[AUTHENTICATION] description],
               [[DCAuthenticationContextKeyChainTest
                 toDictionaryWithOAuth:authentication] description]);
    }

    DCOAuth2Authentication *another = [DCTestUtils loadAuthentication:anotherKey];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:another
                                                     toDictionary:anotherData] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [anotherData description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:another] description]);
    }
}

- (void)testID0005
{
    NSString *storeKeyValue = @"storeKey";
    CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insertData = @{
            KEY_STOREKEY : storeKeyValue,
          AUTHENTICATION : @{
                    ACCESSTOKEN : @"accessToken",
                   REFRESHTOKEN : @"refreshToken",
                       CLIENTID : @"clientId",
                   CLIENTSECRET : @"clientSecret",
                  ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
            }
    };

    DCAuthenticationContext *context = [DCAuthenticationContextKeyChainTest
            createAuthenticationContext:insertData];
    GHAssertTrue([context saveByKey:insertData[KEY_STOREKEY]
                      accessibility:((DCTypeRefHolder *)insertData[AUTHENTICATION][ACCESSIBILITY]).ref
                              error:nil],
                 @"fail to save");

    DCOAuth2Authentication *authentication = [DCTestUtils loadAuthentication:storeKeyValue];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:authentication
                                                     toDictionary:insertData[AUTHENTICATION]] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [insertData[AUTHENTICATION] description],
               [[DCAuthenticationContextKeyChainTest
                 toDictionaryWithOAuth:authentication] description]);
    }

    NSString *anotherKey = @"storeKey_another";
    GHAssertTrue([context saveByKey:anotherKey
                      accessibility:((DCTypeRefHolder *)insertData[AUTHENTICATION][ACCESSIBILITY]).ref
                              error:nil],
                 @"fail to save");

    GHAssertNil([DCTestUtils loadAuthentication:storeKeyValue],
                @"must be fail to load by old key.");
    DCOAuth2Authentication *another = [DCTestUtils loadAuthentication:anotherKey];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:another
                                                     toDictionary:insertData[AUTHENTICATION]] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [insertData[AUTHENTICATION] description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:another] description]);
    }
}

- (void)testID0006
{
    NSError *error = nil;
    GHAssertNil([DCAuthenticationContext loadByKey:@"storeKey"
                                          clientId:@"clientId"
                                      clientSecret:@"clientSecret"
                                             error:&error],
            @"keychain does not contains any records.");
    GHAssertNotNil(error, @"error must not be nil.");
    GHAssertEquals(DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED,
            error.code, @"code must be same.");
    GHAssertNotNil([error.userInfo objectForKey:NSUnderlyingErrorKey],
            @"cause must not be nil.");
}

- (void)testID0007
{
    {
        NSString *anotherKey = @"storeKey_another";
        CFTypeRef ANOTHER_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *anotherData = @{
                ACCESSTOKEN : @"accessToken_another",
               REFRESHTOKEN : @"refreshToken_another",
              ACCESSIBILITY : [DCTypeRefHolder holder:ANOTHER_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:anotherData
                                              toStoreKey:anotherKey];
    }

    NSError *error = nil;
    GHAssertNil([DCAuthenticationContext loadByKey:@"storeKey"
                                          clientId:@"clientId"
                                      clientSecret:@"clientSecret"
                                             error:&error],
            @"keychain does not contains any records.");
    GHAssertNotNil(error, @"error must not be nil.");
    GHAssertEquals(DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED,
            error.code, @"code must be same.");
    GHAssertNotNil([error.userInfo objectForKey:NSUnderlyingErrorKey],
            @"cause must not be nil.");
}

- (void)testID0008
{
    NSString *storeKeyValue = @"storeKey";
    {
        CFTypeRef ANOTHER_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *anotherData = @{
                ACCESSTOKEN : @"accessToken",
                REFRESHTOKEN : @"refreshToken",
                ACCESSIBILITY : [DCTypeRefHolder holder:ANOTHER_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:anotherData
                                              toStoreKey:storeKeyValue];
    }
    [DCTestUtils removeAuthenticationContext:storeKeyValue];

    NSError *error = nil;
    GHAssertNil([DCAuthenticationContext loadByKey:storeKeyValue
                                          clientId:@"clientId"
                                      clientSecret:@"clientSecret"
                                             error:&error],
                @"keychain does not contains any records.");
    GHAssertNotNil(error, @"error must not be nil.");
    GHAssertEquals(DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED,
                   error.code, @"code must be same.");
    GHAssertNotNil([error.userInfo objectForKey:NSUnderlyingErrorKey],
                   @"cause must not be nil.");
}

- (void)testID0009
{
    NSString *storeKeyValue = @"storeKey";
    CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insertData = @{
            KEY_STOREKEY : storeKeyValue,
          AUTHENTICATION : @{
                    ACCESSTOKEN : @"accessToken",
                   REFRESHTOKEN : @"refreshToken",
                       CLIENTID : @"clientId",
                   CLIENTSECRET : @"clientSecret",
                  ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
            }
    };
    [DCTestUtils saveAuthenticationContextWithFields:insertData[AUTHENTICATION]
                                          toStoreKey:storeKeyValue];

    NSError *error = nil;
    DCAuthenticationContext *context = [DCAuthenticationContext loadByKey:storeKeyValue
                                                                 clientId:@"clientId"
                                                             clientSecret:@"clientSecret"
                                                                     error:&error];
    GHAssertNil(error, @"error must be nil.");
    GHAssertNotNil(context, @"context must not be nil.");
    if ([DCAuthenticationContextKeyChainTest equalsPropertiesOf:context
                                                   toDictionary:insertData] == NO) {
        GHFail(@"must be same object: expected=%@ inserted=%@",
               [insertData description],
               [[DCAuthenticationContextKeyChainTest toDictionary:context] description]);
    }
}

- (void)testID0010
{
    NSString *storeKeyValue = @"storeKey";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken",
               REFRESHTOKEN : @"refreshToken",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKeyValue];
    }

    CFTypeRef UPDATE_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *updateData = @{
            KEY_STOREKEY : storeKeyValue,
          AUTHENTICATION : @{
                    ACCESSTOKEN : @"accessToken_update",
                   REFRESHTOKEN : @"refreshToken_update",
                       CLIENTID : @"clientId",
                   CLIENTSECRET : @"clientSecret",
                  ACCESSIBILITY : [DCTypeRefHolder holder:UPDATE_REF]
            }
    };
    [DCTestUtils saveAuthenticationContextWithFields:updateData[AUTHENTICATION]
                                          toStoreKey:storeKeyValue];

    NSError *error = nil;
    DCAuthenticationContext *context = [DCAuthenticationContext loadByKey:storeKeyValue
                                                                 clientId:@"clientId"
                                                             clientSecret:@"clientSecret"
                                                                    error:&error];
    GHAssertNil(error, @"error must be nil.");
    GHAssertNotNil(context, @"context must not be nil.");
    if ([DCAuthenticationContextKeyChainTest equalsPropertiesOf:context
                                                   toDictionary:updateData] == NO) {
        GHFail(@"must be same object: expected=%@ inserted=%@",
               [updateData description],
               [[DCAuthenticationContextKeyChainTest toDictionary:context] description]);
    }
}

- (void)testID0011
{
    NSString *storeKey1Value = @"storeKey_1";
    CFTypeRef INSERT_1_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insert1Data = @{
            KEY_STOREKEY : storeKey1Value,
            AUTHENTICATION : @{
                    ACCESSTOKEN : @"accessToken_1",
                   REFRESHTOKEN : @"refreshToken_1",
                       CLIENTID : @"clientId_1",
                   CLIENTSECRET : @"clientSecret_1",
                  ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_1_REF]
            }
    };
    [DCTestUtils saveAuthenticationContextWithFields:insert1Data[AUTHENTICATION]
                                          toStoreKey:storeKey1Value];

    NSString *storeKey2Value = @"storeKey_2";
    CFTypeRef INSERT_2_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insert2Data = @{
            KEY_STOREKEY : storeKey2Value,
          AUTHENTICATION : @{
                    ACCESSTOKEN : @"accessToken_2",
                   REFRESHTOKEN : @"refreshToken_2",
                       CLIENTID : @"clientId_2",
                   CLIENTSECRET : @"clientSecret_2",
                  ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_2_REF]
            }
    };
    [DCTestUtils saveAuthenticationContextWithFields:insert2Data[AUTHENTICATION]
                                          toStoreKey:storeKey2Value];

    NSError *error = nil;
    DCAuthenticationContext *context1 = [DCAuthenticationContext loadByKey:storeKey1Value
                                                                  clientId:@"clientId_1"
                                                              clientSecret:@"clientSecret_1"
                                                                     error:&error];
    GHAssertNil(error, @"error must be nil.");
    GHAssertNotNil(context1, @"context1 must not be nil.");
    if ([DCAuthenticationContextKeyChainTest equalsPropertiesOf:context1
                                                   toDictionary:insert1Data] == NO) {
        GHFail(@"must be same object: expected=%@ inserted=%@",
               [insert1Data description],
               [[DCAuthenticationContextKeyChainTest toDictionary:context1] description]);
    }

    DCAuthenticationContext *context2 = [DCAuthenticationContext loadByKey:storeKey2Value
                                                                  clientId:@"clientId_2"
                                                              clientSecret:@"clientSecret_2"
                                                                     error:&error];
    GHAssertNil(error, @"error must be nil.");
    GHAssertNotNil(context2, @"context2 must not be nil.");
    if ([DCAuthenticationContextKeyChainTest equalsPropertiesOf:context2
                                                   toDictionary:insert2Data] == NO) {
        GHFail(@"must be same object: expected=%@ inserted=%@",
               [insert2Data description],
               [[DCAuthenticationContextKeyChainTest toDictionary:context2] description]);
    }
}

- (void)testID0012
{
    NSError *error = nil;
    GHAssertFalse([DCAuthenticationContext removeByKey:@"storeKey"
                                             error:&error],
            @"keychain does not contains any records.");
    GHAssertNotNil(error, @"error must not be nil.");
    GHAssertEquals(DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED,
            error.code, @"code must be same.");
}

- (void)testID0013
{
    {
        CFTypeRef ANOTHER_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *anotherData = @{
                ACCESSTOKEN : @"accessToken_another",
               REFRESHTOKEN : @"refreshToken_another",
              ACCESSIBILITY : [DCTypeRefHolder holder:ANOTHER_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:anotherData
                                              toStoreKey:@"storeKey_another"];
    }

    NSError *error = nil;
    GHAssertFalse([DCAuthenticationContext removeByKey:@"storeKey"
                                                 error:&error],
            @"keychain does not contains any records.");
    GHAssertNotNil(error, @"error must not be nil.");
    GHAssertEquals(DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED,
            error.code, @"code must be same.");
}

- (void)testID0014
{
    NSString *storeKeyValue = @"storeKey";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken",
               REFRESHTOKEN : @"refreshToken",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKeyValue];
    }

    NSError *error = nil;
    GHAssertTrue([DCAuthenticationContext removeByKey:storeKeyValue
                                                error:&error],
            @"removing record with storeKey must succeed");
    GHAssertNil(error, @"error must not be nil");

    GHAssertNil([DCTestUtils loadAuthentication:storeKeyValue],
            @"target record still remains.");
}

- (void)testID0015
{
    NSString *storeKeyValue = @"storeKey";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken",
               REFRESHTOKEN : @"refreshToken",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKeyValue];
    }

    NSString *anotherKey = @"storeKey_another";
    {
        CFTypeRef ANOTHER_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *anotherData = @{
                ACCESSTOKEN : @"accessToken_another",
               REFRESHTOKEN : @"refreshToken_another",
              ACCESSIBILITY : [DCTypeRefHolder holder:ANOTHER_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:anotherData
                                              toStoreKey:anotherKey];
    }

    NSError *error = nil;
    GHAssertTrue([DCAuthenticationContext removeByKey:storeKeyValue
                                                error:&error],
            @"removing record with storeKey must succeed");
    GHAssertNil(error, @"error must not be nil");

    GHAssertNil([DCTestUtils loadAuthentication:storeKeyValue],
            @"target record still remains.");
    GHAssertNotNil([DCTestUtils loadAuthentication:anotherKey],
            @"another record must not remove.");
}

- (void)testID0016
{
    NSString *storeKeyValue = @"storeKey";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken",
               REFRESHTOKEN : @"refreshToken",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKeyValue];
    }

    {
        CFTypeRef UPDATE_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *updateData = @{
                ACCESSTOKEN : @"accessToken_another",
               REFRESHTOKEN : @"refreshToken_another",
              ACCESSIBILITY : [DCTypeRefHolder holder:UPDATE_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:updateData
                                              toStoreKey:storeKeyValue];
    }

    NSError *error = nil;
    GHAssertTrue([DCAuthenticationContext removeByKey:storeKeyValue
                                                error:&error],
            @"removing record with storeKey must succeed");
    GHAssertNil(error, @"error must not be nil");

    GHAssertNil([DCTestUtils loadAuthentication:storeKeyValue],
            @"target record still remains.");
}

- (void)testID0017
{
    NSError *error = nil;
    GHAssertTrue([DCAuthenticationContext removeAllWithError:&error],
            @"fail to remove.");
    GHAssertNil(error, @"error must be nil.");

    GHAssertFalse([DCTestUtils keychainHasAuthentication],
            @"keychain must not have any records.");
}

- (void)testID0018
{
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken",
               REFRESHTOKEN : @"refreshToken",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:@"storeKey"];
    }

    NSError *error = nil;
    GHAssertTrue([DCAuthenticationContext removeAllWithError:&error],
            @"fail to remove.");
    GHAssertNil(error, @"error must be nil.");

    GHAssertFalse([DCTestUtils keychainHasAuthentication],
            @"keychain must not have any records.");
}

- (void)testID0019
{
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken_1",
               REFRESHTOKEN : @"refreshToken_1",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:@"storeKey_1"];
    }

    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken_2",
               REFRESHTOKEN : @"refreshToken_2",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:@"storeKey_2"];
    }

    NSError *error = nil;
    GHAssertTrue([DCAuthenticationContext removeAllWithError:&error],
            @"fail to remove.");
    GHAssertNil(error, @"error must be nil.");

    GHAssertFalse([DCTestUtils keychainHasAuthentication],
            @"keychain must not have any records.");
}

- (void)testID0020
{
    NSString *storeKeyValue = @"storeKey";
    NSError *error = nil;
    GHAssertFalse([DCAuthenticationContext hasSavedByKey:storeKeyValue
                                                   error:&error],
            @"a record whose storeKey is storeKey must not contain");
    GHAssertNil(error, @"error must be nil.");

    GHAssertNil([DCTestUtils loadAuthentication:storeKeyValue],
            @"target record must not be created.");
}

- (void)testID0021
{
    NSString *anotherKey = @"storeKey_another";
    CFTypeRef ANOTHER_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *anotherData = @{
            ACCESSTOKEN : @"accessToken_another",
           REFRESHTOKEN : @"refreshToken_another",
          ACCESSIBILITY : [DCTypeRefHolder holder:ANOTHER_REF]
    };
    [DCTestUtils saveAuthenticationContextWithFields:anotherData
                                          toStoreKey:anotherKey];

    NSString *storeKeyValue = @"storeKey";
    NSError *error = nil;
    GHAssertFalse([DCAuthenticationContext hasSavedByKey:storeKeyValue
                                                   error:&error],
            @"a record whose storeKey is storeKey must not contain");
    GHAssertNil(error, @"error must be nil.");

    GHAssertNil([DCTestUtils loadAuthentication:storeKeyValue],
            @"target record must not be created.");

    DCOAuth2Authentication *authentication = [DCTestUtils loadAuthentication:anotherKey];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:authentication
                                                     toDictionary:anotherData] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [anotherData description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:authentication]
                    description]);
    }
}

- (void)testID0022
{
    NSString *storeKeyValue = @"storeKey";
    CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insertData = @{
            ACCESSTOKEN : @"accessToken",
           REFRESHTOKEN : @"refreshToken",
          ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
    };
    [DCTestUtils saveAuthenticationContextWithFields:insertData
                                          toStoreKey:storeKeyValue];

    NSError *error = nil;
    GHAssertTrue([DCAuthenticationContext hasSavedByKey:storeKeyValue
                                                  error:&error],
            @"a record which storeKey is storeKey must contain");
    GHAssertNil(error, @"error must be nil.");

    DCOAuth2Authentication *authentication = [DCTestUtils loadAuthentication:storeKeyValue];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:authentication
                                                     toDictionary:insertData] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [insertData description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:authentication]
                    description]);
    }
}

- (void)testID0023
{
    NSString *storeKeyValue = @"storeKey";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken",
               REFRESHTOKEN : @"refreshToken",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKeyValue];
    }

    CFTypeRef UPDATE_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *updateData = @{
            ACCESSTOKEN : @"accessToken_update",
           REFRESHTOKEN : @"refreshToken_update",
          ACCESSIBILITY : [DCTypeRefHolder holder:UPDATE_REF]
    };
    [DCTestUtils saveAuthenticationContextWithFields:updateData
                                          toStoreKey:storeKeyValue];

    NSError *error = nil;
    GHAssertTrue([DCAuthenticationContext hasSavedByKey:storeKeyValue
                                                  error:&error],
            @"a record which storeKey is storeKey must contain");
    GHAssertNil(error, @"error must be nil.");

    DCOAuth2Authentication *authentication = [DCTestUtils loadAuthentication:storeKeyValue];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:authentication
                                                     toDictionary:updateData] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [updateData description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:authentication]
                    description]);
    }
}

- (void)testID0024
{
    NSString *storeKey1 = @"storeKey_1";
    CFTypeRef INSERT_1_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insert1Data = @{
            ACCESSTOKEN : @"accessToken_1",
           REFRESHTOKEN : @"refreshToken_1",
          ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_1_REF]
    };
    [DCTestUtils saveAuthenticationContextWithFields:insert1Data
                                          toStoreKey:storeKey1];

    NSString *storeKey2 = @"storeKey_2";
    CFTypeRef INSERT_2_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insert2Data = @{
            ACCESSTOKEN : @"accessToken_2",
           REFRESHTOKEN : @"refreshToken_2",
          ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_2_REF]
    };
    [DCTestUtils saveAuthenticationContextWithFields:insert2Data
                                          toStoreKey:storeKey2];

    NSError *error = nil;
    GHAssertTrue([DCAuthenticationContext hasSavedByKey:storeKey1
                                                  error:&error],
            @"record1 which storeKey is storeKey must contain");
    GHAssertNil(error, @"error must be nil.");
    GHAssertTrue([DCAuthenticationContext hasSavedByKey:storeKey2
                                                  error:&error],
            @"record2 which storeKey is storeKey must contain");
    GHAssertNil(error, @"error must be nil.");

    DCOAuth2Authentication *auth1 = [DCTestUtils loadAuthentication:storeKey1];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:auth1
                                                     toDictionary:insert1Data] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [insert1Data description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:auth1]
                    description]);
    }
    DCOAuth2Authentication *auth2 = [DCTestUtils loadAuthentication:storeKey2];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:auth2
                                                     toDictionary:insert2Data] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [insert2Data description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:auth2]
                    description]);
    }
}

- (void)testID0025
{
    NSString *storeKey1 = @"storeKey_1";
    {
        CFTypeRef INSERT_1_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insert1Data = @{
                ACCESSTOKEN : @"accessToken_1",
               REFRESHTOKEN : @"refreshToken_1",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_1_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insert1Data
                                              toStoreKey:storeKey1];
    }

    NSString *storeKey2 = @"storeKey_2";
    CFTypeRef INSERT_2_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *insert2Data = @{
                ACCESSTOKEN : @"accessToken_2",
               REFRESHTOKEN : @"refreshToken_2",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_2_REF]
    };
    [DCTestUtils saveAuthenticationContextWithFields:insert2Data
                                          toStoreKey:storeKey2];

    [DCTestUtils removeAuthenticationContext:storeKey1];

    NSError *error = nil;
    GHAssertFalse([DCAuthenticationContext hasSavedByKey:storeKey1
                                                  error:&error],
            @"record1 which storeKey is storeKey must not contain");
    GHAssertNil(error, @"error must be nil.");
    GHAssertTrue([DCAuthenticationContext hasSavedByKey:storeKey2
                                                  error:&error],
            @"record2 which storeKey is storeKey must contain");
    GHAssertNil(error, @"error must be nil.");

    GHAssertNil([DCTestUtils loadAuthentication:storeKey1],
            @"record1 must not be created.");

    DCOAuth2Authentication *auth2 = [DCTestUtils loadAuthentication:storeKey2];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:auth2
                                                     toDictionary:insert2Data] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [insert2Data description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:auth2]
                description]);
    }
}

- (void)testID0026
{
    NSString *storeKeyValue = @"storeKey";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken",
               REFRESHTOKEN : @"refreshToken",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKeyValue];
    }

    [DCTestUtils removeAuthenticationContext:storeKeyValue];

    NSError *error = nil;
    GHAssertFalse([DCAuthenticationContext hasSavedByKey:storeKeyValue
                                                   error:&error],
            @"a record which storeKey is storeKey must not contain");
    GHAssertNil(error, @"error must be nil.");

    GHAssertNil([DCTestUtils loadAuthentication:storeKeyValue],
            @"target record must not be created.");
}

- (void)testID0027
{
    NSString *storeKey1 = @"storeKey_1";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken_1",
               REFRESHTOKEN : @"refreshToken_1",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKey1];
    }

    NSString *storeKey2 = @"storeKey_2";
    {
        CFTypeRef INSERT_REF = kSecAttrAccessibleAfterFirstUnlock;
        NSDictionary *insertData = @{
                ACCESSTOKEN : @"accessToken_2",
               REFRESHTOKEN : @"refreshToken_2",
              ACCESSIBILITY : [DCTypeRefHolder holder:INSERT_REF]
        };
        [DCTestUtils saveAuthenticationContextWithFields:insertData
                                              toStoreKey:storeKey2];
    }

    CFTypeRef UPDATE_REF = kSecAttrAccessibleAfterFirstUnlock;
    NSDictionary *updateData = @{
            KEY_STOREKEY : storeKey1,
          AUTHENTICATION : @{
                    ACCESSTOKEN : @"accessToken_update",
                   REFRESHTOKEN : @"refreshToken_update",
                       CLIENTID : @"clientId",
                   CLIENTSECRET : @"clientSecret",
                  ACCESSIBILITY : [DCTypeRefHolder holder:UPDATE_REF]
            }
    };
    DCAuthenticationContext *context = [DCAuthenticationContextKeyChainTest
            createAuthenticationContext:updateData];
    GHAssertTrue([context saveByKey:storeKey2
                      accessibility:((DCTypeRefHolder *)updateData[AUTHENTICATION][ACCESSIBILITY]).ref
                              error:nil],
            @"fail to save");

    GHAssertNil([DCTestUtils loadAuthentication:storeKey1],
            @"a record which storeKey is storeKey_1 must not contain.");

    DCOAuth2Authentication *authentication = [DCTestUtils loadAuthentication:storeKey2];
    if ([DCAuthenticationContextKeyChainTest equalsAuthentication:authentication
                                                     toDictionary:updateData[AUTHENTICATION]] == NO) {
        GHFail(@"must be same object: expected=%@ loaded=%@",
               [updateData[AUTHENTICATION] description],
               [[DCAuthenticationContextKeyChainTest toDictionaryWithOAuth:authentication]
                    description]);
    }
}

+ (DCAuthenticationContext *)createAuthenticationContext:(NSDictionary *)fields
{
    NSString *storeKey = fields[KEY_STOREKEY];
    NSString *accessToken = fields[AUTHENTICATION][ACCESSTOKEN];
    NSString *refreshToken = fields[AUTHENTICATION][REFRESHTOKEN];
    NSString *clientId =  fields[AUTHENTICATION][CLIENTID];
    NSString *clientSecret =  fields[AUTHENTICATION][CLIENTSECRET];
    CFTypeRef accessibility =
        ((DCTypeRefHolder *)fields[AUTHENTICATION][ACCESSIBILITY]).ref;

    NSURL *tokenURL = [NSURL URLWithString:@"http://localhost"];
    DCOAuth2Authentication *authentication =
        [DCOAuth2Authentication
          authenticationWithServiceProvider:@"ServiceName"
                                   tokenURL:tokenURL
                                redirectURI:@"redirectUri"
                                   clientID:clientId
                               clientSecret:clientSecret];
    authentication.accessToken = accessToken;
    authentication.refreshToken = refreshToken;
    authentication.accessibility = accessibility;
    DCGTMSessionFetcherService *fecherService =
        [[DCGTMSessionFetcherService alloc] init];
    return [DCAuthenticationContext
          authenticationContextWithAuthentication:authentication
                                   fetcherService:fecherService
                                         storeKey:storeKey];
}

+ (BOOL)equalsAuthentication:(DCOAuth2Authentication *)authentication
                toDictionary:(NSDictionary *)dictionary
{
    if ([authentication.accessToken isEqualToString:dictionary[ACCESSTOKEN]] == NO) {
        return NO;
    } else if ([authentication.refreshToken isEqualToString:dictionary[REFRESHTOKEN]] == NO) {
        return NO;
    } else if (((DCOAuth2Authentication *)(authentication)).accessibility !=
            ((DCTypeRefHolder *)dictionary[ACCESSIBILITY]).ref) {
        return NO;
    }
    return YES;
}

+ (BOOL)equalsPropertiesOf:(DCAuthenticationContext *)context
              toDictionary:(NSDictionary *)dictionary
{
    if([context.storeKey isEqualToString:dictionary[KEY_STOREKEY]] == NO) {
        return NO;
    } else if ([context.authentication.accessToken
                   isEqualToString:dictionary[AUTHENTICATION][ACCESSTOKEN]]
            == NO) {
        return NO;
    } else if ([context.authentication.refreshToken
                   isEqualToString:dictionary[AUTHENTICATION][REFRESHTOKEN]]
            == NO) {
        return NO;
    } else if ([context.authentication.clientID
                   isEqualToString:dictionary[AUTHENTICATION][CLIENTID]]
            == NO) {
        return NO;
    } else if ([context.authentication.clientSecret
                   isEqualToString:dictionary[AUTHENTICATION][CLIENTSECRET]]
            == NO) {
        return NO;
    } else if (
        ((DCOAuth2Authentication *)(context.authentication)).accessibility !=
            ((DCTypeRefHolder *)dictionary[AUTHENTICATION][ACCESSIBILITY]).ref) {
        return NO;
    }
    return YES;
}

+ (NSDictionary *)toDictionary:(DCAuthenticationContext *)context
{
    CFTypeRef ref =
        ((DCOAuth2Authentication *)(context.authentication)).accessibility;
    return @{ KEY_STOREKEY :context.storeKey,
              AUTHENTICATION : @{
                  ACCESSTOKEN : context.authentication.accessToken,
                  REFRESHTOKEN : context.authentication.refreshToken,
                  CLIENTID : context.authentication.clientID,
                  CLIENTSECRET : context.authentication.clientSecret,
                  ACCESSIBILITY : [DCTypeRefHolder holder:ref]}
    };

}

+ (NSDictionary *)toDictionaryWithOAuth:(DCOAuth2Authentication *)authentication
{
    CFTypeRef ref = authentication.accessibility;
    return @{ACCESSTOKEN : authentication.accessToken,
            REFRESHTOKEN : authentication.refreshToken,
           ACCESSIBILITY : [DCTypeRefHolder holder:ref]};
}

@end
