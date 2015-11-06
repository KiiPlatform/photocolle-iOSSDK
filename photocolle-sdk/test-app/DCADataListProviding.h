#import <Foundation/Foundation.h>

@class DCPhotoColle;
@protocol DCADataProviding;

@protocol DCADataListProviding <NSObject>

@required
- (NSInteger)count;

- (id <DCADataProviding>)objectAtIndex:(NSInteger)index;

- (BOOL)retrieveDataWithPhotoColle:(DCPhotoColle *)photocolle
                             error:(NSError **)error;

@end
