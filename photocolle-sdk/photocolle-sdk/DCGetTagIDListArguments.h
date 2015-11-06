#import "DCArguments.h"
#import "DCEnumerations.h"

@interface DCGetTagIDListArguments : DCArguments

@property (nonatomic, readonly) DCCategory category;
@property (nonatomic, readonly) DCFileType fileType;
@property (nonatomic, readonly) NSDate *minDateModified;

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  category:(DCCategory)category
                  fileType:(DCFileType)fileType
           minDateModified:(NSDate *)minDateModified;

@end
