#import "DCATagListArguments.h"

@interface DCATagListArguments()

@end

@implementation DCATagListArguments

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.category = DCCATEGORY_ALL;
        self.fileType = DCFILETYPE_ALL;
        self.minDateModified = nil;
    }
    return self;
}

@end
