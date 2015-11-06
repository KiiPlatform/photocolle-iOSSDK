#import "DCCapacityInfo.h"

@interface DCCapacityInfo ()
@property (nonatomic, readwrite) long long maxSpace;
@property (nonatomic, readwrite) long long freeSpace;

- (id)initWithMaxSpace:(long long)maxSpace freeSpace:(long long)freeSpace;

@end
