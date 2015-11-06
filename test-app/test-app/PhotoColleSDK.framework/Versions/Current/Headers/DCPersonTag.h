#import <Foundation/Foundation.h>
#import "DCTag.h"

/*!
 * Implementation of DCTag for person.
 */
@interface DCPersonTag : DCTag

/*!
 * Birthday of person.
 */
@property (nonatomic, readonly) NSDate *birthDate;

/*!
 * Create a new person tag.
 *
 * @param guid Guid of this tag.
 * @param name Name of this tag.
 * @param contentsCount Contents count of this tag.
 * @param birthDate Birthday of person.
 * @return Created instance.
 * @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (id)initWithGuid:(DCContentGUID *)guid
              name:(NSString *)name
     contentsCount:(int)contentsCount
         birthDate:(NSDate *)birthDate;

@end
