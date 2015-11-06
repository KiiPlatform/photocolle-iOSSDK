#import "DCDataID.h"
#import "DCDataID_Private.h"

@implementation DCDataID

- (id)initWithID:(NSString *)string
{
    self = [super init];
    if (self != nil) {
        self.stringValue = string;
    }
    return self;
}

@end
