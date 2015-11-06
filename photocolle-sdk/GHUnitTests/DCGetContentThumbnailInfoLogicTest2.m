#import "DCGetContentThumbnailInfoLogicTest2.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetContentThumbnailInfoLogic.h"
#import "DCContentThumbnailInfo_Private.h"
#import "DCContentThumbnailInfoList_Private.h"
#import "DCContentGUID_Private.h"

@implementation DCGetContentThumbnailInfoLogicTest2

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0001"
 */
- (void)test1
{
    NSData *data = [@"{ \"result\" : 1 }" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0002"
 */
- (void)test2
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"dummyGUID\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *actual = [logic parseResponse:response
                                                         data:data
                                                        error:&error];
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentGUID *guid = [DCContentGUID guidWithString:@"dummyGUID"];
    NSData *bytes = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCContentThumbnailInfo *expectInfo = [[DCContentThumbnailInfo alloc] initWithGUID:guid
                                                                             mimeType:DCMIMETYPE_JPEG
                                                                       thumbnailBytes:bytes];
    DCContentThumbnailInfoList *expect = [[DCContentThumbnailInfoList alloc] initWithList:[NSArray arrayWithObject:expectInfo]
                                                                                   ngList:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0003"
 */
- (void)test3
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[NSString stringWithFormat:@"%d", i] forKey:@"content_guid"];
        [info setObject:@"image/jpeg" forKey:@"mime_type"];
        [info setObject:@"ZHVtbXk=" forKey:@"thumbnail"];
        [list addObject:info];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"content_info_list"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *actual = [logic parseResponse:response
                                                         data:data
                                                        error:&error];
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    NSMutableArray *expectList = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        DCContentGUID *guid = [DCContentGUID guidWithString:[NSString stringWithFormat:@"%d", i]];
        NSData *bytes = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
        [expectList addObject:[[DCContentThumbnailInfo alloc] initWithGUID:guid
                                                                  mimeType:DCMIMETYPE_JPEG
                                                            thumbnailBytes:bytes]];
    }
    DCContentThumbnailInfoList *expect = [[DCContentThumbnailInfoList alloc] initWithList:[NSArray arrayWithArray:expectList]
                                                                                   ngList:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0004"
 */
- (void)test4
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"01234567890123456789012345678901234567890123456789\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *actual = [logic parseResponse:response
                                                         data:data
                                                        error:&error];
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentGUID *guid = [DCContentGUID guidWithString:
                           @"01234567890123456789012345678901234567890123456789"];
    NSData *bytes = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCContentThumbnailInfo *expectInfo = [[DCContentThumbnailInfo alloc] initWithGUID:guid
                                                                             mimeType:DCMIMETYPE_JPEG
                                                                       thumbnailBytes:bytes];
    DCContentThumbnailInfoList *expect = [[DCContentThumbnailInfoList alloc] initWithList:[NSArray arrayWithObject:expectInfo]
                                                                                   ngList:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0005"
 */
- (void)test5
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : [ ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0006"
 */
- (void)test6
{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 101; ++i) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[NSString stringWithFormat:@"%d", i] forKey:@"content_guid"];
        [info setObject:@"image/jpeg" forKey:@"mime_type"];
        [info setObject:@"ZHVtbXk=" forKey:@"thumbnail"];
        [list addObject:info];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"content_info_list"];

    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0007"
 */
- (void)test7
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"dummyGUID\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ],"
                    @"\"ng_list\" : [ ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *actual = [logic parseResponse:response
                                                         data:data
                                                        error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"dummyGUID"];
    NSData *bytes = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCContentThumbnailInfo *expectInfo = [[DCContentThumbnailInfo alloc] initWithGUID:guid
                                                                             mimeType:DCMIMETYPE_JPEG
                                                                       thumbnailBytes:bytes];
    DCContentThumbnailInfoList *expect = [[DCContentThumbnailInfoList alloc] initWithList:[NSArray arrayWithObject:expectInfo]
                                                                                   ngList:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0008"
 */
- (void)test8
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"dummyGUID\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ],"
                    @"\"ng_list\" : [ \"ng1\" ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *actual = [logic parseResponse:response
                                                         data:data
                                                        error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"dummyGUID"];
    NSData *bytes = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCContentThumbnailInfo *expectInfo = [[DCContentThumbnailInfo alloc] initWithGUID:guid
                                                                             mimeType:DCMIMETYPE_JPEG
                                                                       thumbnailBytes:bytes];
    DCContentGUID *ngGuid = [DCContentGUID guidWithString:@"ng1"];
    DCContentThumbnailInfoList *expect = [[DCContentThumbnailInfoList alloc]
                                          initWithList:[NSArray arrayWithObject:expectInfo]
                                                ngList:[NSArray arrayWithObject:ngGuid]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0009"
 */
- (void)test9
{
    NSMutableArray *list = [NSMutableArray array];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"dummyGUID" forKey:@"content_guid"];
    [info setObject:@"image/jpeg" forKey:@"mime_type"];
    [info setObject:@"ZHVtbXk=" forKey:@"thumbnail"];
    [list addObject:info];
    NSMutableArray *ngList = [NSMutableArray array];
    for (int i = 0; i < 99; ++i) {
        [ngList addObject:[NSString stringWithFormat:@"ng%d", i]];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"content_info_list"];
    [json setObject:ngList forKey:@"ng_list"];

    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *actual = [logic parseResponse:response
                                                         data:data
                                                        error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    NSMutableArray *expectList = [NSMutableArray array];
    DCContentGUID *guid = [DCContentGUID guidWithString:@"dummyGUID"];
    NSData *bytes = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    [expectList addObject:[[DCContentThumbnailInfo alloc] initWithGUID:guid
                                                              mimeType:DCMIMETYPE_JPEG
                                                        thumbnailBytes:bytes]];
    NSMutableArray *expectNGList = [NSMutableArray array];
    for (int i = 0; i < 99; ++i) {
        [expectNGList addObject:[DCContentGUID guidWithString:
                                 [NSString stringWithFormat:@"ng%d", i]]];
    }
    DCContentThumbnailInfoList *expect = [[DCContentThumbnailInfoList alloc]
                                          initWithList:[NSArray arrayWithArray:expectList]
                                          ngList:[NSArray arrayWithArray:expectNGList]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0010"
 */
- (void)test10
{
    NSMutableArray *list = [NSMutableArray array];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"dummyGUID" forKey:@"content_guid"];
    [info setObject:@"image/jpeg" forKey:@"mime_type"];
    [info setObject:@"ZHVtbXk=" forKey:@"thumbnail"];
    [list addObject:info];
    NSMutableArray *ngList = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        [ngList addObject:[NSString stringWithFormat:@"ng%d", i]];
    }
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:[NSNumber numberWithInt:0] forKey:@"result"];
    [json setObject:list forKey:@"content_info_list"];
    [json setObject:ngList forKey:@"ng_list"];

    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0011"
 */
- (void)test11
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"dummyGUID\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ],"
                    @"\"ng_list\" : [ \"01234567890123456789012345678901234567890123456789\" ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *actual = [logic parseResponse:response
                                                         data:data
                                                        error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"dummyGUID"];
    NSData *bytes = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCContentThumbnailInfo *expectInfo = [[DCContentThumbnailInfo alloc] initWithGUID:guid
                                                                             mimeType:DCMIMETYPE_JPEG
                                                                       thumbnailBytes:bytes];
    DCContentGUID *ngGuid = [DCContentGUID
                             guidWithString:@"01234567890123456789012345678901234567890123456789"];
    DCContentThumbnailInfoList *expect = [[DCContentThumbnailInfoList alloc]
                                          initWithList:[NSArray arrayWithObject:expectInfo]
                                          ngList:[NSArray arrayWithObject:ngGuid]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0012"
 */
- (void)test12
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"0\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *actual = [logic parseResponse:response
                                                         data:data
                                                        error:&error];
    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0"];
    NSData *bytes = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCContentThumbnailInfo *expectInfo = [[DCContentThumbnailInfo alloc] initWithGUID:guid
                                                                             mimeType:DCMIMETYPE_JPEG
                                                                       thumbnailBytes:bytes];
    DCContentThumbnailInfoList *expect = [[DCContentThumbnailInfoList alloc] initWithList:[NSArray arrayWithObject:expectInfo]
                                                                                   ngList:[NSArray array]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0013"
 */
- (void)test13
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0014"
 */
- (void)test14
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"012345678901234567890123456789012345678901234567890\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0015"
 */
- (void)test15
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"dummyGUID\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ],"
                    @"\"ng_list\" : [ \"0\" ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    
    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *actual = [logic parseResponse:response
                                                         data:data
                                                        error:&error];
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentGUID *guid = [DCContentGUID guidWithString:@"dummyGUID"];
    NSData *bytes = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCContentThumbnailInfo *expectInfo = [[DCContentThumbnailInfo alloc] initWithGUID:guid
                                                                             mimeType:DCMIMETYPE_JPEG
                                                                       thumbnailBytes:bytes];
    DCContentGUID *ngGuid = [DCContentGUID
                             guidWithString:@"0"];
    DCContentThumbnailInfoList *expect = [[DCContentThumbnailInfoList alloc]
                                          initWithList:[NSArray arrayWithObject:expectInfo]
                                          ngList:[NSArray arrayWithObject:ngGuid]];
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0016"
 */
- (void)test16
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"dummyGUID\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ],"
                    @"\"ng_list\" : [ \"\" ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=12",
 * id = "GCTILPR0017"
 */
- (void)test17
{
    NSData *data = [@"{ \"result\" : 0,"
                    @"\"content_info_list\" : ["
                    @"{ \"content_guid\" : \"dummyGUID\","
                    @"  \"mime_type\" : \"image/jpeg\","
                    @" \"thumbnail\" : \"ZHVtbXk=\" } ],"
                    @"\"ng_list\" : [ \"012345678901234567890123456789012345678901234567890\" ] }"
                    dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];

    NSError *error = nil;
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
    DCContentThumbnailInfoList *retval = [logic parseResponse:response
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

- (void)assertWithExpect:(DCContentThumbnailInfoList *)expect
                  actual:(DCContentThumbnailInfoList *)actual
{
    GHAssertNotNil(actual, @"actual must not be nil.");
    
    GHAssertNotNil(actual.list, @"list must not be nil.");
    GHAssertEquals(expect.list.count, actual.list.count, @"list.count must be equals.");
    for (int i = 0; i < actual.list.count; ++i) {
        [self assertInfo:[expect.list objectAtIndex:i]
              withActual:[actual.list objectAtIndex:i]];
    }
}

- (void)assertInfo:(DCContentThumbnailInfo *)expect
        withActual:(DCContentThumbnailInfo *)actual
{
    GHAssertNotNil(actual, @"actual must not be nil.");
    GHAssertNotNil(actual.guid, @"actual guid must not be nil.");
    GHAssertEqualStrings(expect.guid.stringValue, actual.guid.stringValue,
                         @"guid must be equals.");
    GHAssertEquals(expect.mimeType, actual.mimeType, @"mimeType must be equals.");
    GHAssertTrue([expect.thumbnailBytes isEqualToData:actual.thumbnailBytes],
                 @"thumbnailBytes must be equals.");
}
@end
