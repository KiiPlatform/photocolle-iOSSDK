#import "DCGetContentIDListWithTagsArguments.h"
#import "DCGetContentIDListWithTagsArguments_Private.h"
#import "DCEnumerationsUtils.h"
#import "DCExceptionUtils.h"
#import "DCTagHead.h"
#import "DCContentGUID_Private.h"
#import "DCUploadDateFilter.h"
#import "DCModifiedDateFilter.h"

@implementation DCGetContentIDListWithTagsArguments

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
            projectionType:(DCProjectionType)projectionType
                  fileType:(DCFileType)fileType
              criteriaList:(NSArray *)criteriaList
                forDustbox:(BOOL)forDustbox
                dateFilter:(id <DCDateFiltering>)dateFilter
                maxResults:(NSNumber *)maxResults
                     start:(NSNumber *)start
                  sortType:(DCSortType)sortType
{
    if (context == nil) {
        [DCExceptionUtils raiseNilAssignedExceptionWithReason:
         @"context must not be nil"];
    }
    if ([DCEnumerationsUtils isValidProjectionType:projectionType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
            [NSString stringWithFormat:@"projectionType is invalid: %ld",
                (long)projectionType]];
    }
    if ([DCEnumerationsUtils isValidFileTypeWithAll:fileType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
         [NSString stringWithFormat:@"fileType is invalid: %ld",
             (long)fileType]];
    }
    if (projectionType == DCPROJECTIONTYPE_FILE_COUNT) {
        // If projectionType is DCPROJECTIONTYPE_FILE_COUNT, then
        // parameters except fileType should not be sent to server.
        criteriaList = nil;
        dateFilter = nil;
        maxResults = nil;
        start = nil;
    } else {
        [DCGetContentIDListWithTagsArguments checkArgumentsDefaultWithCriteriaList:criteriaList
                                                                        dateFilter:dateFilter
                                                                        maxResults:maxResults
                                                                             start:start];
    }
    if ([DCGetContentIDListWithTagsArguments isValidSortType:sortType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
         [NSString stringWithFormat:@"sortType is invalid: %ld",
             (long)sortType]];
    }

    return [[DCGetContentIDListWithTagsArguments alloc]
            initWithContext:context
            projectionType:projectionType
            fileType:fileType
            criteriaList:criteriaList
            forDustbox:forDustbox
            dateFilter:dateFilter
            maxResults:maxResults
            start:start
            sortType:sortType];
}

+ (void)checkArgumentsDefaultWithCriteriaList:(NSArray *)criteriaList
                                   dateFilter:(id <DCDateFiltering>)dateFilter
                                   maxResults:(NSNumber *)maxResults
                                        start:(NSNumber *)start
{
    if (criteriaList != nil) {
        if ([criteriaList count] > 5) {
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"criteriaList has too many: %lu",
                    (unsigned long)[criteriaList count]]];
        }
        for (DCTagHead *criteria in criteriaList) {
            if (criteria != nil && [criteria isEqual:[NSNull null]] == NO) {
                if ([DCEnumerationsUtils isValidTagType:criteria.type] == NO) {
                    [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                     [NSString stringWithFormat:@"type of criteria out of range: %ld",
                      (long)criteria.type]];
                }
                if (criteria.guid == nil) {
                    [DCExceptionUtils raiseNilAssignedExceptionWithReason:
                     @"member of criteria must not be nil"];
                }
                NSString *guidStr = criteria.guid.stringValue;
                if (guidStr == nil) {
                    [DCExceptionUtils raiseNilAssignedExceptionWithReason:
                     @"value of ContentGUID must not be nil"];
                } else if (guidStr.length < 1 || guidStr.length > 47) {
                    [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                     [NSString stringWithFormat:@"length of guid string out of range: %lu",
                      (unsigned long)guidStr.length]];
                }
            }
        }
    }
    // no need to check forDustbox.
    if (dateFilter != nil) {
        if ([(NSObject *)dateFilter isMemberOfClass:[DCUploadDateFilter class]] == NO &&
            [(NSObject *)dateFilter isMemberOfClass:[DCModifiedDateFilter class]] == NO) {
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
             [NSString stringWithFormat:@"Unknown dateFilter class: %@",
              NSStringFromClass([(NSObject *)dateFilter class])]];
        }
    }
    if (maxResults != nil) {
        if ([maxResults intValue] < 1 || [maxResults intValue] > 1000) {
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
             [NSString stringWithFormat:
              @"value of maxResults is out of range: %d",
              [maxResults intValue]]];
        }
    }
    if (start != nil) {
        if ([start intValue] < 1) {
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
             [NSString stringWithFormat:
              @"value of start is out of range: %d", [start intValue]]];
        }
    }
}

- (id)initWithContext:(DCAuthenticationContext *)context
       projectionType:(DCProjectionType)projectionType
             fileType:(DCFileType)fileType
         criteriaList:(NSArray *)criteriaList
           forDustbox:(BOOL)forDustbox
           dateFilter:(id <DCDateFiltering>)dateFilter
           maxResults:(NSNumber *)maxResults
                start:(NSNumber *)start
             sortType:(DCSortType)sortType
{
    self = [super initWithContext:context];
    if (self != nil) {
        self.projectionType = projectionType;
        self.fileType = fileType;
        self.criteriaList = criteriaList;
        self.forDustbox = (projectionType != DCPROJECTIONTYPE_FILE_COUNT ?
                           [NSNumber numberWithBool:forDustbox] : nil);
        self.dateFilter = dateFilter;
        self.maxResults = maxResults;
        self.start = start;
        self.sortType = (projectionType != DCPROJECTIONTYPE_FILE_COUNT ?
                         [DCEnumerationsUtils toNSNumberFromDCSortType:sortType] :
                         nil);
    }
    return self;
}

+ (BOOL)isValidSortType:(DCSortType)sortType
{
    switch (sortType) {
        case DCSORTTYPE_CREATION_DATETIME_ASC:
            return YES;
        case DCSORTTYPE_CREATION_DATETIME_DESC:
            return YES;
        case DCSORTTYPE_MODIFICATION_DATETIME_ASC:
            return YES;
        case DCSORTTYPE_MODIFICATION_DATETIME_DESC:
            return YES;
        case DCSORTTYPE_UPLOAD_DATETIME_ASC:
            return YES;
        case DCSORTTYPE_UPLOAD_DATETIME_DESC:
            return YES;
        case DCSORTTYPE_SCORE_DESC:
            return YES;
        default:
            return NO;
    }
}

@end
