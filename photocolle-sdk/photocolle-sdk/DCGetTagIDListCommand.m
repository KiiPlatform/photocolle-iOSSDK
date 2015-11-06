#import "DCGetTagIDListCommand.h"
#import "DCGetTagIDListLogic.h"

@implementation DCGetTagIDListCommand

- (id)initWithBaseURL:(NSURL *)baseURL
{
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    self = [super initWithLogic:logic baseURL:baseURL];
    return self;
}

@end
