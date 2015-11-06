#import "DCGetContentIDListArguments.h"
#import "DCGetContentIDListArguments_Private.h"
#import "DCEnumerationsUtils.h"
#import "DCExceptionUtils.h"

@implementation DCGetContentIDListArguments

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  fileType:(DCFileType)fileType
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
    if ([DCEnumerationsUtils isValidFileType:fileType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
         [NSString stringWithFormat:@"fileType is invalid: %ld",
                   (long)fileType]];
    }
    // no need to check forDustbox.
    // no need to check dateFilter.
    if (maxResults != nil) {
        if ([maxResults intValue] < 1 || [maxResults intValue] > 100) {
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
    if ([DCGetContentIDListArguments isValidSortType:sortType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
         [NSString stringWithFormat:@"sortType is invalid: %ld",
                   (long)sortType]];
    }

    return [[DCGetContentIDListArguments alloc]
                initWithContext:context
                       fileType:fileType
                     forDustbox:forDustbox
                     dateFilter:dateFilter
                     maxResults:maxResults
                          start:start
                       sortType:sortType];
}

- (id)initWithContext:(DCAuthenticationContext *)context
             fileType:(DCFileType)fileType
           forDustbox:(BOOL)forDustbox
           dateFilter:(id <DCDateFiltering>)dateFilter
           maxResults:(NSNumber *)maxResults
                start:(NSNumber *)start
             sortType:(DCSortType)sortType
{
    self = [super initWithContext:context];
    if (self != nil) {
        self.fileType = fileType;
        self.forDustbox = forDustbox;
        self.dateFilter = dateFilter;
        self.maxResults = maxResults;
        self.start = start;
        self.sortType = sortType;
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
            // API 2.00 can not use DCSORTTYPE_SCORE_DESC.
        default:
            return NO;
    }
}

@end
