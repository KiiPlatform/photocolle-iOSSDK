#import "DCGetContentIDListWithTagsLogic.h"
#import "DCGetContentIDListWithTagsLogic_Private.h"
#import "DCGetContentIDListWithTagsArguments.h"
#import "DCEnumerationsUtils.h"
#import "DCMiscUtils.h"
#import "DCDateFiltering.h"
#import "DCCommand.h"
#import "DCTagHead.h"
#import "DCContentGUID_Private.h"
#import "DCErrorUtils.h"
#import "DCDetailedContentInfo_Private.h"
#import "DCDetailedContentInfoListResponse.h"
#import "DCNamedTagHead.h"
#import "DCListResponse_Private.h"

static NSString * const DEFAULT_URL =
    @"https://xlb.photocolle-docomo.com/file_a2/2.0/ext/file_search/get_detail";

@implementation DCGetContentIDListWithTagsLogic

- (void)dealloc
{
    self.arguments = nil;
}

- (NSMutableURLRequest *)createRequestWithURL:(NSURL *)url
                                    arguments:(DCArguments *)arguments
                                        error:(NSError **)error
{
    NSAssert(url != nil, @"url must not be nil.");
    NSAssert(arguments != nil, @"arguments must not be nil.");
    NSAssert([arguments isKindOfClass:[DCGetContentIDListWithTagsArguments class]]
             != NO, @"arguments type must be DCGetContentIDListWithTagsArguments");
    NSAssert(error != nil, @"error must not be nil.");

    DCGetContentIDListWithTagsArguments *args =
        (DCGetContentIDListWithTagsArguments*)arguments;
    self.arguments = args;

    // Set arguments for 2.01 request as JSON object.
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[DCEnumerationsUtils toNSStringFromDCProjectionType:args.projectionType] forKey:@"projection"];
    [json setObject:[DCEnumerationsUtils toNSNumberFromDCFiletype:args.fileType]
             forKey:@"file_type_cd"];

    [DCGetContentIDListWithTagsLogic setCriteria:json
                                    criteriaList:args.criteriaList
                                           index:0
                                      keyTagType:@"criteria_1_tag_type"
                                         keyGuid:@"criteria_1_guid"];

    [DCGetContentIDListWithTagsLogic setCriteria:json
                                    criteriaList:args.criteriaList
                                           index:1
                                      keyTagType:@"criteria_2_tag_type"
                                         keyGuid:@"criteria_2_guid"];

    [DCGetContentIDListWithTagsLogic setCriteria:json
                                    criteriaList:args.criteriaList
                                           index:2
                                      keyTagType:@"criteria_3_tag_type"
                                         keyGuid:@"criteria_3_guid"];

    [DCGetContentIDListWithTagsLogic setCriteria:json
                                    criteriaList:args.criteriaList
                                           index:3
                                      keyTagType:@"criteria_4_tag_type"
                                         keyGuid:@"criteria_4_guid"];

    [DCGetContentIDListWithTagsLogic setCriteria:json
                                    criteriaList:args.criteriaList
                                           index:4
                                      keyTagType:@"criteria_5_tag_type"
                                         keyGuid:@"criteria_5_guid"];

    if (args.forDustbox != nil) {
        [json setObject:[NSNumber numberWithInt:([args.forDustbox boolValue] != NO ? 2 : 1)]
                 forKey:@"dustbox_condition"];
    }
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
    if (args.sortType != nil) {
        [json setObject:args.sortType forKey:@"sort_type"];
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
            return [self toDCDetailedContentInfoListResponse:json
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

+ (void)setCriteria:(NSMutableDictionary *)json
       criteriaList:(NSArray *)criteriaList
              index:(int)index
         keyTagType:(NSString *)keyTagType
            keyGuid:(NSString *)keyGuid
{
    if (criteriaList == nil) {
        return;
    }
    if (index >= criteriaList.count) {
        return;
    }
    DCTagHead *criteria = (DCTagHead *)[criteriaList objectAtIndex:index];
    if (criteria != nil && [criteria isEqual:[NSNull null]] == NO) {
        [json setObject:[DCEnumerationsUtils toNSNumberFromDCTagType:criteria.type]
                 forKey:keyTagType];
        [json setObject:criteria.guid.stringValue forKey:keyGuid];
    }
}

- (DCDetailedContentInfoListResponse *)toDCDetailedContentInfoListResponse:(NSDictionary *)json
                                                                     error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");
    NSAssert(self.arguments != nil, @"arguments must not be nil.");

    NSError *cause = nil;
    NSNumber *count = [DCGetContentIDListWithTagsLogic contentCntFromJSON:json
                                                                    error:error];
    if (count == nil) {
        return nil;
    }
    NSNumber *start = [DCGetContentIDListWithTagsLogic startFromJSON:json
                                                      projectionType:self.arguments.projectionType
                                                           sentStart:self.arguments.start
                                                               error:error];
    if (start == nil) {
        return nil;
    }
    NSNumber *nextPage = [DCGetContentIDListWithTagsLogic nextPageFromJSON:json
                                                            projectionType:self.arguments.projectionType
                                                                     error:error];
    if (nextPage == nil) {
        return nil;
    }
    NSArray *contentList = [DCMiscUtils optArrayForKey:@"content_list"
                                              fromJSON:json
                                                 error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    switch (self.arguments.projectionType) {
        case DCPROJECTIONTYPE_FILE_COUNT:
            if (contentList != nil) {
                *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                          @"response must have no content_list."];
                return nil;
            }
            break;
        case DCPROJECTIONTYPE_ALL_DETAILS:
        case DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS:
            if (contentList == nil) {
                *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                          @"content_list must not be optional, when projection type is not FILE_COUNT."];
                return nil;
            }
            break;
        default:
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                      [NSString stringWithFormat:@"unknown projectionType: %ld",
                       (long)self.arguments.projectionType]];
            return nil;
    }

    NSArray *list = [DCGetContentIDListWithTagsLogic toDCDetailedContentInfoList:contentList
                                                                           error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    return [[DCDetailedContentInfoListResponse alloc] initWithCount:[count intValue]
                                                              start:[start intValue]
                                                           nextPage:[nextPage intValue]
                                                               list:list];
}

+ (NSArray *)toDCDetailedContentInfoList:(NSArray *)jsonArray
                                   error:(NSError **)error
{
    NSAssert(error != nil, @"error must not be nil.");

    NSMutableArray *retval = [NSMutableArray array];
    if (jsonArray != nil) {
        for (id element in jsonArray) {
            if ([element isKindOfClass:[NSDictionary class]] == NO) {
                *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                        @"contents of json array must be json object"];
                return nil;
            }
            DCDetailedContentInfo *info =
                [DCGetContentIDListWithTagsLogic
                 toDCDetailedContentInfoFromJSON:(NSDictionary *)element
                                           error:error];
            if (*error != nil) {
                return nil;
            }
            [retval addObject:info];
        }
    }
    if ([retval count] > 1000) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                  [NSString stringWithFormat:
                   @"count of contents of content_list is over: %lu",
                   (unsigned long)[retval count]]];
        return nil;
    }
    return [NSArray arrayWithArray:retval];
}

+ (DCDetailedContentInfo *)toDCDetailedContentInfoFromJSON:(NSDictionary *)json
                                                     error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSError *cause = nil;
    NSString *guidString = [DCGetContentIDListWithTagsLogic contentGuidFromJSON:json
                                                                          error:error];
    if (guidString == nil) {
        return nil;
    }

    NSString *name = [DCGetContentIDListWithTagsLogic contentNameFromJSON:json
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

    NSString *ratio = [DCMiscUtils stringForKey:@"file_data_xy_rate"
                                       fromJSON:json
                                          error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSNumber *scoreNum = [DCMiscUtils optNumberForKey:@"prf5score"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }

    NSNumber *orientationNum = [DCMiscUtils optNumberForKey:@"orientation"
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

    NSArray *personArray = [DCMiscUtils optArrayForKey:@"person_tag_list"
                                              fromJSON:json
                                                 error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *persons = [DCGetContentIDListWithTagsLogic toArrayOfNamedTagHead:personArray
                                                                      tagType:DCTAGTYPE_PERSON
                                                                      guidKey:@"person_tag_guid"
                                                                      nameKey:@"person_tag_name"
                                                                        error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    if (personArray != nil && (persons.count < 1 || persons.count > 50)) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                  [NSString stringWithFormat:@"count of person_tag_info is out of range: %lu",
                   (unsigned long)persons.count]];
        return nil;
    }

    NSArray *eventArray = [DCMiscUtils optArrayForKey:@"event_tag_list"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *events = [DCGetContentIDListWithTagsLogic toArrayOfNamedTagHead:eventArray
                                                                     tagType:DCTAGTYPE_EVENT
                                                                     guidKey:@"event_tag_guid"
                                                                     nameKey:@"event_tag_name"
                                                                       error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    if (eventArray != nil && (events.count < 1 || events.count > 100)) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                  [NSString stringWithFormat:@"count of event_tag_info is out of range: %lu",
                   (unsigned long)events.count]];
        return nil;
    }

    NSArray *favoriteArray = [DCMiscUtils optArrayForKey:@"optional_tag_list"
                                                fromJSON:json
                                                   error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *favorites = [DCGetContentIDListWithTagsLogic toArrayOfNamedTagHead:favoriteArray
                                                                        tagType:DCTAGTYPE_FAVORITE
                                                                        guidKey:@"optional_tag_guid"
                                                                        nameKey:@"optional_tag_name"
                                                                          error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    if (favoriteArray != nil && (favorites.count < 1 || favorites.count > 100)) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                  [NSString stringWithFormat:@"count of optional_tag_info is out of range: %lu",
                   (unsigned long)favorites.count]];
        return nil;
    }

    NSArray *placeArray = [DCMiscUtils optArrayForKey:@"place_info_list"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *places = [DCGetContentIDListWithTagsLogic toArrayOfNamedTagHead:placeArray
                                                                     tagType:DCTAGTYPE_PLACEMENT
                                                                     guidKey:@"place_tag_guid"
                                                                     nameKey:@"place_name"
                                                                       error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    if (placeArray != nil && places.count < 1) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                  [NSString stringWithFormat:@"count of place_info is out of range: %lu",
                   (unsigned long)favorites.count]];
        return nil;
    }

    NSArray *monthArray = [DCMiscUtils optArrayForKey:@"month_info_list"
                                             fromJSON:json
                                                error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    NSArray *months = [DCGetContentIDListWithTagsLogic toArrayOfNamedTagHead:monthArray
                                                                     tagType:DCTAGTYPE_YEAR_MONTH
                                                                     guidKey:@"month_tag_guid"
                                                                     nameKey:@"month_tag_name"
                                                                       error:&cause];
    if (cause != nil) {
        *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
        return nil;
    }
    if (monthArray != nil && months.count < 1) {
        *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                  [NSString stringWithFormat:@"count of month_info is out of range: %lu",
                   (unsigned long)favorites.count]];
        return nil;
    }

    DCContentGUID *guid = [DCContentGUID guidWithString:guidString];
    DCFileType fileType = [DCEnumerationsUtils toDCFileTypeFromInt:[fileTypeNum intValue]
                                                             error:error];
    if (*error != nil) {
        return nil;
    }
    NSNumber *score = nil;
    if (scoreNum != nil) {
        score = [NSNumber numberWithInt:[DCEnumerationsUtils toDCScoreFromInt:scoreNum.intValue
                                                                        error:error]];
        if (*error != nil) {
            return nil;
        }
    }
    NSNumber *orientation = nil;
    if (orientationNum != nil) {
        orientation = [NSNumber numberWithInt:
                       [DCEnumerationsUtils toDCOrientationFromInt:orientationNum.intValue
                                                             error:error]];
        if (*error != nil) {
            return nil;
        }
    }
    BOOL resizable = [resizeNgFlg isEqualToString:@"0"];

    return [[DCDetailedContentInfo alloc] initWithGUID:guid
                                                  name:name
                                              fileType:fileType
                                        exifCameraDate:exifCameraDate
                                          modifiedDate:modifiedDate
                                          uploadedDate:uploadDate
                                          fileDataSize:[fileDataSize longLongValue]
                                             resizable:resizable
                                                 ratio:ratio
                                                 score:score
                                           orientation:orientation
                                               persons:persons
                                                events:events
                                             favorites:favorites
                                                places:places
                                            yearMonths:months];
}

+ (NSArray *)toArrayOfNamedTagHead:(NSArray *)json
                           tagType:(DCTagType)tagType
                           guidKey:(NSString *)guidKey
                           nameKey:(NSString *)nameKey
                             error:(NSError **)error
{
    NSMutableArray *array = [NSMutableArray array];
    if (json != nil) {
        NSError *cause = nil;
        for (NSDictionary *info in json) {
            DCNamedTagHead *head = [DCGetContentIDListWithTagsLogic toNamedTagHead:info
                                                                           tagType:tagType
                                                                           guidKey:guidKey
                                                                           nameKey:nameKey
                                                                             error:&cause];
            if (cause != nil) {
                *error = [DCErrorUtils responseBodyParseErrorWithCause:cause];
                return nil;
            }
            [array addObject:head];
        }
    }
    return [NSArray arrayWithArray:array];
}

+ (DCNamedTagHead *)toNamedTagHead:(NSDictionary *)json
                           tagType:(DCTagType)tagType
                           guidKey:(NSString *)guidKey
                           nameKey:(NSString *)nameKey
                             error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSString *guidString = [DCGetContentIDListWithTagsLogic tagGuidForKey:guidKey
                                                                 fromJSON:json
                                                                    error:error];
    if (guidString == nil) {
        return nil;
    }

    NSString *name = [DCGetContentIDListWithTagsLogic tagNameForKey:nameKey
                                                           fromJSON:json
                                                              error:error];
    if (name == nil) {
        return nil;
    }

    DCContentGUID *guid = [DCContentGUID guidWithString:guidString];
    return [[DCNamedTagHead alloc] initWithType:tagType
                                           guid:guid
                                           name:name];
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

+ (NSNumber *)startFromJSON:(NSDictionary *)json
             projectionType:(DCProjectionType)projectionType
                  sentStart:(NSNumber *)sentStart
                      error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    NSNumber *defaultValue = (sentStart != nil) ? sentStart :
        [NSNumber numberWithInt:-1];
    switch (projectionType) {
        case DCPROJECTIONTYPE_FILE_COUNT:
            return [DCMiscUtils optNumberForKey:@"start"
                                       fromJSON:json
                                   defaultValue:defaultValue
                               withRangeMinimum:1
                                          error:error];
        case DCPROJECTIONTYPE_ALL_DETAILS:
        case DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS:
            return [DCMiscUtils numberForKey:@"start"
                                    fromJSON:json
                            withRangeMinimum:1
                                       error:error];
        default:
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                      [NSString stringWithFormat:
                       @"unknown projection type: %ld", (long)projectionType]];
            return nil;
    }
}

+ (NSNumber *)nextPageFromJSON:(NSDictionary *)json
                projectionType:(DCProjectionType)projectionType
                         error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    switch (projectionType) {
        case DCPROJECTIONTYPE_FILE_COUNT:
            return [DCMiscUtils optNumberForKey:@"next_page"
                                       fromJSON:json
                                   defaultValue:[NSNumber numberWithInt:-1]
                               withRangeMinimum:0
                                          error:error];
        case DCPROJECTIONTYPE_ALL_DETAILS:
        case DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS:
            return [DCMiscUtils numberForKey:@"next_page"
                                    fromJSON:json
                            withRangeMinimum:0
                                       error:error];
        default:
            *error = [DCErrorUtils responseBodyParseErrorWithDescription:
                      [NSString stringWithFormat:
                       @"unknown projection type: %ld", (long)projectionType]];
            return nil;
    }
}

+ (NSString *)contentGuidFromJSON:(NSDictionary *)json
                            error:(NSError **)error
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

+ (NSString *)tagGuidForKey:(NSString *)key
                   fromJSON:(NSDictionary *)json
                      error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    return [DCMiscUtils stringForKey:key
                            fromJSON:json
              withLengthRangeMinimum:1
                             maximum:47
                               error:error];
}

+ (NSString *)tagNameForKey:(NSString *)key
                   fromJSON:(NSDictionary *)json
                      error:(NSError **)error
{
    NSAssert(json != nil, @"json must not be nil.");
    NSAssert(error != nil, @"error must not be nil.");

    return [DCMiscUtils stringForKey:key
                            fromJSON:json
              withLengthRangeMinimum:1
                             maximum:20
                               error:error];
}

@end
