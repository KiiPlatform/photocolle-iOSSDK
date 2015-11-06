#import "DCUploadContentBodyLogicTest.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCUploadContentBodyArguments.h"
#import "DCUploadContentBodyLogic.h"
#import "DCMiscUtils.h"
#import "DCEnumerationsUtils.h"

#import "GTMMIMEDocument.h"
#import "DCAuthenticationContext_Private.h"
#import "GTMOAuth2Authentication.h"

@implementation DCUploadContentBodyLogicTest

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0001"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:baseUrl];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
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
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                   @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];

    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];

    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0002"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_MPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/mpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0003"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_SLIDE_MOVIE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0004"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:(DCFileType)nil
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0005"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0006"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"j"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"j"
                                                                 size:data.length
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0007"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *fileName =
    @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901234567890123456789012345678901234567890123456789"
    @"01234567890.jpg";
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:fileName
                                                  size:data.length
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:fileName
                                                                 size:data.length
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0008"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@""
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0009"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *fileName =
    @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901234567890123456789012345678901234567890123456789"
    @"012345678901.jpg";
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:fileName
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0010"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:nil
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0011"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0012"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:1L
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:1L
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0013"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:(30L * 1024L * 1024L)
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:31457280L
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0014"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:(30L * 1024L * 1024L + 1L)
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0015"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0016"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_PJPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"image/pjpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0017"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_THREE_GP
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/3gpp"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0018"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_AVI
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/avi"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0019"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_QUICKTIME
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/quicktime"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0020"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_MP4
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/mp4"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0021"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_VND_MTS
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/vnd.mts"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0022"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_MPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/mpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0023"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:(DCMimeType)nil
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0024"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0025"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:nil];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0026"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:(100L * 1024L * 1024L)
                                              mimeType:DCMIMETYPE_MPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:104857600L
                                                             mimeType:@"video/mpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0027"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_VIDEO
                                                  fileName:@"dummy.jpg"
                                                      size:(100L * 1024L * 1024L + 1L)
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0028"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:0L
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0029"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_JPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"image/jpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0030"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_IMAGE
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_PJPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Image"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"image/pjpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0031"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_THREE_GP
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0032"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_AVI
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0033"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_QUICKTIME
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0034"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_MP4
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0035"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_VND_MTS
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0036"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_IMAGE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_MPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0037"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_VIDEO
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0038"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_VIDEO
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_PJPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0039"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_THREE_GP
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/3gpp"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0040"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_AVI
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/avi"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0041"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_QUICKTIME
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/quicktime"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0042"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_MP4
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/mp4"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0043"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_VND_MTS
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/vnd.mts"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0044"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    DCUploadContentBodyArguments *args =
    [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                              fileType:DCFILETYPE_VIDEO
                                              fileName:@"dummy.jpg"
                                                  size:data.length
                                              mimeType:DCMIMETYPE_MPEG
                                              bodyData:data];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    DCUploadContentBodyLogic *logic = [[DCUploadContentBodyLogic alloc] init];
    NSError *error;
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];
    
    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"http://example.com", request.URL.absoluteString,
                         @"url must be equal.");
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    GHAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary=" ],
                 @"Content-Type must be starts 'multipart/form-data; boundary='.");
    NSString *boundary = [contentType substringFromIndex:30];
    NSData *body = [DCUploadContentBodyLogicTest toData:request.HTTPBodyStream];
    NSString *actual = [[NSString alloc] initWithData:body
                                             encoding:NSUTF8StringEncoding];
    
    NSString *expect = [DCUploadContentBodyLogicTest makeExpectString:boundary
                                                             fileType:@"Video"
                                                             fileName:@"dummy.jpg"
                                                                 size:data.length
                                                             mimeType:@"video/mpeg"
                                                             bodyData:data];
    
    GHAssertEqualStrings(expect, actual, @"HTTPBody must be equals.");
}

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0045"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_SLIDE_MOVIE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_JPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0046"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_SLIDE_MOVIE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_PJPEG
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0047"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_SLIDE_MOVIE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_THREE_GP
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0048"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_SLIDE_MOVIE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_AVI
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0049"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_SLIDE_MOVIE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_QUICKTIME
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0050"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_SLIDE_MOVIE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_MP4
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0051"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_SLIDE_MOVIE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_VND_MTS
                                                  bodyData:data];
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
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=9",
 * id = "UCBLCR0052"
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
    
    NSData *data = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
    NSException *exception = nil;
    @try {
        [DCUploadContentBodyArguments argumentsWithContext:mockContext
                                                  fileType:DCFILETYPE_SLIDE_MOVIE
                                                  fileName:@"dummy.jpg"
                                                      size:data.length
                                                  mimeType:DCMIMETYPE_MPEG
                                                  bodyData:data];
    }
    @catch (NSException *e) {
        exception = e;
    }
    GHAssertTrue(exception != nil, @"exception must not be nil.");
    NSRange range = [[exception reason] rangeOfString:@"out of range"];
    GHAssertTrue(range.location != NSNotFound, @"reason must has string @\"out of range\".");
    GHAssertEqualStrings(NSInvalidArgumentException, exception.name, @"name must be equals");
}

+ (NSString *)makeExpectString:(NSString *)boundary
                      fileType:(NSString *)fileType
                      fileName:(NSString *)fileName
                          size:(long long)size
                      mimeType:(NSString *)mimeType
                      bodyData:(NSData *)bodyData
{
    NSString *sizeStr = [NSString stringWithFormat:@"%lld", size];

    DCGTMMIMEDocument *document = [DCGTMMIMEDocument MIMEDocument];
    [DCUploadContentBodyLogicTest putPartWithName:@"type"
                                      stringValue:fileType
                                       toDocument:document];
    [DCUploadContentBodyLogicTest putPartWithName:@"title"
                                      stringValue:fileName
                                       toDocument:document];
    [DCUploadContentBodyLogicTest putPartWithName:@"size"
                                      stringValue:sizeStr
                                       toDocument:document];
    [DCUploadContentBodyLogicTest putPartWithName:@"mime_type"
                                      stringValue:mimeType
                                       toDocument:document];
    [DCUploadContentBodyLogicTest putPartWithName:@"file"
                                         fileName:fileName
                                         bodyData:bodyData
                                       toDocument:document];
    
    NSInputStream *inputStream = nil;
    NSString *replaceTarget = nil;
    unsigned long long len = 0;
    
    [document generateInputStream:&inputStream
                           length:&len
                         boundary:&replaceTarget];

    NSData *data = [DCUploadContentBodyLogicTest toData:inputStream];
    NSString *retval = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [retval stringByReplacingOccurrencesOfString:replaceTarget withString:boundary];
}

+ (void)putPartWithName:(NSString *)name
            stringValue:(NSString *)stringValue
             toDocument:(DCGTMMIMEDocument *)document
{
    NSString *value = [NSString stringWithFormat:@"form-data; name=\"%@\"", name];
    [document addPartWithHeaders:[NSDictionary dictionaryWithObject:value
                                                             forKey:@"Content-Disposition"]
                            body:[stringValue dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)putPartWithName:(NSString *)name
               fileName:(NSString *)fileName
               bodyData:(NSData *)bodyData
             toDocument:(DCGTMMIMEDocument *)document
{
    NSString *format = @"form-data; name=\"%@\"; filename=\"%@\"";
    NSString *contentDispositionValue = [NSString stringWithFormat:format, name, fileName];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:
                             contentDispositionValue, @"Content-Disposition",
                             @"application/octet-stream", @"Content-Type",
                             nil];
    [document addPartWithHeaders:headers body:bodyData];
}

+ (NSData *)toData:(NSInputStream *)stream
{
    [stream open];
    NSData *retval = [DCMiscUtils toDataFromInputStream:stream];
    [stream close];
    return retval;
}
@end
