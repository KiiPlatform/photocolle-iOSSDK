#import "DCGetTagIDListLogicTest2.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetTagIDListLogic.h"
#import "DCListResponse_Private.h"
#import "DCPersonTag_Private.h"
#import "DCContentGUID_Private.h"

@implementation DCGetTagIDListLogicTest2

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0001"
 */
- (void)test1
{
    NSData *data = [@"{ \"result\" : 1 }" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0002"
 */
- (void)test2
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"person_tag_guid"];
    [tag setObject:@"dummy" forKey:@"person_tag_name"];
    [tag setObject:@"2000-01-01" forKey:@"birth_date"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"person_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *birthDate = [formatter dateFromString:@"2000-01-01"];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                       name:@"dummy"
                                              contentsCount:1
                                                  birthDate:birthDate]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0003"
 */
- (void)test3
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 50; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"person_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"person_tag_name"];
        [tag setObject:[NSString stringWithFormat:@"2000-%02d-%02d", i / 31 + 1, i % 31 + 1]
                forKey:@"birth_date"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [list addObject:tag];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"person_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        NSString *birth = [NSString stringWithFormat:@"2000-%02d-%02d", i / 31 + 1, i % 31 + 1];
        NSDate *birthDate = [formatter dateFromString:birth];
        DCPersonTag *tag = [[DCPersonTag alloc] initWithGuid:guid
                                                        name:name
                                               contentsCount:i
                                                   birthDate:birthDate];
        [expectList addObject:tag];
    }
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0004"
 */
- (void)test4
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"event_tag_guid"];
    [tag setObject:@"dummy" forKey:@"event_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"event_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCEventTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                       name:@"dummy"
                                              contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0005"
 */
- (void)test5
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 100; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"event_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"event_tag_name"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [list addObject:tag];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"event_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        DCEventTag *tag = [[DCEventTag alloc] initWithGuid:guid
                                                      name:name
                                             contentsCount:i];
        [expectList addObject:tag];
    }
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0006"
 */
- (void)test6
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"optional_tag_guid"];
    [tag setObject:@"dummy" forKey:@"optional_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"optional_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCFavoriteTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                         name:@"dummy"
                                                contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0007"
 */
- (void)test7
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 100; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"optional_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"optional_tag_name"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [list addObject:tag];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"optional_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        DCFavoriteTag *tag = [[DCFavoriteTag alloc] initWithGuid:guid
                                                            name:name
                                                   contentsCount:i];
        [expectList addObject:tag];
    }
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0008"
 */
- (void)test8
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"place_tag_guid"];
    [tag setObject:@"dummy" forKey:@"place_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"place_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCPlacementTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                          name:@"dummy"
                                                 contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0009"
 */
- (void)test9
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 50; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"place_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"place_name"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [list addObject:tag];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"place_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        DCPlacementTag *tag = [[DCPlacementTag alloc] initWithGuid:guid
                                                              name:name
                                                     contentsCount:i];
        [expectList addObject:tag];
    }
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0010"
 */
- (void)test10
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"month_tag_guid"];
    [tag setObject:@"dummy" forKey:@"month_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"month_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCYearMonthTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                          name:@"dummy"
                                                 contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0011"
 */
- (void)test11
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 50; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"month_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"month_tag_name"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [list addObject:tag];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"month_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        DCYearMonthTag *tag = [[DCYearMonthTag alloc] initWithGuid:guid
                                                              name:name
                                                     contentsCount:i];
        [expectList addObject:tag];
    }
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0012"
 */
- (void)test12
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    NSMutableArray *personList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"person_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"person_tag_name"];
        [tag setObject:[NSString stringWithFormat:@"2000-%02d-%02d", i / 31 + 1, i % 31 + 1]
                forKey:@"birth_date"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [personList addObject:tag];
    }
    [json setObject:personList forKey:@"person_tag_list"];
    NSMutableArray *eventList = [NSMutableArray array];
    for (int i = 50; i < 150; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"event_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"event_tag_name"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [eventList addObject:tag];
    }
    [json setObject:eventList forKey:@"event_tag_list"];
    NSMutableArray *optionalList = [NSMutableArray array];
    for (int i = 150; i < 250; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"optional_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"optional_tag_name"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [optionalList addObject:tag];
    }
    [json setObject:optionalList forKey:@"optional_tag_list"];
    NSMutableArray *placeList = [NSMutableArray array];
    for (int i = 250; i < 300; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"place_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"place_name"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [placeList addObject:tag];
    }
    [json setObject:placeList forKey:@"place_info_list"];
    NSMutableArray *monthList = [NSMutableArray array];
    for (int i = 300; i < 350; ++i ) {
        NSMutableDictionary *tag = [NSMutableDictionary dictionary];
        [tag setObject:[NSString stringWithFormat:@"%d", i] forKey:@"month_tag_guid"];
        [tag setObject:[NSString stringWithFormat:@"dummy_%d", i] forKey:@"month_tag_name"];
        [tag setObject:[NSNumber numberWithInt:i] forKey:@"content_cnt"];
        [monthList addObject:tag];
    }
    [json setObject:monthList forKey:@"month_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        NSString *birth = [NSString stringWithFormat:@"2000-%02d-%02d", i / 31 + 1, i % 31 + 1];
        NSDate *birthDate = [formatter dateFromString:birth];
        DCPersonTag *tag = [[DCPersonTag alloc] initWithGuid:guid
                                                        name:name
                                               contentsCount:i
                                                   birthDate:birthDate];
        [expectList addObject:tag];
    }
    for (int i = 50; i < 150; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        DCEventTag *tag = [[DCEventTag alloc] initWithGuid:guid
                                                      name:name
                                             contentsCount:i];
        [expectList addObject:tag];
    }
    for (int i = 150; i < 250; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        DCFavoriteTag *tag = [[DCFavoriteTag alloc] initWithGuid:guid
                                                            name:name
                                                   contentsCount:i];
        [expectList addObject:tag];
    }
    for (int i = 250; i < 300; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        DCPlacementTag *tag = [[DCPlacementTag alloc] initWithGuid:guid
                                                              name:name
                                                     contentsCount:i];
        [expectList addObject:tag];
    }
    for (int i = 300; i < 350; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSString *name = [NSString stringWithFormat:@"dummy_%d", i];
        DCYearMonthTag *tag = [[DCYearMonthTag alloc] initWithGuid:guid
                                                              name:name
                                                     contentsCount:i];
        [expectList addObject:tag];
    }
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0013"
 */
- (void)test13
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"person_tag_guid"];
    [tag setObject:@"dummy" forKey:@"person_tag_name"];
    [tag setObject:@"2000-01-01" forKey:@"birth_date"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"person_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *birthDate = [formatter dateFromString:@"2000-01-01"];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                       name:@"dummy"
                                              contentsCount:1
                                                  birthDate:birthDate]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0014"
 */
- (void)test14
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"person_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"person_tag_name"];
    [tag setObject:@"2000-01-01" forKey:@"birth_date"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"person_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *birthDate = [formatter dateFromString:@"2000-01-01"];
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                       name:@"01234567890123456789"
                                              contentsCount:1
                                                  birthDate:birthDate]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0015"
 */
- (void)test15
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"event_tag_guid"];
    [tag setObject:@"dummy" forKey:@"event_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"event_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCEventTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                      name:@"dummy"
                                             contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0016"
 */
- (void)test16
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"event_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"event_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"event_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCEventTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                      name:@"01234567890123456789"
                                             contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0017"
 */
- (void)test17
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"optional_tag_guid"];
    [tag setObject:@"dummy" forKey:@"optional_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"optional_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCFavoriteTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0018"
 */
- (void)test18
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"optional_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"optional_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"optional_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCFavoriteTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                         name:@"01234567890123456789"
                                                contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0019"
 */
- (void)test19
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"place_tag_guid"];
    [tag setObject:@"dummy" forKey:@"place_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"place_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCPlacementTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                          name:@"dummy"
                                                 contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0020"
 */
- (void)test20
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"place_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"place_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"place_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCPlacementTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                          name:@"01234567890123456789"
                                                 contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0021"
 */
- (void)test21
{
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:guidStr forKey:@"month_tag_guid"];
    [tag setObject:@"dummy" forKey:@"month_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"month_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCYearMonthTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                          name:@"dummy"
                                                 contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0022"
 */
- (void)test22
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"month_tag_guid"];
    [tag setObject:@"01234567890123456789" forKey:@"month_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"month_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCYearMonthTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                          name:@"01234567890123456789"
                                                 contentsCount:1]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=13",
 * id = "GTILLPR0023"
 */
- (void)test23
{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    [tag setObject:@"dummyGUID" forKey:@"person_tag_guid"];
    [tag setObject:@"dummy" forKey:@"person_tag_name"];
    [tag setObject:[NSNumber numberWithInt:1] forKey:@"content_cnt"];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:tag];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"person_tag_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
    DCTagListResponse *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    [response verify];
    
    GHAssertNil(error, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    [expectList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                       name:@"dummy"
                                              contentsCount:1
                                                  birthDate:nil]];
    DCTagListResponse *expect = [[DCTagListResponse alloc] initWithCount:-1
                                                                   start:-1
                                                                nextPage:0
                                                                    list:[NSArray arrayWithArray:expectList]];
    [self assertWithExpect:expect actual:actual];
}

- (void)assertWithExpect:(DCTagListResponse *)expect
                  actual:(DCTagListResponse *)actual
{
    GHAssertNotNil(actual, @"actual must not be nil.");
    GHAssertEquals(expect.count, actual.count, @"count must be equals.");
    GHAssertEquals(expect.start, actual.start, @"start must be equals.");
    GHAssertEquals(expect.nextPage, actual.nextPage, @"nextPage must be equals.");

    GHAssertNotNil(actual.list, @"list must not be nil.");
    GHAssertEquals(expect.list.count, actual.list.count, @"list.count must be equals.");
    for (int i = 0; i < actual.list.count; ++i) {
        [self assertTag:[expect.list objectAtIndex:i]
             withActual:[actual.list objectAtIndex:i]];
    }
}

- (void)assertTag:(DCTag *)expect withActual:(DCTag *)actual
{
    GHAssertNotNil(actual, @"actual must not be nil.");
    GHAssertEquals(expect.type, actual.type, @"type must be equals.");
    GHAssertNotNil(actual.guid, @"actual guid must not be nil.");
    GHAssertEqualStrings(expect.guid.stringValue, actual.guid.stringValue,
                         @"guid must be equals.");
    GHAssertEqualStrings(expect.name, actual.name, @"guid must be equals.");
    GHAssertEquals(expect.contentsCount, actual.contentsCount,
                   @"contentCount must be equals.");
    if (actual.type == DCTAGTYPE_PERSON) {
        DCPersonTag *exp = (DCPersonTag *)expect;
        DCPersonTag *act = (DCPersonTag *)actual;
        if (exp.birthDate != nil) {
            GHAssertTrue([[exp birthDate] isEqualToDate:[act birthDate]],
                         @"birthDate must be equals.");
        } else {
            GHAssertNil(act.birthDate, @"birthDate must be nil.");
        }
    }
}
@end
