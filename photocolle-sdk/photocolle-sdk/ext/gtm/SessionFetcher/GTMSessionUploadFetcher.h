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

// DCGTMSessionUploadFetcher implements Google's resumable upload protocol.

//
// This subclass of DCGTMSessionFetcher simulates the series of fetches
// needed for chunked upload as a single fetch operation.
//
// Protocol document:  TBD
//
// To the client, the only fetcher that exists is this class; the subsidiary
// fetchers needed for uploading chunks are not visible (though the most recent
// chunk fetcher may be accessed via the -activeFetcher or -chunkFetcher methods, and
// -responseHeaders and -statusCode reflect results from the most recent chunk
// fetcher.)
//
// Chunk fetchers are discarded as soon as they have completed.
//

// Note: Unlike the fetcher superclass, the methods of DCGTMSessionUploadFetcher should
// only be used from the main thread until further work is done to make this subclass
// thread-safe.

#import "GTMSessionFetcher.h"
#import "GTMSessionFetcherService.h"

DCGTM_ASSUME_NONNULL_BEGIN

// Unless an application knows it needs a smaller chunk size, it should use the standard
// chunk size, which sends the entire file as a single chunk to minimize upload overhead.
extern int64_t const kDCGTMSessionUploadFetcherStandardChunkSize;

// When uploading requires data buffer allocations (such as uploading from an NSData or
// an NSFileHandle) this is the maximum buffer size that will be created by the fetcher.
extern int64_t const kDCGTMSessionUploadFetcherMaximumDemandBufferSize;

// Notification that the upload location URL was provided by the server.
extern NSString *const kDCGTMSessionFetcherUploadLocationObtainedNotification;

// Block to provide data during uploads.
//
// Response data may be allocated with dataWithBytesNoCopy:length:freeWhenDone: for efficiency,
// and released after the response block returns.
//
// Pass nil as the data (and optionally an NSError) for a failure.
typedef void (^DCGTMSessionUploadFetcherDataProviderResponse)(NSData * DCGTM_NULLABLE_TYPE data,
                                                            NSError * DCGTM_NULLABLE_TYPE error);
typedef void (^DCGTMSessionUploadFetcherDataProvider)(int64_t offset, int64_t length,
    DCGTMSessionUploadFetcherDataProviderResponse response);

@interface DCGTMSessionUploadFetcher : DCGTMSessionFetcher

// Create an upload fetcher specifying either the request or the resume location URL,
// then set an upload data source using one of these:
//
//   setUploadFileURL:
//   setUploadDataLength:provider:
//   setUploadFileHandle:
//   setUploadData:

+ (instancetype)uploadFetcherWithRequest:(NSURLRequest *)request
                          uploadMIMEType:(NSString *)uploadMIMEType
                               chunkSize:(int64_t)chunkSize
                          fetcherService:(DCGTM_NULLABLE DCGTMSessionFetcherService *)fetcherServiceOrNil;

+ (instancetype)uploadFetcherWithLocation:(NSURL *)uploadLocationURL
                           uploadMIMEType:(NSString *)uploadMIMEType
                                chunkSize:(int64_t)chunkSize
                           fetcherService:(DCGTM_NULLABLE DCGTMSessionFetcherService *)fetcherServiceOrNil;

- (void)setUploadDataLength:(int64_t)fullLength
                   provider:(DCGTM_NULLABLE DCGTMSessionUploadFetcherDataProvider)block;

+ (NSArray *)uploadFetchersForBackgroundSessions;
+ (instancetype)uploadFetcherForSessionIdentifier:(NSString *)sessionIdentifier;

- (void)pauseFetching;
- (void)resumeFetching;
- (BOOL)isPaused;

@property(strong, DCGTM_NULLABLE) NSURL *uploadLocationURL;
@property(strong, DCGTM_NULLABLE) NSData *uploadData;
@property(strong, DCGTM_NULLABLE) NSURL *uploadFileURL;
@property(strong, DCGTM_NULLABLE) NSFileHandle *uploadFileHandle;
@property(copy, readonly, DCGTM_NULLABLE) DCGTMSessionUploadFetcherDataProvider uploadDataProvider;
@property(copy) NSString *uploadMIMEType;
@property(assign) int64_t chunkSize;
@property(assign) int64_t currentOffset;

// The fetcher for the current data chunk, if any
@property(strong, DCGTM_NULLABLE) DCGTMSessionFetcher *chunkFetcher;

// The active fetcher is the current chunk fetcher, or the upload fetcher itself
// if no chunk fetcher has yet been created.
@property(readonly) DCGTMSessionFetcher *activeFetcher;

// The last request made by an active fetcher.  Useful for testing.
@property(readonly, DCGTM_NULLABLE) NSURLRequest *lastChunkRequest;

// The response headers from the most recently-completed fetch.
@property(strong, DCGTM_NULLABLE) NSDictionary *responseHeaders;

// The status code from the most recently-completed fetch.
@property(assign) NSInteger statusCode;

// Exposed for testing only.
@property(readonly, DCGTM_NULLABLE) dispatch_queue_t delegateCallbackQueue;
@property(readonly, DCGTM_NULLABLE) DCGTMSessionFetcherCompletionHandler delegateCompletionHandler;

@end

@interface DCGTMSessionFetcher (DCGTMSessionUploadFetcherMethods)

@property(readonly, DCGTM_NULLABLE) DCGTMSessionUploadFetcher *parentUploadFetcher;

@end

DCGTM_ASSUME_NONNULL_END
