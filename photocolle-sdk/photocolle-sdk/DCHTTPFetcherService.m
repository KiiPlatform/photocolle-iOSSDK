#import "DCHTTPFetcherService_Private.h"
#import "GTMOAuth2Authentication.h"

@implementation DCHTTPFetcherService

+ (instancetype)
    fetcherServiceWithAuthentication:(DCGTMOAuth2Authentication *)authentication
{
    NSAssert(authentication != nil, @"authentication must not be nil.");
    return [[DCHTTPFetcherService alloc] initWithAuthentication:authentication];
}

- (instancetype)
    initWithAuthentication:(DCGTMOAuth2Authentication *)authentication
{
    NSAssert(authentication != nil, @"authentication must not be nil.");

    self = [super init];
    if (self != nil) {
        authentication.fetcherService = self;
        self.authentication = authentication;
        self.delegateQueue = [[NSOperationQueue alloc] init];
        self.requests = [NSMutableArray array];
    }
    return self;
}

- (DCGTMHTTPFetcher *)fetcherWithRequest:(NSURLRequest *)request
{
    if (request == nil) {
        return [super fetcherWithRequest:request];
    }
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setValue:[self authorizationString]
          forHTTPHeaderField:@"Authorization"];
    [mutableRequest setValue:@"application/x-www-form-urlencoded;charset=UTF-8"
          forHTTPHeaderField:@"Content-Type"];
    [self.requests addObject:mutableRequest];
    return [super fetcherWithRequest:mutableRequest];
}

- (void)clearHistory
{
    [super clearHistory];
    for (NSMutableURLRequest *request in self.requests) {
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    }
    [self.requests removeAllObjects];
}

- (NSString *)authorizationString
{
    if (self.authentication.clientID == nil ||
            self.authentication.clientSecret == nil) {
        // DCAuthenticationContext object laoded by loadByKey:error:
        // does not have clientID and clientSecret.
        return nil;
    }
    NSMutableString *string = [NSMutableString string];
    [string appendString:[DCHTTPFetcherService
                           urlEncode:self.authentication.clientID]];
    [string appendString:@":"];
    [string appendString:[DCHTTPFetcherService
                           urlEncode:self.authentication.clientSecret]];
    return [DCHTTPFetcherService base64Encode:string];
}

+ (NSString *)urlEncode:(NSString *)string
{
    return (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            (__bridge CFStringRef)string,
            NULL,
            CFSTR("!*'();:@&=+$,/?%#[]"),
            kCFStringEncodingUTF8);

}

+ (NSString *)base64Encode:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if ([data respondsToSelector:@selector(base64EncodedStringWithOptions:)]
            != NO) {
        // for iOS7.0 or later.
        return [data base64EncodedStringWithOptions:0];
    } else {
        // for iOS6.0 or earlier.
        return [data base64Encoding];
    }
}

@end
