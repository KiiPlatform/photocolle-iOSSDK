#import "GTMHTTPFetcherService.h"

@class DCGTMOAuth2Authentication;

@interface DCHTTPFetcherService : DCGTMHTTPFetcherService

@property (nonatomic, readwrite, weak)
    DCGTMOAuth2Authentication *authentication;

+ (instancetype)fetcherServiceWithAuthentication:(DCGTMOAuth2Authentication *)authentication;

- (DCGTMHTTPFetcher *)fetcherWithRequest:(NSURLRequest *)request;
- (void)clearHistory;

@end
