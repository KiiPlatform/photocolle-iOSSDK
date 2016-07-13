#import <Foundation/Foundation.h>
#import "DCContentInfo.h"
#import "DCEnumerations.h"

/*!
 * Content information with tags.
 */
@interface DCDetailedContentInfo : DCContentInfo

/*!
  XY ratio(Y/X) of this content.
 */
@property (nonatomic, readonly) NSString *ratio;

/*!
  Score of this content. See DCScore for details.
 */
@property (nonatomic, readonly) NSNumber *score;

/*!
  Orientation of this content. See DCOrientation for details.
 */
@property (nonatomic, readonly) NSNumber *orientation;

/*!
 * List of person tag.
 *
 * Elements of this NSArray are DCNamedTagHead.
 */
@property (nonatomic, readonly) NSArray *persons;

/*!
 * List of event tag.
 *
 * Elements of this NSArray are DCNamedTagHead.
 */
@property (nonatomic, readonly) NSArray *events;

/*!
 * List of favorite tag.
 *
 * Elements of this NSArray are DCNamedTagHead.
 */
@property (nonatomic, readonly) NSArray *favorites;

/*!
 * List of placement tag.
 *
 * Elements of this NSArray are DCNamedTagHead.
 */
@property (nonatomic, readonly) NSArray *places;

/*!
 * List of year month tag.
 *
 * Elements of this NSArray are DCNamedTagHead.
 */
@property (nonatomic, readonly) NSArray *yearMonths;

@end
