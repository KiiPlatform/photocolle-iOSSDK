#import "DCMiscUtilsTest.h"
#import "DCMiscUtils.h"

@implementation DCMiscUtilsTest

- (void)testFirstMatchedToPatternOptionsError1
{
    NSString *actual =
        [DCMiscUtils firstMatched:nil
                        toPattern:nil
                          options:NSRegularExpressionCaseInsensitive
                            error:nil];
    GHAssertNil(actual, @"must be nil");
}

- (void)testFirstMatchedToPatternOptionsError2
{
    NSException *exception = nil;
    @try {
        [DCMiscUtils firstMatched:@"text"
                        toPattern:nil
                          options:NSRegularExpressionCaseInsensitive
                            error:nil];
    } @catch (NSException *e) {
        exception = e;
    }
    GHAssertNotNil(exception, @"must not be nil");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name,
                         @"must be NSInvalidArgumentException.");
}

- (void)testFirstMatchedToPatternOptionsError3
{
    NSError *error = nil;
    NSString *actual =
        [DCMiscUtils firstMatched:@"text"
                        toPattern:@"(.*)"
                          options:NSRegularExpressionCaseInsensitive
                            error:&error];
    GHAssertEqualStrings(@"text", actual, @"string must be equal.");
}

- (void)testFirstMatchedToPatternOptionsError4
{
    NSError *error = nil;
    NSString *actual =
        [DCMiscUtils firstMatched:@"oauth_problem=token_expired"
                        toPattern:@"oauth_problem=(.*)"
                          options:NSRegularExpressionCaseInsensitive
                            error:&error];
    GHAssertEqualStrings(@"token_expired", actual, @"string must be equal.");
}

@end
