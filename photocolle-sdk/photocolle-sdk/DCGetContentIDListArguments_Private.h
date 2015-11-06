#import "DCGetContentIDListArguments.h"

@interface DCGetContentIDListArguments ()

@property (nonatomic, readwrite) DCFileType fileType;
@property (nonatomic, readwrite) BOOL forDustbox;
@property (nonatomic, readwrite, strong) id <DCDateFiltering> dateFilter;
@property (nonatomic, readwrite, strong) NSNumber *maxResults;
@property (nonatomic, readwrite, strong) NSNumber *start;
@property (nonatomic, readwrite) DCSortType sortType;

- (id)initWithContext:(DCAuthenticationContext *)context
             fileType:(DCFileType)fileType
           forDustbox:(BOOL)forDustbox
           dateFilter:(id <DCDateFiltering>)dateFilter
           maxResults:(NSNumber *)maxResults
                start:(NSNumber *)start
             sortType:(DCSortType)sortType;

+ (BOOL)isValidSortType:(DCSortType)sortType;

@end
