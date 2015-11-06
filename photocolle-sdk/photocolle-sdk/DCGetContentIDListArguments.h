#import "DCArguments.h"
#import "DCEnumerations.h"

@protocol DCDateFiltering;

@interface DCGetContentIDListArguments : DCArguments

@property (nonatomic, readonly) DCFileType fileType;
@property (nonatomic, readonly) BOOL forDustbox;
@property (nonatomic, readonly) id <DCDateFiltering> dateFilter;
@property (nonatomic, readonly) NSNumber *maxResults;
@property (nonatomic, readonly) NSNumber *start;
@property (nonatomic, readonly) DCSortType sortType;

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
                  fileType:(DCFileType)fileType
                forDustbox:(BOOL)forDustbox
                dateFilter:(id <DCDateFiltering>)dateFilter
                maxResults:(NSNumber *)maxResults
                     start:(NSNumber *)start
                  sortType:(DCSortType)sortType;

@end
