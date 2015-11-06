#import "DCCapacityInfo.h"
#import "DCCapacityInfo_Private.h"

@implementation DCCapacityInfo

- (id)initWithMaxSpace:(long long)maxSpace freeSpace:(long long)freeSpace
{
    self = [super init];
    if (self != nil) {
        self.maxSpace = maxSpace;
        self.freeSpace = freeSpace;
    }
    return self;
}

@end
