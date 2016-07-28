#import "DCGetContentIDListLogicTest.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetContentIDListArguments.h"
#import "DCGetContentIDListLogic.h"
#import "DCTestUtils.h"
#import "DCAuthenticationContext_Private.h"
#import "GTMOAuth2Authentication.h"

@implementation DCGetContentIDListLogicTest
NSString* token = @"dummyToken";
NSString* baseUrl = @"https://example.com";

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0001"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:baseUrl];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
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
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0002"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_VIDEO
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0003"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_SLIDE_MOVIE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0004"
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

    NSException *exception = nil;
    @try {
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:(DCFileType)nil
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:nil
                                                    start:nil
                                                 sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0005"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0006"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_ASC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0007"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_MODIFICATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0008"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_MODIFICATION_DATETIME_ASC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:4] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0009"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_UPLOAD_DATETIME_ASC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:5] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0010"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_UPLOAD_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:6] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0011"
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

    NSException *exception = nil;
    @try {
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:DCFILETYPE_IMAGE
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:nil
                                                    start:nil
                                                 sortType:(DCSortType)nil];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0012"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0013"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:YES
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0014"
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

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSDate *date = [formatter dateFromString:@"2013-01-01T00:00:00Z"];
    DCUploadDateFilter *filter = [[DCUploadDateFilter alloc] initWithDate:date];
    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:filter
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:@"2013-01-01T00:00:00Z" forKey:@"min_date_upload"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0015"
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

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSDate *date = [formatter dateFromString:@"1998-06-15T13:30:25Z"];
    DCUploadDateFilter *filter = [[DCUploadDateFilter alloc] initWithDate:date];
    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:filter
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:@"1998-06-15T13:30:25Z" forKey:@"min_date_upload"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0016"
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

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSDate *date = [formatter dateFromString:@"2013-01-01T00:00:00Z"];
    DCModifiedDateFilter *filter = [[DCModifiedDateFilter alloc] initWithDate:date];
    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:filter
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:@"2013-01-01T00:00:00Z" forKey:@"min_date_modified"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0017"
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

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSDate *date = [formatter dateFromString:@"1998-06-15T13:30:25Z"];
    DCModifiedDateFilter *filter = [[DCModifiedDateFilter alloc] initWithDate:date];
    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:filter
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:@"1998-06-15T13:30:25Z" forKey:@"min_date_modified"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0018"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0019"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:[NSNumber numberWithInt:50]
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:50] forKey:@"max_results"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0020"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:[NSNumber numberWithInt:1]
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"max_results"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0021"
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:[NSNumber numberWithInt:100]
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:100] forKey:@"max_results"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0022"
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

    NSException *exception = nil;
    @try {
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:DCFILETYPE_IMAGE
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:[NSNumber numberWithInt:0]
                                                    start:nil
                                                 sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0023"
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

    NSException *exception = nil;
    @try {
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:DCFILETYPE_IMAGE
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:[NSNumber numberWithInt:101]
                                                    start:nil
                                                 sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0024"
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

    NSException *exception = nil;
    @try {
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:DCFILETYPE_IMAGE
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:[NSNumber numberWithInt:-100]
                                                    start:nil
                                                 sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0025"
 */
- (void)test25
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
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:DCFILETYPE_IMAGE
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:[NSNumber numberWithInt:200]
                                                    start:nil
                                                 sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0026"
 */
- (void)test26
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0027"
 */
- (void)test27
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:[NSNumber numberWithInt:50]
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:50] forKey:@"start"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0028"
 */
- (void)test28
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:[NSNumber numberWithInt:1]
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"start"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0029"
 */
- (void)test29
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
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:DCFILETYPE_IMAGE
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:nil
                                                    start:[NSNumber numberWithInt:0]
                                                 sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0030"
 */
- (void)test30
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
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:DCFILETYPE_IMAGE
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:nil
                                                    start:[NSNumber numberWithInt:-10]
                                                 sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0031"
 */
- (void)test31
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

    DCGetContentIDListArguments *args =
    [DCGetContentIDListArguments argumentsWithContext:mockContext
                                             fileType:DCFILETYPE_IMAGE
                                           forDustbox:NO
                                           dateFilter:nil
                                           maxResults:nil
                                                start:nil
                                             sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListLogic *logic = [[DCGetContentIDListLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    GHAssertEqualStrings(@"application/json", [request valueForHTTPHeaderField:@"Content-Type"],
                   @"Content-Type must be equals application/json.");

    NSDictionary *actual = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0032"
 */
- (void)test32
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
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:DCFILETYPE_IMAGE
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:nil
                                                    start:nil
                                                 sortType:DCSORTTYPE_SCORE_DESC];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=1",
 * id = "GCILLCR0033"
 */
- (void)test33
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
        [DCGetContentIDListArguments argumentsWithContext:mockContext
                                                 fileType:DCFILETYPE_ALL
                                               forDustbox:NO
                                               dateFilter:nil
                                               maxResults:nil
                                                    start:nil
                                                 sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
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
