#import <Foundation/Foundation.h>
#import "DCDTO.h"
#import "DCContentGUID.h"
#import "DCEnumerations.h"

/*!
 * Content information.
 */
@interface DCContentInfo : NSObject<DCDTO>

/*!
 * Guid of this content.
 */
@property (nonatomic, readonly) DCContentGUID *guid;

/*!
 * Name of this content.
 */
@property (nonatomic, readonly) NSString *name;

/*!
 * File type of this content.
 *
 * Details of DCFileType are described at
 * [DCPhotoColle getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:]
 */
@property (nonatomic, readonly) DCFileType fileType;

/*!
 * Photo taking day extracted from EXIF.
 */
@property (nonatomic, readonly) NSDate *exifCameraDate;

/*!
 * Modified date time.
 */
@property (nonatomic, readonly) NSDate *modifiedDate;

/*!
 * Uploaded date time.
 */
@property (nonatomic, readonly) NSDate *uploadedDate;

/*!
 * File size of this content.
 */
@property (nonatomic, readonly) long long fileDataSize;

/*!
 * Resizable flag to determine resizing content is allowed or not.
 */
@property (nonatomic, readonly) BOOL resizable;

@end
