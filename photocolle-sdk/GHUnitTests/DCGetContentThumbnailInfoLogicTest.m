#import "DCGetContentThumbnailInfoLogicTest.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetContentThumbnailInfoArguments.h"
#import "DCGetContentThumbnailInfoLogic.h"
#import "DCContentGUID_Private.h"
#import "DCTestUtils.h"
#import "DCAuthenticationContext_Private.h"
#import "GTMOAuth2Authentication.h"

@implementation DCGetContentThumbnailInfoLogicTest

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=8",
 * id = "GCTILCR0001"
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

    DCContentGUID *guid = [DCContentGUID guidWithString:@"dummyGUID"];
    NSArray *guids = [NSArray arrayWithObject:guid];
    DCGetContentThumbnailInfoArguments *args =
    [DCGetContentThumbnailInfoArguments argumentsWithContext:mockContext
                                                contentGUIDs:guids];

    NSURL *url = [NSURL URLWithString:baseUrl];
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
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
    NSArray *list = [NSArray arrayWithObject:@"dummyGUID"];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:list forKey:@"content_info_list"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=8",
 * id = "GCTILCR0002"
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
    
    DCGetContentThumbnailInfoArguments *args =
    [DCGetContentThumbnailInfoArguments argumentsWithContext:mockContext
                                                contentGUIDs:[self createGuids:100]];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
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
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        [list addObject:[NSString stringWithFormat:@"dummyGUID_%d", i]];
    }
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:list forKey:@"content_info_list"];
    
    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=8",
 * id = "GCTILCR0003"
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
    
    NSException *exception = nil;
    @try {
        [DCGetContentThumbnailInfoArguments argumentsWithContext:mockContext
                                                    contentGUIDs:[self createGuids:101]];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=8",
 * id = "GCTILCR0004"
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
        [DCGetContentThumbnailInfoArguments argumentsWithContext:mockContext
                                                    contentGUIDs:[NSArray array]];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=8",
 * id = "GCTILCR0005"
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

    DCContentGUID *guid = [DCContentGUID guidWithString:@"0"];
    NSArray *guids = [NSArray arrayWithObject:guid];
    DCGetContentThumbnailInfoArguments *args =
    [DCGetContentThumbnailInfoArguments argumentsWithContext:mockContext
                                                contentGUIDs:guids];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
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
    NSArray *list = [NSArray arrayWithObject:@"0"];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:list forKey:@"content_info_list"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=8",
 * id = "GCTILCR0006"
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

    NSString *guidStr = @"01234567890123456789012345678901234567890123456789";
    DCContentGUID *guid = [DCContentGUID guidWithString:guidStr];
    NSArray *guids = [NSArray arrayWithObject:guid];
    DCGetContentThumbnailInfoArguments *args =
    [DCGetContentThumbnailInfoArguments argumentsWithContext:mockContext
                                                contentGUIDs:guids];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCGetContentThumbnailInfoLogic *logic = [[DCGetContentThumbnailInfoLogic alloc] init];
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
    NSArray *list = [NSArray arrayWithObject:guidStr];
    NSMutableDictionary *expect = [[NSMutableDictionary alloc] init];
    [expect setObject:list forKey:@"content_info_list"];

    [[[DCTestUtils alloc] init] assertJSONObjectEquals:expect withActual:actual];
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=8",
 * id = "GCTILCR0007"
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

    DCContentGUID *guid = [DCContentGUID guidWithString:@""];
    NSException *exception = nil;
    @try {
        [DCGetContentThumbnailInfoArguments argumentsWithContext:mockContext
                                                    contentGUIDs:[NSArray arrayWithObject:guid]];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=8",
 * id = "GCTILCR0008"
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

    NSString *guidStr = @"012345678901234567890123456789012345678901234567890";
    DCContentGUID *guid = [DCContentGUID guidWithString:guidStr];
    NSException *exception = nil;
    @try {
        [DCGetContentThumbnailInfoArguments argumentsWithContext:mockContext
                                                    contentGUIDs:[NSArray arrayWithObject:guid]];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"out of range"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"out of range\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name, @"name must be equals");
}

- (NSArray *)createGuids:(int)size
{
    NSMutableArray *guids = [NSMutableArray array];
    for (int i = 0; i < size; ++i) {
        NSString *guid = [NSString stringWithFormat:@"dummyGUID_%d", i];
        [guids addObject:[DCContentGUID guidWithString:guid]];
    }
    return [NSArray arrayWithArray:guids];
}

@end
