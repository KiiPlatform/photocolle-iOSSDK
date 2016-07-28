#import "GTMSessionFetcherService.h"

@class DCGTMOAuth2Authentication;

@interface DCSessionFetcherService : DCGTMSessionFetcherService

@property (nonatomic, readwrite, weak)
    DCGTMOAuth2Authentication *authentication;

+ (instancetype)fetcherServiceWithAuthentication:(DCGTMOAuth2Authentication *)authentication;

- (DCGTMSessionFetcher *)fetcherWithRequest:(NSURLRequest *)request;
- (void)clearHistory;

@end
