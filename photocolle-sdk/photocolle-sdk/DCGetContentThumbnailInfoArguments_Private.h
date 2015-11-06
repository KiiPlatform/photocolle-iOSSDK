#import "DCGetContentThumbnailInfoArguments.h"

@interface DCGetContentThumbnailInfoArguments ()

@property (nonatomic, readwrite, strong) NSArray *contentGUIDs;

- (id)initWithContext:(DCAuthenticationContext *)context
         contentGUIDs:(NSArray *)contentGUIDs;

@end
