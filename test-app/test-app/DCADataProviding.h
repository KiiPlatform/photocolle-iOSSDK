#import <Foundation/Foundation.h>

@class DCContentGUID;

@protocol DCADataProviding <NSObject>

@required

- (NSString *)label;

- (NSString *)jsonString;

- (DCContentGUID *)id;

@end
