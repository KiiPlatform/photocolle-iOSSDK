#import <Foundation/Foundation.h>
#import <photocolle_iOSSDK/DCPhotoColleSDK.h>

@protocol DCDateFiltering;

@interface DCAContentInfoListArguments : NSObject

@property (nonatomic, readwrite) DCFileType fileType;

@property (nonatomic, readwrite) BOOL forDustbox;

@property (nonatomic, readwrite, strong) id<DCDateFiltering> dateFilter;

@property (nonatomic, readwrite, strong) NSNumber *maxResults;

@property (nonatomic, readwrite, strong) NSNumber *start;

@property (nonatomic, readwrite) DCSortType sortType;

- (id)init;

@end
