#import "DCGetContentBodyInfoLogicTest.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetContentBodyInfoArguments.h"
#import "DCGetContentBodyInfoLogic.h"
#import "DCEnumerationsUtils.h"
#import "DCTestUtils.h"
#import "DCAuthenticationContext_Private.h"
#import "GTMOAuth2Authentication.h"

@implementation DCGetContentBodyInfoLogicTest


/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0001"
 */
- (void)test1
{
    NSString* token = @"dummyToken";
    NSString* baseUrl = @"https://example.com";
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub] andReturn:token] accessToken];
    [[[mockAuthentication stub] andReturn:nil] authorizationTokenKey];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
            [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                                       fileType:DCFILETYPE_IMAGE
                                                    contentGUID:guid
                                                     resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:baseUrl];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"POST", request.HTTPMethod,
                         @"http method should be POST.");
    GHAssertEqualStrings(baseUrl, request.URL.absoluteString,
                         @"url must be equal.");
    NSString* authToken = [NSString stringWithFormat:@"Bearer %@", token];
    GHAssertEqualStrings(authToken, [request valueForHTTPHeaderField:@"Authorization"],
                         @"token must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0002"
 */
- (void)test2
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_VIDEO
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");
    
    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0003"
 */
- (void)test3
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_SLIDE_MOVIE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");
    
    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0004"
 */
- (void)test4
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    NSException *exception = nil;
    @try {
        [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                                   fileType:(DCFileType)nil
                                                contentGUID:guid
                                                 resizeType:DCRESIZETYPE_ORIGINAL];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"out of range"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"out of range\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name, @"name must be equals");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0005"
 */
- (void)test5
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_IMAGE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");
    
    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0006"
 */
- (void)test6
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"d"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_IMAGE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");
    
    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"d" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0007"
 */
- (void)test7
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:
                           @"01234567890123456789012345678901234567890123456789"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_IMAGE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");
    
    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"01234567890123456789012345678901234567890123456789"
               forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0008"
 */
- (void)test8
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@""];
    NSException *exception = nil;
    @try {
        [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                                   fileType:DCFILETYPE_IMAGE
                                                contentGUID:guid
                                                 resizeType:DCRESIZETYPE_ORIGINAL];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"out of range"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"out of range\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name, @"name must be equals");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0009"
 */
- (void)test9
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:
                           @"012345678901234567890123456789012345678901234567890"];
    NSException *exception = nil;
    @try {
        [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                                   fileType:DCFILETYPE_IMAGE
                                                contentGUID:guid
                                                 resizeType:DCRESIZETYPE_ORIGINAL];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"out of range"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"out of range\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name, @"name must be equals");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0010"
 */
- (void)test10
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    NSException *exception = nil;
    @try {
        [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                                   fileType:DCFILETYPE_IMAGE
                                                contentGUID:nil
                                                 resizeType:DCRESIZETYPE_ORIGINAL];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"nil was assigned"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"nil was assigned\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name, @"name must be equals");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0011"
 */
- (void)test11
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_IMAGE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");
    
    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0012"
 */
- (void)test12
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_IMAGE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_RESIZED_IMAGE];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");
    
    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"resize_type_cd"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0013"
 */
- (void)test13
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_VIDEO
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_RESIZED_VIDEO];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");
    
    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"resize_type_cd"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0014"
 */
- (void)test14
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
        [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
       andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];
    
    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    NSException *exception = nil;
    @try {
        [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                                   fileType:DCFILETYPE_IMAGE
                                                contentGUID:guid
                                                 resizeType:(DCResizeType)nil];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"out of range"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"out of range\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name, @"name must be equals");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0015"
 */
- (void)test15
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_IMAGE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0016"
 */
- (void)test16
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_IMAGE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_RESIZED_IMAGE];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"resize_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0017"
 */
- (void)test17
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    NSException *exception = nil;
    @try {
        [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                                   fileType:DCFILETYPE_IMAGE
                                                contentGUID:guid
                                                 resizeType:DCRESIZETYPE_RESIZED_VIDEO];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"out of range"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"out of range\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name,
                         @"name must be equals");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0018"
 */
- (void)test18
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_VIDEO
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0019"
 */
- (void)test19
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_VIDEO
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_RESIZED_IMAGE];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"resize_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0020"
 */
- (void)test20
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_VIDEO
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_RESIZED_VIDEO];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"resize_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0021"
 */
- (void)test21
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_SLIDE_MOVIE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_ORIGINAL];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"resize_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0022"
 */
- (void)test22
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    DCGetContentBodyInfoArguments *args =
    [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                               fileType:DCFILETYPE_SLIDE_MOVIE
                                            contentGUID:guid
                                             resizeType:DCRESIZETYPE_RESIZED_IMAGE];
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentBodyInfoLogic *logic = [[DCGetContentBodyInfoLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEquals(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"file_type_cd"];
    [expect setObject:@"dummyGUID" forKey:@"content_guid"];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"resize_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0023"
 */
- (void)test23
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    NSException *exception = nil;
    @try {
        [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                                   fileType:DCFILETYPE_SLIDE_MOVIE
                                                contentGUID:guid
                                                 resizeType:DCRESIZETYPE_RESIZED_VIDEO];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"out of range"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"out of range\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name,
                         @"name must be equals");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=7",
 * id = "GCBILCR0024"
 */
- (void)test24
{
    DCAuthenticationContext *context = [[DCAuthenticationContext alloc] init];
    id mockContext = [OCMockObject partialMockForObject:context];
    DCGTMOAuth2Authentication *authentication =
    [[DCGTMOAuth2Authentication alloc] init];
    id mockAuthentication = [OCMockObject partialMockForObject:authentication];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] authorizeRequest:[OCMArg any]];
    [[[mockAuthentication stub]
      andReturnValue:OCMOCK_VALUE((BOOL){YES})] canAuthorize];
    [[[mockContext stub] andReturn:mockAuthentication] authentication];

    DCContentGUID *guid = [[DCContentGUID alloc] initWithGUID:@"dummyGUID"];
    NSException *exception = nil;
    @try {
        [DCGetContentBodyInfoArguments argumentsWithContext:mockContext
                                                   fileType:DCFILETYPE_ALL
                                                contentGUID:guid
                                                 resizeType:DCRESIZETYPE_ORIGINAL];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"out of range"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"out of range\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name, @"name must be equals");
}

@end
