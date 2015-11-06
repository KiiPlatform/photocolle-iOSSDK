#import "DCHTTPFetcherService.h"

@interface DCHTTPFetcherService ()

@property (nonatomic, readwrite, strong) NSMutableArray *requests;

- (instancetype)
    initWithAuthentication:(DCGTMOAuth2Authentication *)authentication;
- (NSString *)authorizationString;

+ (NSString *)urlEncode:(NSString *)string;
+ (NSString *)base64Encode:(NSString *)string;

@end
