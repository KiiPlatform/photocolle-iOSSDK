#import "DCGetCapacityInfoLogicTest.h"

#import "OCMock/OCMock.h"

#import "DCPhotoColleSDK.h"
#import "DCGetCapacityInfoArguments.h"
#import "DCGetCapacityInfoLogic.h"
#import "DCAuthenticationContext_Private.h"
#import "GTMOAuth2Authentication.h"

@implementation DCGetCapacityInfoLogicTest

/**
 * TestInformation
 * url = "https://docs.google.com/a/muraoka-design.com/spreadsheet/ccc?key=0Al0NPhbFN_J-dC1nd3RCR2pkRkVDSmdnYzc0UVVlZmc#gid=10",
 * id = "GCILCR0001"
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

    NSError *error;
    DCGetCapacityInfoArguments *args =
            [DCGetCapacityInfoArguments argumentsWithContext:mockContext];
    NSURL *url = [NSURL URLWithString:baseUrl];
    DCGetCapacityInfoLogic *logic = [[DCGetCapacityInfoLogic alloc] init];
    NSURLRequest *request = [logic createRequestWithURL:url
                                              arguments:args
                                                  error:&error];
    [mockContext verify];

    GHAssertTrue(request != nil, @"request must not be nil.");
    GHAssertTrue(request.URL != nil, @"request url must not be nil.");
    GHAssertEqualStrings(@"GET", request.HTTPMethod,
                         @"http method should be GET.");
    GHAssertEqualStrings(baseUrl, request.URL.absoluteString,
                          @"url must be equal.");
    NSDictionary* headers = [request allHTTPHeaderFields];
    NSString* authToken = [NSString stringWithFormat:@"Bearer %@", token];
    GHAssertEqualStrings(authToken, [headers objectForKey:@"Authorization"],
                         @"token must be equal.");
}

@end
