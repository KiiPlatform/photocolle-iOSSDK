#import "DCGetContentBodyInfoLogicTest2.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetContentBodyInfoLogic.h"
#import "DCContentBodyInfo_Private.h"
#import "DCMiscUtils.h"

@implementation DCGetContentBodyInfoLogicTest2

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0001"
 */
- (void)test1
{
    NSData *data = [@"{ \"result\" : 1 }" dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"application/json"] MIMEType];

    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *retval = [logic parseResponse:response
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0002"
 */
- (void)test2
{
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];

    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"image/jpeg"] MIMEType];

    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];

    [response verify];

    GHAssertTrue(error == nil, @"error must be nil.");

    DCContentBodyInfo *expect = [[DCContentBodyInfo alloc]
                                 initWithContentType:DCMIMETYPE_JPEG
                                         inputStream:[NSInputStream inputStreamWithData:data]];

    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0003"
 */
- (void)test3
{
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"image/pjpeg"] MIMEType];
    
    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentBodyInfo *expect = [[DCContentBodyInfo alloc]
                                 initWithContentType:DCMIMETYPE_PJPEG
                                 inputStream:[NSInputStream inputStreamWithData:data]];
    
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0004"
 */
- (void)test4
{
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"video/3gpp"] MIMEType];
    
    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentBodyInfo *expect = [[DCContentBodyInfo alloc]
                                 initWithContentType:DCMIMETYPE_THREE_GP
                                 inputStream:[NSInputStream inputStreamWithData:data]];
    
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0005"
 */
- (void)test5
{
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"video/avi"] MIMEType];
    
    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentBodyInfo *expect = [[DCContentBodyInfo alloc]
                                 initWithContentType:DCMIMETYPE_AVI
                                 inputStream:[NSInputStream inputStreamWithData:data]];
    
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0006"
 */
- (void)test6
{
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"video/quicktime"] MIMEType];
    
    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentBodyInfo *expect = [[DCContentBodyInfo alloc]
                                 initWithContentType:DCMIMETYPE_QUICKTIME
                                 inputStream:[NSInputStream inputStreamWithData:data]];
    
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0007"
 */
- (void)test7
{
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"video/mp4"] MIMEType];
    
    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentBodyInfo *expect = [[DCContentBodyInfo alloc]
                                 initWithContentType:DCMIMETYPE_MP4
                                 inputStream:[NSInputStream inputStreamWithData:data]];
    
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0008"
 */
- (void)test8
{
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"video/vnd.mts"] MIMEType];
    
    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentBodyInfo *expect = [[DCContentBodyInfo alloc]
                                 initWithContentType:DCMIMETYPE_VND_MTS
                                 inputStream:[NSInputStream inputStreamWithData:data]];
    
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0009"
 */
- (void)test9
{
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"video/mpeg"] MIMEType];
    
    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentBodyInfo *expect = [[DCContentBodyInfo alloc]
                                 initWithContentType:DCMIMETYPE_MPEG
                                 inputStream:[NSInputStream inputStreamWithData:data]];
    
    [self assertWithExpect:expect actual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=15",
 * id = "GCBILPR0010"
 */
- (void)test10
{
    NSData *data = [@"012345678901234567890123456789" dataUsingEncoding:NSUTF8StringEncoding];
    
    id response = [OCMockObject partialMockForObject:[[NSHTTPURLResponse alloc] init]];
    NSInteger status = 200;
    [[[response stub] andReturnValue:OCMOCK_VALUE(status)] statusCode];
    [[[response stub] andReturn:@"image/jpeg"] MIMEType];
    
    NSError *error = nil;
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    DCContentBodyInfo *actual = [logic parseResponse:response
                                                data:data
                                               error:&error];
    
    [response verify];
    
    GHAssertTrue(error == nil, @"error must be nil.");
    
    DCContentBodyInfo *expect = [[DCContentBodyInfo alloc]
                                 initWithContentType:DCMIMETYPE_JPEG
                                 inputStream:[NSInputStream inputStreamWithData:data]];
    
    [self assertWithExpect:expect actual:actual];
}

- (void)assertWithExpect:(DCContentBodyInfo *)expect
                  actual:(DCContentBodyInfo *)actual
{
    GHAssertTrue(actual != nil, @"actual must not be nil.");
    GHAssertEquals(expect.contentType, actual.contentType,
                   @"contentType must be equals.");
    NSData *expectData = [DCMiscUtils toDataFromInputStream:expect.inputStream];
    NSData *actualData = [DCMiscUtils toDataFromInputStream:actual.inputStream];
    // These data is small.
    GHAssertTrue([expectData isEqualToData:actualData],
                 @"data of inputStream must be equals.");
}

@end
