#import <Foundation/Foundation.h>

@interface DCExceptionUtils : NSObject

+ (void)raiseUnexpectedExceptionWithReason:(NSString *)reason;
+ (void)raiseUnexpectedExceptionWithError:(NSError *)error;
+ (void)raiseNilAssignedExceptionWithReason:(NSString *)reason;
+ (void)raiseOutOfRangeExceptionWithReason:(NSString *)reason;
+ (void)raiseInvalidArgumentExceptionWithReason:(NSString *)reason;

@end
