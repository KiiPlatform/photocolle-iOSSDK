#import "DCContentGUID.h"
#import "DCContentGUID_Private.h"

@implementation DCContentGUID

- (id)initWithGUID:(NSString *)string
{
    self = [super init];
    if (self != nil) {
        self.stringValue = string;
    }
    return self;
}

+ (id)guidWithString:(NSString *)string
{
    return [[DCContentGUID alloc] initWithGUID:string];
}

@end
