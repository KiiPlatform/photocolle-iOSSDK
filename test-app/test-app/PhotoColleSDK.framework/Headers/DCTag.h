#import <Foundation/Foundation.h>
#import "DCTagHead.h"

/*!
 * The abstract definition for the data model that provides a tag.
 */
@interface DCTag : DCTagHead

/*!
 * Name of this tag.
 */
@property (nonatomic, readonly) NSString *name;

/*!
 * Contents count of this tag.
 */
@property (nonatomic, readonly) int contentsCount;

@end
