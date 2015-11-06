#import "DCArguments.h"
#import "DCEnumerations.h"

@protocol DCDateFiltering;

@interface DCGetContentIDListWithTagsArguments : DCArguments

@property (nonatomic, readonly) DCProjectionType projectionType;
@property (nonatomic, readonly) DCFileType fileType;
@property (nonatomic, readonly) NSArray *criteriaList;
@property (nonatomic, readonly) NSNumber *forDustbox;
@property (nonatomic, readonly) id <DCDateFiltering> dateFilter;
@property (nonatomic, readonly) NSNumber *maxResults;
@property (nonatomic, readonly) NSNumber *start;
@property (nonatomic, readonly) NSNumber *sortType;

+ (id)argumentsWithContext:(DCAuthenticationContext *)context
            projectionType:(DCProjectionType)projectionType
                  fileType:(DCFileType)fileType
              criteriaList:(NSArray *)criteriaList
                forDustbox:(BOOL)forDustbox
                dateFilter:(id <DCDateFiltering>)dateFilter
                maxResults:(NSNumber *)maxResults
                     start:(NSNumber *)start
                  sortType:(DCSortType)sortType;

@end
