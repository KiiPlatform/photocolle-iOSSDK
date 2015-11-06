#import "DCGetContentBodyInfoLogic.h"
#import "DCGetContentBodyInfoArguments.h"
#import "DCEnumerationsUtils.h"
#import "DCContentGUID.h"
#import "DCMiscUtils.h"
#import "DCCommand.h"
#import "DCContentBodyInfo_Private.h"
#import "DCErrorUtils.h"

static NSString * const DEFAULT_URL =
    @"https://xlb.photocolle-docomo.com/file_a2/2.0/ext/content/get";

@implementation DCGetContentBodyInfoLogic

- (NSMutableURLRequest *)createRequestWithURL:(NSURL *)url
                                    arguments:(DCArguments *)arguments
                                        error:(NSError **)error
{
    NSAssert(url != nil, @"url must not be nil.");
    NSAssert(arguments != nil, @"arguments must not be nil.");
    NSAssert([arguments isKindOfClass:[DCGetContentBodyInfoArguments class]]
             != NO, @"arguments type must be DCGetContentBodyInfoArguments");
    NSAssert(error != nil, @"error must not be nil.");
    
    DCGetContentBodyInfoArguments *args = (DCGetContentBodyInfoArguments*)arguments;
    
    // Set arguments for 2.04 request as JSON object.
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[DCEnumerationsUtils toNSNumberFromDCFiletype:args.fileType]
             forKey:@"file_type_cd"];
    
    [json setObject:args.contentGUID.stringValue forKey:@"content_guid"];

    [json setObject:[DCEnumerationsUtils toNSNumberFromDCResizeType:args.resizeType]
             forKey:@"resize_type_cd"];
    
    // create request.
    NSMutableURLRequest *retval = [DCMiscUtils toPostRequestFromURL:url];
    if ([DCCommand signRequest:retval withContext:args.context error:error]
            == NO) {
        return nil;
    }
    [DCCommand setJSONData:json toRequest:retval];
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

    if ([response.MIMEType isEqualToString:@"application/json"]) {
        // check data.
        NSAssert(data != nil, @"data must not be nil.");
        NSDictionary *json = [DCMiscUtils JSONObjectWithData:data error:error];
        if (*error != nil) {
            return nil;
        }
        NSNumber *result = [DCMiscUtils numberForKey:@"result"
                                            fromJSON:json
                                               error:error];
        if (*error != nil) {
            return nil;
        }

        if ([result intValue] == 1) {
            *error = [DCErrorUtils applicationLayerErrorFromJSON:json];
        } else {
            *error = [DCErrorUtils
                     responseBodyParseErrorWithDescription:
                         [NSString stringWithFormat:
                                     @"In this situation, result must be 1: %d",
                                   [result intValue]]];
        }
        return nil;
    }

    DCMimeType contentType = [DCEnumerationsUtils toDCMimeTypeFromString:response.MIMEType
                                                                   error:error];
    if (*error != nil) {
        return nil;
    }

    // check data.
    NSAssert(data != nil, @"data must not be nil.");
    NSInputStream *bodyStream = [NSInputStream inputStreamWithData:data];

    return [[DCContentBodyInfo alloc] initWithContentType:contentType
                                              inputStream:bodyStream];
}

- (NSURL *)getDefaultURL
{
    return [NSURL URLWithString:DEFAULT_URL];
}

@end
