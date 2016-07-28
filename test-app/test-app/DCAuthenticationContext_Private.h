#import <PhotoColleSDK/DCPhotoColleSDK.h>

@class DCGTMOAuth2Authentication;
@protocol DCGTMHTTPFetcherServiceProtocol;

@interface DCAuthenticationContext ()

@property (nonatomic, readwrite, strong) DCGTMOAuth2Authentication *authentication;
@property (nonatomic, readwrite, strong) NSString* storeKey;
@property (nonatomic, readwrite, strong) id<DCGTMHTTPFetcherServiceProtocol> fetcherService;

+ (id)authenticationContextWithAuthentication:(DCGTMOAuth2Authentication *)authentication
                               fetcherService:(id<DCGTMHTTPFetcherServiceProtocol>)fetcherService;
+ (instancetype)authenticationContextWithAuthentication:(DCGTMOAuth2Authentication *)authentication
                                         fetcherService:(id<DCGTMHTTPFetcherServiceProtocol>)fetcherService
                                               storeKey:(NSString *)storeKey;
- (id)initWithAuthentication:(DCGTMOAuth2Authentication *)authentication
              fetcherService:(id<DCGTMHTTPFetcherServiceProtocol>)fetcherService;
- (instancetype)
    initWithAuthentication:(DCGTMOAuth2Authentication *)authentication
            fetcherService:(id<DCGTMHTTPFetcherServiceProtocol>)fetcherService
                  storeKey:(NSString *)storeKey;

- (BOOL)isExpired;
- (BOOL)canRefresh;

+ (BOOL)isValidAccessibility:(CFTypeRef)accessibility;

@end
