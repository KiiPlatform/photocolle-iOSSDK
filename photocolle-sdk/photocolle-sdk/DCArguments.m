#import "DCArguments.h"
#import "DCArguments_Private.h"

@implementation DCArguments

- (id)initWithContext:(DCAuthenticationContext *)context
{
    self = [super init];
    if (self != nil) {
        self.context = context;
    }
    return self;
}

@end
