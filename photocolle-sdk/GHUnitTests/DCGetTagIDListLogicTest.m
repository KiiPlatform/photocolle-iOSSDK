#import "DCGetTagIDListLogicTest.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetTagIDListArguments.h"
#import "DCGetTagIDListLogic.h"
#import "DCTestUtils.h"
#import "DCAuthenticationContext_Private.h"
#import "GTMOAuth2Authentication.h"

@implementation DCGetTagIDListLogicTest

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0001"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_ALL
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:baseUrl];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0002"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_PERSON
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0003"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_EVENT
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0004"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_FAVORITE
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0005"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_PLACEMENT
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:4] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0006"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_YEAR_MONTH
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:5] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0007"
 */
/* no need to check 'category == nil' pattern. nil is equals to DCCATEGORY_ALL(0).
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

    NSException *exception = nil;
    @try {
        [DCGetTagIDListArguments argumentsWithContext:mockContext
                                             category:(DCCategory)nil
                                      minDateModified:nil];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0008"
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

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSDate *date = [formatter dateFromString:@"2013-01-01T00:00:00Z"];
    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_ALL
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:date];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];
    [expect setObject:@"2013-01-01T00:00:00Z" forKey:@"min_date_modified"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0009"
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

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSDate *date = [formatter dateFromString:@"1998-06-15T13:30:25Z"];
    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_ALL
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:date];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];
    [expect setObject:@"1998-06-15T13:30:25Z" forKey:@"min_date_modified"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0010"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_ALL
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0011"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_ALL
                                         fileType:DCFILETYPE_ALL
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0012"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_ALL
                                         fileType:DCFILETYPE_IMAGE
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:1] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0013"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_ALL
                                         fileType:DCFILETYPE_VIDEO
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:2] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0014"
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_ALL
                                         fileType:DCFILETYPE_SLIDE_MOVIE
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"category"];
    [expect setObject:[NSNumber numberWithInt:3] forKey:@"file_type_cd"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=3",
 * id = "GTILLCR0015"
 */
/* no need to check 'filType == nil' pattern. nil is equals to DCFILETYPE_ALL(0).
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

    DCGetTagIDListArguments *args =
    [DCGetTagIDListArguments argumentsWithContext:mockContext
                                         category:DCCATEGORY_ALL
                                         fileType:nil
                                  minDateModified:nil];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetTagIDListLogic *logic = [[DCGetTagIDListLogic alloc] init];
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
    [expect setObject:[NSNumber numberWithInt:0] forKey:@"category"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}
*/

@end
