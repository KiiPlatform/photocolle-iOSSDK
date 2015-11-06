#import <Foundation/Foundation.h>
#import "DCTagHead.h"

/*!
 * TagHead with <font>name</font>.
 */
@interface DCNamedTagHead : DCTagHead

/*!
 * Name of this tag.
 */
@property (nonatomic, readonly) NSString *name;

/*!
 * Create a new instance.
 *
 * @param type Type of this tag. See DCTagType for details.
 * @param guid Guid of this tag.
 * @param name Name of this tag.
 * @return Created instance.
 * @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (id)initWithType:(DCTagType)type
              guid:(DCContentGUID *)guid
              name:(NSString *)name;

@end
