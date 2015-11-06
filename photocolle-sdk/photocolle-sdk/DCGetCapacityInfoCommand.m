#import "DCGetCapacityInfoCommand.h"
#import "DCGetCapacityInfoLogic.h"

@implementation DCGetCapacityInfoCommand

- (id)initWithBaseURL:(NSURL *)baseURL
{
    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    self = [super initWithLogic:logic baseURL:baseURL];
    return self;
}

@end
