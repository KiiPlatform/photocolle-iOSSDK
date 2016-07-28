#import "DCAuthenticationContext.h"

@class DCGTMOAuth2Authentication;
@class DCGTMSessionFetcherService;

@interface DCAuthenticationContext ()

@property (nonatomic, readwrite, strong) DCGTMOAuth2Authentication *authentication;
@property (nonatomic, readwrite, strong) NSString* storeKey;
@property (nonatomic, readwrite, strong) DCGTMSessionFetcherService * fetcherService;

+ (id)authenticationContextWithAuthentication:(DCGTMOAuth2Authentication *)authentication
                               fetcherService:(DCGTMSessionFetcherService *)fetcherService;
+ (instancetype)authenticationContextWithAuthentication:(DCGTMOAuth2Authentication *)authentication
                                         fetcherService:(DCGTMSessionFetcherService *)fetcherService
                                               storeKey:(NSString *)storeKey;
- (id)initWithAuthentication:(DCGTMOAuth2Authentication *)authentication
              fetcherService:(DCGTMSessionFetcherService *)fetcherService;
- (instancetype)
    initWithAuthentication:(DCGTMOAuth2Authentication *)authentication
            fetcherService:(DCGTMSessionFetcherService *)fetcherService
                  storeKey:(NSString *)storeKey;

- (BOOL) saveInnerByKey:(NSString *)key
          accessibility:(CFTypeRef)accessibility
                  error:(NSError **)error;
- (BOOL)isExpired;
- (BOOL)canRefresh;
- (void)save;

+ (BOOL)isValidAccessibility:(CFTypeRef)accessibility;
+ (BOOL)saveStoreKey:(NSString *)storeKey
      authentication:(DCGTMOAuth2Authentication *)authentication
       accessibility:(CFTypeRef)accessibility
               error:(NSError **)error;
+ (void)removeStoreKey:(NSString *)storeKey;
+ (NSArray *)loadStoreKeysWithError:(NSError **)error;
+ (void)removeStoreKeys:(NSArray *)storeKeys;
+ (BOOL)saveStoreKeys:(NSArray *)storeKeys error:(NSError **)error;
+ (NSMutableArray *)toMutableArrayFromStoreKeyString:(NSString *)string
                                               error:(NSError **)error;
+ (NSString *)toStoreKeyStringFromArray:(NSArray *)array
                                  error:(NSError **)error;

@end
