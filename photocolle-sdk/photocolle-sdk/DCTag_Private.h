#import "DCTag.h"

@interface DCTag ()

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite) int contentsCount;

- (id)initWithType:(DCTagType)type
              guid:(DCContentGUID *)guid
              name:(NSString *)name
     contentsCount:(int)contentsCount;

@end
