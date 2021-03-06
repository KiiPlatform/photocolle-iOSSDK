#import <Foundation/Foundation.h>
#import "DCTag.h"

/*!
 * Implementation of DCTag for placement.
 */
@interface DCPlacementTag : DCTag

/*!
 * Create a new placement tag.
 *
 * @param guid Guid of this tag.
 * @param name Name of this tag.
 * @param contentsCount Contents count of this tag.
 * @return Created instance.
 * @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (id)initWithGuid:(DCContentGUID *)guid
              name:(NSString *)name
     contentsCount:(int)contentsCount;

@end
