#import "DCTestUtils.h"

#import <GHUnitIOS/GHTestCase.h>

#import "DCTypeRefHolder.h"

#import "DCOAuth2Authentication.h"

NSString * const DCTESTKEY_ACCESSTOKEN = @"accessToken";
NSString * const DCTESTKEY_REFRESHTOKEN = @"refreshToken";
NSString * const DCTESTKEY_CLIENTID = @"clientId";
NSString * const DCTESTKEY_CLIENTSECRET = @"clientSecret";
NSString * const DCTESTKEY_ACCESSIBILITY = @"accessibility";

@implementation DCTestUtils

- (void)assertJSONObjectEquals:(NSDictionary *)expect withActual:(NSDictionary *)actual
{
    if (expect == actual) {
        return;
    }
    if (expect != nil) {
        GHAssertTrue(actual != nil, @"actual must not be nil");
    } else {
        GHAssertTrue(actual == nil, @"actual must be nil");
    }
    GHAssertEquals(expect.count, actual.count, @"count must be equals.");
    for (NSString *key in expect.allKeys) {
        [self assertJSONElementEquals:key
                             Expected:[expect valueForKey:key]
                               Actual:[actual valueForKey:key]];
    }
}

- (void)assertJSONElementEquals:(NSString *)key Expected:(id)expected Actual:(id)actual
{
    //GHAssertEquals(expectedClass, actualClass, @"class must be equals.");
    if ([expected isKindOfClass:[NSDictionary class]] == YES) {
        GHAssertTrue([actual isKindOfClass:[NSDictionary class]],
                     @"actual must be kind of NSDictionary class");
        [self assertJSONObjectEquals:(NSDictionary *)expected
                                 withActual:(NSDictionary *)actual];
    } else if ([expected isKindOfClass:[NSArray class]] == YES) {
        GHAssertTrue([actual isKindOfClass:[NSArray class]],
                     @"actual must be kind of NSArray class");
        GHAssertEquals([expected count], [actual count], @"NSArray count must be equals.");
        for (int i = 0; i < [expected count]; ++i) {
            [self assertJSONElementEquals:key
                                 Expected:[expected objectAtIndex:i]
                                   Actual:[actual objectAtIndex:i]];
        }
    } else {
        GHAssertTrue([expected isEqual:actual], @"%@ must be equals.", key);
    }
}

+ (DCOAuth2Authentication *)authenticationByFileds:(NSDictionary *)fields
{
    NSURL *tokenURL = [NSURL URLWithString:@"http://localhost"];
    DCOAuth2Authentication *retval =
        [DCOAuth2Authentication
          authenticationWithServiceProvider:@"ServiceName"
                                   tokenURL:tokenURL
                                redirectURI:@"redirectUri"
                                   clientID:fields[DCTESTKEY_CLIENTID]
                               clientSecret:fields[DCTESTKEY_CLIENTSECRET]
         ];
    retval.accessToken = fields[DCTESTKEY_ACCESSTOKEN];
    retval.refreshToken = fields[DCTESTKEY_REFRESHTOKEN];
    retval.accessibility =
        ((DCTypeRefHolder *)fields[DCTESTKEY_ACCESSIBILITY]).ref;
    return retval;
}

+ (BOOL)containsAuthenticationContext:(NSString *)storeKey
{
    BOOL containsAuthentication =
        [DCTestUtils loadAuthentication:storeKey] != nil ? YES : NO;
    BOOL containsStoreKey = [DCTestUtils containsStoreKey:storeKey];
    if (containsAuthentication != NO && containsStoreKey != NO) {
        return YES;
    } else if (containsAuthentication == NO && containsStoreKey == NO) {
        return NO;
    } else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"containsAuthentication=%@ containsStoreKey=%@ file=%s, line=%d",
                     containsAuthentication != NO ? @"YES" : @"NO",
                     containsStoreKey != NO ? @"YES" : @"NO",
                     __FILE__, __LINE__];
        return NO;
    }
}

+ (DCOAuth2Authentication *)loadAuthentication:(NSString *)storeKey
{
    CFDataRef data = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)@{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount : @"OAuth",
        (__bridge id)kSecAttrService :
            [storeKey stringByAppendingString:@"-docomo"],
        (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
        (__bridge id)kSecMatchLimitOne : (__bridge id)kSecMatchLimit
      }, (CFTypeRef *)&data);
    switch (status) {
        case noErr:
            // nothing to do.
            break;
        case errSecItemNotFound:
            return nil;
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"error code=%d, file=%s, line=%d",
                                (int)status, __FILE__, __LINE__];
            return nil;
    }
    DCOAuth2Authentication *retval = [[DCOAuth2Authentication alloc] init];
    [retval
      setKeysForResponseString:[[NSString alloc]
                                 initWithData:(__bridge_transfer NSData *)data
                                     encoding:NSUTF8StringEncoding]];
    return retval;
}

+ (void)saveAuthenticationContextWithFields:(NSDictionary *)fields
                                 toStoreKey:(NSString *)storeKey
{
    [DCTestUtils removeAuthenticationContext:storeKey];

    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)@{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrGeneric : @"OAuth",
        (__bridge id)kSecAttrAccount : @"OAuth",
        (__bridge id)kSecAttrService :
                [storeKey stringByAppendingString:@"-docomo"],
        (__bridge id)kSecAttrAccessible :
                (__bridge id)(
                    (DCTypeRefHolder *)fields[DCTESTKEY_ACCESSIBILITY]).ref,
        (__bridge id)kSecValueData :
                [[[DCTestUtils authenticationByFileds:fields]
                   persistenceResponseString]
                  dataUsingEncoding:NSUTF8StringEncoding]
      }, NULL);

    if (status != noErr) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"error code=%d, file=%s, line=%d",
                            (int)status, __FILE__, __LINE__];
        return;
    }

    NSMutableArray *storeKeys =
        [NSMutableArray arrayWithArray:[DCTestUtils loadStoreKeys]];
    [storeKeys addObject:storeKey];
    [DCTestUtils saveStoreKeys:storeKeys];
}

+ (void)removeAuthenticationContext:(NSString *)storeKey
{
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)@{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrGeneric : @"OAuth",
        (__bridge id)kSecAttrAccount : @"OAuth",
        (__bridge id)kSecAttrService :
                [storeKey stringByAppendingString:@"-docomo"]
      });
    if (status == errSecItemNotFound) {
        return;
    } else if (status != noErr) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"error code=%d, file=%s, line=%d",
                            (int)status, __FILE__, __LINE__];
        return;
    }
    NSMutableArray *storeKeys =
        [NSMutableArray arrayWithArray:[DCTestUtils loadStoreKeys]];
    [storeKeys removeObject:storeKey];
    [DCTestUtils saveStoreKeys:storeKeys];
}

+ (void)removeAllAuthenticationContext
{
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)@{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount : @"OAuth"});
    switch (status) {
        case noErr:
        case errSecItemNotFound:
            // nothing todo.
            break;
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"error code=%d, file=%s, line=%d",
                                (int)status, __FILE__, __LINE__];
            break;
    }

    [DCTestUtils removeStoreKeys];
}

+ (BOOL)keychainHasAuthentication
{
    CFArrayRef data = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)@{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount : @"OAuth",
        (__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue,
        (__bridge id)kSecMatchLimitAll : (__bridge id)kSecMatchLimit
      }, (CFTypeRef *)&data);
    if (status == errSecItemNotFound) {
        return NO;
    } else if (status != noErr) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"error code=%d, file=%s, line=%d",
                            (int)status, __FILE__, __LINE__];
    }
    NSArray *array = (__bridge NSArray *)data;
    return [array count] > 0 ? YES : NO;
}

+ (BOOL)keychainHasStoreKeys
{
    return [[DCTestUtils loadStoreKeys] count] > 0 ? YES : NO;
}

+ (NSArray *)loadStoreKeys
{
    CFDataRef data = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)@{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount : @"dc-storekey-account",
        (__bridge id)kSecAttrService : @"dc-storekey-service",
        (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
        (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne
      },(CFTypeRef *)&data);
    if (status == errSecItemNotFound) {
        return [NSArray array];
    } else if (status != noErr) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"error code=%d, file=%s, line=%d",
                            (int)status, __FILE__, __LINE__];
    } else if (data == NULL) {
        return [NSArray array];
    }

    NSError *cause = nil;
    id array =
        [NSJSONSerialization JSONObjectWithData:(__bridge_transfer NSData *)data
                                        options:NSJSONReadingAllowFragments
                                          error:&cause];
    if (cause != nil) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"cause=%@, file=%s, line=%d", [cause description]];
    } else if ([array isKindOfClass:[NSArray class]] == NO) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"invlid class: file=%s, line=%d",
                            __FILE__, __LINE__];
    }

    return (NSArray *)array;
}

+ (void)saveStoreKeys:(NSArray *)storeKeys
{
    NSError *cause = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:storeKeys
                                                   options:0
                                                     error:&cause];
    if (cause != nil) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"cause=%@, file=%s, line=%d", [cause description]];
        return;
    }
    [DCTestUtils removeStoreKeys];

    OSStatus status = SecItemAdd((__bridge CFDictionaryRef) @{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount : @"dc-storekey-account",
        (__bridge id)kSecAttrService : @"dc-storekey-service",
        (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAlways,
        (__bridge id)kSecAttrGeneric : @"OAuth",
        (__bridge id)kSecValueData :
            [[[NSString alloc]
               initWithData:data encoding:NSUTF8StringEncoding]
              dataUsingEncoding:NSUTF8StringEncoding]
      }, NULL);
    if (status != noErr) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"error code=%d, file=%s, line=%d",
                            (int)status, __FILE__, __LINE__];
        return;
    }
}

+ (void)removeStoreKeys
{
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)@{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount : @"dc-storekey-account",
        (__bridge id)kSecAttrService : @"dc-storekey-service"});
    switch (status) {
        case noErr:
        case errSecItemNotFound:
            // nothing todo.
            break;
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"error code=%d, file=%s, line=%d",
                                (int)status, __FILE__, __LINE__];
            break;
    }
}

+ (BOOL)containsStoreKey:(NSString *)storeKey
{
    return [[DCTestUtils loadStoreKeys] containsObject:storeKey];
}

@end
