#import "DCGetContentDeletionHistoryLogic_Private.h"
#import "DCGetContentDeletionHistoryArguments.h"
#import "DCEnumerationsUtils.h"
#import "DCMiscUtils.h"
#import "DCCommand.h"
#import "DCErrorUtils.h"
#import "DCContentGUIDListResponse.h"
#import "DCListResponse_Private.h"
#import "DCContentGUID_Private.h"

static NSString * const DEFAULT_URL =
    @"https://xlb.photocolle-docomo.com/file_a2/2.0/ext/content/get_delete_history";

@implementation DCGetContentDeletionHistoryLogic

- (NSMutableURLRequest *)createRequestWithURL:(NSURL *)url
                                    arguments:(DCArguments *)arguments
                                        error:(NSError **)error
{
    NSAssert(url != nil, @"url must not be nil.");
    NSAssert(arguments != nil, @"arguments must not be nil.");
    NSAssert([arguments isKindOfClass:[DCGetContentDeletionHistoryArguments class]]
             != NO, @"arguments type must be DCGetContentDeletionHistoryArguments");
    NSAssert(error != nil, @"error must not be nil.");
    
    DCGetContentDeletionHistoryArguments *args =
        (DCGetContentDeletionHistoryArguments*)arguments;
    
    // Set arguments for 2.03 request as JSON object.
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[DCEnumerationsUtils toNSNumberFromDCFiletype:args.fileType]
             forKey:@"file_type_cd"];
    
    if (args.minDateDeleted != nil) {
        [json setObject:[DCMiscUtils getUTCString:args.minDateDeleted]
                 forKey:@"min_date_deleted"];
    }
    if (args.maxResults != nil) {
        [json setObject:args.maxResults forKey:@"max_results"];
    }
    if (args.start != nil) {
        [json setObject:args.start forKey:@"start"];
    }
    
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
    switch ([result intValue]) {
        case 0:
            return [DCGetContentDeletionHistoryLogic toDCContentGUIDListResponse:json
                                                                           error:error];
        case 1:
            *error = [DCErrorUtils applicationLayerErrorFromJSON:json];
            return nil;
        default:
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                      [NSString stringWithFormat:@"result is out of range: %d",
                       [result intValue]]];
            return nil;
    }
}

- (NSURL *)getDefaultURL
{
    return [NSURL URLWithString:DEFAULT_URL];
}

+ (DCContentGUIDListResponse *)toDCContentGUIDListResponse:(NSDictionary *)json
                                                     error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");
    
    NSError *cause = nil;
    NSNumber *count =
        [DCGetContentDeletionHistoryLogic contenCntFromJSON:json error:error];
    if (count == nil) {
        return nil;
    }

    NSNumber *start = [DCGetContentDeletionHistoryLogic startFromJSON:json
                                                                error:error];
    if (start == nil) {
        return nil;
    }

    NSNumber *nextPage =
        [DCGetContentDeletionHistoryLogic nextPageFromJSON:json error:error];
    if (nextPage == nil) {
        return nil;
    }

    NSArray *contentList = [DCMiscUtils arrayForKey:@"content_list"
                                           fromJSON:json
                                              error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSArray *list = [DCGetContentDeletionHistoryLogic toDCContentGUIDList:contentList
                                                                    error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    return [[DCContentGUIDListResponse alloc] initWithCount:[count intValue]
                                                      start:[start intValue]
                                                   nextPage:[nextPage intValue]
                                                       list:[NSArray arrayWithArray:list]];
}

+ (NSArray *)toDCContentGUIDList:(NSArray *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSMutableArray *retval = [NSMutableArray array];
    for (NSString *guid in json) {
        if (guid == nil) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                                     @"guid must not be nil."];
            return nil;
        } else if ([guid length] < 1 || [guid length] > 50) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    [NSString stringWithFormat:@"length of guid is invalid: %lu",
                              (unsigned long)[guid length]]];
            return nil;
        }
        [retval addObject:[DCContentGUID guidWithString:guid]];
    }

    if ([retval count] > 100) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
            [NSString stringWithFormat:
                @"count of contents of content_list is over: %lu",
                      (unsigned long)[retval count]]];
        return nil;
    }
    return retval;
}

+ (NSNumber *)startFromJSON:(NSDictionary *)json
                      error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    return [DCMiscUtils numberForKey:@"start"
                            fromJSON:json
                    withRangeMinimum:1
                               error:error];
}

+ (NSNumber *)nextPageFromJSON:(NSDictionary *)json
                         error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    return [DCMiscUtils numberForKey:@"next_page"
                            fromJSON:json
                    withRangeMinimum:0
                               error:error];
}

+ (NSNumber *)contenCntFromJSON:(NSDictionary *)json
                          error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    return [DCMiscUtils numberForKey:@"content_cnt"
                            fromJSON:json
                    withRangeMinimum:0
                             maximum:100
                               error:error];
}

@end
