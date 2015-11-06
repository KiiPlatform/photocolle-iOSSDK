#import "DCGetContentDeletionHistoryLogicTest2.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetContentDeletionHistoryLogic.h"
#import "DCContentGUIDListResponse.h"
#import "DCListResponse_Private.h"
#import "DCContentGUID_Private.h"

@implementation DCGetContentDeletionHistoryLogicTest2

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0001"
 */
- (void)test1
{
    NSData *data = [@"{ \"result\" : 1 }" dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0002"
 */
- (void)test2
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 50,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUIDListResponse *expect =
            [[DCContentGUIDListResponse alloc] initWithCount:50
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0003"
 */
- (void)test3
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 0,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:0
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0004"
 */
- (void)test4
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 100,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @" \"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:100
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0005"
 */
- (void)test5
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : -1,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @" \"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0006"
 */
- (void)test6
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 101,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @" \"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0007"
 */
- (void)test7
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @" \"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0008"
 */
- (void)test8
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 50, \"start\" : 5,"
                    @"\"next_page\" : 0, \"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:50
                                               start:5
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0009"
 */
- (void)test9
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 50, \"start\" : 1,"
                    @"\"next_page\" : 0, \"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0010"
 */
- (void)test10
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 50, \"start\" : 0,"
                    @"\"next_page\" : 0, \"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0011"
 */
- (void)test11
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 50,"
                    @"\"next_page\" : 0, \"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0012"
 */
- (void)test12
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 50,"
                    @"\"start\" : 1, \"next_page\" : 5,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:5
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0013"
 */
- (void)test13
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 50,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0014"
 */
- (void)test14
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 50,"
                    @"\"start\" : 1, \"next_page\" : -1,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0015"
 */
- (void)test15
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 50,"
                    @"\"start\" : 1, \"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0016"
 */
- (void)test16
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        [list addObject:[NSString stringWithFormat:@"dummy_%d", i]];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:50] forKey:@"content_cnt"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"start"];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"next_page"];
    [json setObject:list forKey:@"content_list"];

    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *guids = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        NSString *guid = [NSString stringWithFormat:@"dummy_%d", i];
        [guids addObject:[DCContentGUID guidWithString:guid]];
    }
    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:guids]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0017"
 */
- (void)test17
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 0,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:0
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0018"
 */
- (void)test18
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        [list addObject:[NSString stringWithFormat:@"dummy_%d", i]];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:100] forKey:@"content_cnt"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"start"];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"next_page"];
    [json setObject:list forKey:@"content_list"];

    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *guids = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        NSString *guid = [NSString stringWithFormat:@"dummy_%d", i];
        [guids addObject:[DCContentGUID guidWithString:guid]];
    }
    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:100
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:guids]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0019"
 */
- (void)test19
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 101; ++i) {
        [list addObject:[NSString stringWithFormat:@"dummy_%d", i]];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:100] forKey:@"content_cnt"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"start"];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"next_page"];
    [json setObject:list forKey:@"content_list"];

    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0020"
 */
- (void)test20
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 1,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @"\"content_list\" : [ \"0123456789012345\"] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *guids = [NSMutableArray array];
    [guids addObject:[DCContentGUID guidWithString:@"0123456789012345"]];
    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:guids]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0021"
 */
- (void)test21
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 1,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @"\"content_list\" : [ \"0\"] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *guids = [NSMutableArray array];
    [guids addObject:[DCContentGUID guidWithString:@"0"]];
    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:guids]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0022"
 */
- (void)test22
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 1,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @"\"content_list\" : [ \"01234567890123456789012345678901234567890123456789\"] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *guids = [NSMutableArray array];
    [guids addObject:[DCContentGUID guidWithString:
                      @"01234567890123456789012345678901234567890123456789"]];
    DCContentGUIDListResponse *expect =
    [[DCContentGUIDListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:guids]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0023"
 */
- (void)test23
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 1,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @"\"content_list\" : [ \"\"] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=16",
 * id = "GCDHLPR0024"
 */
- (void)test24
{
    NSData *data = [@"{ \"result\" : 0, \"content_cnt\" : 1,"
                    @"\"start\" : 1, \"next_page\" : 0,"
                    @"\"content_list\" : [ \"012345678901234567890123456789012345678901234567890\"] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentDeletionHistoryLogic *logic = [[DCGetContentDeletionHistoryLogic alloc] init];
    DCContentGUIDListResponse *retval = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(retval == nil, @"retval must be nil.");
    GHAssertTrue(error != nil, @"error must not be nil.");
    GHAssertEquals((NSInteger)0, error.code, @"error.code must be 0.");
    GHAssertEquals(DCResponseBodyParseErrorDomain, error.domain,
                   @"error.domain must be DCResponseBodyParseErrorDomain.");
    NSError *cause = [error.userInfo objectForKey:NSUnderlyingErrorKey];
    GHAssertNil(cause, @"cause must be nil.");
    NSString *msg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    GHAssertNotNil(msg, @"userInfo must have value of NSLocalizedDescriptionKey");
}

- (void)assertWithExpect:(DCContentGUIDListResponse *)expect
                  actual:(DCContentGUIDListResponse *)actual
{
    GHAssertTrue(actual != nil, @"actual must not be nil.");
    GHAssertEquals(expect.count, actual.count, @"count must be equals.");
    GHAssertEquals(expect.start, actual.start, @"start must be equals.");
    GHAssertEquals(expect.nextPage, actual.nextPage, @"nextPage must be equals.");

    GHAssertTrue(actual.list != nil, @"list must not be nil.");
    GHAssertEquals(expect.list.count, actual.list.count, @"list.count must be equals.");
    for (int i = 0; i < actual.list.count; ++i) {
        DCContentGUID *exp = [expect.list objectAtIndex:i];
        DCContentGUID *act = [actual.list objectAtIndex:i];
        GHAssertEquals(exp.class, act.class, @"class must be equals.");
        GHAssertEqualStrings(exp.stringValue, act.stringValue,
                             @"stringValue must be equals.");
    }
}

@end
