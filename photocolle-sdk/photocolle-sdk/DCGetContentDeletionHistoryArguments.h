#import "DCArguments.h"
#import "DCEnumerations.h"

@interface DCGetContentDeletionHistoryArguments : DCArguments

@property (nonatomic, readonly) DCFileType fileType;
@property (nonatomic, readonly) NSDate *minDateDeleted;
@property (nonatomic, readonly) NSNumber *maxResults;
@property (nonatomic, readonly) NSNumber *start;

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  fileType:(DCFileType)fileType
            minDateDeleted:(NSDate *)minDateDeleted
                maxResults:(NSNumber *)maxResults
                     start:(NSNumber *)start;

@end
