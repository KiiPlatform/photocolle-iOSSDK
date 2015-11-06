#import "DCADeletionListArguments.h"

@implementation DCADeletionListArguments

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.fileType = DCFILETYPE_IMAGE;
        self.minDateDeleted = nil;
        self.maxResults = nil;
        self.start = nil;
    }
    return self;
}


@end
