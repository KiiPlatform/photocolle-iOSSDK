/* Copyright 2014 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* 2015 Kii corp.
 *
 * Prefixes are changed from GTM to DCDCGTM.
 *
 * Targets of changing prefix are all classes, protocols, extensions,
 * categoriesconst values, comments and etc.
 */

// DCGTMSessionFetcher is a wrapper around NSURLSession for http operations.
//
// What does this offer on top of of NSURLSession?
//
// - Block-style callbacks for useful functionality like progress rather than delegate methods.
// - Out-of-process uploads and downloads using NSURLSession, including management of fetches after
//   relaunch.
// - Integration with DCGTMOAuth2 for invisible management and refresh of authorization tokens.
// - Pretty-printed http logging.
// - Cookies handling that does not interfere with or get interfered with by WebKit cookies
//   or on Mac by Safari and other apps.
// - Credentials handling for the http operation.
// - Rate-limiting and cookie grouping when fetchers are created with DCGTMSessionFetcherService.
//
// If the bodyData or bodyFileURL property is set, then a POST request is assumed.
//
// Each fetcher is assumed to be for a one-shot fetch request; don't reuse the object
// for a second fetch.
//
// The fetcher will be self-retained as long as a connection is pending.
//
// To keep user activity private, URLs must have an https scheme (unless the property
// allowedInsecureSchemes is set to permit the scheme.)
//
// Callbacks will be released when the fetch completes or is stopped, so there is no need
// to use weak self references in the callback blocks.
//
// Sample usage:
//
//  DCGTMSessionFetcher *myFetcher = [DCGTMSessionFetcher fetcherWithURLString:myURLString];
//
//  // Optionally specify a file URL or NSData for the request body to upload.
//  myFetcher.bodyData = [postString dataUsingEncoding:NSUTF8StringEncoding];
//
//  // Optionally specify if the transfer should be done in another process.
//  myFetcher.useBackgroundSession = YES;
//
//  [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
//    if (error != nil) {
//      // Status code or network error
//    } else {
//      // Succeeded
//    }
//  }];
//
// There is also a beginFetch call that takes a pointer and selector for the completion handler;
// a pointer and selector is a better style when the callback is a substantial, separate method.
//
// NOTE:  Fetches may retrieve data from the server even though the server
//        returned an error.  The completion handler is called when the server
//        status is >= 300 with an NSError having domain
//        kDCGTMSessionFetcherStatusDomain and code set to the server status.
//
//        Status codes are at <http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html>
//
//
// Background session support:
//
// Out-of-process uploads and downloads may be created by setting the useBackgroundSession property.
// Data to be uploaded should be provided with a file URL; the download destination should also
// specified with a file URL.
//
// When background sessions are used in iOS apps, the application delegate must pass
// through the parameters from UIApplicationDelegate's
// application:handleEventsForBackgroundURLSession:completionHandler: to the fetcher class.
//
// When the application has been relaunched, it may also create a new fetcher instance
// to handle completion of the transfers.
//
//  - (void)application:(UIApplication *)application
//      handleEventsForBackgroundURLSession:(NSString *)identifier
//                        completionHandler:(void (^)())completionHandler {
//    // Application was re-launched on completing an out-of-process download.
//
//    // Pass the URLSession info related to this re-launch to the fetcher class.
//    [DCGTMSessionFetcher application:application
//        handleEventsForBackgroundURLSession:identifier
//                          completionHandler:completionHandler];
//
//    // Get a fetcher related to this re-launch and re-hook up a completionHandler to it.
//    DCGTMSessionFetcher *fetcher = [DCGTMSessionFetcher fetcherWithSessionIdentifier:identifier];
//    NSURL *destinationFileURL = fetcher.destinationFileURL;
//    fetcher.completionHandler = ^(NSData *data, NSError *error) {
//      [self downloadCompletedToFile:destinationFileURL error:error];
//    };
//  }
//
//
// Threading and queue support:
//
// Callbacks are run on the main thread; alternatively, the app may set the
// fetcher's callbackQueue to a dispatch queue.
//
// Once the fetcher's beginFetch method has been called, the fetcher's methods and
// properties may be accessed from any thread.
//
// Downloading to disk:
//
// To have downloaded data saved directly to disk, specify a file URL for the
// destinationFileURL property.
//
// HTTP methods and headers:
//
// Alternative HTTP methods, like PUT, and custom headers can be specified by
// creating the fetcher with an appropriate NSMutableURLRequest
//
//
// Cookies:
//
// There are three supported mechanisms for remembering cookies between fetches.
//
// By default, a standalone DCGTMSessionFetcher uses a mutable array held statically to track
// cookies for all instantiated fetchers.  This avoids cookies being set by servers for the
// application from interfering with Safari and WebKit cookie settings, and vice versa.
// The fetcher cookies are lost when the application quits.
//
// To rely instead on WebKit's global NSHTTPCookieStorage, set the fetcher's
// cookieStorage property:
//   myFetcher.cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//
// To ignore cookies entirely, make a temporary cookie storage object:
//   myFetcher.cookieStorage = [[DCGTMSessionCookieStorage alloc] init];
//
// If the fetcher is created from a DCGTMHTTPFetcherService object
// then the cookie storage mechanism is set to use the cookie storage in the
// service object rather than the static storage.
//
//
// Monitoring data transfers.
//
// The fetcher supports a variety of properties for progress monitoring progress with callback
// blocks.
//  DCGTMSessionFetcherSendProgressBlock sendProgressBlock
//  DCGTMSessionFetcherReceivedProgressBlock receivedProgressBlock
//  DCGTMSessionFetcherDownloadProgressBlock downloadProgressBlock
//
// If supplied by the server, the anticipated total download size is available
// as [[myFetcher response] expectedContentLength] (and may be -1 for unknown
// download sizes.)
//
//
// Automatic retrying of fetches
//
// The fetcher can optionally create a timer and reattempt certain kinds of
// fetch failures (status codes 408, request timeout; 502, gateway failure;
// 503, service unavailable; 504, gateway timeout; networking errors
// NSURLErrorTimedOut and NSURLErrorNetworkConnectionLost.)  The user may
// set a retry selector to customize the type of errors which will be retried.
//
// Retries are done in an exponential-backoff fashion (that is, after 1 second,
// 2, 4, 8, and so on.)
//
// Enabling automatic retries looks like this:
//  myFetcher.retryEnabled = YES;
//
// With retries enabled, the completion callbacks are called only
// when no more retries will be attempted. Calling the fetcher's stopFetching
// method will terminate the retry timer, without the finished or failure
// selectors being invoked.
//
// Optionally, the client may set the maximum retry interval:
//  myFetcher.maxRetryInterval = 60.0; // in seconds; default is 60 seconds
//                                     // for downloads, 600 for uploads
//
// Also optionally, the client may provide a block to determine if a status code or other error
// should be retried. The block returns YES to set the retry timer or NO to fail without additional
// fetch attempts.
//
// The retry method may return the |suggestedWillRetry| argument to get the
// default retry behavior.  Server status codes are present in the
// error argument, and have the domain kDCGTMSessionFetcherStatusDomain. The
// user's method may look something like this:
//
//  myFetcher.retryBlock = ^(BOOL suggestedWillRetry, NSError *error,
//                           DCGTMSessionFetcherRetryResponse response) {
//    // Perhaps examine [error domain] and [error code], or [fetcher retryCount]
//    //
//    // Respond with YES to start the retry timer, NO to proceed to the failure
//    // callback, or suggestedWillRetry to get default behavior for the
//    // current error domain and code values.
//    response(suggestedWillRetry);
//  };


#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

// Logs in debug builds.
#ifndef DCGTMSESSION_LOG_DEBUG
  #if DEBUG
    #define DCGTMSESSION_LOG_DEBUG(...) NSLog(__VA_ARGS__)
  #else
    #define DCGTMSESSION_LOG_DEBUG(...) do { } while (0)
  #endif
#endif

// Asserts in debug builds (or logs in debug builds if DCGTMSESSION_ASSERT_AS_LOG is defined.)
#ifndef DCGTMSESSION_ASSERT_DEBUG
  #if DEBUG && !DCGTMSESSION_ASSERT_AS_LOG
    #define DCGTMSESSION_ASSERT_DEBUG(...) NSAssert(__VA_ARGS__)
  #elif DEBUG
    #define DCGTMSESSION_ASSERT_DEBUG(pred, ...) if (!(pred)) { NSLog(__VA_ARGS__); }
  #else
    #define DCGTMSESSION_ASSERT_DEBUG(pred, ...) do { } while (0)
  #endif
#endif

// Asserts in debug builds, logs in release builds (or logs in debug builds if
// DCGTMSESSION_ASSERT_AS_LOG is defined.)
#ifndef DCGTMSESSION_ASSERT_DEBUG_OR_LOG
  #if DEBUG && !DCGTMSESSION_ASSERT_AS_LOG
    #define DCGTMSESSION_ASSERT_DEBUG_OR_LOG(...) NSAssert(__VA_ARGS__)
  #else
    #define DCGTMSESSION_ASSERT_DEBUG_OR_LOG(pred, ...) if (!(pred)) { NSLog(__VA_ARGS__); }
  #endif
#endif

// Until Xcode can autocomplete typedef'd blocks with nullable
// annotations (broken in 6.3.x), we'll leave the annotations disabled.
// <http://openradar.appspot.com/20723086>
#define DCGTM_CAN_XCODE_AUTOCOMPLETE_WITH_NULLABLES 0

// Macro useful for examining messages from NSURLSession during debugging.
#if 0
#define DCGTM_LOG_SESSION_DELEGATE(...) DCGTMSESSION_LOG_DEBUG(__VA_ARGS__)
#else
#define DCGTM_LOG_SESSION_DELEGATE(...)
#endif

#ifndef DCGTM_NULLABLE
  #if DCGTM_CAN_XCODE_AUTOCOMPLETE_WITH_NULLABLES && \
      __has_feature(nullability)  // Available starting in Xcode 6.3
    #define DCGTM_NULLABLE_TYPE __nullable
    #define DCGTM_NONNULL_TYPE __nonnull
    #define DCGTM_NULLABLE nullable
    #define DCGTM_NONNULL_DECL nonnull  // DCGTM_NONNULL is used by DCGTMDefines.h

    #define DCGTM_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
    #define DCGTM_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
  #else
    #define DCGTM_NULLABLE_TYPE
    #define DCGTM_NONNULL_TYPE
    #define DCGTM_NULLABLE
    #define DCGTM_NONNULL_DECL
    #define DCGTM_ASSUME_NONNULL_BEGIN
    #define DCGTM_ASSUME_NONNULL_END
  #endif  // __has_feature(nullability)
#endif  // DCGTM_NULLABLE

#ifndef DCGTM_DECLARE_GENERICS
  #if __has_feature(objc_generics) \
    && ((!TARGET_OS_IPHONE && defined(MAC_OS_X_VERSION_10_11) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_11) \
      || (TARGET_OS_IPHONE && defined(__IPHONE_9_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0))
    #define DCGTM_DECLARE_GENERICS 1
  #else
    #define DCGTM_DECLARE_GENERICS 0
  #endif
#endif

#ifndef DCGTM_NSArrayOf
  #if DCGTM_DECLARE_GENERICS
    #define DCGTM_NSArrayOf(value) NSArray<value>
    #define DCGTM_NSDictionaryOf(key, value) NSDictionary<key, value>
  #else
    #define DCGTM_NSArrayOf(value) NSArray
    #define DCGTM_NSDictionaryOf(key, value) NSDictionary
  #endif // __has_feature(objc_generics)
#endif  // DCGTM_NSArrayOf

#ifdef __cplusplus
extern "C" {
#endif

#if (!TARGET_OS_IPHONE && defined(MAC_OS_X_VERSION_10_11) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_11) \
  || (TARGET_OS_IPHONE && defined(__IPHONE_9_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0)
  #ifndef DCGTM_USE_SESSION_FETCHER
    #define DCGTM_USE_SESSION_FETCHER 1
  #endif

  #define DCGTMSESSION_DEPRECATE_OLD_ENUMS 1
#endif

#if !defined(DCGTMBridgeFetcher)
  // These bridge macros should be identical in DCGTMHTTPFetcher.h and DCGTMSessionFetcher.h
  #if DCGTM_USE_SESSION_FETCHER
  // Macros to new fetcher class.
    #define DCGTMBridgeFetcher DCGTMSessionFetcher
    #define DCGTMBridgeFetcherService DCGTMSessionFetcherService
    #define DCGTMBridgeFetcherServiceProtocol DCGTMSessionFetcherServiceProtocol
    #define DCGTMBridgeAssertValidSelector DCGTMSessionFetcherAssertValidSelector
    #define DCGTMBridgeCookieStorage DCGTMSessionCookieStorage
    #define DCGTMBridgeCleanedUserAgentString DCGTMFetcherCleanedUserAgentString
    #define DCGTMBridgeSystemVersionString DCGTMFetcherSystemVersionString
    #define DCGTMBridgeApplicationIdentifier DCGTMFetcherApplicationIdentifier
    #define kDCGTMBridgeFetcherStatusDomain kDCGTMSessionFetcherStatusDomain
    #define kDCGTMBridgeFetcherStatusBadRequest DCGTMSessionFetcherStatusBadRequest
  #else
    // Macros to old fetcher class.
    #define DCGTMBridgeFetcher DCGTMHTTPFetcher
    #define DCGTMBridgeFetcherService DCGTMHTTPFetcherService
    #define DCGTMBridgeFetcherServiceProtocol DCGTMHTTPFetcherServiceProtocol
    #define DCGTMBridgeAssertValidSelector DCGTMAssertSelectorNilOrImplementedWithArgs
    #define DCGTMBridgeCookieStorage DCGTMCookieStorage
    #define DCGTMBridgeCleanedUserAgentString DCGTMCleanedUserAgentString
    #define DCGTMBridgeSystemVersionString DCGTMSystemVersionString
    #define DCGTMBridgeApplicationIdentifier DCGTMApplicationIdentifier
    #define kDCGTMBridgeFetcherStatusDomain kDCGTMHTTPFetcherStatusDomain
    #define kDCGTMBridgeFetcherStatusBadRequest kDCGTMHTTPFetcherStatusBadRequest
  #endif  // DCGTM_USE_SESSION_FETCHER
#endif

DCGTM_ASSUME_NONNULL_BEGIN

// Notifications
//
// Fetch started and stopped, and fetch retry delay started and stopped.
extern NSString *const kDCGTMSessionFetcherStartedNotification;
extern NSString *const kDCGTMSessionFetcherStoppedNotification;
extern NSString *const kDCGTMSessionFetcherRetryDelayStartedNotification;
extern NSString *const kDCGTMSessionFetcherRetryDelayStoppedNotification;

// Completion handler notification. This is intended for use by code capturing
// and replaying fetch requests and results for testing. For fetches where
// destinationFileURL or accumulateDataBlock is set for the fetcher, the data
// will be nil for successful fetches.
//
// This notification is posted on the main thread.
extern NSString *const kDCGTMSessionFetcherCompletionInvokedNotification;
extern NSString *const kDCGTMSessionFetcherCompletionDataKey;
extern NSString *const kDCGTMSessionFetcherCompletionErrorKey;

// Constants for NSErrors created by the fetcher.
extern NSString *const kDCGTMSessionFetcherErrorDomain;

// The fetcher turns server error status values (3XX, 4XX, 5XX) into NSErrors
// with domain kDCGTMSessionFetcherStatusDomain.
extern NSString *const kDCGTMSessionFetcherStatusDomain;
extern NSString *const kDCGTMSessionFetcherStatusDataKey;  // data returned with a kDCGTMSessionFetcherStatusDomain error

// Background session support requires access to NSUserDefaults.
// If [NSUserDefaults standardUserDefaults] doesn't yield the correct NSUserDefaults for your usage,
// ie for an App Extension, then implement this class/method to return the correct NSUserDefaults.
// https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW6
@interface DCGTMSessionFetcherUserDefaultsFactory : NSObject

+ (NSUserDefaults *)fetcherUserDefaults;

@end

#ifdef __cplusplus
}
#endif

typedef NS_ENUM(NSInteger, DCGTMSessionFetcherError) {
  DCGTMSessionFetcherErrorDownloadFailed = -1,
  DCGTMSessionFetcherErrorUploadChunkUnavailable = -2,
  DCGTMSessionFetcherErrorBackgroundExpiration = -3,
  DCGTMSessionFetcherErrorBackgroundFetchFailed = -4,
  DCGTMSessionFetcherErrorInsecureRequest = -5,
  DCGTMSessionFetcherErrorTaskCreationFailed = -6,
};

typedef NS_ENUM(NSInteger, DCGTMSessionFetcherStatus) {
  // Standard http status codes.
  DCGTMSessionFetcherStatusNotModified = 304,
  DCGTMSessionFetcherStatusBadRequest = 400,
  DCGTMSessionFetcherStatusUnauthorized = 401,
  DCGTMSessionFetcherStatusForbidden = 403,
  DCGTMSessionFetcherStatusPreconditionFailed = 412
};

#if !DCGTMSESSION_DEPRECATE_OLD_ENUMS
#define kDCGTMSessionFetcherErrorDownloadFailed         DCGTMSessionFetcherErrorDownloadFailed
#define kDCGTMSessionFetcherErrorUploadChunkUnavailable DCGTMSessionFetcherErrorUploadChunkUnavailable
#define kDCGTMSessionFetcherErrorBackgroundExpiration   DCGTMSessionFetcherErrorBackgroundExpiration
#define kDCGTMSessionFetcherErrorBackgroundFetchFailed  DCGTMSessionFetcherErrorBackgroundFetchFailed
#define kDCGTMSessionFetcherErrorInsecureRequest        DCGTMSessionFetcherErrorInsecureRequest
#define kDCGTMSessionFetcherErrorTaskCreationFailed     DCGTMSessionFetcherErrorTaskCreationFailed

#define kDCGTMSessionFetcherStatusNotModified        DCGTMSessionFetcherStatusNotModified
#define kDCGTMSessionFetcherStatusBadRequest         DCGTMSessionFetcherStatusBadRequest
#define kDCGTMSessionFetcherStatusUnauthorized       DCGTMSessionFetcherStatusUnauthorized
#define kDCGTMSessionFetcherStatusForbidden          DCGTMSessionFetcherStatusForbidden
#define kDCGTMSessionFetcherStatusPreconditionFailed DCGTMSessionFetcherStatusPreconditionFailed
#endif  // !DCGTMSESSION_DEPRECATE_OLD_ENUMS

#ifdef __cplusplus
extern "C" {
#endif

@class DCGTMSessionCookieStorage;
@class DCGTMSessionFetcher;

typedef void (^DCGTMSessionFetcherConfigurationBlock)(DCGTMSessionFetcher *fetcher,
                                                    NSURLSessionConfiguration *configuration);
typedef void (^DCGTMSessionFetcherSystemCompletionHandler)(void);
typedef void (^DCGTMSessionFetcherCompletionHandler)(NSData * DCGTM_NULLABLE_TYPE data,
                                                   NSError * DCGTM_NULLABLE_TYPE error);
typedef void (^DCGTMSessionFetcherBodyStreamProviderResponse)(NSInputStream *bodyStream);
typedef void (^DCGTMSessionFetcherBodyStreamProvider)(DCGTMSessionFetcherBodyStreamProviderResponse response);
typedef void (^DCGTMSessionFetcherDidReceiveResponseDispositionBlock)(NSURLSessionResponseDisposition disposition);
typedef void (^DCGTMSessionFetcherDidReceiveResponseBlock)(NSURLResponse *response,
                                                         DCGTMSessionFetcherDidReceiveResponseDispositionBlock dispositionBlock);
typedef void (^DCGTMSessionFetcherWillRedirectResponse)(NSURLRequest *redirectedRequest);
typedef void (^DCGTMSessionFetcherWillRedirectBlock)(NSHTTPURLResponse *redirectResponse,
                                                   NSURLRequest *redirectRequest,
                                                   DCGTMSessionFetcherWillRedirectResponse response);
typedef void (^DCGTMSessionFetcherAccumulateDataBlock)(NSData * DCGTM_NULLABLE_TYPE buffer);
typedef void (^DCGTMSessionFetcherReceivedProgressBlock)(int64_t bytesWritten,
                                                       int64_t totalBytesWritten);
typedef void (^DCGTMSessionFetcherDownloadProgressBlock)(int64_t bytesWritten,
                                                       int64_t totalBytesWritten,
                                                       int64_t totalBytesExpectedToWrite);
typedef void (^DCGTMSessionFetcherSendProgressBlock)(int64_t bytesSent,
                                                   int64_t totalBytesSent,
                                                   int64_t totalBytesExpectedToSend);
typedef void (^DCGTMSessionFetcherWillCacheURLResponseResponse)(NSCachedURLResponse *cachedResponse);
typedef void (^DCGTMSessionFetcherWillCacheURLResponseBlock)(NSCachedURLResponse *proposedResponse,
                                                           DCGTMSessionFetcherWillCacheURLResponseResponse responseBlock);
typedef void (^DCGTMSessionFetcherRetryResponse)(BOOL shouldRetry);
typedef void (^DCGTMSessionFetcherRetryBlock)(BOOL suggestedWillRetry,
                                            NSError * DCGTM_NULLABLE_TYPE error,
                                            DCGTMSessionFetcherRetryResponse response);

typedef void (^DCGTMSessionFetcherTestResponse)(NSHTTPURLResponse * DCGTM_NULLABLE_TYPE response,
                                              NSData * DCGTM_NULLABLE_TYPE data,
                                              NSError * DCGTM_NULLABLE_TYPE error);
typedef void (^DCGTMSessionFetcherTestBlock)(DCGTMSessionFetcher *fetcherToTest,
                                           DCGTMSessionFetcherTestResponse testResponse);

void DCGTMSessionFetcherAssertValidSelector(id obj, SEL sel, ...);

// Utility functions for applications self-identifying to servers via a
// user-agent header

// The "standard" user agent includes the application identifier, taken from the bundle,
// followed by a space and the system version string. Pass nil to use +mainBundle as the source
// of the bundle identifier.
//
// Applications may use this as a starting point for their own user agent strings, perhaps
// with additional sections appended.  Use DCGTMFetcherCleanedUserAgentString() below to
// clean up any string being added to the user agent.
NSString *DCGTMFetcherStandardUserAgentString(NSBundle * DCGTM_NULLABLE_TYPE bundle);

// Make a generic name and version for the current application, like
// com.example.MyApp/1.2.3 relying on the bundle identifier and the
// CFBundleShortVersionString or CFBundleVersion.
//
// The bundle ID may be overridden as the base identifier string by
// adding to the bundle's Info.plist a "DCGTMUserAgentID" key.
//
// If no bundle ID or override is available, the process name preceded
// by "proc_" is used.
NSString *DCGTMFetcherApplicationIdentifier(NSBundle * DCGTM_NULLABLE_TYPE bundle);

// Make an identifier like "MacOSX/10.7.1" or "iPod_Touch/4.1 hw/iPod1_1"
NSString *DCGTMFetcherSystemVersionString(void);

// Make a parseable user-agent identifier from the given string, replacing whitespace
// and commas with underscores, and removing other characters that may interfere
// with parsing of the full user-agent string.
//
// For example, @"[My App]" would become @"My_App"
NSString *DCGTMFetcherCleanedUserAgentString(NSString *str);

// Grab the data from an input stream. Since streams cannot be assumed to be rewindable,
// this may be destructive; the caller can try to rewind the stream (by setting the
// NSStreamFileCurrentOffsetKey property) or can just use the NSData to make a new
// NSInputStream. This function is intended to facilitate testing rather than be used in
// production.
//
// This function operates synchronously on the current thread. Depending on how the
// input stream is implemented, it may be appropriate to dispatch to a different
// queue before calling this function.
//
// Failure is indicated by a returned data value of nil.
NSData *DCGTMDataFromInputStream(NSInputStream *inputStream, NSError **outError);

#ifdef __cplusplus
}  // extern "C"
#endif


#if !DCGTM_USE_SESSION_FETCHER
@protocol DCGTMHTTPFetcherServiceProtocol;
#endif

// This protocol allows abstract references to the fetcher service, primarily for
// fetchers (which may be compiled without the fetcher service class present.)
//
// Apps should not need to use this protocol.
@protocol DCGTMSessionFetcherServiceProtocol <NSObject>
// This protocol allows us to call into the service without requiring
// DCGTMSessionFetcherService sources in this project

@property(strong) dispatch_queue_t callbackQueue;

- (BOOL)fetcherShouldBeginFetching:(DCGTMSessionFetcher *)fetcher;
- (void)fetcherDidCreateSession:(DCGTMSessionFetcher *)fetcher;
- (void)fetcherDidBeginFetching:(DCGTMSessionFetcher *)fetcher;
- (void)fetcherDidStop:(DCGTMSessionFetcher *)fetcher;

- (DCGTMSessionFetcher *)fetcherWithRequest:(NSURLRequest *)request;
- (BOOL)isDelayingFetcher:(DCGTMSessionFetcher *)fetcher;

@property(atomic, assign) BOOL reuseSession;
- (DCGTM_NULLABLE NSURLSession *)session;
- (DCGTM_NULLABLE NSURLSession *)sessionForFetcherCreation;
- (DCGTM_NULLABLE id<NSURLSessionDelegate>)sessionDelegate;
- (DCGTM_NULLABLE NSDate *)stoppedAllFetchersDate;

// Methods for compatibility with the old DCGTMHTTPFetcher.
@property(readonly, strong, DCGTM_NULLABLE) NSOperationQueue *delegateQueue;

@end  // @protocol DCGTMSessionFetcherServiceProtocol

#ifndef DCGTM_FETCHER_AUTHORIZATION_PROTOCOL
#define DCGTM_FETCHER_AUTHORIZATION_PROTOCOL 1
@protocol DCGTMFetcherAuthorizationProtocol <NSObject>
@required
// This protocol allows us to call the authorizer without requiring its sources
// in this project.
- (void)authorizeRequest:(NSMutableURLRequest *)request
                delegate:(id)delegate
       didFinishSelector:(SEL)sel;

- (void)stopAuthorization;

- (void)stopAuthorizationForRequest:(NSURLRequest *)request;

- (BOOL)isAuthorizingRequest:(NSURLRequest *)request;

- (BOOL)isAuthorizedRequest:(NSURLRequest *)request;

@property(strong, readonly) NSString *userEmail;

@optional

// Indicate if authorization may be attempted. Even if this succeeds,
// authorization may fail if the user's permissions have been revoked.
@property(readonly) BOOL canAuthorize;

// For development only, allow authorization of non-SSL requests, allowing
// transmission of the bearer token unencrypted.
@property(assign) BOOL shouldAuthorizeAllRequests;

- (void)authorizeRequest:(DCGTM_NULLABLE NSMutableURLRequest *)request
       completionHandler:(void (^)(NSError * DCGTM_NULLABLE_TYPE error))handler;

#if DCGTM_USE_SESSION_FETCHER
@property (weak, DCGTM_NULLABLE) id<DCGTMSessionFetcherServiceProtocol> fetcherService;
#else
@property (weak, DCGTM_NULLABLE) id<DCGTMHTTPFetcherServiceProtocol> fetcherService;
#endif

- (BOOL)primeForRefresh;

@end
#endif  // DCGTM_FETCHER_AUTHORIZATION_PROTOCOL

#pragma mark -

// DCGTMSessionFetcher objects are used for async retrieval of an http get or post
//
// See additional comments at the beginning of this file
@interface DCGTMSessionFetcher : NSObject <NSURLSessionDelegate>

// Create a fetcher
//
// fetcherWithRequest will return an autoreleased fetcher, but if
// the connection is successfully created, the connection should retain the
// fetcher for the life of the connection as well. So the caller doesn't have
// to retain the fetcher explicitly unless they want to be able to cancel it.
+ (instancetype)fetcherWithRequest:(DCGTM_NULLABLE NSURLRequest *)request;

// Convenience methods that make a request, like +fetcherWithRequest
+ (instancetype)fetcherWithURL:(NSURL *)requestURL;
+ (instancetype)fetcherWithURLString:(NSString *)requestURLString;

// Methods for creating fetchers to continue previous fetches.
+ (instancetype)fetcherWithDownloadResumeData:(NSData *)resumeData;
+ (instancetype)fetcherWithSessionIdentifier:(NSString *)sessionIdentifier;

// Returns an array of currently active fetchers for background sessions,
// both restarted and newly created ones.
+ (DCGTM_NSArrayOf(DCGTMSessionFetcher *) *)fetchersForBackgroundSessions;

// Designated initializer.
- (instancetype)initWithRequest:(DCGTM_NULLABLE NSURLRequest *)request
                  configuration:(DCGTM_NULLABLE NSURLSessionConfiguration *)configuration;

// The fetcher's request
//
// The underlying request is mutable and may be modified by the caller.  Request changes will not
// affect a fetch after it has begun.
@property(readonly, DCGTM_NULLABLE) NSMutableURLRequest *mutableRequest;

// Data used for resuming a download task.
@property(strong, DCGTM_NULLABLE) NSData *downloadResumeData;

// The configuration; this must be set before the fetch begins. If no configuration is
// set or inherited from the fetcher service, then the fetcher uses an ephemeral config.
@property(strong, DCGTM_NULLABLE) NSURLSessionConfiguration *configuration;

// A block the client may use to customize the configuration used to create the session.
//
// This is called synchronously, either on the thread that begins the fetch or, during a retry,
// on the main thread. The configuration block may be called repeatedly if multiple fetchers are
// created.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherConfigurationBlock configurationBlock;

// A session is created as needed by the fetcher.  A fetcher service object
// may maintain sessions for multiple fetches to the same host.
@property(strong, DCGTM_NULLABLE) NSURLSession *session;

// The task in flight.
@property(readonly, DCGTM_NULLABLE) NSURLSessionTask *sessionTask;

// The background session identifier.
@property(readonly, DCGTM_NULLABLE) NSString *sessionIdentifier;

// Indicates a fetcher created to finish a background session task.
@property(readonly) BOOL wasCreatedFromBackgroundSession;

// Additional user-supplied data to encode into the session identifier. Since session identifier
// length limits are unspecified, this should be kept small. Key names beginning with an underscore
// are reserved for use by the fetcher.
@property(strong, DCGTM_NULLABLE) DCGTM_NSDictionaryOf(NSString *, NSString *) *sessionUserInfo;

// The human-readable description to be assigned to the task.
@property(copy, DCGTM_NULLABLE) NSString *taskDescription;

// The priority assigned to the task, if any.  Use NSURLSessionTaskPriorityLow,
// NSURLSessionTaskPriorityDefault, or NSURLSessionTaskPriorityHigh.
@property(assign) float taskPriority;

// The fetcher encodes information used to resume a session in the session identifier.
// This method, intended for internal use returns the encoded information.  The sessionUserInfo
// dictionary is stored as identifier metadata.
- (DCGTM_NULLABLE DCGTM_NSDictionaryOf(NSString *, NSString *) *)sessionIdentifierMetadata;

#if TARGET_OS_IPHONE
// The app should pass to this method the completion handler passed in the app delegate method
// application:handleEventsForBackgroundURLSession:completionHandler:
+ (void)application:(UIApplication *)application
    handleEventsForBackgroundURLSession:(NSString *)identifier
                      completionHandler:(DCGTMSessionFetcherSystemCompletionHandler)completionHandler;
#endif

// Indicate that a newly created session should be a background session.
// A new session identifier will be created by the fetcher.
@property(assign) BOOL useBackgroundSession;

// Indicates if uploads should use an upload task.  This is always set for file or stream-provider
// bodies, but may be set explicitly for NSData bodies.
@property(assign) BOOL useUploadTask;

// Indicates that the fetcher is using a session that may be shared with other fetchers.
@property(readonly) BOOL canShareSession;

// By default, the fetcher allows only secure (https) schemes unless this
// property is set, or the DCGTM_ALLOW_INSECURE_REQUESTS build flag is set.
//
// For example, during debugging when fetching from a development server that lacks SSL support,
// this may be set to @[ @"http" ], or when the fetcher is used to retrieve local files,
// this may be set to @[ @"file" ].
//
// This should be left as nil for release builds to avoid creating the opportunity for
// leaking private user behavior and data.  If a server is providing insecure URLs
// for fetching by the client app, report the problem as server security & privacy bug.
//
// For builds with the iOS 9/OS X 10.11 and later SDKs, this property is required only when
// the app specifies NSAppTransportSecurity/NSAllowsArbitraryLoads in the main bundle's Info.plist.
@property(copy, DCGTM_NULLABLE) DCGTM_NSArrayOf(NSString *) *allowedInsecureSchemes;

// By default, the fetcher prohibits localhost requests unless this property is set,
// or the DCGTM_ALLOW_INSECURE_REQUESTS build flag is set.
//
// For localhost requests, the URL scheme is not checked  when this property is set.
//
// For builds with the iOS 9/OS X 10.11 and later SDKs, this property is required only when
// the app specifies NSAppTransportSecurity/NSAllowsArbitraryLoads in the main bundle's Info.plist.
@property(assign) BOOL allowLocalhostRequest;

// By default, the fetcher requires valid server certs.  This may be bypassed
// temporarily for development against a test server with an invalid cert.
@property(assign) BOOL allowInvalidServerCertificates;

// Cookie storage object for this fetcher. If nil, the fetcher will use a static cookie
// storage instance shared among fetchers.  If this fetcher was created by a fetcher service
// object, it will be set to use the service object's cookie storage.  To have no cookies
// sent or saved by this fetcher, set this property to use a temporary storage object:
//   fetcher.cookieStorage = [[DCGTMSessionCookieStorage alloc] init];
//
// Because as of Jan 2014 standalone instances of NSHTTPCookieStorage do not actually
// store any cookies (Radar 15735276) we use our own subclass, DCGTMSessionCookieStorage,
// to hold cookies in memory.
@property(strong, DCGTM_NULLABLE) NSHTTPCookieStorage *cookieStorage;

// Setting the credential is optional; it is used if the connection receives
// an authentication challenge.
@property(strong, DCGTM_NULLABLE) NSURLCredential *credential;

// Setting the proxy credential is optional; it is used if the connection
// receives an authentication challenge from a proxy.
@property(strong, DCGTM_NULLABLE) NSURLCredential *proxyCredential;

// If body data, body file URL, or body stream provider is not set, then a GET request
// method is assumed.
@property(strong, DCGTM_NULLABLE) NSData *bodyData;

// File to use as the request body. This forces use of an upload task.
@property(strong, DCGTM_NULLABLE) NSURL *bodyFileURL;

// Length of body to send, expected or actual.
@property(readonly) int64_t bodyLength;

// The body stream provider may be called repeatedly to provide a body.
// Setting a body stream provider forces use of an upload task.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherBodyStreamProvider bodyStreamProvider;

// Object to add authorization to the request, if needed.
@property(strong, DCGTM_NULLABLE) id<DCGTMFetcherAuthorizationProtocol> authorizer;

// The service object that created and monitors this fetcher, if any.
@property(strong) id<DCGTMSessionFetcherServiceProtocol> service;

// The host, if any, used to classify this fetcher in the fetcher service.
@property(copy, DCGTM_NULLABLE) NSString *serviceHost;

// The priority, if any, used for starting fetchers in the fetcher service.
//
// Lower values are higher priority; the default is 0, and values may
// be negative or positive. This priority affects only the start order of
// fetchers that are being delayed by a fetcher service when the running fetchers
// exceeds the service's maxRunningFetchersPerHost.  A priority of NSIntegerMin will
// exempt this fetcher from delay.
@property(assign) NSInteger servicePriority;

// The delegate's optional didReceiveResponse block may be used to inspect or alter
// the session response.
//
// This is called on the callback queue.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherDidReceiveResponseBlock didReceiveResponseBlock;

// The delegate's optional willRedirect block may be used to inspect or alter
// the redirection.
//
// This is called on the callback queue.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherWillRedirectBlock willRedirectBlock;

// The optional send progress block reports body bytes uploaded.
//
// This is called on the callback queue.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherSendProgressBlock sendProgressBlock;

// The optional accumulate block may be set by clients wishing to accumulate data
// themselves rather than let the fetcher append each buffer to an NSData.
//
// When this is called with nil data (such as on redirect) the client
// should empty its accumulation buffer.
//
// This is called on the callback queue.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherAccumulateDataBlock accumulateDataBlock;

// The optional received progress block may be used to monitor data
// received from a data task.
//
// This is called on the callback queue.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherReceivedProgressBlock receivedProgressBlock;

// The delegate's optional downloadProgress block may be used to monitor download
// progress in writing to disk.
//
// This is called on the callback queue.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherDownloadProgressBlock downloadProgressBlock;

// The delegate's optional willCacheURLResponse block may be used to alter the cached
// NSURLResponse. The user may prevent caching by passing nil to the block's response.
//
// This is called on the callback queue.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherWillCacheURLResponseBlock willCacheURLResponseBlock;

// Enable retrying; see comments at the top of this file.  Setting
// retryEnabled=YES resets the min and max retry intervals.
@property(assign, getter=isRetryEnabled) BOOL retryEnabled;

// Retry block is optional for retries.
//
// If present, this block should call the response block with YES to cause a retry or NO to end the
// fetch.
// See comments at the top of this file.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherRetryBlock retryBlock;

// Retry intervals must be strictly less than maxRetryInterval, else
// they will be limited to maxRetryInterval and no further retries will
// be attempted.  Setting maxRetryInterval to 0.0 will reset it to the
// default value, 60 seconds for downloads and 600 seconds for uploads.
@property(assign) NSTimeInterval maxRetryInterval;

// Starting retry interval.  Setting minRetryInterval to 0.0 will reset it
// to a random value between 1.0 and 2.0 seconds.  Clients should normally not
// set this except for unit testing.
@property(assign) NSTimeInterval minRetryInterval;

// Multiplier used to increase the interval between retries, typically 2.0.
// Clients should not need to set this.
@property(assign) double retryFactor;

// Number of retries attempted.
@property(readonly) NSUInteger retryCount;

// Interval delay to precede next retry.
@property(readonly) NSTimeInterval nextRetryInterval;

// Begin fetching the request
//
// The delegate may optionally implement the callback or pass nil for the selector or handler.
//
// The delegate and all callback blocks are retained between the beginFetch call until after the
// finish callback, or until the fetch is stopped.
//
// An error is passed to the callback for server statuses 300 or
// higher, with the status stored as the error object's code.
//
// finishedSEL has a signature like:
//   - (void)fetcher:(DCGTMSessionFetcher *)fetcher
//  finishedWithData:(NSData *)data
//             error:(NSError *)error;
//
// If the application has specified a destinationFileURL or an accumulateDataBlock
// for the fetcher, the data parameter passed to the callback will be nil.

- (void)beginFetchWithDelegate:(id)delegate
             didFinishSelector:(SEL)finishedSEL;

- (void)beginFetchWithCompletionHandler:(DCGTM_NULLABLE DCGTMSessionFetcherCompletionHandler)handler;

// Returns YES if this fetcher is in the process of fetching a URL.
@property(readonly, getter=isFetching) BOOL fetching;

// Cancel the fetch of the request that's currently in progress.  The completion handler
// will not be called.
- (void)stopFetching;

// A block to be called when the fetch completes.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherCompletionHandler completionHandler;

// A block to be called if download resume data becomes available.
@property(strong, DCGTM_NULLABLE) void (^resumeDataBlock)(NSData *);

// Return the status code from the server response.
@property(readonly) NSInteger statusCode;

// Return the http headers from the response.
@property(strong, readonly, DCGTM_NULLABLE) DCGTM_NSDictionaryOf(NSString *, NSString *) *responseHeaders;

// The response, once it's been received.
@property(strong, readonly, DCGTM_NULLABLE) NSURLResponse *response;

// Bytes downloaded so far.
@property(readonly) int64_t downloadedLength;

// Buffer of currently-downloaded data, if available.
@property(readonly, strong, DCGTM_NULLABLE) NSData *downloadedData;

// Local path to which the downloaded file will be moved.
//
// If a file already exists at the path, it will be overwritten.
@property(strong, DCGTM_NULLABLE) NSURL *destinationFileURL;

// userData is retained solely for the convenience of the client.
@property(strong, DCGTM_NULLABLE) id userData;

// Stored property values are retained solely for the convenience of the client.
@property(copy, DCGTM_NULLABLE) DCGTM_NSDictionaryOf(NSString *, id) *properties;

- (void)setProperty:(DCGTM_NULLABLE id)obj forKey:(NSString *)key;  // Pass nil for obj to remove the property.
- (id)propertyForKey:(NSString *)key;

- (void)addPropertiesFromDictionary:(DCGTM_NSDictionaryOf(NSString *, id) *)dict;

// Comments are useful for logging, so are strongly recommended for each fetcher.
@property(copy, DCGTM_NULLABLE) NSString *comment;

- (void)setCommentWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

// Log of request and response, if logging is enabled
@property(copy, DCGTM_NULLABLE) NSString *log;

// Callbacks are run on this queue.  If none is supplied, the main queue is used.
@property(strong, DCGTM_NONNULL_DECL) dispatch_queue_t callbackQueue;

// Spin the run loop or sleep the thread, discarding events, until the fetch has completed.
//
// This is only for use in testing or in tools without a user interface.
//
// Note:  Synchronous fetches should never be used by shipping apps; they are
// sufficient reason for rejection from the app store.
//
// Returns NO if timed out.
- (BOOL)waitForCompletionWithTimeout:(NSTimeInterval)timeoutInSeconds;

// Test block is optional for testing.
//
// If present, this block will cause the fetcher to skip starting the session, and instead
// use the test block response values when calling the completion handler and delegate code.
//
// Test code can set this on the fetcher or on the fetcher service.  For testing libraries
// that use a fetcher without exposing either the fetcher or the fetcher service, the global
// method setGlobalTestBlock: will set the block for all fetchers that do not have a test
// block set.
//
// The test code can pass nil for all response parameters to indicate that the fetch
// should proceed.
//
// Applications can exclude test block support by setting DCGTM_DISABLE_FETCHER_TEST_BLOCK.
@property(copy, DCGTM_NULLABLE) DCGTMSessionFetcherTestBlock testBlock;

+ (void)setGlobalTestBlock:(DCGTM_NULLABLE DCGTMSessionFetcherTestBlock)block;

// Exposed for testing.
+ (DCGTMSessionCookieStorage *)staticCookieStorage;
+ (BOOL)appAllowsInsecureRequests;

#if STRIP_DCGTM_FETCH_LOGGING
// If logging is stripped, provide a stub for the main method
// for controlling logging.
+ (void)setLoggingEnabled:(BOOL)flag;
+ (BOOL)isLoggingEnabled;

#else

// These methods let an application log specific body text, such as the text description of a binary
// request or response. The application should set the fetcher to defer response body logging until
// the response has been received and the log response body has been set by the app. For example:
//
//   fetcher.logRequestBody = [binaryObject stringDescription];
//   fetcher.deferResponseBodyLogging = YES;
//   [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
//      if (error == nil) {
//        fetcher.logResponseBody = [[[MyThing alloc] initWithData:data] stringDescription];
//      }
//      fetcher.deferResponseBodyLogging = NO;
//   }];

@property(copy, DCGTM_NULLABLE) NSString *logRequestBody;
@property(assign) BOOL deferResponseBodyLogging;
@property(copy, DCGTM_NULLABLE) NSString *logResponseBody;

// Internal logging support.
@property(readonly) NSData *loggedStreamData;
@property(assign) BOOL hasLoggedError;
@property(strong, DCGTM_NULLABLE) NSURL *redirectedFromURL;
- (void)appendLoggedStreamData:(NSData *)dataToAdd;
- (void)clearLoggedStreamData;

#endif // STRIP_DCGTM_FETCH_LOGGING

@end

@interface DCGTMSessionFetcher (BackwardsCompatibilityOnly)
// Clients using DCGTMSessionFetcher should set the cookie storage explicitly themselves.
// This method is just for compatibility with the old DCGTMHTTPFetcher class.
- (void)setCookieStorageMethod:(NSInteger)method;
@end

// Until we can just instantiate NSHTTPCookieStorage for local use, we'll
// implement all the public methods ourselves.  This stores cookies only in
// memory.  Additional methods are provided for testing.
@interface DCGTMSessionCookieStorage : NSHTTPCookieStorage

// Add the array off cookies to the storage, replacing duplicates.
// Also removes expired cookies from the storage.
- (void)setCookies:(DCGTM_NULLABLE DCGTM_NSArrayOf(NSHTTPCookie *) *)cookies;

- (void)removeAllCookies;

@end

DCGTM_ASSUME_NONNULL_END
