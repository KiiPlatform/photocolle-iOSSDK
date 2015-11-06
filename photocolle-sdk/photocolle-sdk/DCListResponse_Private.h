#import "DCListResponse.h"

@interface DCListResponse ()

@property (nonatomic, readwrite) int count;
@property (nonatomic, readwrite) int nextPage;
@property (nonatomic, readwrite) int start;
@property (nonatomic, readwrite, strong) NSArray *list ;

- (DCListResponse *)initWithCount:(int)count
                            start:(int)start
                         nextPage:(int)nextPage
                             list:(NSArray *)list;
@end
