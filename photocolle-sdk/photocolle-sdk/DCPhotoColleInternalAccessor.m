#import "DCPhotoColleInternalAccessor.h"

#import "DCPhotoColle_Private.h"

@implementation DCPhotoColleInternalAccessor

+ (void)setBaseUrl:(NSURL *)baseUrl
      toPhotoColle:(DCPhotoColle *)photoColle
{
    photoColle.baseUrl = baseUrl;
}

@end
