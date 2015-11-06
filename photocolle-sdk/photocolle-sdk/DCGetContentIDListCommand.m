#import "DCGetContentIDListCommand.h"
#import "DCGetContentIDListLogic.h"

@implementation DCGetContentIDListCommand

- (id)initWithBaseURL:(NSURL *)baseURL
{
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    self = [super initWithLogic:logic baseURL:baseURL];
    return self;
}

@end
