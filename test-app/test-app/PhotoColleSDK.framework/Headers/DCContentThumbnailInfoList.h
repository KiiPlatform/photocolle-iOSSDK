#import <Foundation/Foundation.h>
#import "DCDTO.h"

/*!
 * List of content thumbnail information.
 */
@interface DCContentThumbnailInfoList : NSObject<DCDTO>

/*!
 * List of content thumbnail information.
 *
 * Elements of this NSArray are DCContentThumbnailInfo.
 */
@property (nonatomic, readonly) NSArray *list;

/*!
 * List of content guids whose thumbnails PhotoColleSDK failed to retrieve.
 *
 * Elements of this NSArray are DCContentGUID.
 */
@property (nonatomic, readonly) NSArray *ngList;

@end
