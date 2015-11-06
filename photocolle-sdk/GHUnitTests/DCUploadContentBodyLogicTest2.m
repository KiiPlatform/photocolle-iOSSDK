#import "DCUploadContentBodyLogicTest2.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCUploadContentBodyLogic.h"
#import "DCDataID_Private.h"

@implementation DCUploadContentBodyLogicTest2

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=14",
 * id = "UCBLPR0001"
 */
- (void)test1
{
    NSData *data = [@"{ \"result\" : \"1\" }" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    DCDataID *retval = [logic parseResponse:response
                                       data:data
                                      error:&error];
    [response verify];
    
    GHAssertNil(retval, @"retval must be nil.");
    GHAssertNotNil(error, @"error must not be nil.");
    GHAssertEquals((NSInteger)0, error.code, @"error.code must be 0.");
    GHAssertEquals(DCResponseBodyParseErrorDomain, error.domain,
                   @"error.domain must be DCResponseBodyParseErrorDomain.");
    NSError *cause = [error.userInfo objectForKey:NSUnderlyingErrorKey];
    GHAssertNil(cause, @"cause must be nil.");
    NSString *msg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    GHAssertNotNil(msg, @"userInfo must have value of NSLocalizedDescriptionKey");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=14",
 * id = "UCBLPR0002"
 */
- (void)test2
{
    NSData *data = [@"{ \"result\" : \"0\", \"data_id\" :"
                    @"\"01234567890123456789012345678901234567890\" }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    DCDataID *actual = [logic parseResponse:response
                                       data:data
                                      error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must not be nil.");

    DCDataID *expect = [[DCDataID alloc] initWithID:@"01234567890123456789012345678901234567890"];

    GHAssertNotNil(actual, @"actual must not be nil.");
    GHAssertEqualStrings(expect.stringValue, actual.stringValue,
                         @"stringValue must be equals.");
}

@end
