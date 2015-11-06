#import "DCGetContentIDListLogicTest2.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetContentIDListLogic.h"
#import "DCListResponse_Private.h"
#import "DCContentInfo_Private.h"
#import "DCContentGUID_Private.h"
#import "DCMiscUtils.h"

@implementation DCGetContentIDListLogicTest2

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0001"
 */
- (void)test1
{
    NSData *data = [@"{ \"result\" : 1 }" dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0002"
 */
- (void)test2
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0003"
 */
- (void)test3
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 0,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:0
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0004"
 */
- (void)test4
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : 100,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:100
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0005"
 */
- (void)test5
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_cnt\" : -1,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0006"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0007"
 */
- (void)test7
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"start\" : 1,"
                    @"\"next_page\" : 0,"
                    @"\"content_list\" : [] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0008"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:50
                                               start:5
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0009"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0010"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0011"
 */
- (void)test11
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0012"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:5
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0013"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0014"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0015"
 */
- (void)test15
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0016"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"dummy_%d", i]];
        DCContentInfo *info = [[DCContentInfo alloc] initWithGUID:guid
                                                             name:[NSString stringWithFormat:@"name_%d", i]
                                                         fileType:DCFILETYPE_IMAGE
                                                   exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                     modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                     uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                     fileDataSize:0
                                                        resizable:NO];
        [expectList addObject:info];
    }
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:50
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0017"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *expectList = [NSMutableArray array];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:0
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0018"
 */
- (void)test18
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"content_guid"];
        [info setObject:[NSString stringWithFormat:@"name_%d", i] forKey:@"content_name"];
        [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
        [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
        [info setObject:@"1" forKey:@"resize_ng_flg"];
        [list addObject:info];
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"dummy_%d", i]];
        DCContentInfo *info = [[DCContentInfo alloc] initWithGUID:guid
                                                             name:[NSString stringWithFormat:@"name_%d", i]
                                                         fileType:DCFILETYPE_IMAGE
                                                   exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                     modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                     uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                     fileDataSize:0
                                                        resizable:NO];
        [expectList addObject:info];
    }
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:100
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0019"
 */
- (void)test19
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 101; ++i) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"content_guid"];
        [info setObject:[NSString stringWithFormat:@"name_%d", i] forKey:@"content_name"];
        [info setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"exif_camera_day"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"mdate"];
        [info setObject:@"1970-01-01T00:00:00+09:00" forKey:@"upload_datetime"];
        [info setObject:[NSNumber numberWithLongLong:0] forKey:@"file_data_size"];
        [info setObject:@"1" forKey:@"resize_ng_flg"];
        [list addObject:info];
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0020"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0021"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0022"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"01234567890123456789012345678901234567890123456789"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0023"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0024"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0025"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0026"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    NSString *name = @"012345678901234567890123456789012345678901234";
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:name
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0027"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    NSString *name = @"0";
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:name
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0028"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:name
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0029"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0030"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0031"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0032"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0033"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_VIDEO
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0034"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_SLIDE_MOVIE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0035"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0036"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0037"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0038"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"2013-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0039"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0040"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1998-06-15T13:30:25+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0041"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0042"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1989-01-07T12:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0043"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0044"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:1234L
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0045"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0046"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:YES];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0047"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *actual = [logic parseResponse:response
                                                        data:data
                                                       error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0123456789012345"];
    DCContentInfo *expectInfo = [[DCContentInfo alloc] initWithGUID:guid
                                                               name:@"name_0"
                                                           fileType:DCFILETYPE_IMAGE
                                                     exifCameraDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       modifiedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       uploadedDate:[DCMiscUtils parseAs3339:@"1970-01-01T00:00:00+09:00" error:nil]
                                                       fileDataSize:0
                                                          resizable:NO];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:expectInfo];
    DCContentInfoListResponse *expect =
    [[DCContentInfoListResponse alloc] initWithCount:1
                                               start:1
                                            nextPage:0
                                                list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=17",
 * id = "GCILLPR0048"
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
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    DCContentInfoListResponse *retval = [logic parseResponse:response
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

- (void)assertWithExpect:(DCContentInfoListResponse *)expect
                  actual:(DCContentInfoListResponse *)actual
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

- (void)assertContentInfo:(DCContentInfo *)expect
                   actual:(DCContentInfo *)actual
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
}

@end
