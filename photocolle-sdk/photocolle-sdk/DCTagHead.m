#import "DCTagHead.h"
#import "DCTagHead_Private.h"
#import "DCEnumerationsUtils.h"
#import "DCExceptionUtils.h"

@implementation DCTagHead

- (id)initWithType:(DCTagType)type guid:(DCContentGUID *)guid
{
    if ([DCEnumerationsUtils isValidTagType:type] == NO) {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:
            [NSString stringWithFormat:@"type is invalid: %ld", (long)type]];
    }
    if (guid == nil) {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:
            @"guid must not be nil."];
    }

    self = [super init];
    if (self != nil) {
        self.type = type;
        self.guid = guid;
    }
    return self;
}

@end
