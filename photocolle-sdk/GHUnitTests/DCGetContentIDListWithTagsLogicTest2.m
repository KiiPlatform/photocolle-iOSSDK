#import "DCGetContentIDListWithTagsLogicTest2.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetContentIDListWithTagsLogic_Private.h"
#import "DCListResponse_Private.h"
#import "DCDetailedContentInfo_Private.h"
#import "DCContentGUID_Private.h"
#import "DCMiscUtils.h"
#import "DCNamedTagHead.h"
#import "DCGetContentIDListWithTagsArguments.h"

@implementation DCGetContentIDListWithTagsLogicTest2

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0001"
 */
- (void)test1
{
    NSData *data = [@"{ \"result\" : 1 }" dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_FILE_COUNT];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0002"
 */
- (void)test2
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0 }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_FILE_COUNT];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0003"
 */
- (void)test3
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 0,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0 }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_FILE_COUNT];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:0
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0004"
 */
- (void)test4
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 1000,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0 }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_FILE_COUNT];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1000
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0005"
 */
- (void)test5
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : -1,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0 }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_FILE_COUNT];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0006"
 */
/* Disabled.
- (void)test6
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 101,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
*/

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0007"
 */
- (void)test7
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0 }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_FILE_COUNT];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0008"
 */
- (void)test8
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 5,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:50
                                               start:5
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0009"
 */
- (void)test9
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0010"
 */
- (void)test10
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 0,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0011"
 */
- (void)test11
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"next_page\" : 0 }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_FILE_COUNT];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:50
                                                       start:-1
                                                    nextPage:0
                                                        list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0012"
 */
- (void)test12
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 5,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:5
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0013"
 */
- (void)test13
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0014"
 */
- (void)test14
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : -1,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0015"
 */
- (void)test15
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 1 }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_FILE_COUNT];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:50
                                                       start:1
                                                    nextPage:-1
                                                        list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0016"
 */
- (void)test16
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"content_guid"];
        [info setObject:[NSString stringWithFormat:@"name_%d", i] forKey:@"content_name"];
        [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
        [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
        [info setObject:@"1" forKey:@"resize_ng_flg"];
        [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
        [list addObject:info];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"dummy_%d", i]];
        DCDetailedContentInfo *info = [[DCDetailedContentInfo alloc] initWithGUID:guid
                                                                             name:[NSString stringWithFormat:@"name_%d", i]
                                                                         fileType:DCFILETYPE_IMAGE
                                                                   exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                                     modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                                     uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                                     fileDataSize:0
                                                                        resizable:NO
                                                                            ratio:@"0.75"
                                                                            score:nil
                                                                      orientation:nil
                                                                          persons:[NSArray array]
                                                                           events:[NSArray array]
                                                                        favorites:[NSArray array]
                                                                           places:[NSArray array]
                                                                       yearMonths:[NSArray array]];
        [expectList addObject:info];
    }
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0017"
 */
- (void)test17
{
    NSMutableArray *list = [NSMutableArray array];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *expectList = [NSMutableArray array];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:0
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0018"
 */
- (void)test18
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 1000; ++i) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"content_guid"];
        [info setObject:[NSString stringWithFormat:@"name_%d", i] forKey:@"content_name"];
        [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
        [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
        [info setObject:@"1" forKey:@"resize_ng_flg"];
        [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
        [list addObject:info];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1000] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 1000; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"dummy_%d", i]];
        DCDetailedContentInfo *info =
        [[DCDetailedContentInfo alloc] initWithGUID:guid
                                               name:[NSString stringWithFormat:@"name_%d", i]
                                           fileType:DCFILETYPE_IMAGE
                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                       fileDataSize:0
                                          resizable:NO
                                              ratio:@"0.75"
                                              score:nil
                                        orientation:nil
                                            persons:[NSArray array]
                                             events:[NSArray array]
                                          favorites:[NSArray array]
                                             places:[NSArray array]
                                         yearMonths:[NSArray array]];
        [expectList addObject:info];
    }
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1000
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0019"
 */
- (void)test19
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 1001; ++i) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"content_guid"];
        [info setObject:[NSString stringWithFormat:@"name_%d", i] forKey:@"content_name"];
        [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
        [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
        [info setObject:@"1" forKey:@"resize_ng_flg"];
        [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
        [list addObject:info];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1001] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0020"
 */
- (void)test20
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0021"
 */
- (void)test21
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0022"
 */
- (void)test22
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"01234567890123456789012345678901234567890123456789" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"01234567890123456789012345678901234567890123456789"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0023"
 */
- (void)test23
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0024"
 */
- (void)test24
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"012345678901234567890123456789012345678901234567890" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0025"
 */
- (void)test25
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0026"
 */
- (void)test26
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"012345678901234567890123456789012345678901234" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    NSString *name = @"012345678901234567890123456789012345678901234";
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:name
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0027"
 */
- (void)test27
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    NSString *name = @"0";
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:name
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0028"
 */
- (void)test28
{
    NSString *name = @"012345678901234567890123456789012345678901234567890123456789"
            @"012345678901234567890123456789012345678901234567890123456789"
            @"012345678901234567890123456789012345678901234567890123456789"
            @"012345678901234567890123456789012345678901234567890123456789"
            @"012345678901234";
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:name forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:name
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0029"
 */
- (void)test29
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0030"
 */
- (void)test30
{
    NSString *name = @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901234567890123456789012345678901234567890123456789"
    @"0123456789012345";
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:name forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0031"
 */
- (void)test31
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0032"
 */
- (void)test32
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0033"
 */
- (void)test33
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:2] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_VIDEO
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0034"
 */
- (void)test34
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:3] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_SLIDE_MOVIE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0035"
 */
- (void)test35
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:-1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0036"
 */
- (void)test36
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:4] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0037"
 */
- (void)test37
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0038"
 */
- (void)test38
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"2013-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"2013-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0039"
 */
- (void)test39
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:4] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0040"
 */
- (void)test40
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1998-06-15T13:30:25+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1998-06-15T13:30:25+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0041"
 */
- (void)test41
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:4] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0042"
 */
- (void)test42
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1989-01-07T12:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1989-01-07T12:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0043"
 */
- (void)test43
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:4] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0044"
 */
- (void)test44
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:1234L] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:1234L
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0045"
 */
- (void)test45
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:4] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0046"
 */
- (void)test46
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"0" forKey:@"resize_ng_flg"];
    [info setObject:@"1.3" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:YES
                                          ratio:@"1.3"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0047"
 */
- (void)test47
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0048"
 */
- (void)test48
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:4] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0049"
 */
- (void)test49
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"prf5score"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:[NSNumber numberWithInt:DCSCORE_SCORE_1]
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0050"
 */
- (void)test50
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:2] forKey:@"prf5score"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:[NSNumber numberWithInt:DCSCORE_SCORE_2]
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0051"
 */
- (void)test51
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:3] forKey:@"prf5score"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:[NSNumber numberWithInt:DCSCORE_SCORE_3]
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0052"
 */
- (void)test52
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:4] forKey:@"prf5score"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:[NSNumber numberWithInt:DCSCORE_SCORE_4]
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0053"
 */
- (void)test53
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:5] forKey:@"prf5score"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:[NSNumber numberWithInt:DCSCORE_SCORE_5]
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0054"
 */
- (void)test54
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:0] forKey:@"prf5score"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0055"
 */
- (void)test55
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:6] forKey:@"prf5score"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0056"
 */
- (void)test56
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0057"
 */
- (void)test57
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:0] forKey:@"orientation"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:[NSNumber numberWithInt:DCORIENTATION_ROTATE_0]
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0058"
 */
- (void)test58
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:90] forKey:@"orientation"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:[NSNumber numberWithInt:DCORIENTATION_ROTATE_90]
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0059"
 */
- (void)test59
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:180] forKey:@"orientation"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:[NSNumber numberWithInt:DCORIENTATION_ROTATE_180]
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0060"
 */
- (void)test60
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:270] forKey:@"orientation"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:[NSNumber numberWithInt:DCORIENTATION_ROTATE_270]
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0061"
 */
- (void)test61
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:[NSNumber numberWithInt:360] forKey:@"orientation"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0062"
 */
- (void)test62
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0063"
 */
- (void)test63
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"person_guid" forKey:@"person_tag_guid"];
    [tag setObject:@"Jhon Smith" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *personList = [NSMutableArray array];
    [personList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PERSON
                                                          guid:[DCContentGUID guidWithString:@"person_guid"]
                                                          name:@"Jhon Smith"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray arrayWithArray:personList]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0064"
 */
- (void)test64
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"person_guid_%d", i]
                forKey:@"person_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"Jhon Smith.%d", i]
                forKey:@"person_tag_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *personList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        NSString *guidStr = [NSString stringWithFormat:@"person_guid_%d", i];
        NSString *name = [NSString stringWithFormat:@"Jhon Smith.%d", i];
        DCContentGUID *guid = [DCContentGUID guidWithString:guidStr];
        [personList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PERSON
                                                              guid:guid
                                                              name:name]];
    }
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray arrayWithArray:personList]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0065"
 */
- (void)test65
{
    NSMutableArray *tagList = [NSMutableArray array];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0066"
 */
- (void)test66
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 51; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"person_guid_%d", i]
                forKey:@"person_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"Jhon Smith.%d", i]
                forKey:@"person_tag_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0067"
 */
- (void)test67
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0068"
 */
- (void)test68
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"event_guid" forKey:@"event_tag_guid"];
    [tag setObject:@"summer_fes" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *eventList = [NSMutableArray array];
    [eventList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_EVENT
                                                          guid:[DCContentGUID guidWithString:@"event_guid"]
                                                          name:@"summer_fes"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray arrayWithArray:eventList]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0069"
 */
- (void)test69
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"event_guid_%d", i]
                forKey:@"event_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"summer_fes.%d", i]
                forKey:@"event_tag_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *eventList = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        NSString *guidStr = [NSString stringWithFormat:@"event_guid_%d", i];
        NSString *name = [NSString stringWithFormat:@"summer_fes.%d", i];
        DCContentGUID *guid = [DCContentGUID guidWithString:guidStr];
        [eventList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_EVENT
                                                              guid:guid
                                                              name:name]];
    }
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray arrayWithArray:eventList]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0070"
 */
- (void)test70
{
    NSMutableArray *tagList = [NSMutableArray array];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0071"
 */
- (void)test71
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 101; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"event_guid_%d", i]
                forKey:@"event_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"summer_fes.%d", i]
                forKey:@"event_tag_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0072"
 */
- (void)test72
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0073"
 */
- (void)test73
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"optional_guid" forKey:@"optional_tag_guid"];
    [tag setObject:@"optional_name" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *optionalList = [NSMutableArray array];
    [optionalList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_FAVORITE
                                                            guid:[DCContentGUID guidWithString:@"optional_guid"]
                                                            name:@"optional_name"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray arrayWithArray:optionalList]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0074"
 */
- (void)test74
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"optional_guid_%d", i]
                forKey:@"optional_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"optional_name_%d", i]
                forKey:@"optional_tag_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *favoriteList = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        NSString *guidStr = [NSString stringWithFormat:@"optional_guid_%d", i];
        NSString *name = [NSString stringWithFormat:@"optional_name_%d", i];
        DCContentGUID *guid = [DCContentGUID guidWithString:guidStr];
        [favoriteList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_FAVORITE
                                                                guid:guid
                                                                name:name]];
    }
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray arrayWithArray:favoriteList]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0075"
 */
- (void)test75
{
    NSMutableArray *tagList = [NSMutableArray array];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0076"
 */
- (void)test76
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 101; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"optional_guid_%d", i]
                forKey:@"optional_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"optional_name_%d", i]
                forKey:@"optional_tag_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0077"
 */
- (void)test77
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0078"
 */
- (void)test78
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"place_guid" forKey:@"place_tag_guid"];
    [tag setObject:@"place_name" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *placeList = [NSMutableArray array];
    [placeList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PLACEMENT
                                                         guid:[DCContentGUID guidWithString:@"place_guid"]
                                                         name:@"place_name"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray arrayWithArray:placeList]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0079"
 */
- (void)test79
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"place_guid_%d", i]
                forKey:@"place_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"place_%d", i]
                forKey:@"place_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *placeList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        NSString *guidStr = [NSString stringWithFormat:@"place_guid_%d", i];
        NSString *name = [NSString stringWithFormat:@"place_%d", i];
        DCContentGUID *guid = [DCContentGUID guidWithString:guidStr];
        [placeList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PLACEMENT
                                                             guid:guid
                                                             name:name]];
    }
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray arrayWithArray:placeList]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0080"
 */
- (void)test80
{
    NSMutableArray *tagList = [NSMutableArray array];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0081"
 */
/* Disabled.
- (void)test81
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 51; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"place_guid_%d", i]
                forKey:@"place_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"place_%d", i]
                forKey:@"place_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 */

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0082"
 */
- (void)test82
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0083"
 */
- (void)test83
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"month_guid" forKey:@"month_tag_guid"];
    [tag setObject:@"month_name" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *monthList = [NSMutableArray array];
    [monthList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_YEAR_MONTH
                                                         guid:[DCContentGUID guidWithString:@"month_guid"]
                                                         name:@"month_name"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray arrayWithArray:monthList]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0084"
 */
- (void)test84
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"month_guid_%d", i]
                forKey:@"month_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"month_name_%d", i]
                forKey:@"month_tag_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *monthList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        NSString *guidStr = [NSString stringWithFormat:@"month_guid_%d", i];
        NSString *name = [NSString stringWithFormat:@"month_name_%d", i];
        DCContentGUID *guid = [DCContentGUID guidWithString:guidStr];
        [monthList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_YEAR_MONTH
                                                             guid:guid
                                                             name:name]];
    }
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray arrayWithArray:monthList]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0085"
 */
- (void)test85
{
    NSMutableArray *tagList = [NSMutableArray array];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0086"
 */
/* Disabled.
- (void)test86
{
    NSMutableArray *tagList = [NSMutableArray array];
    for (int i = 0; i < 51; ++i) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"month_guid_%d", i]
                forKey:@"month_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"month_name_%d", i]
                forKey:@"month_tag_name"];
        [tagList addObject:tag];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
*/

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0087"
 */
- (void)test87
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0088"
 */
- (void)test88
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"0" forKey:@"person_tag_guid"];
    [tag setObject:@"Jhon Smith" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *personList = [NSMutableArray array];
    [personList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PERSON
                                                          guid:[DCContentGUID guidWithString:@"0"]
                                                          name:@"Jhon Smith"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray arrayWithArray:personList]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0089"
 */
- (void)test89
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"person_tag_guid"];
    [tag setObject:@"Jhon Smith" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *personList = [NSMutableArray array];
    [personList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PERSON
                                                          guid:[DCContentGUID guidWithString:guidStr]
                                                          name:@"Jhon Smith"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray arrayWithArray:personList]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0090"
 */
- (void)test90
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"" forKey:@"person_tag_guid"];
    [tag setObject:@"Jhon Smith" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0091"
 */
- (void)test91
{
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"person_tag_guid"];
    [tag setObject:@"Jhon Smith" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0092"
 */
- (void)test92
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"Jhon Smith" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0093"
 */
- (void)test93
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"person_guid" forKey:@"person_tag_guid"];
    [tag setObject:@"0" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *personList = [NSMutableArray array];
    [personList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PERSON
                                                          guid:[DCContentGUID guidWithString:@"person_guid"]
                                                          name:@"0"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray arrayWithArray:personList]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0094"
 */
- (void)test94
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"person_guid" forKey:@"person_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *personList = [NSMutableArray array];
    [personList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PERSON
                                                          guid:[DCContentGUID guidWithString:@"person_guid"]
                                                          name:@"01234567890123456789"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray arrayWithArray:personList]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0095"
 */
- (void)test95
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"person_guid" forKey:@"person_tag_guid"];
    [tag setObject:@"" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0096"
 */
- (void)test96
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"person_guid" forKey:@"person_tag_guid"];
    [tag setObject:@"012345678901234567890" forKey:@"person_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0097"
 */
- (void)test97
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"person_guid" forKey:@"person_tag_guid"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"person_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0098"
 */
- (void)test98
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"0" forKey:@"event_tag_guid"];
    [tag setObject:@"summer_fes" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *eventList = [NSMutableArray array];
    [eventList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_EVENT
                                                         guid:[DCContentGUID guidWithString:@"0"]
                                                         name:@"summer_fes"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray arrayWithArray:eventList]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0099"
 */
- (void)test99
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"event_tag_guid"];
    [tag setObject:@"summer_fes" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *eventList = [NSMutableArray array];
    [eventList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_EVENT
                                                         guid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"summer_fes"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray arrayWithArray:eventList]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0100"
 */
- (void)test100
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"" forKey:@"event_tag_guid"];
    [tag setObject:@"summer_fes" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0101"
 */
- (void)test101
{
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"event_tag_guid"];
    [tag setObject:@"summer_fes" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0102"
 */
- (void)test102
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"summer_fes" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0103"
 */
- (void)test103
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"event_guid" forKey:@"event_tag_guid"];
    [tag setObject:@"0" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *eventList = [NSMutableArray array];
    [eventList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_EVENT
                                                         guid:[DCContentGUID guidWithString:@"event_guid"]
                                                         name:@"0"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray arrayWithArray:eventList]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0104"
 */
- (void)test104
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"event_guid" forKey:@"event_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *eventList = [NSMutableArray array];
    [eventList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_EVENT
                                                         guid:[DCContentGUID guidWithString:@"event_guid"]
                                                         name:@"01234567890123456789"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray arrayWithArray:eventList]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0105"
 */
- (void)test105
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"event_guid" forKey:@"event_tag_guid"];
    [tag setObject:@"" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0106"
 */
- (void)test106
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"event_guid" forKey:@"event_tag_guid"];
    [tag setObject:@"012345678901234567890" forKey:@"event_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0107"
 */
- (void)test107
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"event_guid" forKey:@"event_tag_guid"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"event_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0108"
 */
- (void)test108
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"0" forKey:@"optional_tag_guid"];
    [tag setObject:@"optional_name" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *optionalList = [NSMutableArray array];
    [optionalList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_FAVORITE
                                                            guid:[DCContentGUID guidWithString:@"0"]
                                                            name:@"optional_name"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray arrayWithArray:optionalList]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0109"
 */
- (void)test109
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"optional_tag_guid"];
    [tag setObject:@"optional_name" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *optionalList = [NSMutableArray array];
    [optionalList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_FAVORITE
                                                            guid:[DCContentGUID guidWithString:guidStr]
                                                            name:@"optional_name"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray arrayWithArray:optionalList]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0110"
 */
- (void)test110
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"" forKey:@"optional_tag_guid"];
    [tag setObject:@"optional_name" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0111"
 */
- (void)test111
{
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"optional_tag_guid"];
    [tag setObject:@"optional_name" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0112"
 */
- (void)test112
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"optional_name" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0113"
 */
- (void)test113
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"optional_guid" forKey:@"optional_tag_guid"];
    [tag setObject:@"0" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *optionalList = [NSMutableArray array];
    [optionalList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_FAVORITE
                                                            guid:[DCContentGUID guidWithString:@"optional_guid"]
                                                            name:@"0"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray arrayWithArray:optionalList]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0114"
 */
- (void)test114
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"optional_guid" forKey:@"optional_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *optionalList = [NSMutableArray array];
    [optionalList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_FAVORITE
                                                            guid:[DCContentGUID guidWithString:@"optional_guid"]
                                                            name:@"01234567890123456789"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray arrayWithArray:optionalList]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0115"
 */
- (void)test115
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"optional_guid" forKey:@"optional_tag_guid"];
    [tag setObject:@"" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0116"
 */
- (void)test116
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"optional_guid" forKey:@"optional_tag_guid"];
    [tag setObject:@"012345678901234567890" forKey:@"optional_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0117"
 */
- (void)test117
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"optional_guid" forKey:@"optional_tag_guid"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"optional_tag_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0118"
 */
- (void)test118
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"0" forKey:@"place_tag_guid"];
    [tag setObject:@"place_name" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *placeList = [NSMutableArray array];
    [placeList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PLACEMENT
                                                         guid:[DCContentGUID guidWithString:@"0"]
                                                         name:@"place_name"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray arrayWithArray:placeList]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0119"
 */
- (void)test119
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"place_tag_guid"];
    [tag setObject:@"place_name" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *placeList = [NSMutableArray array];
    [placeList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PLACEMENT
                                                         guid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"place_name"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray arrayWithArray:placeList]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0120"
 */
- (void)test120
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"" forKey:@"place_tag_guid"];
    [tag setObject:@"place_name" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0121"
 */
- (void)test121
{
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"place_tag_guid"];
    [tag setObject:@"place_name" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0122"
 */
- (void)test122
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"place_name" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0123"
 */
- (void)test123
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"place_guid" forKey:@"place_tag_guid"];
    [tag setObject:@"0" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *placeList = [NSMutableArray array];
    [placeList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PLACEMENT
                                                         guid:[DCContentGUID guidWithString:@"place_guid"]
                                                         name:@"0"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray arrayWithArray:placeList]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0124"
 */
- (void)test124
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"place_guid" forKey:@"place_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *placeList = [NSMutableArray array];
    [placeList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_PLACEMENT
                                                         guid:[DCContentGUID guidWithString:@"place_guid"]
                                                         name:@"01234567890123456789"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray arrayWithArray:placeList]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0125"
 */
- (void)test125
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"place_guid" forKey:@"place_tag_guid"];
    [tag setObject:@"" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0126"
 */
- (void)test126
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"place_guid" forKey:@"place_tag_guid"];
    [tag setObject:@"012345678901234567890" forKey:@"place_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0127"
 */
- (void)test127
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"place_guid" forKey:@"place_tag_guid"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"place_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0128"
 */
- (void)test128
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"0" forKey:@"month_tag_guid"];
    [tag setObject:@"month_name" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *monthList = [NSMutableArray array];
    [monthList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_YEAR_MONTH
                                                         guid:[DCContentGUID guidWithString:@"0"]
                                                         name:@"month_name"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray arrayWithArray:monthList]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0129"
 */
- (void)test129
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"month_tag_guid"];
    [tag setObject:@"month_name" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *monthList = [NSMutableArray array];
    [monthList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_YEAR_MONTH
                                                         guid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"month_name"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray arrayWithArray:monthList]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0130"
 */
- (void)test130
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"" forKey:@"month_tag_guid"];
    [tag setObject:@"month_name" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0121"
 */
- (void)test131
{
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"month_tag_guid"];
    [tag setObject:@"month_name" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0132"
 */
- (void)test132
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"month_name" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0133"
 */
- (void)test133
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"month_guid" forKey:@"month_tag_guid"];
    [tag setObject:@"0" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *monthList = [NSMutableArray array];
    [monthList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_YEAR_MONTH
                                                         guid:[DCContentGUID guidWithString:@"month_guid"]
                                                         name:@"0"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray arrayWithArray:monthList]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0134"
 */
- (void)test134
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"month_guid" forKey:@"month_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *monthList = [NSMutableArray array];
    [monthList addObject:[[DCNamedTagHead alloc] initWithType:DCTAGTYPE_YEAR_MONTH
                                                         guid:[DCContentGUID guidWithString:@"month_guid"]
                                                         name:@"01234567890123456789"]];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:[DCContentGUID guidWithString:@"0"]
                                           name:@"0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray arrayWithArray:monthList]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0135"
 */
- (void)test135
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"month_guid" forKey:@"month_tag_guid"];
    [tag setObject:@"" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0136"
 */
- (void)test136
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"month_guid" forKey:@"month_tag_guid"];
    [tag setObject:@"012345678901234567890" forKey:@"month_tag_name"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0137"
 */
- (void)test137
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"month_guid" forKey:@"month_tag_guid"];
    NSMutableArray *tagList = [NSMutableArray array];
    [tagList addObject:tag];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0" forKey:@"content_guid"];
    [info setObject:@"0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    [info setObject:tagList forKey:@"month_info_list"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0138"
 */
- (void)test138
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_IMAGE
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0139"
 */
- (void)test139
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:4] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0140"
 */
- (void)test140
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"0123456789012345" forKey:@"content_guid"];
    [info setObject:@"name_0" forKey:@"content_name"];
    [info setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
    [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
    [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
    [info setObject:@"1" forKey:@"resize_ng_flg"];
    [info setObject:@"0.75" forKey:@"file_data_xy_rate"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:info];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
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
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCDetailedContentInfo *expectInfo =
    [[DCDetailedContentInfo alloc] initWithGUID:guid
                                           name:@"name_0"
                                       fileType:DCFILETYPE_ALL
                                 exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                   fileDataSize:0
                                      resizable:NO
                                          ratio:@"0.75"
                                          score:nil
                                    orientation:nil
                                        persons:[NSArray array]
                                         events:[NSArray array]
                                      favorites:[NSArray array]
                                         places:[NSArray array]
                                     yearMonths:[NSArray array]];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:1
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0141"
 */
- (void)test141
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0142"
 */
- (void)test142
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 1,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0143"
 */
- (void)test143
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0 }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_FILE_COUNT];
    DCDetailedContentInfoListResponse *actual = [logic parseResponse:response
                                                                data:data
                                                               error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCDetailedContentInfoListResponse *expect =
    [[DCDetailedContentInfoListResponse alloc] initWithCount:50
                                                       start:1
                                                    nextPage:0
                                                        list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=18",
 * id = "GCILWTLPR0144"
 */
- (void)test144
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 50,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0 }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
    logic.arguments = [self createArguments:DCPROJECTIONTYPE_ALL_DETAILS];
    DCDetailedContentInfoListResponse *retval = [logic parseResponse:response
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

- (void)assertWithExpect:(DCDetailedContentInfoListResponse *)expect
                  actual:(DCDetailedContentInfoListResponse *)actual
{
    GHAssertTrue(actual != nil, @"actual must not be nil.");
    GHAssertEquals(expect.count, actual.count, @"count must be equals.");
    GHAssertEquals(expect.start, actual.start, @"start must be equals.");
    GHAssertEquals(expect.nextPage, actual.nextPage, @"nextPage must be equals.");

    GHAssertTrue(actual.list != nil, @"list must not be nil.");
    GHAssertEquals(expect.list.count, actual.list.count, @"list.count must be equals.");
    for (int i = 0; i < actual.list.count; ++i) {
        [self assertContentInfo:[expect.list objectAtIndex:i]
                         actual:[actual.list objectAtIndex:i]];
    }
}

- (void)assertContentInfo:(DCDetailedContentInfo *)expect
                   actual:(DCDetailedContentInfo *)actual
{
    GHAssertTrue(actual != nil, @"actual must not be nil.");
    GHAssertEquals(expect.class, actual.class, @"class must be equals.");
    if (expect.guid != nil) {
        GHAssertTrue(actual.guid != nil, @"guid must not be nil.");
        GHAssertEqualStrings(expect.guid.stringValue, actual.guid.stringValue,
                             @"guid must be equals.");
    } else {
        GHAssertTrue(actual.guid == nil, @"guid must be nil.");
    }
    if (expect.name != nil) {
        GHAssertTrue(actual.name != nil, @"name must not be nil.");
        GHAssertEqualStrings(expect.name, actual.name, @"name must be equals.");
    } else {
        GHAssertTrue(actual.name == nil, @"name must be nil.");
    }
    GHAssertEquals(expect.fileType, actual.fileType, @"fileType must be equals.");
    if (expect.exifCameraDate != nil) {
        GHAssertTrue(actual.exifCameraDate != nil, @"exifCameraDate must not be nil.");
        GHAssertTrue([expect.exifCameraDate isEqualToDate:actual.exifCameraDate],
                             @"exifCameraDate must be equals.");
    } else {
        GHAssertTrue(actual.exifCameraDate == nil, @"exifCameraDate must be nil.");
    }
    if (expect.modifiedDate != nil) {
        GHAssertTrue(actual.modifiedDate != nil, @"modifiedDate must not be nil.");
        GHAssertTrue([expect.modifiedDate isEqualToDate:actual.modifiedDate],
                     @"modifiedDate must be equals.");
    } else {
        GHAssertTrue(actual.modifiedDate == nil, @"modifiedDate must be nil.");
    }
    if (expect.uploadedDate != nil) {
        GHAssertTrue(actual.uploadedDate != nil, @"uploadedDate must not be nil.");
        GHAssertTrue([expect.uploadedDate isEqualToDate:actual.uploadedDate],
                     @"uploadedDate must be equals.");
    } else {
        GHAssertTrue(actual.uploadedDate == nil, @"uploadedDate must be nil.");
    }
    GHAssertEquals(expect.fileDataSize, actual.fileDataSize,
                   @"fileDataSize must be equals.");
    GHAssertEquals(expect.resizable, actual.resizable, @"resizable must be equals.");
    GHAssertEqualStrings(expect.ratio, actual.ratio, @"ratio must be equals.");
    if (expect.score != nil) {
        GHAssertTrue(actual.score != nil, @"score must not be nil.");
        GHAssertTrue([expect.score isEqualToNumber:actual.score],
                     @"score must be equals.");
    } else {
        GHAssertTrue(actual.score == nil, @"score must be nil.");
    }
    if (expect.orientation != nil) {
        GHAssertTrue(actual.orientation != nil, @"orientation must not be nil.");
        GHAssertTrue([expect.orientation isEqualToNumber:actual.orientation],
                       @"orientation must be equals.");
    } else {
        GHAssertTrue(actual.orientation == nil, @"orientation must be nil.");
    }
    [self assertNamedTagHeadList:expect.persons actual:actual.persons];
    [self assertNamedTagHeadList:expect.events actual:actual.events];
    [self assertNamedTagHeadList:expect.favorites actual:actual.favorites];
    [self assertNamedTagHeadList:expect.places actual:actual.places];
    [self assertNamedTagHeadList:expect.yearMonths actual:actual.yearMonths];
}

- (void)assertNamedTagHeadList:(NSArray *)expect actual:(NSArray *)actual
{
    GHAssertTrue(actual != nil, @"NamedTagHead list must not be nil.");
    GHAssertEquals(expect.count, actual.count, @"list count must be equals.");
    for (int i = 0; i < actual.count; ++i) {
        [self assertNamedTagHead:[expect objectAtIndex:i] actual:[actual objectAtIndex:i]];
    }
}

- (void)assertNamedTagHead:(DCNamedTagHead *)expect actual:(DCNamedTagHead *)actual
{
    GHAssertTrue(actual != nil, @"tag must not be nil.");
    GHAssertEquals(expect.type, actual.type, @"tag type must be equals");
    GHAssertTrue(actual.guid != nil, @"tag guid must not be nil.");
    GHAssertEqualStrings(expect.guid.stringValue, actual.guid.stringValue,
                         @"tag guid must be equals.");
    GHAssertEqualStrings(expect.name, actual.name, @"tag name must be equals.");
}

- (DCGetContentIDListWithTagsArguments *)createArguments:(DCProjectionType)projectionType
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    return [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:projectionType
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
}
@end
