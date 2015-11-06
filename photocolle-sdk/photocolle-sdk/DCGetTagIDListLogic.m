#import "DCGetTagIDListLogic.h"
#import "DCGetTagIDListArguments.h"
#import "DCEnumerationsUtils.h"
#import "DCMiscUtils.h"
#import "DCCommand.h"
#import "DCErrorUtils.h"
#import "DCTagListResponse.h"
#import "DCListResponse_Private.h"
#import "DCPersonTag_Private.h"
#import "DCEventTag_Private.h"
#import "DCFavoriteTag_Private.h"
#import "DCPlacementTag_Private.h"
#import "DCYearMonthTag_Private.h"
#import "DCContentGUID_Private.h"

static NSString * const DEFAULT_URL =
    @"https://xlb.photocolle-docomo.com/file_a2/2.0/ext/tag_info/get_all";

@implementation DCGetTagIDListLogic

- (NSMutableURLRequest *)createRequestWithURL:(NSURL *)url
                                    arguments:(DCArguments *)arguments
                                        error:(NSError **)error
{
    NSAssert(url != nil, @"url must not be nil.");
    NSAssert(arguments != nil, @"arguments must not be nil.");
    NSAssert([arguments isKindOfClass:[DCGetTagIDListArguments class]]
             != NO, @"arguments type must be DCGetTagIDListArguments");
    NSAssert(error != nil, @"error must not be nil.");
    
    DCGetTagIDListArguments *args = (DCGetTagIDListArguments*)arguments;
    
    // Set arguments for 2.02 request as JSON object.
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[DCEnumerationsUtils toNSNumberFromDCCategory:args.category]
             forKey:@"category"];
    [json setObject:[DCEnumerationsUtils toNSNumberFromDCFiletype:args.fileType]
             forKey:@"file_type_cd"];
    if (args.minDateModified != nil) {
        [json setObject:[DCMiscUtils getUTCString:args.minDateModified]
                 forKey:@"min_date_modified"];
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
            return [DCGetTagIDListLogic toDCTagListResponse:json
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

+ (DCTagListResponse *)toDCTagListResponse:(NSDictionary *)json
                                     error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSArray *personArray = [DCMiscUtils optArrayForKey:@"person_tag_list"
                                              fromJSON:json
                                                 error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *persons = [DCGetTagIDListLogic toArrayOfPersonTag:personArray
                                                         error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSArray *eventArray = [DCMiscUtils optArrayForKey:@"event_tag_list"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *events = [DCGetTagIDListLogic toArrayOfEventTag:eventArray
                                                       error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSArray *favoriteArray = [DCMiscUtils optArrayForKey:@"optional_tag_list"
                                                fromJSON:json
                                                   error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *favorites = [DCGetTagIDListLogic toArrayOfFavoriteTag:favoriteArray
                                                             error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSArray *placeArray = [DCMiscUtils optArrayForKey:@"place_info_list"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *places = [DCGetTagIDListLogic toArrayOfPlacementTag:placeArray
                                                           error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    NSArray *monthArray = [DCMiscUtils optArrayForKey:@"month_info_list"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *months = [DCGetTagIDListLogic toArrayOfYearMonthTag:monthArray
                                                           error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSMutableArray *list = [NSMutableArray array];
    [list addObjectsFromArray:persons];
    [list addObjectsFromArray:events];
    [list addObjectsFromArray:favorites];
    [list addObjectsFromArray:places];
    [list addObjectsFromArray:months];

    return [[DCTagListResponse alloc] initWithCount:-1
                                              start:-1
                                           nextPage:0
                                               list:[NSArray arrayWithArray:list]];
}

+ (NSArray *)toArrayOfPersonTag:(NSArray *)json error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");

    NSMutableArray *retval = [NSMutableArray array];
    if (json != nil) {
        for (NSDictionary *info in json) {
            DCPersonTag *tag = [DCGetTagIDListLogic toPersonTag:info error:error];
            if (*error != nil) {
                return nil;
            }
            [retval addObject:tag];
        }
    }
    return retval;
}

+ (DCPersonTag *)toPersonTag:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSString *guidString = [DCMiscUtils stringForKey:@"person_tag_guid"
                                            fromJSON:json
                                               error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSString *name = [DCMiscUtils stringForKey:@"person_tag_name"
                                      fromJSON:json
                                         error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSString *birth = [DCMiscUtils optStringForKey:@"birth_date"
                                          fromJSON:json
                                             error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSNumber *count = [DCMiscUtils numberForKey:@"content_cnt"
                                       fromJSON:json
                                          error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    DCContentGUID *guid = [DCContentGUID guidWithString:guidString];
    NSDate *birthDate = nil;
    if (birth != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        birthDate = [formatter dateFromString:birth];
    }

    return [[DCPersonTag alloc] initWithGuid:guid
                                        name:name
                               contentsCount:[count intValue]
                                   birthDate:birthDate];
}

+ (NSArray *)toArrayOfEventTag:(NSArray *)json error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");
    
    NSMutableArray *retval = [NSMutableArray array];
    if (json != nil) {
        for (NSDictionary *info in json) {
            DCEventTag *tag = [DCGetTagIDListLogic toEventTag:info error:error];
            if (*error != nil) {
                return nil;
            }
            [retval addObject:tag];
        }
    }
    return retval;
}

+ (DCEventTag *)toEventTag:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSString *guidString = [DCMiscUtils stringForKey:@"event_tag_guid"
                                            fromJSON:json
                                               error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSString *name = [DCMiscUtils stringForKey:@"event_tag_name"
                                      fromJSON:json
                                         error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSNumber *count = [DCMiscUtils numberForKey:@"content_cnt"
                                       fromJSON:json
                                          error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    DCContentGUID *guid = [DCContentGUID guidWithString:guidString];

    return [[DCEventTag alloc] initWithGuid:guid
                                       name:name
                              contentsCount:[count intValue]];
}

+ (NSArray *)toArrayOfFavoriteTag:(NSArray *)json error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");
    
    NSMutableArray *retval = [NSMutableArray array];
    if (json != nil) {
        for (NSDictionary *info in json) {
            DCFavoriteTag *tag = [DCGetTagIDListLogic toFavoriteTag:info error:error];
            if (*error != nil) {
                return nil;
            }
            [retval addObject:tag];
        }
    }
    return retval;
}

+ (DCFavoriteTag *)toFavoriteTag:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");
    
    NSError *cause = nil;
    NSString *guidString = [DCMiscUtils stringForKey:@"optional_tag_guid"
                                            fromJSON:json
                                               error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    NSString *name = [DCMiscUtils stringForKey:@"optional_tag_name"
                                      fromJSON:json
                                         error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    NSNumber *count = [DCMiscUtils numberForKey:@"content_cnt"
                                       fromJSON:json
                                          error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    DCContentGUID *guid = [DCContentGUID guidWithString:guidString];
    
    return [[DCFavoriteTag alloc] initWithGuid:guid
                                          name:name
                                 contentsCount:[count intValue]];
}

+ (NSArray *)toArrayOfPlacementTag:(NSArray *)json error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");
    
    NSMutableArray *retval = [NSMutableArray array];
    if (json != nil) {
        for (NSDictionary *info in json) {
            DCPlacementTag *tag = [DCGetTagIDListLogic toPlacementTag:info error:error];
            if (*error != nil) {
                return nil;
            }
            [retval addObject:tag];
        }
    }
    return retval;
}

+ (DCPlacementTag *)toPlacementTag:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");
    
    NSError *cause = nil;
    NSString *guidString = [DCMiscUtils stringForKey:@"place_tag_guid"
                                            fromJSON:json
                                               error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    NSString *name = [DCMiscUtils stringForKey:@"place_name"
                                      fromJSON:json
                                         error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    NSNumber *count = [DCMiscUtils numberForKey:@"content_cnt"
                                       fromJSON:json
                                          error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    DCContentGUID *guid = [DCContentGUID guidWithString:guidString];
    
    return [[DCPlacementTag alloc] initWithGuid:guid
                                           name:name
                                  contentsCount:[count intValue]];
}

+ (NSArray *)toArrayOfYearMonthTag:(NSArray *)json error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");
    
    NSMutableArray *retval = [NSMutableArray array];
    if (json != nil) {
        for (NSDictionary *info in json) {
            DCYearMonthTag *tag = [DCGetTagIDListLogic toYearMonthTag:info error:error];
            if (*error != nil) {
                return nil;
            }
            [retval addObject:tag];
        }
    }
    return retval;
}

+ (DCYearMonthTag *)toYearMonthTag:(NSDictionary *)json error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");
    
    NSError *cause = nil;
    NSString *guidString = [DCMiscUtils stringForKey:@"month_tag_guid"
                                            fromJSON:json
                                               error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    NSString *name = [DCMiscUtils stringForKey:@"month_tag_name"
                                      fromJSON:json
                                         error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    NSNumber *count = [DCMiscUtils numberForKey:@"content_cnt"
                                       fromJSON:json
                                          error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    
    DCContentGUID *guid = [DCContentGUID guidWithString:guidString];
    
    return [[DCYearMonthTag alloc] initWithGuid:guid
                                           name:name
                                  contentsCount:[count intValue]];
}

@end
