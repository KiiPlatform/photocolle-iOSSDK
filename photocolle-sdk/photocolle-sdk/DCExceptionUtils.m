#import "DCExceptionUtils.h"

static NSString * const DCUNEXPECTEDEXCEPTION = @"DCUnexpectedException";
static NSString * const NIL_ASSIGNED = @"nil was assigned";
static NSString * const OUT_OF_RANGE = @"out of range";

@implementation DCExceptionUtils

+ (void)raiseUnexpectedExceptionWithReason:(NSString *)reason
{
    [[NSException exceptionWithName:DCUNEXPECTEDEXCEPTION
                             reason:reason
                           userInfo:nil] raise];
}

+ (void)raiseUnexpectedExceptionWithError:(NSError *)error
{
    NSString *reason = [NSString stringWithFormat:@"%@ %ld %@", error.domain,
                                 (long)error.code, [error.userInfo description]];
    [DCExceptionUtils raiseUnexpectedExceptionWithReason:reason];
}

+ (void)raiseNilAssignedExceptionWithReason:(NSString *)reason
{
    if (reason == nil) {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:NIL_ASSIGNED];
    } else {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:
                [NSString stringWithFormat:@"%@: %@", NIL_ASSIGNED, reason]];
    }
}

+ (void)raiseOutOfRangeExceptionWithReason:(NSString *)reason
{
    if (reason == nil) {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:OUT_OF_RANGE];
    } else {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:
                [NSString stringWithFormat:@"%@: %@", OUT_OF_RANGE, reason]];
    }
}

+ (void)raiseInvalidArgumentExceptionWithReason:(NSString *)reason
{
    [[NSException exceptionWithName:NSInvalidArgumentException
                             reason:reason
                           userInfo:nil] raise];
}

@end
