#import "DCGetContentBodyInfoArguments.h"

@interface DCGetContentBodyInfoArguments ()

@property (nonatomic, readwrite) DCFileType fileType;
@property (nonatomic, readwrite, strong) DCContentGUID *contentGUID;
@property (nonatomic, readwrite) DCResizeType resizeType;

- (id)initWithContext:(DCAuthenticationContext *)context
             fileType:(DCFileType)fileType
          contentGUID:(DCContentGUID *)contentGUID
           resizeType:(DCResizeType)resizeType;

@end
