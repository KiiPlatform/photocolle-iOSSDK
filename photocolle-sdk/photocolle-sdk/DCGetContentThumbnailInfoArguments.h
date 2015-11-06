#import "DCArguments.h"

@interface DCGetContentThumbnailInfoArguments : DCArguments

@property (nonatomic, readonly) NSArray *contentGUIDs;

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
              contentGUIDs:(NSArray *)contentGUIDs;

@end
