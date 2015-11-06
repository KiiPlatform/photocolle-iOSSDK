#import "DCGetCapacityInfoLogic.h"
#import "DCGetCapacityInfoArguments.h"
#import "DCMiscUtils.h"
#import "DCCommand.h"
#import "DCErrorUtils.h"
#import "DCCapacityInfo_Private.h"
#import "DCExceptionUtils.h"

static NSString * const DEFAULT_URL =
    @"https://xlb.photocolle-docomo.com/file_a2/1.0/docomo/capacity";

@implementation DCGetCapacityInfoLogic

- (NSMutableURLRequest *)createRequestWithURL:(NSURL *)url
                                    arguments:(DCArguments *)arguments
                                        error:(NSError **)error
{
    NSAssert(url != nil, @"url must not be nil.");
    NSAssert(arguments != nil, @"arguments must not be nil.");
    NSAssert([arguments isKindOfClass:[DCGetCapacityInfoArguments class]]
             != NO, @"arguments type must be DCGetCapacityInfoArguments");
    NSAssert(error != nil, @"error must not be nil.");
    
    DCGetCapacityInfoArguments *args = (DCGetCapacityInfoArguments*)arguments;

    // create request.
    NSMutableURLRequest *retval = [DCMiscUtils toPostRequestFromURL:url];
    [retval setHTTPMethod:@"GET"];
    if ([DCCommand signRequest:retval withContext:args.context error:error]
            == NO) {
        return nil;
    }
    return retval;
}

- (id)parseResponse:(NSURLResponse *)response
               data:(NSData *)data
              error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");

    // check response.
    NSAssert(response != nil, @"response must not be nil.");
    NSAssert([response isKindOfClass:[NSHTTPURLResponse class]] != NO,
             @"response type must be NSHTTPURLResponse");
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode != 200) {
        *error = [DCErrorUtils httpRelatedErrorFromHttpResponse:httpResponse
                                                           data:data];
        return nil;
    }

    // check data.
    NSAssert(data != nil, @"data must not be nil.");
    NSDictionary *json = [DCMiscUtils JSONObjectWithData:data error:error];
    if (*error != nil) {
        return nil;
    }
    NSString *result = [DCMiscUtils stringForKey:@"result"
                                        fromJSON:json
                                           error:error];
    if (*error != nil) {
        return nil;
    }
    if ([result isEqualToString:@"0"] != NO) {
        return [DCGetCapacityInfoLogic toDCCapacityInfo:json
                                                  error:error];
    } else if ([result isEqualToString:@"1"] != NO) {
        *error = [DCErrorUtils applicationLayerErrorFromJSON:json];
        return nil;
    } else {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                  [NSString stringWithFormat:@"result is out of range: %@",
                   result]];
        return nil;
    }
}

- (NSURL *)getDefaultURL
{
    return [NSURL URLWithString:DEFAULT_URL];
}

+ (DCCapacityInfo *)toDCCapacityInfo:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSString *maxSpace = [DCMiscUtils optStringForKey:@"max_space"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSString *freeSpace = [DCMiscUtils stringForKey:@"free_space"
                                            fromJSON:json
                                               error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    long long max = -1;
    if (maxSpace != nil) {
        max = [maxSpace longLongValue];
    }

    long long free = 0;
    if (freeSpace != nil) {
        free = [freeSpace longLongValue];
    } else {
        // freeSpace was got by stringForKey:fromJSON:error.
        // stringForKey:fromJSON:error must not return nil so if
        // freeSpace was nil, then it is programming error.
        [DCExceptionUtils
          raiseUnexpectedExceptionWithReason:@"freeSpace must not be nil."];
        return nil;
    }

    return [[DCCapacityInfo alloc] initWithMaxSpace:max freeSpace:free];
}

@end
