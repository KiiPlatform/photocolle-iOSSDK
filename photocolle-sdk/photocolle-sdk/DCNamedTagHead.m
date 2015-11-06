#import "DCNamedTagHead.h"
#import "DCNamedTagHead_Private.h"
#import "DCExceptionUtils.h"

@implementation DCNamedTagHead

- (id)initWithType:(DCTagType)type
              guid:(DCContentGUID *)guid
              name:(NSString *)name
{
    if (name == nil) {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:
         @"name must not be nil."];
    }
    
    self = [super initWithType:type guid:guid];
    if (self != nil) {
        self.name = name;
    }
    return self;
}

@end
