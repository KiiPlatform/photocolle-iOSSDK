#import "DCCommand.h"
#import "DCCommand_Private.h"
#import "DCExceptionUtils.h"
#import "DCLogic.h"
#import "DCAuthenticationContext.h"
#import "DCAuthenticationContext_Private.h"
#import "GTMOAuth2Authentication.h"
#import "DCErrorUtils.h"
#import "GTMHTTPFetcher.h"
#import "DCMiscUtils.h"
#import "DCAuthority_Private.h"

@implementation DCCommand

- (id)initWithLogic:(id <DCLogic>)logic
            baseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self != nil) {
        self.logic = logic;
        self.baseURL = baseURL;
    }
    return self;
}

- (void)dealloc
{
    self.logic = nil;
    self.baseURL = nil;
}

- (id)executeWithArgument:(DCArguments *)arguments
                    error:(NSError **)error;
{
    NSAssert(arguments != nil, @"argument must not be nil");
    NSAssert(error != nil, @"error must not be nil");

    NSMutableURLRequest *request =
        [self.logic createRequestWithURL:self.targetURL
                               arguments:arguments
                                   error:error];
    if (*error != nil) {
        return nil;
    }
    [request setTimeoutInterval:60];
    __block NSError *cause = nil;
    __block NSData *data = nil;
    __block BOOL isFinished = NO;
    DCGTMHTTPFetcher *fetcher =  [DCGTMHTTPFetcher fetcherWithRequest:request];
    [fetcher beginFetchWithCompletionHandler:^(
                NSData *retrievedData,
                NSError *error) {
            cause = error;
            data = retrievedData;
            isFinished = YES;
        }];
    [fetcher waitForCompletionWithTimeout:120];
    if (fetcher.response == nil && cause != nil) {
        *error = [DCErrorUtils connectionErrorWithCause:cause];
        return nil;
    } else if (isFinished == NO) {
        *error = [DCErrorUtils connectionErrorWithDescription:
                                 @"HTTP connection timeout"];
        return nil;
    }
    if ([DCMiscUtils isLoggable] != NO) {
        [DCCommand printDebugInfoWithRequest:request
                                    response:(NSHTTPURLResponse *)fetcher.response
                                responseBody:data];
    }
    return [self.logic parseResponse:fetcher.response data:data error:error];
}

- (NSURL *)targetURL
{
    if (self.baseURL == nil) {
        return [self.logic getDefaultURL];
    } else {
        return [self.baseURL
                URLByAppendingPathComponent:[self.logic getDefaultURL].path];
    }
}

+ (BOOL)signRequest:(NSMutableURLRequest *)request
        withContext:(DCAuthenticationContext *)context
              error:(NSError **)error;
{
    NSAssert(request != nil, @"request must not be nil.");
    NSAssert(context != nil, @"context must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");
    if (context.authentication.canAuthorize == NO) {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:
                            @"context must be authorized."];
    }

    NSError *cause = nil;
    DCRefreshResult result = [DCAuthority tryToRefresh:context error:&cause];
    switch (result) {
        case DCREFRESHRESULT_FAIL:
        {
            *error = [DCErrorUtils toAuthenticationRelatedError:cause];
            return NO;
        }
        case DCREFRESHRESULT_REFRESHED:
            [context save];
            break;
        case DCREFRESHRESULT_NOTEXPIRED:
        case DCREFRESHRESULT_CANTREFRESH:
            break;
        default:
            NSAssert(NO, @"unknown DCRefreshResult: %d", result);
            break;
    }
    if ([context.authentication authorizeRequest:request] == NO) {
        [DCExceptionUtils raiseUnexpectedExceptionWithReason:
                            @"Signing is failed"];
    }
    return YES;
}

+ (void)setJSONData:(NSDictionary *)json
          toRequest:(NSMutableURLRequest *)request
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(request != nil, @"request must not be nil.");

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:0
                                                     error:&error];
    if (data == nil) {
        if (error == nil) {
            [DCExceptionUtils raiseUnexpectedExceptionWithReason:
                    @"fail to convert to json object"];
        } else {
            [DCExceptionUtils raiseUnexpectedExceptionWithError:error];
        }
    }
    [request setHTTPBody:data];
}

+ (void)printDebugInfoWithRequest:(NSURLRequest *)request
                         response:(NSHTTPURLResponse *)response
                     responseBody:(NSData *)responseBody
{
    NSMutableString *builder = [NSMutableString string];

    [builder appendFormat:@"URL: %@\n", [request.URL absoluteString]];
    [builder appendFormat:@"Request Headers: %@\n",
        request.allHTTPHeaderFields];
    [builder appendFormat:@"Request Body: %@\n",
        [[NSString alloc] initWithData:request.HTTPBody
                              encoding:NSUTF8StringEncoding]];
    [builder appendFormat:@"HTTP Status Code: %ld\n",
             (long)response.statusCode];
    [builder appendFormat:@"Response Headers: %@\n",
        response.allHeaderFields];
    [builder appendFormat:@"Response Body: %@\n",
        [[NSString alloc] initWithData:responseBody
                              encoding:NSUTF8StringEncoding]];

    NSLog(@"%@", builder);
}

@end
