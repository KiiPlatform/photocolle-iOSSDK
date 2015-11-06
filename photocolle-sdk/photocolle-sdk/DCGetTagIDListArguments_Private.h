#import "DCGetTagIDListArguments.h"

@interface DCGetTagIDListArguments ()

@property (nonatomic, readwrite) DCCategory category;
@property (nonatomic, readwrite) DCFileType fileType;
@property (nonatomic, readwrite, strong) NSDate *minDateModified;

- (id)initWithContext:(DCAuthenticationContext *)context
             category:(DCCategory)category
             fileType:(DCFileType)fileType
      minDateModified:(NSDate *)minDateModified;

@end
