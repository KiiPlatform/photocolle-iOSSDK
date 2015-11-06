#import <Foundation/Foundation.h>
#import <PhotoColleSDK/DCEnumerations.h>

@protocol DCDateFiltering;

@interface DCADetailedContentInfoListArguments : NSObject

@property (nonatomic, readwrite) DCProjectionType projectionType;

@property (nonatomic, readwrite) DCFileType fileType;

@property (nonatomic, readwrite) NSArray *criteriaList;

@property (nonatomic, readwrite) BOOL forDustbox;

@property (nonatomic, readwrite, strong) id<DCDateFiltering> dateFilter;

@property (nonatomic, readwrite, strong) NSNumber *maxResults;

@property (nonatomic, readwrite, strong) NSNumber *start;

@property (nonatomic, readwrite) DCSortType sortType;

- (id)init;

@end
