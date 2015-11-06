#import "DCGetContentIDListWithTagsArguments.h"

@interface DCGetContentIDListWithTagsArguments ()

@property (nonatomic, readwrite) DCProjectionType projectionType;
@property (nonatomic, readwrite) DCFileType fileType;
@property (nonatomic, readwrite, strong) NSArray *criteriaList;
@property (nonatomic, readwrite, strong) NSNumber *forDustbox;
@property (nonatomic, readwrite, strong) id <DCDateFiltering> dateFilter;
@property (nonatomic, readwrite, strong) NSNumber *maxResults;
@property (nonatomic, readwrite, strong) NSNumber *start;
@property (nonatomic, readwrite, strong) NSNumber *sortType;

- (id)initWithContext:(DCAuthenticationContext *)context
       projectionType:(DCProjectionType)projectionType
             fileType:(DCFileType)fileType
         criteriaList:(NSArray *)criteriaList
           forDustbox:(BOOL)forDustbox
           dateFilter:(id <DCDateFiltering>)dateFilter
           maxResults:(NSNumber *)maxResults
                start:(NSNumber *)start
             sortType:(DCSortType)sortType;

+ (BOOL)isValidSortType:(DCSortType)sortType;

@end
