#import <Foundation/Foundation.h>
#import "DCDTO.h"
#import "DCEnumerations.h"

@class DCContentGUID;

/*!
 * Implementation of header info for tag.
 */
@interface DCTagHead : NSObject<DCDTO>

/*!
  Type of this tag. See DCTagType for details.
 */
@property (nonatomic, readonly) DCTagType type;

/*!
 * Guid of this tag.
 */
@property (nonatomic, readonly) DCContentGUID *guid;

/*!
 * Create a new instance.
 *
 * @param type Type of this tag.
 * @param guid Guid of this tag.
 * @return Created instance.
 * @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (id)initWithType:(DCTagType)type guid:(DCContentGUID *)guid;

@end
