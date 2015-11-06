#import "DCErrorUtilsTest.h"
#import "DCErrorUtils_Private.h"

#import "OCMock/OCMock.h"

@implementation DCErrorUtilsTest

- (void)testIsTokenExpired1
{
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[mockResponse stub]
       andReturnValue:OCMOCK_VALUE((NSInteger){200})] statusCode];
    BOOL actual = [DCErrorUtils isTokenExpired:mockResponse];
    GHAssertFalse(actual, @"must be NO");
}

- (void)testIsTokenExpired2
{
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[mockResponse stub]
       andReturnValue:OCMOCK_VALUE((NSInteger){401})] statusCode];
    [[[mockResponse stub] andReturn:nil] allHeaderFields];
    BOOL actual = [DCErrorUtils isTokenExpired:mockResponse];
    GHAssertFalse(actual, @"must be NO");
}

- (void)testIsTokenExpired3
{
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[mockResponse stub]
       andReturnValue:OCMOCK_VALUE((NSInteger){401})] statusCode];
    [[[mockResponse stub] andReturn:[NSDictionary dictionary]] allHeaderFields];
    BOOL actual = [DCErrorUtils isTokenExpired:mockResponse];
    GHAssertFalse(actual, @"must be NO");
}

- (void)testIsTokenExpired4
{
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[mockResponse stub]
       andReturnValue:OCMOCK_VALUE((NSInteger){401})] statusCode];
    NSDictionary *dict =
        [NSDictionary dictionaryWithObjectsAndKeys:@"hogehoge", @"fugafuga",
                nil];
    [[[mockResponse stub] andReturn:dict] allHeaderFields];
    BOOL actual = [DCErrorUtils isTokenExpired:mockResponse];
    GHAssertFalse(actual, @"must be NO");
}

- (void)testIsTokenExpired5
{
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[mockResponse stub]
       andReturnValue:OCMOCK_VALUE((NSInteger){401})] statusCode];
    NSDictionary *dict =
        [NSDictionary dictionaryWithObjectsAndKeys:@"error=other_reason",
                      @"WWW-Authenticate", nil];
    [[[mockResponse stub] andReturn:dict] allHeaderFields];
    BOOL actual = [DCErrorUtils isTokenExpired:mockResponse];
    GHAssertFalse(actual, @"must be NO");
}

- (void)testIsTokenExpired6
{
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[mockResponse stub]
       andReturnValue:OCMOCK_VALUE((NSInteger){401})] statusCode];
    NSDictionary *dict =
        [NSDictionary dictionaryWithObjectsAndKeys:@"error=invalid_token",
                      @"WWW-Authenticate", nil];
    [[[mockResponse stub] andReturn:dict] allHeaderFields];
    BOOL actual = [DCErrorUtils isTokenExpired:mockResponse];
    GHAssertTrue(actual, @"must be YES");
}

- (void)testApplicationLayerErrorSuccess
{
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:100], @"err_cd",
                          nil];
    NSError* error = [DCErrorUtils applicationLayerErrorFromJSON:json];
    GHAssertNotNil(error, @"error must not be nil.");
    GHAssertEqualStrings(DCApplicationLayerErrorDomain, error.domain,
                         @"domain must equal DCApplicationLayerErrorDomain.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR, error.code,
                   @"code must equals PARAMETER_ERROR.");
}

- (void)testApplicationLayerErrorFail
{
    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:0], @"err_cd",
                          nil];
    NSError* error = [DCErrorUtils applicationLayerErrorFromJSON:json];
    GHAssertNotNil(error, @"error must not be nil.");
    GHAssertEqualStrings(DCResponseBodyParseErrorDomain, error.domain,
                         @"domain must equal DCResponseBodyParseErrorDomain.");
}

- (void)testACParameterError
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:100
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR.");
}

- (void)testACTargetNotFound
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:101
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_TARGET_NOT_FOUND, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_TARGET_NOT_FOUND.");
}

- (void)testACTimeout
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:110
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_TIMEOUT, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_TIMEOUT.");
}

- (void)testACNoResults
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:113
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_NO_RESULTS, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_NO_RESULTS.");
}

- (void)testACContentDuplicated
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:1101
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_CONTENTS_DUPLICATED, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_CONTENTS_DUPLICATED.");
}

- (void)testACCapacityOver
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:1102
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_CAPACITY_OVER, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_CAPACITY_OVER.");
}

- (void)testACFailToGetFreeSpace
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:1103
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_FREE_SPACE, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_FREE_SPACE.");
}

- (void)testACFailToGetMaximumSpace
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:1104
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_MAXIMUM_SPACE, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_MAXIMUM_SPACE.");
}

- (void)testACContentNotFound
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:1105
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_CONTENTS_NOT_FOUND, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_CONTENTS_NOT_FOUND.");
}

- (void)testACMandatoryParameterMissed
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:1110
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_MANDATORY_PARAMETER_MISSED, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_MANDATORY_PARAMETER_MISSED.");
}

- (void)testACParameterSizeUnmatched
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:1111
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_PARAMETER_SIZE_UNMATCHED, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_PARAMETER_SIZE_UNMATCHED.");
}

- (void)testACParameterTypeUnmatched
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:1112
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_PARAMETER_TYPE_UNMATCHED, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_PARAMETER_TYPE_UNMATCHED.");
}

- (void)testACParameterValueInvalid
{
    NSError *cause = nil;
    DCApplicationLayerErrorCode code = [DCErrorUtils toErrorCodeFromInt:1113
                                                                  error:&cause];
    GHAssertNil(cause, @"cause must be nil.");
    GHAssertEquals(DCAPPLICATIONLAYERERRORCODE_PARAMETER_VALUE_INVALID, code,
                   @"code must be equals to DCAPPLICATIONLAYERERRORCODE_PARAMETER_VALUE_INVALID.");
}

@end
