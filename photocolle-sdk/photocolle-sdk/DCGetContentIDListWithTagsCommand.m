#import "DCGetContentIDListWithTagsCommand.h"
#import "DCGetContentIDListWithTagsLogic.h"

@implementation DCGetContentIDListWithTagsCommand

- (id)initWithBaseURL:(NSURL *)baseURL
{
    DCGetContentIDListWithTagsLogic *logic =
        [[DCGetContentIDListWithTagsLogic alloc] init];
    self = [super initWithLogic:logic baseURL:baseURL];
    return self;
}

@end
