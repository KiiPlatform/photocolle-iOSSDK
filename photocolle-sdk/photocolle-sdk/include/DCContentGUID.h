#import <Foundation/Foundation.h>
#import "DCDTO.h"

/*!
 * Guid of a content.
 */
@interface DCContentGUID : NSObject<DCDTO>

/*!
 * String representation of guid.
 */
@property (nonatomic, readonly) NSString *stringValue;

/*!
 * Create a new guid of a content.
 *
 * @param string String representation of guid which are
 * retrieved by string property.
 */
- (id)initWithGUID:(NSString *)string;

@end
