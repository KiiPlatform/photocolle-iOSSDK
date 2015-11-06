#import "DCGetContentThumbnailInfoLogic.h"
#import "DCGetContentThumbnailInfoArguments.h"
#import "DCContentGUID_Private.h"
#import "DCMiscUtils.h"
#import "DCCommand.h"
#import "DCErrorUtils.h"
#import "DCContentThumbnailInfoList_Private.h"
#import "DCContentThumbnailInfo_Private.h"
#import "DCEnumerationsUtils.h"

static NSString * const DEFAULT_URL =
    @"https://xlb.photocolle-docomo.com/file_a2/4.0/ext/thumbnail_list/get";

@implementation DCGetContentThumbnailInfoLogic

- (NSMutableURLRequest *)createRequestWithURL:(NSURL *)url
                                    arguments:(DCArguments *)arguments
                                        error:(NSError **)error
{
    NSAssert(url != nil, @"url must not be nil.");
    NSAssert(arguments != nil, @"arguments must not be nil.");
    NSAssert([arguments isKindOfClass:[DCGetContentThumbnailInfoArguments class]]
             != NO, @"arguments type must be DCGetContentThumbnailInfoArguments");
    NSAssert(error != nil, @"error must not be nil.");
    
    DCGetContentThumbnailInfoArguments *args =
        (DCGetContentThumbnailInfoArguments*)arguments;
    
    // Set arguments for 2.30 request as JSON object.
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < args.contentGUIDs.count; ++i) {
        DCContentGUID *guid = (DCContentGUID *)[args.contentGUIDs objectAtIndex:i];
        if (guid == nil) {
            continue;
        }
        [array addObject:guid.stringValue];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:array forKey:@"content_info_list"];
    
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
            return [DCGetContentThumbnailInfoLogic toDCContentThumbnailInfoList:json
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

+ (DCContentThumbnailInfoList *)toDCContentThumbnailInfoList:(NSDictionary *)json
                                                       error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSArray *contentInfoList = [DCMiscUtils arrayForKey:@"content_info_list"
                                           fromJSON:json
                             withLengthRangeMinimum:1
                                            maximum:100
                                              error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSArray *list = [DCGetContentThumbnailInfoLogic toArrayOfContentThumbnailInfo:contentInfoList
                                                                            error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSArray *ngArray = [DCMiscUtils optArrayForKey:@"ng_list"
                                          fromJSON:json
                            withLengthRangeMinimum:0
                                           maximum:99
                                             error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSArray *ngList = [DCGetContentThumbnailInfoLogic toArrayOfContentGUID:ngArray
                                                                     error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    return [[DCContentThumbnailInfoList alloc] initWithList:list
                                                     ngList:ngList];
}

+ (NSArray *)toArrayOfContentThumbnailInfo:(NSArray *)json
                                     error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSMutableArray *retval = [NSMutableArray array];
    for (NSDictionary *contentInfo in json) {
        DCContentThumbnailInfo *info =
            [DCGetContentThumbnailInfoLogic toContentThumbnailInfo:contentInfo
                                                             error:error];
        if (*error != nil) {
            return nil;
        }
        [retval addObject:info];
    }
    return [NSArray arrayWithArray:retval];
}

+ (DCContentThumbnailInfo *)toContentThumbnailInfo:(NSDictionary *)json
                                             error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSString *guidString = [DCMiscUtils stringForKey:@"content_guid"
                                            fromJSON:json
                              withLengthRangeMinimum:1
                                             maximum:50
                                               error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSString *mimeType = [DCMiscUtils stringForKey:@"mime_type"
                                                fromJSON:json
                                                   error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    } else if ([@"image/jpeg" isEqualToString:mimeType] == NO) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                [NSString stringWithFormat:
                            @"MIME type must be image/jpeg: %@", mimeType]];
        return nil;
    }
    
    NSString *thumbnail = [DCMiscUtils stringForKey:@"thumbnail"
                                           fromJSON:json
                                              error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    DCContentGUID *guid = [DCContentGUID guidWithString:guidString];
    NSData *bytes = [DCMiscUtils dataFromBase64String:thumbnail];
    return [[DCContentThumbnailInfo alloc] initWithGUID:guid
                                               mimeType:DCMIMETYPE_JPEG
                                         thumbnailBytes:bytes];
}

+ (NSArray *)toArrayOfContentGUID:(NSArray *)json
                            error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");

    NSMutableArray *retval = [NSMutableArray array];
    if (json != nil) {
        for (NSString *ngId in json) {
            if ([ngId length] < 1 || [ngId length] > 50) {
                if (error != nil) {
                    *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                              [NSString stringWithFormat:
                               @"length of ng_content_guid is out of range: %lu",
                               (unsigned long)[ngId length]]];
                }
                return nil;
            }
            [retval addObject:[DCContentGUID guidWithString:ngId]];
        }
    }
    return [NSArray arrayWithArray:retval];
}

@end
