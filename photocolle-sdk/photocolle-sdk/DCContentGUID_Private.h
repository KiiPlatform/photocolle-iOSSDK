#import "DCContentGUID.h"

@interface DCContentGUID ()

@property (nonatomic, readwrite, strong) NSString *stringValue;


/*!
 * @method guidWithString
 * @abstract Create a new guid of a content.
 * @param string String representation of guid which are
 * retrieved by string property.
 */
+ (id)guidWithString:(NSString *)string;

@end
