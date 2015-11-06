#import "DCGetContentBodyInfoArguments.h"
#import "DCGetContentBodyInfoArguments_Private.h"
#import "DCEnumerationsUtils.h"
#import "DCExceptionUtils.h"
#import "DCContentGUID.h"

@implementation DCGetContentBodyInfoArguments

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  fileType:(DCFileType)fileType
               contentGUID:(DCContentGUID *)contentGUID
                resizeType:(DCResizeType)resizeType
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
    if ([DCEnumerationsUtils isValidResizeType:resizeType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
            [NSString stringWithFormat:@"resizeType is invalid: %ld",
                (long)resizeType]];
    } else if (resizeType == DCRESIZETYPE_RESIZED_VIDEO &&
               (fileType == DCFILETYPE_IMAGE ||
                    fileType == DCFILETYPE_SLIDE_MOVIE)) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
            @"This combination of FileType and ResizeType is invalid."];
    }

    return [[DCGetContentBodyInfoArguments alloc]
                initWithContext:context
                       fileType:fileType
                    contentGUID:contentGUID
                     resizeType:resizeType];
}

- (id)initWithContext:(DCAuthenticationContext *)context
             fileType:(DCFileType)fileType
          contentGUID:(DCContentGUID *)contentGUID
           resizeType:(DCResizeType)resizeType
{
    self = [super initWithContext:context];
    if (self != nil) {
        self.fileType = fileType;
        self.contentGUID = contentGUID;
        self.resizeType = resizeType;
    }
    return self;
}

@end
