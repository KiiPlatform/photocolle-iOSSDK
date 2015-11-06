#import "DCCommand.h"

@protocol DCLogic;

@interface DCCommand ()

@property (nonatomic, readwrite, strong) id <DCLogic> logic;
@property (nonatomic, readwrite, strong) NSURL *baseURL;
@property (nonatomic, readonly) NSURL *targetURL;

@end
