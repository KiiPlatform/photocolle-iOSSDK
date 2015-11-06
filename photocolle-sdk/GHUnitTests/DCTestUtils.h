#import <Foundation/Foundation.h>

@class DCOAuth2Authentication;

#import <GHUnitIOS/GHTestCase.h>

extern NSString * const DCTESTKEY_ACCESSTOKEN;
extern NSString * const DCTESTKEY_REFRESHTOKEN;
extern NSString * const DCTESTKEY_CLIENTID;
extern NSString * const DCTESTKEY_CLIENTSECRET;
extern NSString * const DCTESTKEY_ACCESSIBILITY;

@interface DCTestUtils : GHTestCase

- (void)assertJSONObjectEquals:(NSDictionary *)expect withActual:(NSDictionary *)actual;

+ (DCOAuth2Authentication *)authenticationByFileds:(NSDictionary *)fields;
+ (BOOL)containsAuthenticationContext:(NSString *)storeKey;
+ (DCOAuth2Authentication *)loadAuthentication:(NSString *)storeKey;
+ (void)saveAuthenticationContextWithFields:(NSDictionary *)fields
                                 toStoreKey:(NSString *)storeKey;
+ (void)removeAuthenticationContext:(NSString *)storeKey;
+ (void)removeAllAuthenticationContext;
+ (BOOL)keychainHasAuthentication;
+ (BOOL)keychainHasStoreKeys;
+ (NSArray *)loadStoreKeys;
+ (BOOL)containsStoreKey:(NSString *)storeKey;

@end
