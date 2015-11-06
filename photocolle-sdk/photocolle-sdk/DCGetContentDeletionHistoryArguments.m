#import "DCGetContentDeletionHistoryArguments.h"
#import "DCGetContentDeletionHistoryArguments_Private.h"
#import "DCEnumerationsUtils.h"
#import "DCExceptionUtils.h"

@implementation DCGetContentDeletionHistoryArguments

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  fileType:(DCFileType)fileType
            minDateDeleted:(NSDate *)minDateDeleted
                maxResults:(NSNumber *)maxResults
                     start:(NSNumber *)start
{
    if (context == nil) {
        [DCExceptionUtils
            raiseNilAssignedExceptionWithReason:@"context must not be nil"];
    }
    if ([DCEnumerationsUtils isValidFileType:fileType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
                [NSString stringWithFormat:@"fileType is invalid: %ld",
                    (long)fileType]];
    }
    // no need to check minDateDeleted.
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

    return [[DCGetContentDeletionHistoryArguments alloc]
             initWithContext:context
                    fileType:fileType
              minDateDeleted:minDateDeleted
                  maxResults:maxResults
                       start:start];
}

- (id)initWithContext:(DCAuthenticationContext *)context
             fileType:(DCFileType)fileType
       minDateDeleted:(NSDate *)minDateDeleted
           maxResults:(NSNumber *)maxResults
                start:(NSNumber *)start
{
    self = [super initWithContext:context];
    if (self != nil) {
        self.fileType = fileType;
        self.minDateDeleted = minDateDeleted;
        self.maxResults = maxResults;
        self.start = start;
    }
    return self;
}

@end
