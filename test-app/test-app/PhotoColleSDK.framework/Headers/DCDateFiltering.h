#import <Foundation/Foundation.h>

/*!
 * Date time filter protocol.
 */
@protocol DCDateFiltering

@required

/*!
 * Get date time value.
 *
 * @return Date time value of this filter.
 */
- (NSDate *)getDate;

/*!
 * Get the name of this filter.
 *
 * @return The name of this filter.
 */
- (NSString *)getFilterName;

/*!
 * Get date time value of this filter as NSString.
 *
 * @return The value of this filter as NSString.
 */
- (NSString *)getFilterValue;

@end
