#import "DCGetContentDeletionHistoryCommand.h"
#import "DCGetContentDeletionHistoryLogic.h"

@implementation DCGetContentDeletionHistoryCommand

- (id)initWithBaseURL:(NSURL *)baseURL
{
    DCGetContentDeletionHistoryLogic *logic =
        [[DCGetContentDeletionHistoryLogic alloc] init];
    self = [super initWithLogic:logic baseURL:baseURL];
    return self;
}

@end
