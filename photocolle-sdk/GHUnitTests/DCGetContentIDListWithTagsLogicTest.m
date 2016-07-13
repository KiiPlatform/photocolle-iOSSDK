#import "DCGetContentIDListWithTagsLogicTest.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetContentIDListWithTagsArguments.h"
#import "DCGetContentIDListWithTagsLogic.h"
#import "DCTestUtils.h"
#import "DCContentGUID_Private.h"
#import "DCAuthenticationContext_Private.h"
#import "GTMOAuth2Authentication.h"

@implementation DCGetContentIDListWithTagsLogicTest

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0001"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                             fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:baseUrl];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0002"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_VIDEO
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0003"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_SLIDE_MOVIE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0004"
 */
/* only Android test.
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
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:(DCFileType)nil
                                                     criteriaList:nil
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
*/

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0005"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0006"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_ASC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0007"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_MODIFICATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0008"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_MODIFICATION_DATETIME_ASC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0009"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_UPLOAD_DATETIME_ASC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0010"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_UPLOAD_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0011"
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
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0012"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0013"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:YES
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0014"
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
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:filter
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0015"
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
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:filter
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0016"
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
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:filter
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0017"
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
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:filter
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0018"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0019"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:[NSNumber numberWithInt:50]
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0020"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:[NSNumber numberWithInt:1]
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0021"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:[NSNumber numberWithInt:1000]
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1000] forKey:@"max_results"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0022"
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
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0023"
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
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
                                                       forDustbox:NO
                                                       dateFilter:nil
                                                       maxResults:[NSNumber numberWithInt:1001]
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0024"
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
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0025"
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
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
                                                       forDustbox:NO
                                                       dateFilter:nil
                                                       maxResults:[NSNumber numberWithInt:2000]
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0026"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0027"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:[NSNumber numberWithInt:50]
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0028"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:[NSNumber numberWithInt:1]
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0029"
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
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0030"
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
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0031"
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

    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0032"
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
    
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_FILE_COUNT
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:@"1" forKey:@"projection"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0033"
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
    
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_ALL_DETAILS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:@"2" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0034"
 */
- (void)test34
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
    
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0035"
 */
- (void)test35
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
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:(DCProjectionType)nil
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0036"
 */
- (void)test36
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
    
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0037"
 */
- (void)test37
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

    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_1_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_1_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0038"
 */
- (void)test38
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[[DCEventTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                        name:@"dummy"
                                               contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"criteria_1_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_1_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0039"
 */
- (void)test39
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[[DCFavoriteTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                           name:@"dummy"
                                                  contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"criteria_1_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_1_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0040"
 */
- (void)test40
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[[DCPlacementTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:4] forKey:@"criteria_1_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_1_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0041"
 */
- (void)test41
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[[DCYearMonthTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:5] forKey:@"criteria_1_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_1_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0042"
 */
- (void)test42
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0043"
 */
- (void)test43
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
    
    NSString *guidStr = @"0";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_1_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_1_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0044"
 */
- (void)test44
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
    
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_1_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_1_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0045"
 */
- (void)test45
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
    
    NSString *guidStr = @"";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0046"
 */
- (void)test46
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
    
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0047"
 */
- (void)test47
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_2_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_2_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0048"
 */
- (void)test48
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCEventTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                        name:@"dummy"
                                               contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"criteria_2_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_2_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0049"
 */
- (void)test49
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCFavoriteTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                           name:@"dummy"
                                                  contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"criteria_2_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_2_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0050"
 */
- (void)test50
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPlacementTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:4] forKey:@"criteria_2_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_2_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0051"
 */
- (void)test51
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCYearMonthTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:5] forKey:@"criteria_2_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_2_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0052"
 */
- (void)test52
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0053"
 */
- (void)test53
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
    
    NSString *guidStr = @"0";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_2_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_2_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0054"
 */
- (void)test54
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
    
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_2_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_2_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0055"
 */
- (void)test55
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
    
    NSString *guidStr = @"";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0056"
 */
- (void)test56
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
    
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0057"
 */
- (void)test57
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_3_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_3_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0058"
 */
- (void)test58
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCEventTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                        name:@"dummy"
                                               contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"criteria_3_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_3_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0059"
 */
- (void)test59
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCFavoriteTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                           name:@"dummy"
                                                  contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"criteria_3_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_3_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0060"
 */
- (void)test60
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPlacementTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:4] forKey:@"criteria_3_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_3_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0061"
 */
- (void)test61
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCYearMonthTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:5] forKey:@"criteria_3_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_3_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0062"
 */
- (void)test62
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0063"
 */
- (void)test63
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
    
    NSString *guidStr = @"0";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_3_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_3_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0064"
 */
- (void)test64
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
    
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_3_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_3_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0065"
 */
- (void)test65
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
    
    NSString *guidStr = @"";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0066"
 */
- (void)test66
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
    
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0067"
 */
- (void)test67
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_4_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_4_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0068"
 */
- (void)test68
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCEventTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                        name:@"dummy"
                                               contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"criteria_4_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_4_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0069"
 */
- (void)test69
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCFavoriteTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                           name:@"dummy"
                                                  contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"criteria_4_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_4_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0070"
 */
- (void)test70
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPlacementTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:4] forKey:@"criteria_4_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_4_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0071"
 */
- (void)test71
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCYearMonthTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:5] forKey:@"criteria_4_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_4_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0072"
 */
- (void)test72
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0073"
 */
- (void)test73
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
    
    NSString *guidStr = @"0";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_4_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_4_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0074"
 */
- (void)test74
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
    
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_4_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_4_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0075"
 */
- (void)test75
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
    
    NSString *guidStr = @"";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0076"
 */
- (void)test76
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
    
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0077"
 */
- (void)test77
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_5_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_5_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0078"
 */
- (void)test78
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCEventTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                        name:@"dummy"
                                               contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"criteria_5_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_5_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0079"
 */
- (void)test79
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCFavoriteTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                           name:@"dummy"
                                                  contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"criteria_5_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_5_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0080"
 */
- (void)test80
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPlacementTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:4] forKey:@"criteria_5_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_5_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0081"
 */
- (void)test81
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCYearMonthTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                            name:@"dummy"
                                                   contentsCount:0]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:5] forKey:@"criteria_5_tag_type"];
    [expect setObject:@"dummyGUID" forKey:@"criteria_5_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0082"
 */
- (void)test82
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0083"
 */
- (void)test83
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
    
    NSString *guidStr = @"0";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_5_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_5_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0084"
 */
- (void)test84
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
    
    NSString *guidStr = @"01234567890123456789012345678901234567890123456";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:criteriaList
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"criteria_5_tag_type"];
    [expect setObject:guidStr forKey:@"criteria_5_guid"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0085"
 */
- (void)test85
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
    
    NSString *guidStr = @"";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0086"
 */
- (void)test86
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
    
    NSString *guidStr = @"012345678901234567890123456789012345678901234567";
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:guidStr]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0087"
 */
- (void)test87
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
    
    NSMutableArray *criteriaList = [NSMutableArray array];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[NSNull null]];
    [criteriaList addObject:[[DCPersonTag alloc] initWithGuid:[DCContentGUID guidWithString:@"dummyGUID"]
                                                         name:@"dummy"
                                                contentsCount:0
                                                    birthDate:[NSDate date]]];
    NSException *exception = nil;
    @try {
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:criteriaList
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0088"
 */
- (void)test88
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
    
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_SCORE_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:7] forKey:@"sort_type"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0089"
 */
- (void)test89
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
    
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_FILE_COUNT
                                                     fileType:DCFILETYPE_IMAGE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:@"1" forKey:@"projection"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0090"
 */
- (void)test90
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
    
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_FILE_COUNT
                                                     fileType:DCFILETYPE_VIDEO
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:@"1" forKey:@"projection"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0091"
 */
- (void)test91
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
    
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_FILE_COUNT
                                                     fileType:DCFILETYPE_SLIDE_MOVIE
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:@"1" forKey:@"projection"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0092"
 * Ignore this test, because of ignore DCSortType in iOS SDK.
 */

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0093"
 */
- (void)test93
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
    DCGetContentIDListWithTagsArguments *args =
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_FILE_COUNT
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
                                                       forDustbox:NO
                                                       dateFilter:filter
                                                       maxResults:nil
                                                            start:nil
                                                         sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:@"1" forKey:@"projection"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0094"
 */
- (void)test94
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

    DCGetContentIDListWithTagsArguments *args =
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_FILE_COUNT
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
                                                       forDustbox:NO
                                                       dateFilter:nil
                                                       maxResults:[NSNumber numberWithInt:50]
                                                            start:nil
                                                         sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:@"1" forKey:@"projection"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0095"
 */
- (void)test95
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
    
    DCGetContentIDListWithTagsArguments *args =
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_FILE_COUNT
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:nil
                                                       forDustbox:NO
                                                       dateFilter:nil
                                                       maxResults:nil
                                                            start:[NSNumber numberWithInt:50]
                                                         sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:@"1" forKey:@"projection"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0096"
 */
- (void)test96
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

    DCGetContentIDListWithTagsArguments *args =
        [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                                   projectionType:DCPROJECTIONTYPE_FILE_COUNT
                                                         fileType:DCFILETYPE_IMAGE
                                                     criteriaList:[NSArray array]
                                                       forDustbox:NO
                                                       dateFilter:nil
                                                       maxResults:nil
                                                            start:nil
                                                         sortType:DCSORTTYPE_CREATION_DATETIME_DESC];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:@"1" forKey:@"projection"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=2",
 * id = "GCILWTLCR0097"
 */
- (void)test97
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
    
    DCGetContentIDListWithTagsArguments *args =
    [DCGetContentIDListWithTagsArguments argumentsWithContext:mockContext
                                               projectionType:DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS
                                                     fileType:DCFILETYPE_ALL
                                                 criteriaList:nil
                                                   forDustbox:NO
                                                   dateFilter:nil
                                                   maxResults:nil
                                                        start:nil
                                                     sortType:DCSORTTYPE_CREATION_DATETIME_DESC];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentIDListWithTagsLogic *logic = [[DCGetContentIDListWithTagsLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];
    [expect setObject:@"3" forKey:@"projection"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"dustbox_condition"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"sort_type"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

@end
