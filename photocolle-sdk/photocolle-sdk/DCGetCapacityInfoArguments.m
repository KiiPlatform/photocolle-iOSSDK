#import "DCGetCapacityInfoArguments.h"
#import "DCExceptionUtils.h"

@implementation DCGetCapacityInfoArguments

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
{
    if (context == nil) {
        [DCExceptionUtils
            raiseNilAssignedExceptionWithReason:@"context must not be nil"];
    }

    return [[DCGetCapacityInfoArguments alloc] initWithContext:context];
}

@end
