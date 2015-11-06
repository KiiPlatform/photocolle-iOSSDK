#import "DCGetContentThumbnailInfoArguments.h"
#import "DCGetContentThumbnailInfoArguments_Private.h"
#import "DCExceptionUtils.h"
#import "DCContentGUID.h"

@implementation DCGetContentThumbnailInfoArguments

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
              contentGUIDs:(NSArray *)contentGUIDs
{
    if (context == nil) {
        [DCExceptionUtils
            raiseNilAssignedExceptionWithReason:@"context must not be nil"];
    }
    if (contentGUIDs == nil) {
        [DCExceptionUtils
            raiseNilAssignedExceptionWithReason:@"contentGUIDs must not be nil"];
    }
    NSUInteger count = [contentGUIDs count];
    if (count < 1 || count > 100) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
            [NSString stringWithFormat:@"contentGUIDs's count is invalid: %lu",
                (unsigned long)count]];
    }
    for (DCContentGUID *contentGUID in contentGUIDs) {
        if (contentGUID == nil) {
            [DCExceptionUtils raiseNilAssignedExceptionWithReason:
             @"contentGUID must not be nil"];
        } else if (contentGUID.stringValue == nil) {
            [DCExceptionUtils raiseNilAssignedExceptionWithReason:
             @"contentGUID.stringValue must not be nil"];
        } else if ([contentGUID.stringValue length] < 1 ||
                   [contentGUID.stringValue length] > 50) {
            [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
             [NSString stringWithFormat:
              @"contentGUID.stringValue is out of range: %lu",
              (unsigned long)[contentGUID.stringValue length]]];
        }
    }

    return [[DCGetContentThumbnailInfoArguments alloc]
                initWithContext:context contentGUIDs:contentGUIDs];
}

- (id)initWithContext:(DCAuthenticationContext *)context
         contentGUIDs:(NSArray *)contentGUIDs
{
    self = [super initWithContext:context];
    if (self != nil) {
        self.contentGUIDs = contentGUIDs;
    }
    return self;
}

@end
