#import "DCGetCapacityInfoLogicTest2.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetCapacityInfoLogic.h"
#import "DCCapacityInfo_Private.h"

@implementation DCGetCapacityInfoLogicTest2

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=11",
 * id = "GCILPR0001"
 */
- (void)test1
{
    NSData *data = [@"{ \"result\" : \"1\" }" dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    NSError *error = nil;

    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    DCCapacityInfo *retval = [logic parseResponse:response
                                             data:data
                                            error:&error];

    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
    GHAssertEquals((NSInteger)0, error.code, @"error.code must be 0");
    GHAssertEquals(DCResponseBodyParseErrorDomain, error.domain,
                   @"error.domain must be DCResponseBodyParseErrorDomain.");
    NSError *cause = [error.userInfo objectForKey:NSUnderlyingErrorKey];
    GHAssertNil(cause, @"cause must be nil.");
    NSString *msg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    GHAssertNotNil(msg, @"userInfo must have value of NSLocalizedDescriptionKey");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=11",
 * id = "GCILPR0002"
 */
- (void)test2
{
    NSData *data = [@"{ \"result\" : \"0\", \"free_space\" : \"3221225472\" }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    NSError *error = nil;
    
    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    DCCapacityInfo *actual = [logic parseResponse:response
                                             data:data
                                            error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");

    DCCapacityInfo *expect = [[DCCapacityInfo alloc] initWithMaxSpace:-1L
                                                            freeSpace:3221225472L];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=11",
 * id = "GCILPR0003"
 */
- (void)test3
{
    NSData *data = [@"{ \"result\" : \"0\", \"free_space\" : \"0\" }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    NSError *error = nil;
    
    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    DCCapacityInfo *actual = [logic parseResponse:response
                                             data:data
                                            error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCCapacityInfo *expect = [[DCCapacityInfo alloc] initWithMaxSpace:-1L
                                                            freeSpace:0L];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=11",
 * id = "GCILPR0004"
 */
- (void)test4
{
    NSData *data = [@"{ \"result\" : \"0\", \"free_space\" : \"1072668082176\" }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    NSError *error = nil;
    
    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    DCCapacityInfo *actual = [logic parseResponse:response
                                             data:data
                                            error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCCapacityInfo *expect = [[DCCapacityInfo alloc] initWithMaxSpace:-1L
                                                            freeSpace:1072668082176L];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=11",
 * id = "GCILPR0005"
 */
- (void)test5
{
    NSData *data = [@"{ \"result\" : \"0\", \"free_space\" : \"50\", "
                    @" \"max_space\" : \"3221225472\" }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    NSError *error = nil;
    
    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    DCCapacityInfo *actual = [logic parseResponse:response
                                             data:data
                                            error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCCapacityInfo *expect = [[DCCapacityInfo alloc] initWithMaxSpace:3221225472L
                                                            freeSpace:50L];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=11",
 * id = "GCILPR0006"
 */
- (void)test6
{
    NSData *data = [@"{ \"result\" : \"0\", \"free_space\" : \"50\", "
                    @" \"max_space\" : \"0\" }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    NSError *error = nil;
    
    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    DCCapacityInfo *actual = [logic parseResponse:response
                                             data:data
                                            error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCCapacityInfo *expect = [[DCCapacityInfo alloc] initWithMaxSpace:0L
                                                            freeSpace:50L];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=11",
 * id = "GCILPR0007"
 */
- (void)test7
{
    NSData *data = [@"{ \"result\" : \"0\", \"free_space\" : \"50\", "
                    @" \"max_space\" : \"1072668082176\" }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    NSError *error = nil;
    
    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    DCCapacityInfo *actual = [logic parseResponse:response
                                             data:data
                                            error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCCapacityInfo *expect = [[DCCapacityInfo alloc] initWithMaxSpace:1072668082176L
                                                            freeSpace:50L];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=11",
 * id = "GCILPR0008"
 */
- (void)test8
{
    NSData *data = [@"{ \"result\" : \"0\", \"free_space\" : \"3221225472\" }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    NSError *error = nil;
    
    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    DCCapacityInfo *actual = [logic parseResponse:response
                                             data:data
                                            error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCCapacityInfo *expect = [[DCCapacityInfo alloc] initWithMaxSpace:-1L
                                                            freeSpace:3221225472L];
    [self assertWithExpect:expect actual:actual];
}

- (void)assertWithExpect:(DCCapacityInfo *)expect
                  actual:(DCCapacityInfo *)actual
{
    GHAssertTrue(actual != nil, @"actual must not be nil.");
    GHAssertEquals(expect.maxSpace, actual.maxSpace,
                   @"maxSpace must be equals.");
    GHAssertEquals(expect.freeSpace, actual.freeSpace,
                   @"freeSpace must be equals.");
}

@end
