#import "DCSessionFetcherService_Private.h"
#import "GTMOAuth2Authentication.h"

@implementation DCSessionFetcherService

+ (instancetype)
    fetcherServiceWithAuthentication:(DCGTMOAuth2Authentication *)authentication
{
    NSAssert(authentication != nil, @"authentication must not be nil.");
    return [[DCSessionFetcherService alloc] initWithAuthentication:authentication];
}

- (instancetype)
    initWithAuthentication:(DCGTMOAuth2Authentication *)authentication
{
    NSAssert(authentication != nil, @"authentication must not be nil.");

    self = [super init];
    if (self != nil) {
        authentication.fetcherService = self;
        self.authentication = authentication;
        self.requests = [NSMutableArray array];
    }
    return self;
}

- (DCGTMSessionFetcher *)fetcherWithRequest:(NSURLRequest *)request
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
    [string appendString:[DCSessionFetcherService
                           urlEncode:self.authentication.clientID]];
    [string appendString:@":"];
    [string appendString:[DCSessionFetcherService
                           urlEncode:self.authentication.clientSecret]];
    return [DCSessionFetcherService base64Encode:string];
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
    return [data base64EncodedStringWithOptions:0];
}

@end
