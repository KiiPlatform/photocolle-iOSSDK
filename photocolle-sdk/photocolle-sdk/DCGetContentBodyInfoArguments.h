#import "DCArguments.h"
#import "DCEnumerations.h"

@class DCContentGUID;

@interface DCGetContentBodyInfoArguments : DCArguments

@property (nonatomic, readonly) DCFileType fileType;
@property (nonatomic, readonly) DCContentGUID *contentGUID;
@property (nonatomic, readonly) DCResizeType resizeType;

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  fileType:(DCFileType)fileType
               contentGUID:(DCContentGUID *)contentGUID
                resizeType:(DCResizeType)resizeType;

@end
