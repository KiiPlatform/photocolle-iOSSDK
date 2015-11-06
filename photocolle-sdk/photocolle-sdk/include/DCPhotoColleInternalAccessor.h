#import <Foundation/Foundation.h>

@class DCPhotoColle;

// This is a secret class to integrate PhotoColleSDK to KiiCloudSDK.
@interface DCPhotoColleInternalAccessor : NSObject

+ (void)setBaseUrl:(NSURL *)baseUrl
      toPhotoColle:(DCPhotoColle *)photoColle;

@end
