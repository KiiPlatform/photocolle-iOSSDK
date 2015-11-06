#import "DCGetContentIDListLogic.h"
#import "DCGetContentIDListLogic_Private.h"
#import "DCCommand.h"
#import "DCGetContentIDListArguments.h"
#import "DCDateFiltering.h"
#import "DCMiscUtils.h"
#import "DCEnumerationsUtils.h"
#import "DCErrorUtils.h"
#import "DCContentInfoListResponse.h"
#import "DCListResponse.h"
#import "DCListResponse_Private.h"
#import "DCErrors.h"
#import "DCContentInfo.h"
#import "DCContentInfo_Private.h"
#import "DCContentGUID_Private.h"

static NSString * const DEFAULT_URL =
    @"https://xlb.photocolle-docomo.com/file_a2/2.0/ext/file_search/get_list";

@implementation DCGetContentIDListLogic

- (NSMutableURLRequest *)createRequestWithURL:(NSURL *)url
                                    arguments:(DCArguments *)arguments
                                        error:(NSError **)error
{
    NSAssert(url != nil, @"url must not be nil.");
    NSAssert(arguments != nil, @"arguments must not be nil.");
    NSAssert([arguments isKindOfClass:[DCGetContentIDListArguments class]]
            != NO, @"arguments type must be DCGetContentIDListArguments");
    NSAssert(error != nil, @"error must not be nil.");

    DCGetContentIDListArguments *args = (DCGetContentIDListArguments*)arguments;

    // Set arguments for 2.00 request as JSON object.
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:@"3" forKey:@"projection"];
    [json setObject:[DCEnumerationsUtils toNSNumberFromDCFiletype:args.fileType]
             forKey:@"file_type_cd"];
    [json setObject:[NSNumber numberWithInt:(args.forDustbox != NO ? 2 : 1)]
             forKey:@"dustbox_condition"];
    // dateFilter is optional.
    if (args.dateFilter != nil) {
        [json setObject:[args.dateFilter getFilterValue]
                 forKey:[args.dateFilter getFilterName]];
    }
    if (args.maxResults != nil) {
        [json setObject:args.maxResults forKey:@"max_results"];
    }
    if (args.start != nil) {
        [json setObject:args.start forKey:@"start"];
    }
    [json setObject:[DCEnumerationsUtils toNSNumberFromDCSortType:args.sortType]
             forKey:@"sort_type"];

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
              error:(NSError **)error;
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
            return [DCGetContentIDListLogic toDCContentInfoListResponse:json
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

- (NSURL *)getDefaultURL;
{
    return [NSURL URLWithString:DEFAULT_URL];
}

+ (DCContentInfoListResponse *)toDCContentInfoListResponse:(NSDictionary *)json
                                                     error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSNumber *count = [DCGetContentIDListLogic contentCntFromJSON:json
                                                            error:error];
    if (count == nil) {
        return nil;
    }
    NSNumber *start = [DCGetContentIDListLogic startFromJSON:json error:error];
    if (start == nil) {
        return nil;
    }
    NSNumber *nextPage = [DCGetContentIDListLogic nextPageFromJSON:json
                                                             error:error];
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

    NSArray *list = [DCGetContentIDListLogic toDCContentInfoList:contentList
                                                           error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    return [[DCContentInfoListResponse alloc] initWithCount:[count intValue]
                                                      start:[start intValue]
                                                   nextPage:[nextPage intValue]
                                                       list:list];
}

+ (NSArray *)toDCContentInfoList:(NSArray *)jsonArray
                           error:(NSError **)error
{
    NSAssert(jsonArray != nil, @"jsonArray must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSMutableArray *retval = [NSMutableArray array];
    for (id element in jsonArray) {
        if ([element isKindOfClass:[NSDictionary class]] == NO) {
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                    @"contents of json array must be json object"];
            return nil;
        }
        DCContentInfo *info =
            [DCGetContentIDListLogic
                toDCContentInfoFromJSON:(NSDictionary *)element
                                  error:error];
        if (*error != nil) {
            return nil;
        }
        [retval addObject:info];
    }
    if ([retval count] > 100) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
            [NSString stringWithFormat:
                @"count of contents of content_list is over: %lu",
                      (unsigned long)[retval count]]];
        return nil;
    }
    return [NSArray arrayWithArray:retval];
}

+ (DCContentInfo *)toDCContentInfoFromJSON:(NSDictionary *)json
                                     error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSString *guid = [DCGetContentIDListLogic guidFromJSON:json error:error];
    if (guid == nil) {
        return nil;
    }
    NSString *name = [DCGetContentIDListLogic contentNameFromJSON:json
                                                            error:error];
    if (name == nil) {
        return nil;
    }
    NSNumber *fileTypeNum = [DCMiscUtils numberForKey:@"file_type_cd"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    DCFileType fileType = [DCEnumerationsUtils toDCFileTypeFromInt:[fileTypeNum intValue]
                                                             error:error];
    if (*error != nil) {
        return nil;
    }

    NSDate *exifCameraDate = [DCMiscUtils dateForKey:@"exif_camera_day"
                                            fromJSON:json
                                               error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSDate *modifiedDate = [DCMiscUtils dateForKey:@"mdate"
                                          fromJSON:json
                                             error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSDate *uploadDate = [DCMiscUtils dateForKey:@"upload_datetime"
                                        fromJSON:json
                                           error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSNumber *fileDataSize = [DCMiscUtils numberForKey:@"file_data_size"
                                              fromJSON:json
                                                 error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSString *resizeNgFlg = [DCMiscUtils stringForKey:@"resize_ng_flg"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    return [[DCContentInfo alloc]
              initWithGUID:[DCContentGUID guidWithString:guid]
                      name:name
                  fileType:fileType
              exifCameraDate:exifCameraDate
              modifiedDate:modifiedDate
              uploadedDate:uploadDate
              fileDataSize:[fileDataSize longLongValue]
                 resizable:[resizeNgFlg isEqualToString:@"0"]];
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

+ (NSString *)guidFromJSON:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    return [DCMiscUtils stringForKey:@"content_guid"
                            fromJSON:json
              withLengthRangeMinimum:1
                             maximum:50
                               error:error];
}

+ (NSString *)contentNameFromJSON:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    return [DCMiscUtils stringForKey:@"content_name"
                            fromJSON:json
              withLengthRangeMinimum:1
                             maximum:255
                               error:error];
}

+ (NSNumber *)contentCntFromJSON:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    return [DCMiscUtils numberForKey:@"content_cnt"
                            fromJSON:json
                    withRangeMinimum:0
                               error:error];
}

@end
