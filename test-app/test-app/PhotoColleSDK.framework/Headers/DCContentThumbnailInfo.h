#import <Foundation/Foundation.h>
#import "DCDTO.h"
#import "DCContentGUID.h"
#import "DCEnumerations.h"

/*!
 * Content thumbnail information.
 */
@interface DCContentThumbnailInfo : NSObject<DCDTO>

/*!
 * Guid of this content.
 */
@property (nonatomic, readonly) DCContentGUID *guid;

/*!
  MIME type of this content. See DCMimeType for details.
 */
@property (nonatomic, readonly) DCMimeType mimeType;

/*!
 * Thumbnail byte data of this content.
 */
@property (nonatomic, readonly) NSData *thumbnailBytes;

@end
