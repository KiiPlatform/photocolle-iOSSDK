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
 * Prefixes are changed from GTM to DCGTM.
 *
 * Targets of changing prefix are all classes, protocols, extensions,
 * categoriesconst values, comments and etc.
 */

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GTMSessionUploadFetcher.h"

static NSString *const kDCGTMSessionIdentifierIsUploadChunkFetcherMetadataKey = @"_upChunk";
static NSString *const kDCGTMSessionIdentifierUploadFileURLMetadataKey        = @"_upFileURL";
static NSString *const kDCGTMSessionIdentifierUploadFileLengthMetadataKey     = @"_upFileLen";
static NSString *const kDCGTMSessionIdentifierUploadLocationURLMetadataKey    = @"_upLocURL";
static NSString *const kDCGTMSessionIdentifierUploadMIMETypeMetadataKey       = @"_uploadMIME";
static NSString *const kDCGTMSessionIdentifierUploadChunkSizeMetadataKey      = @"_upChSize";
static NSString *const kDCGTMSessionIdentifierUploadCurrentOffsetMetadataKey  = @"_upOffset";

static NSString *const kDCGTMSessionHeaderXGoogUploadChunkGranularity = @"X-Goog-Upload-Chunk-Granularity";
static NSString *const kDCGTMSessionHeaderXGoogUploadCommand          = @"X-Goog-Upload-Command";
static NSString *const kDCGTMSessionHeaderXGoogUploadContentLength    = @"X-Goog-Upload-Content-Length";
static NSString *const kDCGTMSessionHeaderXGoogUploadContentType      = @"X-Goog-Upload-Content-Type";
static NSString *const kDCGTMSessionHeaderXGoogUploadOffset           = @"X-Goog-Upload-Offset";
static NSString *const kDCGTMSessionHeaderXGoogUploadProtocol         = @"X-Goog-Upload-Protocol";
static NSString *const kDCGTMSessionHeaderXGoogUploadSizeReceived     = @"X-Goog-Upload-Size-Received";
static NSString *const kDCGTMSessionHeaderXGoogUploadStatus           = @"X-Goog-Upload-Status";
static NSString *const kDCGTMSessionHeaderXGoogUploadURL              = @"X-Goog-Upload-URL";

// Property of chunk fetchers identifying the parent upload fetcher.  Non-retained NSValue.
static NSString *const kDCGTMSessionUploadFetcherChunkParentKey = @"_uploadFetcherChunkParent";

int64_t const kDCGTMSessionUploadFetcherStandardChunkSize = (int64_t)LLONG_MAX;

#if TARGET_OS_IPHONE
int64_t const kDCGTMSessionUploadFetcherMaximumDemandBufferSize = 10 * 1024 * 1024;  // 10 MB for iOS
#else
int64_t const kDCGTMSessionUploadFetcherMaximumDemandBufferSize = 100 * 1024 * 1024;  // 100 MB for OS X
#endif

typedef NS_ENUM(NSUInteger, DCGTMSessionUploadFetcherStatus) {
  kStatusUnknown,
  kStatusActive,
  kStatusFinal,
  kStatusCancelled,
};

NSString *const kDCGTMSessionFetcherUploadLocationObtainedNotification =
    @"kDCGTMSessionFetcherUploadLocationObtainedNotification";

@interface DCGTMSessionFetcher (ProtectedMethods)

- (void)stopFetchReleasingCallbacks:(BOOL)shouldReleaseCallbacks;
- (void)createSessionIdentifierWithMetadata:(NSDictionary *)metadata;
- (DCGTMSessionFetcherCompletionHandler)completionHandlerWithTarget:(id)target
                                                didFinishSelector:(SEL)finishedSelector;
- (void)invokeOnCallbackQueue:(dispatch_queue_t)callbackQueue
             afterUserStopped:(BOOL)afterStopped
                        block:(void (^)(void))block;
- (NSTimer *)retryTimer;

@property(readwrite, strong) NSData *downloadedData;
- (void)releaseCallbacks;

@end

@interface DCGTMSessionUploadFetcher ()
@property(strong, readwrite) NSURLRequest *lastChunkRequest;
@end

@implementation DCGTMSessionUploadFetcher {
  DCGTMSessionFetcher *_chunkFetcher;

  // We'll call through to the delegate's completion handler.
  DCGTMSessionFetcherCompletionHandler _delegateCompletionHandler;
  dispatch_queue_t _delegateCallbackQueue;

  // The initial fetch's body length and bytes actually sent are
  // needed for calculating progress during subsequent chunk uploads
  int64_t _initialBodyLength;
  int64_t _initialBodySent;

  // The upload server address for the chunks of this upload session.
  NSURL *_uploadLocationURL;

  // _uploadData, _uploadDataProvider, or _uploadFileHandle may be set, but only one.
  NSData *_uploadData;
  NSFileHandle *_uploadFileHandle;
  DCGTMSessionUploadFetcherDataProvider _uploadDataProvider;
  int64_t _uploadFileLength;
  NSString *_uploadMIMEType;
  int64_t _chunkSize;
  int64_t _uploadGranularity;
  BOOL _isPaused;
  BOOL _isRestartedUpload;
  BOOL _shouldInitiateOffsetQuery;

  // Tied to useBackgroundSession property, since this property is applicable to chunk fetchers.
  BOOL _useBackgroundSessionOnChunkFetchers;

  // We keep the latest offset into the upload data just for progress reporting.
  int64_t _currentOffset;

  // We store the response headers and status code for the most recent chunk fetcher
  NSDictionary *_responseHeaders;
  NSInteger _statusCode;

  // For waiting, we need to know the fetcher in flight, if any, and if subdata generation
  // is in progress.
  DCGTMSessionFetcher *_fetcherInFlight;
  BOOL _isSubdataGenerating;
}

+ (void)load {
  [self uploadFetchersForBackgroundSessions];
}

+ (instancetype)uploadFetcherWithRequest:(NSURLRequest *)request
                          uploadMIMEType:(NSString *)uploadMIMEType
                               chunkSize:(int64_t)chunkSize
                          fetcherService:(DCGTMSessionFetcherService *)fetcherService {
  DCGTMSessionUploadFetcher *fetcher = [self uploadFetcherWithRequest:request
                                                     fetcherService:fetcherService];
  [fetcher setLocationURL:nil
           uploadMIMEType:uploadMIMEType
                chunkSize:chunkSize];
  return fetcher;
}

+ (instancetype)uploadFetcherWithLocation:(NSURL *)uploadLocationURL
                           uploadMIMEType:(NSString *)uploadMIMEType
                                chunkSize:(int64_t)chunkSize
                           fetcherService:(DCGTMSessionFetcherService *)fetcherService {
  DCGTMSessionUploadFetcher *fetcher = [self uploadFetcherWithRequest:nil
                                                     fetcherService:fetcherService];
  [fetcher setLocationURL:uploadLocationURL
           uploadMIMEType:uploadMIMEType
                chunkSize:chunkSize];
  return fetcher;
}

+ (instancetype)uploadFetcherForSessionIdentifierMetadata:(NSDictionary *)metadata {
  DCGTMSESSION_ASSERT_DEBUG(
      [metadata[kDCGTMSessionIdentifierIsUploadChunkFetcherMetadataKey] boolValue],
      @"Session identifier metadata is not for an upload fetcher: %@", metadata);

  NSNumber *uploadFileLengthNum = metadata[kDCGTMSessionIdentifierUploadFileLengthMetadataKey];
  DCGTMSESSION_ASSERT_DEBUG(uploadFileLengthNum != nil,
                          @"Session metadata missing an UploadFileSize");
  if (uploadFileLengthNum == nil) return nil;

  int64_t uploadFileLength = [uploadFileLengthNum longLongValue];
  DCGTMSESSION_ASSERT_DEBUG(uploadFileLength >= 0, @"Session metadata UploadFileSize is unknown");

  NSString *uploadFileURLString = metadata[kDCGTMSessionIdentifierUploadFileURLMetadataKey];
  DCGTMSESSION_ASSERT_DEBUG(uploadFileURLString, @"Session metadata missing an UploadFileURL");
  if (uploadFileURLString == nil) return nil;

  NSURL *uploadFileURL = [NSURL URLWithString:uploadFileURLString];
  // There used to be a call here to NSURL checkResourceIsReachableAndReturnError: to check for the
  // existence of the file (also tried NSFileManager fileExistsAtPath:). We've determined
  // empirically that the check can fail at startup even when the upload file does in fact exist.
  // For now, we'll go ahead and restore the background upload fetcher. If the file doesn't exist,
  // it will fail later.

  NSString *uploadLocationURLString = metadata[kDCGTMSessionIdentifierUploadLocationURLMetadataKey];
  NSURL *uploadLocationURL =
      uploadLocationURLString ? [NSURL URLWithString:uploadLocationURLString] : nil;

  NSString *uploadMIMEType =
      metadata[kDCGTMSessionIdentifierUploadMIMETypeMetadataKey];
  int64_t uploadChunkSize =
      [metadata[kDCGTMSessionIdentifierUploadChunkSizeMetadataKey] longLongValue];
  if (uploadChunkSize <= 0) {
    uploadChunkSize = kDCGTMSessionUploadFetcherStandardChunkSize;
  }
  int64_t currentOffset =
      [metadata[kDCGTMSessionIdentifierUploadCurrentOffsetMetadataKey] longLongValue];
  DCGTMSESSION_ASSERT_DEBUG(currentOffset <= uploadFileLength,
                          @"CurrentOffset (%lld) exceeds UploadFileSize (%lld)",
                          currentOffset, uploadFileLength);
  if (currentOffset > uploadFileLength) return nil;

  DCGTMSessionUploadFetcher *uploadFetcher = [self uploadFetcherWithLocation:uploadLocationURL
                                                            uploadMIMEType:uploadMIMEType
                                                                 chunkSize:uploadChunkSize
                                                            fetcherService:nil];
  // Set the upload file length before setting the upload file URL tries to determine the length.
  [uploadFetcher setUploadFileLength:uploadFileLength];

  uploadFetcher.uploadFileURL = uploadFileURL;
  uploadFetcher.sessionUserInfo = metadata;
  uploadFetcher.useBackgroundSession = YES;
  uploadFetcher.currentOffset = currentOffset;
  uploadFetcher.allowedInsecureSchemes = @[ @"http" ];  // Allowed on restored upload fetcher.
  return uploadFetcher;
}

+ (instancetype)uploadFetcherWithRequest:(NSURLRequest *)request
                          fetcherService:(DCGTMSessionFetcherService *)fetcherService {
  // Internal utility method for instantiating fetchers
  DCGTMSessionUploadFetcher *fetcher;
  if ([fetcherService isKindOfClass:[DCGTMSessionFetcherService class]]) {
    fetcher = [fetcherService fetcherWithRequest:request
                                    fetcherClass:self];
  } else {
    fetcher = [self fetcherWithRequest:request];
  }
  fetcher.useBackgroundSession = YES;
  return fetcher;
}

+ (NSPointerArray *)uploadFetcherPointerArrayForBackgroundSessions {
  static NSPointerArray *gUploadFetcherPointerArrayForBackgroundSessions = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gUploadFetcherPointerArrayForBackgroundSessions = [NSPointerArray weakObjectsPointerArray];
  });
  return gUploadFetcherPointerArrayForBackgroundSessions;
}

+ (instancetype)uploadFetcherForSessionIdentifier:(NSString *)sessionIdentifier {
  DCGTMSESSION_ASSERT_DEBUG(sessionIdentifier != nil, @"Invalid session identifier");
  NSArray *uploadFetchersForBackgroundSessions = [self uploadFetchersForBackgroundSessions];
  for (DCGTMSessionUploadFetcher *uploadFetcher in uploadFetchersForBackgroundSessions) {
    if ([uploadFetcher.chunkFetcher.sessionIdentifier isEqual:sessionIdentifier]) {
      return uploadFetcher;
    }
  }
  return nil;
}

+ (NSArray *)uploadFetchersForBackgroundSessions {
  // Collect the background session upload fetchers that are still in memory.
  NSPointerArray *uploadFetcherPointerArray = [self uploadFetcherPointerArrayForBackgroundSessions];
  [uploadFetcherPointerArray compact];
  NSMutableSet *restoredSessionIdentifiers = [[NSMutableSet alloc] init];
  NSMutableArray *uploadFetchers = [[NSMutableArray alloc] init];
  for (DCGTMSessionUploadFetcher *uploadFetcher in uploadFetcherPointerArray) {
    NSString *sessionIdentifier = uploadFetcher.chunkFetcher.sessionIdentifier;
    if (sessionIdentifier) {
      [restoredSessionIdentifiers addObject:sessionIdentifier];
      [uploadFetchers addObject:uploadFetcher];
    }
  }

  // The system may have other ongoing background upload sessions. Restore upload fetchers for those
  // too.
  NSArray *fetchers = [DCGTMSessionFetcher fetchersForBackgroundSessions];
  for (DCGTMSessionFetcher *fetcher in fetchers) {
    NSString *sessionIdentifier = fetcher.sessionIdentifier;
    if (!sessionIdentifier || [restoredSessionIdentifiers containsObject:sessionIdentifier]) {
      continue;
    }
    NSDictionary *sessionIdentifierMetadata = [fetcher sessionIdentifierMetadata];
    if (sessionIdentifierMetadata == nil) {
      continue;
    }
    if (![sessionIdentifierMetadata[kDCGTMSessionIdentifierIsUploadChunkFetcherMetadataKey] boolValue]) {
      continue;
    }
    DCGTMSessionUploadFetcher *uploadFetcher =
        [self uploadFetcherForSessionIdentifierMetadata:sessionIdentifierMetadata];
    if (uploadFetcher == nil) {
      // Something went wrong with this upload fetcher, so kill the restored chunk fetcher.
      [fetcher stopFetching];
      continue;
    }
    [uploadFetchers addObject:uploadFetcher];
    uploadFetcher->_chunkFetcher = fetcher;
    uploadFetcher->_fetcherInFlight = fetcher;
    [uploadFetcher attachSendProgressBlockToChunkFetcher:fetcher];
    fetcher.completionHandler =
        [fetcher completionHandlerWithTarget:uploadFetcher
                           didFinishSelector:@selector(chunkFetcher:finishedWithData:error:)];

    DCGTMSESSION_LOG_DEBUG(@"%@ restoring upload fetcher %@ for chunk fetcher %@",
                         [self class], uploadFetcher, fetcher);
  }
  return uploadFetchers;
}

- (void)setUploadData:(NSData *)data {
  if (_uploadData != data) {
    _uploadData = data;
    [self setupRequestHeaders];
  }
}

- (NSData *)uploadData {
  return _uploadData;
}

- (void)setUploadFileHandle:(NSFileHandle *)fh {
  if (_uploadFileHandle != fh) {
    _uploadFileHandle = fh;
    [self setupRequestHeaders];
  }
}

- (NSFileHandle *)uploadFileHandle {
  return _uploadFileHandle;
}

- (void)setUploadFileURL:(NSURL *)uploadURL {
  if (_uploadFileURL != uploadURL) {
    _uploadFileURL = uploadURL;
    [self setupRequestHeaders];
  }
}

- (NSURL *)uploadFileURL {
  return _uploadFileURL;
}

- (void)setUploadDataLength:(int64_t)fullLength
                   provider:(DCGTMSessionUploadFetcherDataProvider)block {
  _uploadDataProvider = [block copy];
  _uploadFileLength = fullLength;

  [self setupRequestHeaders];
}

- (DCGTMSessionUploadFetcherDataProvider)uploadDataProvider {
  return _uploadDataProvider;
}

- (void)setupRequestHeaders {
#if DEBUG
  int hasData = (_uploadData != nil) ? 1 : 0;
  int hasFileHandle = (_uploadFileHandle != nil) ? 1 : 0;
  int hasFileURL = (_uploadFileURL != nil) ? 1 : 0;
  int hasUploadDataProvider = (_uploadDataProvider != nil) ? 1 : 0;
  int numberOfSources = hasData + hasFileHandle + hasFileURL + hasUploadDataProvider;
  #pragma unused(numberOfSources)
  DCGTMSESSION_ASSERT_DEBUG(numberOfSources == 1,
                          @"Need just one upload source (%d)", numberOfSources);
#endif

  // Add our custom headers to the initial request indicating the data
  // type and total size to be delivered later in the chunk requests.
  NSMutableURLRequest *mutableRequest = self.mutableRequest;

  DCGTMSESSION_ASSERT_DEBUG((mutableRequest == nil) != (_uploadLocationURL == nil),
                          @"Request and location are mutually exclusive");
  if (!mutableRequest) return;

  NSNumber *lengthNum = @([self fullUploadLength]);
  [mutableRequest setValue:@"resumable"
        forHTTPHeaderField:kDCGTMSessionHeaderXGoogUploadProtocol];
  [mutableRequest setValue:@"start"
        forHTTPHeaderField:kDCGTMSessionHeaderXGoogUploadCommand];
  [mutableRequest setValue:_uploadMIMEType
        forHTTPHeaderField:kDCGTMSessionHeaderXGoogUploadContentType];
  [mutableRequest setValue:lengthNum.stringValue
        forHTTPHeaderField:kDCGTMSessionHeaderXGoogUploadContentLength];

  NSString *method = [mutableRequest HTTPMethod];
  if (method == nil || [method caseInsensitiveCompare:@"GET"] == NSOrderedSame) {
    [mutableRequest setHTTPMethod:@"POST"];
  }

  // Ensure the user agent header identifies this to the upload server as a
  // DCGTMSessionUploadFetcher client.  The /1 can be incremented in the unlikely circumstance
  // we need to make a bug fix in the client that the server can recognize.
  NSString *const kUserAgentStub = @"(DCGTMSUF/1)";
  NSString *userAgent = [mutableRequest valueForHTTPHeaderField:@"User-Agent"];
  if (userAgent == nil
      || [userAgent rangeOfString:kUserAgentStub].location == NSNotFound) {
    if (userAgent.length == 0) {
      userAgent = DCGTMFetcherStandardUserAgentString(nil);
    }
    userAgent = [userAgent stringByAppendingFormat:@" %@", kUserAgentStub];
    [mutableRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
  }
}

- (void)setLocationURL:(NSURL *)location
        uploadMIMEType:(NSString *)uploadMIMEType
             chunkSize:(int64_t)chunkSize {
  DCGTMSESSION_ASSERT_DEBUG(chunkSize > 0, @"chunk size is zero");

  // When resuming an upload, set the known upload target URL.
  _uploadLocationURL = location;

  self.uploadMIMEType = uploadMIMEType;
  self.chunkSize = chunkSize;

  // Indicate that we've not yet determined the file handle's length
  _uploadFileLength = -1;

  // Indicate that we've not yet determined the upload fetcher status
  _statusCode = -1;

  // If this is restarting an upload begun by another fetcher,
  // the location is specified but the request is nil
  _isRestartedUpload = (location != nil);
}

- (int64_t)fullUploadLength {
  if (_uploadData) {
    return (int64_t)[_uploadData length];
  } else {
    if (_uploadFileLength == -1) {
      if (_uploadFileHandle) {
        // First time through, seek to end to determine file length
        _uploadFileLength = (int64_t)[_uploadFileHandle seekToEndOfFile];
      } else if (_uploadDataProvider) {
        // _uploadFileLength is set when the _uploadDataProvider is set.
        DCGTMSESSION_ASSERT_DEBUG(_uploadFileLength >= 0, @"No uploadDataProvider length set");
      } else {
        NSNumber *filesizeNum;
        NSError *valueError;
        if ([self.uploadFileURL getResourceValue:&filesizeNum
                                          forKey:NSURLFileSizeKey
                                           error:&valueError]) {
          _uploadFileLength = filesizeNum.longLongValue;
        } else {
          DCGTMSESSION_ASSERT_DEBUG(NO, @"Cannot get file size: %@\n  %@",
                                  valueError, self.uploadFileURL.path);
          _uploadFileLength = 0;
        }
      }
    }
    return _uploadFileLength;
  }
}

- (void)setUploadFileLength:(int64_t)val {
  _uploadFileLength = val;
}

// Make a subdata of the upload data.
- (void)generateChunkSubdataWithOffset:(int64_t)offset
                                length:(int64_t)length
                              response:(DCGTMSessionUploadFetcherDataProviderResponse)response {
  if (_uploadDataProvider) {
    _uploadDataProvider(offset, length, response);
    return;
  }
  if (_uploadData) {
    // NSData provided.
    NSData *resultData;
    if (offset == 0 && length == (int64_t)[_uploadData length]) {
      resultData = _uploadData;
    } else {
      int64_t dataLength = (int64_t)[_uploadData length];
      // Ensure our range is valid.  b/18007814
      if (offset + length > dataLength) {
        NSString *errorMessage = [NSString stringWithFormat:
            @"Range invalid for upload data.  offset: %lld\tlength: %lld\tdataLength: %lld",
            offset, length, dataLength];
        DCGTMSESSION_ASSERT_DEBUG(NO, @"%@", errorMessage);
        response(nil, [self uploadChunkUnavailableErrorWithDescription:errorMessage]);
        return;
      }
      NSRange range = NSMakeRange((NSUInteger)offset, (NSUInteger)length);
      resultData = [_uploadData subdataWithRange:range];
    }
    response(resultData, nil);
    return;
  }
  if (_uploadFileURL) {
    NSURL *uploadFileURL = _uploadFileURL;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [self generateChunkSubdataFromFileURL:uploadFileURL
                                     offset:offset
                                     length:length
                                   response:response];
    });
    return;
  }
  DCGTMSESSION_ASSERT_DEBUG(_uploadFileHandle, @"Unexpectedly missing upload data package");
  NSFileHandle *uploadFileHandle = _uploadFileHandle;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self generateChunkSubdataFromFileHandle:uploadFileHandle
                                      offset:offset
                                      length:length
                                    response:response];
  });
}

- (void)generateChunkSubdataFromFileHandle:(NSFileHandle *)fileHandle
                                    offset:(int64_t)offset
                                    length:(int64_t)length
                                  response:(DCGTMSessionUploadFetcherDataProviderResponse)response {
  NSData *resultData;
  NSError *error;
  @try {
    [fileHandle seekToFileOffset:(unsigned long long)offset];
    resultData = [fileHandle readDataOfLength:(NSUInteger)length];
  }
  @catch (NSException *exception) {
    DCGTMSESSION_ASSERT_DEBUG(NO, @"uploadFileHandle failed to read, %@", exception);
    error = [self uploadChunkUnavailableErrorWithDescription:[exception description]];
  }
  // The response always re-dispatches to the main thread, so we skip doing that here.
  response(resultData, error);
}

- (void)generateChunkSubdataFromFileURL:(NSURL *)fileURL
                                 offset:(int64_t)offset
                                 length:(int64_t)length
                               response:(DCGTMSessionUploadFetcherDataProviderResponse)response {
  NSData *resultData;
  NSError *error;
  int64_t fullUploadLength = [self fullUploadLength];
  NSData *mappedData =
      [NSData dataWithContentsOfURL:fileURL
                            options:NSDataReadingMappedAlways + NSDataReadingUncached
                              error:&error];
  if (!mappedData) {
    // We could not create an NSData by memory-mapping the file.
#if TARGET_IPHONE_SIMULATOR
    // NSTemporaryDirectory() can differ in the simulator between app restarts,
    // yet the contents for the new path remains unchanged, so try the latest temp path.
    if ([error.domain isEqual:NSCocoaErrorDomain] && (error.code == NSFileReadNoSuchFileError)) {
      NSString *filename = [fileURL lastPathComponent];
      NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
      NSURL *newFileURL = [NSURL fileURLWithPath:filePath];
      if (![newFileURL isEqual:fileURL]) {
        [self generateChunkSubdataFromFileURL:newFileURL
                                       offset:offset
                                       length:length
                                     response:response];
        return;
      }
    }
#endif

    // If the file is just too large to create an NSData for, or if for some other reason we can't
    // map it, create an NSFileHandle instead to read a subset into an NSData.
#if DEBUG
    NSNumber *fileSizeNum;
    BOOL hasFileSize = [fileURL getResourceValue:&fileSizeNum forKey:NSURLFileSizeKey error:NULL];
    DCGTMSESSION_LOG_DEBUG(@"uploadFileURL failed to map for making a chunk, file size %@, %@",
                         hasFileSize ? fileSizeNum : @"unknown", error);
#endif

    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:fileURL
                                                                   error:&error];
    if (fileHandle != nil) {
      [self generateChunkSubdataFromFileHandle:fileHandle
                                        offset:offset
                                        length:length
                                      response:response];
      return;
    }
    DCGTMSESSION_ASSERT_DEBUG(NO, @"uploadFileURL failed to read, %@", error);
    // Fall through with the error.
  } else {
    // Successfully created an NSData by memory-mapping the file.
    if (offset > 0 || length < fullUploadLength) {
      NSRange range = NSMakeRange((NSUInteger)offset, (NSUInteger)length);
      resultData = [mappedData subdataWithRange:range];
    } else {
      resultData = mappedData;
    }
  }
  // The response always re-dispatches to the main thread, so we skip re-dispatching here.
  response(resultData, error);
}

- (NSError *)uploadChunkUnavailableErrorWithDescription:(NSString *)description {
  // The description in the userInfo is intended as a clue to programmers, not
  // for client code to examine or rely on.
  NSDictionary *userInfo = @{ @"description" : description };
  return [NSError errorWithDomain:kDCGTMSessionFetcherErrorDomain
                             code:DCGTMSessionFetcherErrorUploadChunkUnavailable
                         userInfo:userInfo];
}

- (NSError *)prematureFailureErrorWithUserInfo:(NSDictionary *)userInfo {
  // An error for if we get an unexpected status from the upload server or
  // otherwise cannot continue.  This is an issue beyond the upload protocol;
  // there's no way the client can do anything useful except give up.
  NSError *error = [NSError errorWithDomain:kDCGTMSessionFetcherStatusDomain
                                       code:501  // Not implemented
                                   userInfo:userInfo];
  return error;
}

+ (DCGTMSessionUploadFetcherStatus)uploadStatusFromResponseHeaders:(NSDictionary *)responseHeaders {
  NSString *statusString = [responseHeaders objectForKey:kDCGTMSessionHeaderXGoogUploadStatus];
  if ([statusString isEqual:@"active"]) {
    return kStatusActive;
  }
  if ([statusString isEqual:@"final"]) {
    return kStatusFinal;
  }
  if ([statusString isEqual:@"cancelled"]) {
    return kStatusCancelled;
  }
  return kStatusUnknown;
}

#pragma mark Method overrides affecting the initial fetch only

- (void)setCompletionHandler:(DCGTMSessionFetcherCompletionHandler)handler {
  _delegateCompletionHandler = handler;
}

- (void)beginFetchWithCompletionHandler:(DCGTMSessionFetcherCompletionHandler)handler {
  _initialBodyLength = [self bodyLength];

  // We'll hold onto the superclass's callback queue so we can invoke the handler
  // even after the superclass has released the queue and its callback handler, as
  // happens during auth failure.
  _delegateCallbackQueue = self.callbackQueue;
  self.completionHandler = handler;

  if (_isRestartedUpload) {
    // When restarting an upload, we know the destination location for chunk fetches,
    // but we need to query to find the initial offset.
    if (![self isPaused]) {
      [self sendQueryForUploadOffsetWithFetcherProperties:self.properties];
    }
    return;
  }
  // We don't want to call into the client's completion block immediately
  // after the finish of the initial connection (the delegate is called only
  // when uploading finishes), so we substitute our own completion block to be
  // called when the initial connection finishes
  DCGTMSESSION_ASSERT_DEBUG(_fetcherInFlight == nil, @"unexpected fetcher in flight");

  _fetcherInFlight = self;
  [super beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
    _fetcherInFlight = nil;
    // callback

    BOOL hasTestBlock = (self.testBlock != nil);
    if (!_isRestartedUpload && !hasTestBlock) {
      if (error == nil) {
        [self beginChunkFetches];
      } else {
        if ([self retryTimer] == nil) {
          [self invokeFinalCallbackWithData:nil
                                      error:error
                   shouldInvalidateLocation:YES];
        }
      }
    } else {
      // If there was no initial request, then this fetch is resuming some
      // other uploadFetcher's initial request, and the superclass's connection
      // is never used, so at this point we call the user's actual completion
      // block.
      if (!hasTestBlock) {
        [self invokeFinalCallbackWithData:data
                                    error:error
                 shouldInvalidateLocation:YES];
      } else {
        // There was a test block, so we won't do chunk fetches, but we simulate obtaining
        // the data to be uploaded from the upload data provider block or the file handle,
        // and then call back.
        [self generateChunkSubdataWithOffset:0
                                      length:[self fullUploadLength]
                                    response:^(NSData *generateData, NSError *generateError) {
            [self invokeFinalCallbackWithData:data
                                        error:error
                     shouldInvalidateLocation:YES];
        }];
      }
    }
  }];
}

- (void)beginChunkFetches {
#if DEBUG
  // The initial response of the resumable upload protocol should have an
  // empty body
  //
  // This assert typically happens because the upload create/edit link URL was
  // not supplied with the request, and the server is thus expecting a non-
  // resumable request/response.
  if ([[self downloadedData] length] > 0) {
    NSString *str = [[NSString alloc] initWithData:[self downloadedData]
                                          encoding:NSUTF8StringEncoding];
    #pragma unused(str)
    DCGTMSESSION_ASSERT_DEBUG(NO, @"unexpected response data (uploading to the wrong URL?)\n%@", str);
  }
#endif

  // We need to get the upload URL from the location header to continue.
  NSDictionary *responseHeaders = [self responseHeaders];

  [self retrieveUploadChunkGranularityFromResponseHeaders:responseHeaders];

  DCGTMSessionUploadFetcherStatus uploadStatus =
      [[self class] uploadStatusFromResponseHeaders:responseHeaders];
  DCGTMSESSION_ASSERT_DEBUG(uploadStatus != kStatusUnknown,
      @"beginChunkFetches has unexpected upload status for headers %@", responseHeaders);

  BOOL isPrematureStop = (uploadStatus == kStatusFinal) || (uploadStatus == kStatusCancelled);

  NSString *uploadLocationURLStr = [responseHeaders objectForKey:kDCGTMSessionHeaderXGoogUploadURL];
  BOOL hasUploadLocation = (uploadLocationURLStr.length > 0);

  if (isPrematureStop || !hasUploadLocation) {
    DCGTMSESSION_ASSERT_DEBUG(NO, @"Premature failure: upload-status:\"%@\"  location:%@",
        [responseHeaders objectForKey:kDCGTMSessionHeaderXGoogUploadStatus], uploadLocationURLStr);
    // We cannot continue since we do not know the location to use
    // as our upload destination.
    NSDictionary *userInfo = nil;
    NSData *downloadedData = self.downloadedData;
    if (downloadedData.length > 0) {
      userInfo = @{ kDCGTMSessionFetcherStatusDataKey : downloadedData };
    }
    NSError *failureError = [self prematureFailureErrorWithUserInfo:userInfo];
    [self invokeFinalCallbackWithData:nil
                                error:failureError
             shouldInvalidateLocation:YES];
    return;
  }

  self.uploadLocationURL = [NSURL URLWithString:uploadLocationURLStr];

  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:kDCGTMSessionFetcherUploadLocationObtainedNotification
                    object:self];

  // we've now sent all of the initial post body data, so we need to include
  // its size in future progress indicator callbacks
  _initialBodySent = _initialBodyLength;

  // just in case the user paused us during the initial fetch...
  if (![self isPaused]) {
    [self uploadNextChunkWithOffset:0];
  }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
  // Overrides the superclass.
  [self invokeDelegateWithDidSendBytes:bytesSent
                        totalBytesSent:totalBytesSent
              totalBytesExpectedToSend:totalBytesExpectedToSend + [self fullUploadLength]];
}

- (BOOL)shouldReleaseCallbacksUponCompletion {
  // Overrides the superclass.

  // We don't want the superclass to release the delegate and callback
  // blocks once the initial fetch has finished
  //
  // This is invoked for only successful completion of the connection;
  // an error always will invoke and release the callbacks
  return NO;
}

- (void)invokeFinalCallbackWithData:(NSData *)data
                              error:(NSError *)error
           shouldInvalidateLocation:(BOOL)shouldInvalidateLocation {
  @synchronized(self) {
    if (shouldInvalidateLocation) {
      self.uploadLocationURL = nil;
    }
    dispatch_queue_t queue = _delegateCallbackQueue;
    DCGTMSessionFetcherCompletionHandler handler = _delegateCompletionHandler;
    if (queue && handler) {
      [self invokeOnCallbackQueue:queue
                 afterUserStopped:NO
                            block:^{
          handler(data, error);
      }];
    }

    [self releaseUploadAndBaseCallbacks];
  }
}

- (void)releaseUploadAndBaseCallbacks {
  // Should be called in @synchronized(self)
  _delegateCallbackQueue = nil;
  _delegateCompletionHandler = nil;
  _uploadDataProvider = nil;

  // Release the base class's callbacks, too, if needed.
  [self releaseCallbacks];
}

- (void)stopFetchReleasingCallbacks:(BOOL)shouldReleaseCallbacks {
  // Clear _fetcherInFlight when stopped. Moved from stopFetching, since that's a public method,
  // where this method does the work. Fixes issue clearing value when retryBlock included.
  if (_fetcherInFlight == self) {
    _fetcherInFlight = nil;
  }
  [super stopFetchReleasingCallbacks:shouldReleaseCallbacks];

  if (shouldReleaseCallbacks) {
    @synchronized(self) {
      [self releaseUploadAndBaseCallbacks];
    }
  }
}

#pragma mark Chunk fetching methods

- (void)uploadNextChunkWithOffset:(int64_t)offset {
  // use the properties in each chunk fetcher
  NSDictionary *props = [self properties];

  [self uploadNextChunkWithOffset:offset
                fetcherProperties:props];
}

- (void)sendQueryForUploadOffsetWithFetcherProperties:(NSDictionary *)props {
  DCGTMSessionFetcher *queryFetcher = [self uploadFetcherWithProperties:props
                                                         isQueryFetch:YES];
  queryFetcher.bodyData = [NSData data];

  NSString *originalComment = self.comment;
  [queryFetcher setCommentWithFormat:@"%@ (query offset)",
   originalComment ? originalComment : @"upload"];

  NSMutableURLRequest *queryRequest = queryFetcher.mutableRequest;
  [queryRequest setValue:@"query" forHTTPHeaderField:kDCGTMSessionHeaderXGoogUploadCommand];

  _fetcherInFlight = queryFetcher;
  [queryFetcher beginFetchWithDelegate:self
                     didFinishSelector:@selector(queryFetcher:finishedWithData:error:)];
}

- (void)queryFetcher:(DCGTMSessionFetcher *)queryFetcher
    finishedWithData:(NSData *)data
               error:(NSError *)error {
  _fetcherInFlight = nil;

  NSDictionary *responseHeaders = [queryFetcher responseHeaders];
  NSString *sizeReceivedHeader;

  DCGTMSessionUploadFetcherStatus uploadStatus =
      [[self class] uploadStatusFromResponseHeaders:responseHeaders];
  DCGTMSESSION_ASSERT_DEBUG(uploadStatus != kStatusUnknown || error != nil,
      @"query fetcher completion has unexpected upload status for headers %@", responseHeaders);

  if (error == nil) {
    sizeReceivedHeader = [responseHeaders objectForKey:kDCGTMSessionHeaderXGoogUploadSizeReceived];

    if (uploadStatus == kStatusCancelled ||
        (uploadStatus == kStatusActive && sizeReceivedHeader == nil)) {
      NSDictionary *userInfo = nil;
      if (data.length > 0) {
        userInfo = @{ kDCGTMSessionFetcherStatusDataKey : data };
      }
      error = [self prematureFailureErrorWithUserInfo:userInfo];
    }
  }

  if (error == nil) {
    int64_t offset = [sizeReceivedHeader longLongValue];
    int64_t fullUploadLength = [self fullUploadLength];
    if (offset >= fullUploadLength || uploadStatus == kStatusFinal) {
      // Handle we're done
      [self chunkFetcher:queryFetcher finishedWithData:data error:nil];
    } else {
      [self retrieveUploadChunkGranularityFromResponseHeaders:responseHeaders];
      [self uploadNextChunkWithOffset:offset];
    }
  } else {
    // Handle query error
    [self chunkFetcher:queryFetcher finishedWithData:data error:error];
  }
}

- (void)sendCancelUploadWithFetcherProperties:(NSDictionary *)props {
  DCGTMSessionFetcher *cancelFetcher = [self uploadFetcherWithProperties:props
                                                          isQueryFetch:YES];
  cancelFetcher.bodyData = [NSData data];

  NSString *originalComment = self.comment;
  [cancelFetcher setCommentWithFormat:@"%@ (cancel)",
      originalComment ? originalComment : @"upload"];

  NSMutableURLRequest *cancelRequest = cancelFetcher.mutableRequest;
  [cancelRequest setValue:@"cancel" forHTTPHeaderField:kDCGTMSessionHeaderXGoogUploadCommand];

  _fetcherInFlight = cancelFetcher;
  [cancelFetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
      _fetcherInFlight = nil;
      if (error) {
        DCGTMSESSION_LOG_DEBUG(@"cancelFetcher %@", error);
      }
  }];
}

- (void)uploadNextChunkWithOffset:(int64_t)offset
                fetcherProperties:(NSDictionary *)props {
  // Example chunk headers:
  //  X-Goog-Upload-Command: upload, finalize
  //  X-Goog-Upload-Offset: 0
  //  Content-Length: 2000000
  //  Content-Type: image/jpeg
  //
  //  {bytes 0-1999999}

  // The chunk upload URL requires no authentication header.
  DCGTMSessionFetcher *chunkFetcher = [self uploadFetcherWithProperties:props
                                                         isQueryFetch:NO];
  [self attachSendProgressBlockToChunkFetcher:chunkFetcher];
  NSMutableURLRequest *chunkRequest = chunkFetcher.mutableRequest;

  BOOL isUploadingFileURL = (self.uploadFileURL != nil);

  // Upload another chunk, meeting server-required granularity.
  int64_t chunkSize = [self chunkSize];

  int64_t fullUploadLength = [self fullUploadLength];

  BOOL isUploadingFullFile = (offset == 0 && chunkSize >= fullUploadLength);
  if (!isUploadingFileURL || !isUploadingFullFile) {
    // We're not uploading the entire file and given the file URL.  Since we'll be
    // allocating a subdata block for a chunk, we need to bound it to something that
    // won't blow the process's memory.
    if (chunkSize > kDCGTMSessionUploadFetcherMaximumDemandBufferSize) {
      chunkSize = kDCGTMSessionUploadFetcherMaximumDemandBufferSize;
    }
  }

  if (_uploadGranularity > 0) {
    if (chunkSize < _uploadGranularity) {
      chunkSize = _uploadGranularity;
    } else {
      chunkSize = chunkSize - (chunkSize % _uploadGranularity);
    }
  }

  DCGTMSESSION_ASSERT_DEBUG(offset < fullUploadLength || fullUploadLength == 0,
                          @"offset %lld exceeds data length %lld", offset, fullUploadLength);

  if (_uploadGranularity > 0) {
    offset = offset - (offset % _uploadGranularity);
  }

  // If the chunk size is bigger than the remaining data, or else
  // it's close enough in size to the remaining data that we'd rather
  // avoid having a whole extra http fetch for the leftover bit, then make
  // this chunk size exactly match the remaining data size
  NSString *command;
  int64_t thisChunkSize = chunkSize;

  BOOL isChunkTooBig = (thisChunkSize >= (fullUploadLength - offset));
  BOOL isChunkAlmostBigEnough = (fullUploadLength - offset - 2500 < thisChunkSize);
  BOOL isFinalChunk = isChunkTooBig || isChunkAlmostBigEnough;
  if (isFinalChunk) {
    thisChunkSize = fullUploadLength - offset;
    if (thisChunkSize > 0) {
      command = @"upload, finalize";
    } else {
      command = @"finalize";
    }
  } else {
    command = @"upload";
  }
  NSString *lengthStr = @(thisChunkSize).stringValue;
  NSString *offsetStr = @(offset).stringValue;

  [chunkRequest setValue:command forHTTPHeaderField:kDCGTMSessionHeaderXGoogUploadCommand];
  [chunkRequest setValue:lengthStr forHTTPHeaderField:@"Content-Length"];
  [chunkRequest setValue:offsetStr forHTTPHeaderField:kDCGTMSessionHeaderXGoogUploadOffset];

  // Append the range of bytes in this chunk to the fetcher comment.
  NSString *baseComment = self.comment;
  [chunkFetcher setCommentWithFormat:@"%@ (%lld-%lld)",
   baseComment ? baseComment : @"upload", offset, MAX(0, offset + thisChunkSize - 1)];

  // The chunk size may have changed, so determine again if we're uploading the full file.
  isUploadingFullFile = (offset == 0 && thisChunkSize >= fullUploadLength);
  if (isUploadingFullFile && isUploadingFileURL) {
    // The data is the full upload file URL.
    chunkFetcher.bodyFileURL = self.uploadFileURL;
    [self beginChunkFetcher:chunkFetcher
                     offset:offset];
  } else {
    // Make an NSData for the subset for this upload chunk.
    _isSubdataGenerating = YES;
    [self generateChunkSubdataWithOffset:offset
                                  length:thisChunkSize
                                response:^(NSData *chunkData, NSError *chunkError) {
      // The subdata methods may leave us on a background thread.
      dispatch_async(dispatch_get_main_queue(), ^{
        _isSubdataGenerating = NO;
        if (chunkData == nil) {
          NSError *responseError = chunkError;
          if (!responseError) {
            responseError = [self uploadChunkUnavailableErrorWithDescription:@"chunkData is nil"];
          }
          [self invokeFinalCallbackWithData:nil
                                      error:responseError
                   shouldInvalidateLocation:YES];
          return;
        }

        BOOL didWriteFile = NO;
        if (isUploadingFileURL) {
          // Make a temporary file with the data subset.
          NSString *tempName =
              [NSString stringWithFormat:@"DCGTMUpload_temp_%@", [[NSUUID UUID] UUIDString]];
          NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:tempName];
          NSError *writeError;
          didWriteFile = [chunkData writeToFile:tempPath
                                        options:NSDataWritingAtomic
                                          error:&writeError];
          if (didWriteFile) {
            chunkFetcher.bodyFileURL = [NSURL fileURLWithPath:tempPath];
          } else {
            DCGTMSESSION_LOG_DEBUG(@"writeToFile failed: %@\n%@", writeError, tempPath);
          }
        }
        if (!didWriteFile) {
          chunkFetcher.bodyData = [chunkData copy];
        }
        [self beginChunkFetcher:chunkFetcher
                         offset:offset];
      });
    }];
  }
}

- (void)beginChunkFetcher:(DCGTMSessionFetcher *)chunkFetcher
                   offset:(int64_t)offset {

  // Track the current offset for progress reporting
  _currentOffset = offset;

  // Hang on to the fetcher in case we need to cancel it.  We set these before beginning the
  // chunk fetch so the observers notified of chunk fetches can inspect the upload fetcher to
  // match to the chunk.
  _chunkFetcher = chunkFetcher;
  _fetcherInFlight = _chunkFetcher;

  [chunkFetcher beginFetchWithDelegate:self
                     didFinishSelector:@selector(chunkFetcher:finishedWithData:error:)];
}

- (void)attachSendProgressBlockToChunkFetcher:(DCGTMSessionFetcher *)chunkFetcher {
  chunkFetcher.sendProgressBlock = ^(int64_t bytesSent, int64_t totalBytesSent,
                                     int64_t totalBytesExpectedToSend) {
    // The total bytes expected include the initial body and the full chunked
    // data, independent of how big this fetcher's chunk is.
    int64_t initialBodySent = [self bodyLength];
    int64_t totalSent = initialBodySent + _currentOffset + totalBytesSent;
    int64_t totalExpected = initialBodySent + [self fullUploadLength];

    [self invokeDelegateWithDidSendBytes:bytesSent
                          totalBytesSent:totalSent
                totalBytesExpectedToSend:totalExpected];
  };
}

- (NSDictionary *)uploadSessionIdentifierMetadata {
  NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
  metadata[kDCGTMSessionIdentifierIsUploadChunkFetcherMetadataKey] = @YES;
  DCGTMSESSION_ASSERT_DEBUG(self.uploadFileURL,
                          @"Invalid upload fetcher to create session identifier for metadata");
  metadata[kDCGTMSessionIdentifierUploadFileURLMetadataKey] = [self.uploadFileURL absoluteString];
  metadata[kDCGTMSessionIdentifierUploadFileLengthMetadataKey] = @([self fullUploadLength]);

  if (self.uploadLocationURL) {
    metadata[kDCGTMSessionIdentifierUploadLocationURLMetadataKey] =
        [self.uploadLocationURL absoluteString];
  }
  if (self.uploadMIMEType) {
    metadata[kDCGTMSessionIdentifierUploadMIMETypeMetadataKey] = self.uploadMIMEType;
  }
  metadata[kDCGTMSessionIdentifierUploadChunkSizeMetadataKey] = @(_chunkSize);
  metadata[kDCGTMSessionIdentifierUploadCurrentOffsetMetadataKey] = @(_currentOffset);
  return metadata;
}

- (DCGTMSessionFetcher *)uploadFetcherWithProperties:(NSDictionary *)properties
                                      isQueryFetch:(BOOL)isQueryFetch {
  // Common code to make a request for a query command or for a chunk upload.
  NSMutableURLRequest *chunkRequest = [NSMutableURLRequest requestWithURL:self.uploadLocationURL];
  [chunkRequest setHTTPMethod:@"PUT"];

  // copy the user-agent from the original connection
  NSURLRequest *origRequest = self.mutableRequest;
  NSString *userAgent = [origRequest valueForHTTPHeaderField:@"User-Agent"];
  if ([userAgent length] > 0) {
    [chunkRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
  }
  // To avoid timeouts when debugging, copy the timeout of the initial fetcher.
  NSTimeInterval origTimeout = [origRequest timeoutInterval];
  [chunkRequest setTimeoutInterval:origTimeout];

  //
  // Make a new chunk fetcher.
  //
  DCGTMSessionFetcher *chunkFetcher = [DCGTMSessionFetcher fetcherWithRequest:chunkRequest];
  chunkFetcher.callbackQueue = self.callbackQueue;
  chunkFetcher.sessionUserInfo = self.sessionUserInfo;
  chunkFetcher.configurationBlock = self.configurationBlock;
  chunkFetcher.allowedInsecureSchemes = self.allowedInsecureSchemes;
  chunkFetcher.allowLocalhostRequest = self.allowLocalhostRequest;
  chunkFetcher.allowInvalidServerCertificates = self.allowInvalidServerCertificates;
  chunkFetcher.useUploadTask = !isQueryFetch;

  if (self.uploadFileURL && !isQueryFetch && _useBackgroundSessionOnChunkFetchers) {
    [chunkFetcher createSessionIdentifierWithMetadata:[self uploadSessionIdentifierMetadata]];
  }

  // Give the chunk fetcher the same properties as the previous chunk fetcher
  chunkFetcher.properties = [properties mutableCopy];
  [chunkFetcher setProperty:[NSValue valueWithNonretainedObject:self]
                     forKey:kDCGTMSessionUploadFetcherChunkParentKey];

  // copy other fetcher settings to the new fetcher
  chunkFetcher.retryEnabled = self.retryEnabled;
  chunkFetcher.maxRetryInterval = self.maxRetryInterval;

  if ([self isRetryEnabled]) {
    // We interpose our own retry method both so we can change the request to ask the server to
    // tell us where to resume the chunk.
    chunkFetcher.retryBlock = ^(BOOL suggestedWillRetry, NSError *chunkError,
                                DCGTMSessionFetcherRetryResponse response){
      void (^finish)(BOOL) = ^(BOOL shouldRetry){
        // We'll retry by sending an offset query.
        if (shouldRetry) {
          _shouldInitiateOffsetQuery = YES;

          // We don't know what our actual offset is anymore, but the server will tell us.
          self.currentOffset = 0;
        }
        // We don't actually want to retry this specific fetcher.
        response(NO);
      };

      DCGTMSessionFetcherRetryBlock retryBlock = self.retryBlock;
      if (retryBlock) {
        // Ask the client, then call the finish block above.
        retryBlock(suggestedWillRetry, chunkError, finish);
      } else {
        finish(suggestedWillRetry);
      }
    };
  }

  // The chunk request becomes the fetcher's last request.
  self.lastChunkRequest = chunkFetcher.mutableRequest;
  return chunkFetcher;
}

- (void)chunkFetcher:(DCGTMSessionFetcher *)chunkFetcher
    finishedWithData:(NSData *)data
               error:(NSError *)error {
  BOOL hasDestroyedOldChunkFetcher = NO;
  _fetcherInFlight = nil;

  NSDictionary *responseHeaders = [chunkFetcher responseHeaders];
  DCGTMSessionUploadFetcherStatus uploadStatus =
      [[self class] uploadStatusFromResponseHeaders:responseHeaders];
  DCGTMSESSION_ASSERT_DEBUG(uploadStatus != kStatusUnknown
                          || error != nil
                          || self.wasCreatedFromBackgroundSession,
      @"chunk fetcher completion has kStatusUnknown upload status for headers %@ fetcher %@",
      responseHeaders, self);
  BOOL isUploadStatusStopped = (uploadStatus == kStatusFinal || uploadStatus == kStatusCancelled);

  int64_t previousContentLength =
      [[chunkFetcher.mutableRequest valueForHTTPHeaderField:@"Content-Length"] longLongValue];
  // The Content-Length header may not be present if the chunk fetcher was recreated from
  // a background session.
  BOOL hasKnownChunkSize = (previousContentLength > 0);
  BOOL needsQuery = (!hasKnownChunkSize && !isUploadStatusStopped);

  if (error || needsQuery) {
    NSInteger status = [error code];

    // Status 4xx indicates a bad offset in the Google upload protocol. However, do not retry status
    // 404 per spec, nor if the upload size appears to have been zero (since the server will just
    // keep asking us to retry.)
    if (_shouldInitiateOffsetQuery ||
        needsQuery ||
        ([error.domain isEqual:kDCGTMSessionFetcherStatusDomain] &&
         status >= 400 && status <= 499 &&
         status != 404 &&
         uploadStatus == kStatusActive &&
         previousContentLength > 0)) {
      _shouldInitiateOffsetQuery = NO;
      [self destroyChunkFetcher];
      hasDestroyedOldChunkFetcher = YES;
      [self sendQueryForUploadOffsetWithFetcherProperties:chunkFetcher.properties];
    } else {
      // Some unexpected status has occurred; handle it as we would a regular
      // object fetcher failure.
      [self invokeFinalCallbackWithData:data
                                  error:error
               shouldInvalidateLocation:NO];
    }
  } else {
    // The chunk has uploaded successfully.
    int64_t newOffset = _currentOffset + previousContentLength;
#if DEBUG
    // Verify that if we think all of the uploading data has been sent, the server responded with
    // the "final" upload status.
    BOOL hasUploadAllData = (newOffset == [self fullUploadLength]);
    BOOL isFinalStatus = (uploadStatus == kStatusFinal);
    #pragma unused(hasUploadAllData,isFinalStatus)
    DCGTMSESSION_ASSERT_DEBUG(hasUploadAllData == isFinalStatus || !hasKnownChunkSize,
                            @"uploadStatus:%@  newOffset:%zd (%lld + %zd)  fullUploadLength:%lld"
                            @" chunkFetcher:%@ requestHeaders:%@ responseHeaders:%@",
                            [responseHeaders objectForKey:kDCGTMSessionHeaderXGoogUploadStatus],
                            newOffset, _currentOffset, previousContentLength,
                            [self fullUploadLength],
                            chunkFetcher, chunkFetcher.mutableRequest.allHTTPHeaderFields,
                            responseHeaders);
#endif
    if (isUploadStatusStopped) {
      // This was the last chunk.
      if (error == nil && uploadStatus == kStatusCancelled) {
        // Report cancelled status as an error.
        NSDictionary *userInfo = nil;
        if (data.length > 0) {
          userInfo = @{ kDCGTMSessionFetcherStatusDataKey : data };
        }
        data = nil;
        error = [self prematureFailureErrorWithUserInfo:userInfo];
      } else {
        // The upload is in final status.
        //
        // Take the chunk fetcher's data as the superclass data.
        self.downloadedData = data;
        self.statusCode = chunkFetcher.statusCode;
      }

      // we're done
      [self invokeFinalCallbackWithData:data
                                  error:error
               shouldInvalidateLocation:YES];
    } else {
      // Start the next chunk.
      self.currentOffset = newOffset;

      // We want to destroy this chunk fetcher before creating the next one, but
      // we want to pass on its properties
      NSDictionary *props = [chunkFetcher properties];

      // We no longer need to be able to cancel this chunkFetcher.  Destroy it
      // before we create a new chunk fetcher.
      [self destroyChunkFetcher];
      hasDestroyedOldChunkFetcher = YES;

      [self uploadNextChunkWithOffset:newOffset
                    fetcherProperties:props];
    }
  }
  if (!hasDestroyedOldChunkFetcher) {
    [self destroyChunkFetcher];
  }
}

- (void)destroyChunkFetcher {
  if (_fetcherInFlight == _chunkFetcher) {
    _fetcherInFlight = nil;
  }

  [_chunkFetcher stopFetching];

  NSURL *chunkFileURL = _chunkFetcher.bodyFileURL;
  BOOL wasTemporaryUploadFile = ![chunkFileURL isEqual:self.uploadFileURL];
  if (wasTemporaryUploadFile) {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:chunkFileURL
                                              error:&error];
    if (error) {
      DCGTMSESSION_LOG_DEBUG(@"removingItemAtURL failed: %@\n%@", error, chunkFileURL);
    }
  }

  _responseHeaders = _chunkFetcher.responseHeaders;
  _chunkFetcher.properties = nil;
  _chunkFetcher.retryBlock = nil;
  _chunkFetcher = nil;
}

// This method calculates the proper values to pass to the client's send progress block.
//
// The actual total bytes sent include the initial body sent, plus the
// offset into the batched data prior to the current chunk fetcher

- (void)invokeDelegateWithDidSendBytes:(int64_t)bytesSent
                        totalBytesSent:(int64_t)totalBytesSent
              totalBytesExpectedToSend:(int64_t)totalBytesExpected {
  @synchronized(self) {
    // Ensure the chunk fetcher survives the callback in case the user pauses the upload process.
    __block DCGTMSessionFetcher *holdFetcher = _chunkFetcher;

    [self invokeOnCallbackQueue:_delegateCallbackQueue
               afterUserStopped:NO
                          block:^{
        DCGTMSessionFetcherSendProgressBlock sendProgressBlock = self.sendProgressBlock;
        if (sendProgressBlock) {
          sendProgressBlock(bytesSent, totalBytesSent, totalBytesExpected);
        }
        holdFetcher = nil;
    }];
  }
}

- (void)retrieveUploadChunkGranularityFromResponseHeaders:(NSDictionary *)responseHeaders {
  // Standard granularity for Google uploads is 256K.
  NSString *chunkGranularityHeader =
      [responseHeaders objectForKey:@"X-Goog-Upload-Chunk-Granularity"];
  _uploadGranularity = [chunkGranularityHeader longLongValue];
}

#pragma mark -

- (BOOL)isPaused {
  return _isPaused;
}

- (void)pauseFetching {
  _isPaused = YES;

  // Pausing just means stopping the current chunk from uploading;
  // when we resume, we will send a query request to the server to
  // figure out what bytes to resume sending.
  //
  // we won't try to cancel the initial data upload, but rather will look for
  // the magic offset value in -connectionDidFinishLoading before
  // creating first initial chunk fetcher, just in case the user
  // paused during the initial data upload
  [self destroyChunkFetcher];
}

- (void)resumeFetching {
  if (_isPaused) {
    _isPaused = NO;

    [self sendQueryForUploadOffsetWithFetcherProperties:self.properties];
  }
}

- (void)stopFetching {
  // Overrides the superclass
  [self destroyChunkFetcher];

  // If we think the server is waiting for more data, then tell it there won't be more.
  if (self.uploadLocationURL) {
    [self sendCancelUploadWithFetcherProperties:[self properties]];
    self.uploadLocationURL = nil;
  }

  [super stopFetching];
}

#pragma mark -

@synthesize uploadData = _uploadData,
            uploadFileURL = _uploadFileURL,
            uploadFileHandle = _uploadFileHandle,
            uploadMIMEType = _uploadMIMEType,
            uploadLocationURL = _uploadLocationURL,
            chunkSize = _chunkSize,
            currentOffset = _currentOffset,
            delegateCallbackQueue = _delegateCallbackQueue,
            delegateCompletionHandler = _delegateCompletionHandler,
            chunkFetcher = _chunkFetcher,
            lastChunkRequest = _lastChunkRequest;

@dynamic activeFetcher;
@dynamic responseHeaders;
@dynamic statusCode;

+ (void)removePointer:(void *)pointer fromPointerArray:(NSPointerArray *)pointerArray {
  for (NSUInteger index = 0; index < pointerArray.count; ++index) {
    void *pointerAtIndex = [pointerArray pointerAtIndex:index];
    if (pointerAtIndex == pointer) {
      [pointerArray removePointerAtIndex:index];
      return;
    }
  }
}

- (BOOL)useBackgroundSession {
  return _useBackgroundSessionOnChunkFetchers;
}

- (void)setUseBackgroundSession:(BOOL)useBackgroundSession {
  if (_useBackgroundSessionOnChunkFetchers == useBackgroundSession) {
    return;
  }
  _useBackgroundSessionOnChunkFetchers = useBackgroundSession;
  NSPointerArray *uploadFetcherPointerArrayForBackgroundSessions =
      [[self class] uploadFetcherPointerArrayForBackgroundSessions];
  if (_useBackgroundSessionOnChunkFetchers) {
    [uploadFetcherPointerArrayForBackgroundSessions addPointer:(__bridge void *)self];
  } else {
    [[self class] removePointer:(__bridge void *)self
               fromPointerArray:uploadFetcherPointerArrayForBackgroundSessions];
  }
}

- (NSDictionary *)responseHeaders {
  // Overrides the superclass

  // If asked for the fetcher's response, use the most recent chunk fetcher's response,
  // since the original request's response lacks useful information like the actual
  // Content-Type.
  NSDictionary *dict = _chunkFetcher.responseHeaders;
  if (dict) {
    return dict;
  } else if (_responseHeaders) {
    return _responseHeaders;
  } else {
    // No chunk fetcher yet completed, so return whatever we have from the initial fetch.
    return [super responseHeaders];
  }
}

- (NSInteger)statusCode {
  if (_statusCode != -1) {
    // Overrides the superclass to indicate status appropriate to the initial
    // or latest chunk fetch
    return _statusCode;
  } else {
    return [super statusCode];
  }
}

- (void)setStatusCode:(NSInteger)val {
  _statusCode = val;
}

- (NSURL *)uploadLocationURL {
  @synchronized(self) {
    return _uploadLocationURL;
  }
}

- (void)setUploadLocationURL:(NSURL *)locationURL {
  @synchronized(self) {
    _uploadLocationURL = locationURL;
  }
}

- (DCGTMSessionFetcher *)activeFetcher {
  if (_fetcherInFlight) {
    return _fetcherInFlight;
  } else {
    return self;
  }
}

- (BOOL)waitForCompletionWithTimeout:(NSTimeInterval)timeoutInSeconds {
  NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutInSeconds];

  while (_fetcherInFlight || _isSubdataGenerating) {
    if ([timeoutDate timeIntervalSinceNow] < 0) return NO;

    if (_isSubdataGenerating) {
      // Allow time for subdata generation.
      NSDate *stopDate = [NSDate dateWithTimeIntervalSinceNow:0.001];
      [[NSRunLoop currentRunLoop] runUntilDate:stopDate];
    } else {
      // Wait for the fetcher in flight.
      BOOL timedOut;
      if (_fetcherInFlight == self) {
        timedOut = ![super waitForCompletionWithTimeout:timeoutInSeconds];
      } else {
        timedOut = ![_fetcherInFlight waitForCompletionWithTimeout:timeoutInSeconds];
      }
      if (timedOut) return NO;
    }
  }
  return YES;
}

@end

@implementation DCGTMSessionFetcher (DCGTMSessionUploadFetcherMethods)

- (DCGTMSessionUploadFetcher *)parentUploadFetcher {
  return [self propertyForKey:kDCGTMSessionUploadFetcherChunkParentKey];
}

@end