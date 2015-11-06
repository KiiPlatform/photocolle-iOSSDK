#import <Foundation/Foundation.h>

@interface DCTypeRefHolder : NSObject

@property (nonatomic, readwrite, assign) CFTypeRef ref;

+ (instancetype)holder:(CFTypeRef)ref;

@end
