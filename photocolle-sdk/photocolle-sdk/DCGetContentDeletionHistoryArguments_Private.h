#import "DCGetContentDeletionHistoryArguments.h"

@interface DCGetContentDeletionHistoryArguments ()

@property (nonatomic, readwrite) DCFileType fileType;
@property (nonatomic, readwrite, strong) NSDate *minDateDeleted;
@property (nonatomic, readwrite, strong) NSNumber *maxResults;
@property (nonatomic, readwrite, strong) NSNumber *start;

- (id)initWithContext:(DCAuthenticationContext *)context
             fileType:(DCFileType)fileType
       minDateDeleted:(NSDate *)minDateDeleted
           maxResults:(NSNumber *)maxResults
                start:(NSNumber *)start;

@end
