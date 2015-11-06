#import "DCTag.h"
#import "DCTag_Private.h"
#import "DCExceptionUtils.h"

@implementation DCTag

- (id)initWithType:(DCTagType)type
              guid:(DCContentGUID *)guid
              name:(NSString *)name
     contentsCount:(int)contentsCount
{
    if (name == nil) {
        [DCExceptionUtils raiseInvalidArgumentExceptionWithReason:
            @"name must not be nil."];
    }

    self = [super initWithType:type guid:guid];
    if (self != nil) {
        self.name = name;
        self.contentsCount = contentsCount;
    }
    return self;
}

@end
