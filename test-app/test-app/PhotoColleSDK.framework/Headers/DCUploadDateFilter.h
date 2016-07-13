#import <Foundation/Foundation.h>
#import "DCDateFiltering.h"

/*!
 * The filter of upload date time.
 */
@interface DCUploadDateFilter : NSObject<DCDateFiltering>

/*!
 * Create a new DCUploadDateFilter.
 *
 * @param date Value of filter.
 * @return Created instance.
 * @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (id)initWithDate:(NSDate *)date;

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
