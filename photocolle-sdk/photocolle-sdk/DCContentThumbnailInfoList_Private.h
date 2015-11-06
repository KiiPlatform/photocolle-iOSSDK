#import "DCContentThumbnailInfoList.h"

@interface DCContentThumbnailInfoList ()

@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, strong) NSArray *ngList;

- (id)initWithList:(NSArray *)list ngList:(NSArray *)ngList;

@end
