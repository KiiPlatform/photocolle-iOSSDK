#import "DCGetTagIDListArguments.h"
#import "DCGetTagIDListArguments_Private.h"
#import "DCEnumerationsUtils.h"
#import "DCExceptionUtils.h"

@implementation DCGetTagIDListArguments

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  category:(DCCategory)category
                  fileType:(DCFileType)fileType
           minDateModified:(NSDate *)minDateModified
{
    if (context == nil) {
        [DCExceptionUtils
         raiseNilAssignedExceptionWithReason:@"context must not be nil"];
    }
    if ([DCEnumerationsUtils isValidCategory:category] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
            [NSString stringWithFormat:@"category is invalid: %ld",
                (long)category]];
    }
    if ([DCEnumerationsUtils isValidFileTypeWithAll:fileType] == NO) {
        [DCExceptionUtils raiseOutOfRangeExceptionWithReason:
            [NSString stringWithFormat:@"fileType is invalid: %ld",
                (long)fileType]];
    }
    // no need to check minDateDeleted.

    return [[DCGetTagIDListArguments alloc]
                initWithContext:context
                       category:category
                       fileType:fileType
                minDateModified:minDateModified];
}

- (id)initWithContext:(DCAuthenticationContext *)context
             category:(DCCategory)category
             fileType:(DCFileType)fileType
      minDateModified:(NSDate *)minDateModified
{
    self = [super initWithContext:context];
    if (self != nil) {
        self.category = category;
        self.fileType = fileType;
        self.minDateModified = minDateModified;
    }
    return self;
}

@end
