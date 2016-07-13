#import <Foundation/Foundation.h>

#import "DCEnumerations.h"

@class DCAuthenticationContext;
@class DCCapacityInfo;
@class DCContentBodyInfo;
@class DCContentGUID;
@class DCContentGUIDListResponse;
@class DCContentInfoListResponse;
@class DCContentThumbnailInfoList;
@class DCContentThumbnailInfoList;
@class DCDataID;
@class DCDetailedContentInfoListResponse;
@class DCTagListResponse;

@protocol DCDateFiltering;

/*!
 * APIs to access PhotoColle server.
 */
@interface DCPhotoColle : NSObject

/*!
 * An DCAuthenticationContext object.
 */
@property (nonatomic, readonly) DCAuthenticationContext *dcAuthenticationContext;

/*!
 * Constructor of this class.
 *
 * @param authenticationContext a context of an authentication.
 * @return Returns DCPhotoColle object, nil on failure.
 * @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (DCPhotoColle *)initWithDCAuthenticationContext:
        (DCAuthenticationContext *)authenticationContext;

/*!
  Get the list of content information.

  Do not call this method on the main thread.

#### Errors

##### Error domains

  This method notifies NSError at error situation. Domains notified by
  this method are followings:

  Domain name                    | Explanation
  -------------------------------|---------------------------
  DCApplicationLayerErrorDomain  | This error is raised when a request sending by PhotoColleSDK was failed to execute on a server.
  DCConnectionErrorDomain        | This error is raised when network IO error occurred.
  DCHttpErrorDomain              | This error is raised when PhotoColleSDK received unexpected status code in HTTP session.
  DCResponseBodyParseErrorDomain | This error is raised when PhotoColleSDK receives unexptected response body data from server, therefore, PhotoColleSDK failed to parse response body data to return value of PhotoColleSDK methods.
  DCTokenExpiredErrorDomain      | This error is raised when token is expired.

##### Error codes

  DCApplicationLayerErrorDomain have error codes to show detail of the
  error. Type of error codes was DCApplicationLayerErrorCode.

##### User information

  This section shows key and type of value in userInfo of NSError.

###### DCApplicationLayerErrorDomain

Key        | Type of Value | Explanation
-----------|---------------|-----------
paramName  | NSString *    | Parameter name which cause a error.
paramValue | NSString *    | Parameter value which cause a error.

###### DCHttpErrorDomain

Key          | Type of Value | Explanation
-------------|---------------|-----------
statusCode   | NSNumber *    | HTTP status code
reasonPhrase | NSString *    | reason phrase.
responseBody | NSData *      | response data.

###### DCResponseBodyParseErrorDomain

Key                       | Type of Value | Explanation
--------------------------|---------------|-----------
NSUnderlyingErrorKey      | NSError *     | cause of response body parse error.
NSLocalizedDescriptionKey | NSString *    | Description of this error.

NSUnderlyingErrorKey and NSLocalizedDescriptionKey are defined NSError.h

###### DCTokenExpiredErrorDomain
DCTokenExpiredErrorDomain does not have userInfo.

###### DCConnectionErrorDomain

Key                       | Type of Value | Explanation
--------------------------|---------------|-----------
NSUnderlyingErrorKey      | NSError *     | Cause of connection error.
NSLocalizedDescriptionKey | NSString *    | Description of this error.

NSUnderlyingErrorKey contains error raised from NSURLConnection methods.
NSUnderlyingErrorKey NSLocalizedDescriptionKey are defined NSError.h

  @param fileType The file type to select contents. This API does not
  support DCFILETYPE_ALL. See DCFileType for details.
  @param forDustbox The flag to select contents from dust box or not.
  @param dateFilter The filter of minimum date time. Contents are
  selected if contents's date time is equal or greater than this
  value. This parameter is optional. DCModifiedDateFilter or
  DCUploadDateFilter can be used as this parameter.
  @param maxResults The maximum of results in list. This parameter is
  optional. If this parameter is null, then 100 is used. Domain of
  this parameter is between 1 and 100. Otherwise this method
  fails. The content of this NSNumber must be int.
  @param start The start index of selected results.  This parameter
  is optional. If this parameter is null, then 1 is used.  Domain of
  this parameter is equal or greater than 1.  Otherwise, this method
  fails. The content of this NSNumber must be int.
  @param sortType Type of sort. See DCSortType for details. This
  method can not DCSORTTYPE_SCORE_DESC.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns a list of target content information, nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.

*/
- (DCContentInfoListResponse *)
        getContentIDListWithFileType:(DCFileType)fileType
                          forDustbox:(BOOL)forDustbox
                          dateFilter:(id <DCDateFiltering>)dateFilter
                          maxResults:(NSNumber *)maxResults
                               start:(NSNumber *)start
                            sortType:(DCSortType)sortType
                               error:(NSError **)error;

/*!
  Get the list of content information with tags.

  Do not call this method on the main thread.

#### Errors

  Following errors are notified from this method:

  - DCApplicationLayerErrorDomain
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR
    - DCAPPLICATIONLAYERERRORCODE_TIMEOUT
    - DCAPPLICATIONLAYERERRORCODE_NO_RESULTS
    - DCAPPLICATIONLAYERERRORCODE_SERVER_ERROR
  - DCConnectionErrorDomain
  - DCHttpErrorDomain
  - DCResponseBodyParseErrorDomain
  - DCTokenExpiredErrorDomain

  Detail of errors are described at
  getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:

  @param projectionType The type of projection rule. See
  DCProjectionType for details. If projectionType is
  DCPROJECTIONTYPE_FILE_COUNT, then fileType is only meaningful
  parameter. Other parameters are ignored.
  @param fileType The file type to select contents.
  See DCFileType for details.
  @param criteriaList The tags to select contents. This parameter is
  optional. This list can have five tags at the maximum. If this list
  has more than five tags, then this method throws an exception.
  @param forDustbox The flag to select contents from dust box or not.
  @param dateFilter The filter of minimum date time. Contents are
  selected if contents's date time is equal or greater than this
  value. This parameter is optional. DCModifiedDateFilter or
  DCUploadDateFilter can be used as this parameter.
  @param maxResults The maximum of results in list. This parameter is
  optional. If this parameter is null, then 1000 is used. Domain of
  this parameter is between 1 and 1000. Otherwise this method
  fails. The content of this NSNumber must be int.
  @param start The start index of selected results.  This parameter
  is optional. If this parameter is null, then 1 is used.  Domain of
  this parameter is equal or greater than 1.  Otherwise, this method
  fails. The content of this NSNumber must be int.
  @param sortType Type of sort. See DCSortType for details.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns the list of target content information, nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
-(DCDetailedContentInfoListResponse *)
        getContentIDListWithTagsWithProjectionType:(DCProjectionType)projectionType
                                          fileType:(DCFileType)fileType
                                      criteriaList:(NSArray *)criteriaList
                                        forDustbox:(BOOL)forDustbox
                                        dateFilter:(id <DCDateFiltering>)dateFilter
                                        maxResults:(NSNumber *)maxResults
                                             start:(NSNumber *)start
                                          sortType:(DCSortType)sortType
                                             error:(NSError **)error;

/*!
  Get the list of tag information.

  Do not call this method on the main thread.

#### Errors

  Following errors are notified from this method:

  - DCApplicationLayerErrorDomain
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR
    - DCAPPLICATIONLAYERERRORCODE_TIMEOUT
    - DCAPPLICATIONLAYERERRORCODE_NO_RESULTS
    - DCAPPLICATIONLAYERERRORCODE_SERVER_ERROR
  - DCConnectionErrorDomain
  - DCHttpErrorDomain
  - DCResponseBodyParseErrorDomain
  - DCTokenExpiredErrorDomain

  Detail of errors are described at
  getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:

  @param category The category to select tags.
  See DCCategory for details.
  @param fileType The file type of content to select tags.
  See DCFileType for details.
  @param minDateModified The filter of minimum modified date time.
  Tags are selected if tag's modified date time is equal or greater than
  this value. This parameter is optional.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns the list of tag information, nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (DCTagListResponse *)getTagIDListWithCategory:(DCCategory)category
                                       fileType:(DCFileType)fileType
                                minDateModified:(NSDate *)minDateModified
                                          error:(NSError **)error;

/*!
  Get the list of deleted content information.

  Do not call this method on the main thread.

#### Errors

  Following errors are notified from this method:

  - DCApplicationLayerErrorDomain
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR
    - DCAPPLICATIONLAYERERRORCODE_TIMEOUT
    - DCAPPLICATIONLAYERERRORCODE_SERVER_ERROR
  - DCConnectionErrorDomain
  - DCHttpErrorDomain
  - DCResponseBodyParseErrorDomain
  - DCTokenExpiredErrorDomain

  Detail of errors are described at
  getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:

  @param fileType The file type to select contents. This API does not
  support DCFILETYPE_ALL. See DCFileType for details.
  @param minDateDeleted The filter of minimum deleted date time.
  Contents are selected if content's deleted date time is equal or
  greater than this value. This parameter is optional.
  @param maxResults The maximum of results in list. This parameter is
  optional. If this parameter is null, then 100 is used. Domain of
  this parameter is between 1 and 100. Otherwise this method
  fails. The content of this NSNumber must be int.
  @param start The start index of selected results.  This parameter
  is optional. If this parameter is null, then 1 is used.  Domain of
  this parameter is equal or greater than 1.  Otherwise, this method
  fails. The content of this NSNumber must be int.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns the list of deleted content information, nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (DCContentGUIDListResponse *)
        getContentDeletionHistoryWithFileType:(DCFileType)fileType
                               minDateDeleted:(NSDate *)minDateDeleted
                                   maxResults:(NSNumber *)maxResults
                                        start:(NSNumber *)start
                                        error:(NSError **)error;

/*!
  Get content body data.

  Do not call this method on the main thread.

#### Errors

  Following errors are notified from this method:

  - DCApplicationLayerErrorDomain
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR
    - DCAPPLICATIONLAYERERRORCODE_TARGET_NOT_FOUND
    - DCAPPLICATIONLAYERERRORCODE_TIMEOUT
    - DCAPPLICATIONLAYERERRORCODE_SERVER_ERROR
  - DCConnectionErrorDomain
  - DCHttpErrorDomain
  - DCResponseBodyParseErrorDomain
  - DCTokenExpiredErrorDomain

  Detail of errors are described at
  getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:

  @param fileType The file type to select contents. This API does not
  support DCFILETYPE_ALL. See DCFileType for details.
  @param contentGUID guid of selecting content.
  @param resizeType The resize type. if DCRESIZETYPE_RESIZED_IMAGE or
  DCRESIZETYPE_RESIZED_VIDEO is selected, then returned content is
  resized. See DCResizeType for details. resizeType is restricted by
  fileType. Detail of the restrictions are shown by following table:

  DCFileType             | Allowed DCResizeType
  -----------------------|----------------------------------------
  DCFILETYPE_IMAGE       | DCRESIZETYPE_ORIGINAL, DCRESIZETYPE_RESIZED_IMAGE
  DCFILETYPE_SLIDE_MOVIE | DCRESIZETYPE_ORIGINAL, DCRESIZETYPE_RESIZED_IMAGE
  DCFILETYPE_VIDEO       | DCRESIZETYPE_ORIGINAL, DCRESIZETYPE_RESIZED_IMAGE, DCRESIZETYPE_RESIZED_VIDEO

  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns content body data, nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (DCContentBodyInfo *)
        getContentBodyInfoWithFileType:(DCFileType)fileType
                           contentGUID:(DCContentGUID *)contentGUID
                            resizeType:(DCResizeType)resizeType
                                 error:(NSError **)error;

/*!
  Get thumbnails.

  Do not call this method on the main thread.

#### Errors

  Following errors are notified from this method:

  - DCApplicationLayerErrorDomain
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR
    - DCAPPLICATIONLAYERERRORCODE_TARGET_NOT_FOUND
    - DCAPPLICATIONLAYERERRORCODE_TIMEOUT
    - DCAPPLICATIONLAYERERRORCODE_SERVER_ERROR
  - DCConnectionErrorDomain
  - DCHttpErrorDomain
  - DCResponseBodyParseErrorDomain
  - DCTokenExpiredErrorDomain

  Detail of errors are described at
  getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:

  @param contentGUIDs The guids to select thumbnails. This parameter has
  30 guids at the maximum.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns the list of thumbnails, nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
-(DCContentThumbnailInfoList *)
        getContentThumbnailInfoWithContentGUIDArray:(NSArray *)contentGUIDs
                                              error:(NSError **)error;

/*!
  Upload a content body data.

  Do not call this method on the main thread.

#### Errors

  Following errors are notified from this method:

  - DCUploadErrorDomain
    - DCAPPLICATIONLAYERERRORCODE_CONTENTS_DUPLICATED
    - DCAPPLICATIONLAYERERRORCODE_CAPACITY_OVER
    - DCAPPLICATIONLAYERERRORCODE_MANDATORY_PARAMETER_MISSED
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_SIZE_UNMATCHED
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_TYPE_UNMATCHED
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_VALUE_INVALID
  - DCConnectionErrorDomain
  - DCHttpErrorDomain
  - DCResponseBodyParseErrorDomain
  - DCTokenExpiredErrorDomain

  Detail of errors are described at
  getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:

##### Error domains
  Domain name         | Explanation
  --------------------|---------------------------
  DCUploadErrorDomain | This error is raised when upload is failed.

##### User information

  This section shows key and type of value in userInfo of NSError.

###### DCUploadErrorDomain

Key         | Type of Value | Explanation
------------|---------------|-----------
errorItems  | NSArray *     | Elements of this NSArray are DCUploadErrorItem.

  @param fileType The file type to select contents. See DCFileType for
  details. This method can not use DCFILETYPE_SLIDE_MOVIE.
  @param fileName The file name with extension of this content.
  @param size The data size of this content. If fileType equals DCFILETYPE_IMAGE,
  the maximum of size is 30MB. If fileType equals DCFILETYPE_VIDEO,
  the maximum of size is 100MB.
  @param mimeType The mimeType of this content. See DCMimeType for
  details. mimeType is restricted by fileType. Detail of the
  restrictions are shown following table:

  DCFileType       | Allowed DCMimeType
  -----------------|----------------------------------------
  DCFILETYPE_IMAGE | DCMIMETYPE_JPEG, DCMIMETYPE_PJPEG
  DCFILETYPE_VIDEO | DCMIMETYPE_THREE_GP, DCMIMETYPE_AVI, DCMIMETYPE_QUICKTIME, DCMIMETYPE_MP4, DCMIMETYPE_VND_MTS, DCMIMETYPE_MPEG

  @param bodyStream InputStream to upload. If fileType equals DCFILETYPE_IMAGE,
  the maximum of data size is 30MB. If fileType equals DCFILETYPE_VIDEO,
  the maximum of data size is 100MB. (Same as size parameter)
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns ID of this uploaded content. This ID is assigned by
  server, nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
-(DCDataID *)uploadContentBodyWithFileType:(DCFileType)fileType
                                  fileName:(NSString *)fileName
                                      size:(long long)size
                                  mimeType:(DCMimeType)mimeType
                                bodyStream:(NSInputStream *)bodyStream
                                     error:(NSError **)error;

/*!
  Upload a content body data.

  Do not call this method on the main thread.

#### Errors

  Following errors are notified from this method:

  - DCApplicationLayerErrorDomain
    - DCAPPLICATIONLAYERERRORCODE_CONTENTS_DUPLICATED
    - DCAPPLICATIONLAYERERRORCODE_CAPACITY_OVER
    - DCAPPLICATIONLAYERERRORCODE_MANDATORY_PARAMETER_MISSED
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_SIZE_UNMATCHED
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_TYPE_UNMATCHED
    - DCAPPLICATIONLAYERERRORCODE_PARAMETER_VALUE_INVALID
  - DCConnectionErrorDomain
  - DCHttpErrorDomain
  - DCResponseBodyParseErrorDomain
  - DCTokenExpiredErrorDomain

  Detail of errors are described at
  getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:

  @param fileType The file type to select contents. See DCFileType for
  details. This method can not use DCFILETYPE_SLIDE_MOVIE.
  @param fileName The file name with extension of this content.
  @param size The data size of this content.
  @param mimeType The mimeType of this content. See DCMimeType for
  details. mimeType is restricted by fileType. Detail of the
  restrictions are shown following table:

  DCFileType       | Allowed DCMimeType
  -----------------|----------------------------------------
  DCFILETYPE_IMAGE | DCMIMETYPE_JPEG, DCMIMETYPE_PJPEG
  DCFILETYPE_VIDEO | DCMIMETYPE_THREE_GP, DCMIMETYPE_AVI, DCMIMETYPE_QUICKTIME, DCMIMETYPE_MP4, DCMIMETYPE_VND_MTS, DCMIMETYPE_MPEG

  @param bodyData Data to upload.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns ID of this uploaded content. This ID is assigned by
  server, nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
-(DCDataID *)uploadContentBodyWithFileType:(DCFileType)fileType
                                  fileName:(NSString *)fileName
                                      size:(long long)size
                                  mimeType:(DCMimeType)mimeType
                                  bodyData:(NSData *)bodyData
                                     error:(NSError **)error;

/*!
  Confirm maximum space and free space of this user.

  Do not call this method on the main thread.

#### Errors

  Following errors are notified from this method:

  - DCApplicationLayerErrorDomain
    - DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_FREE_SPACE
    - DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_MAXIMUM_SPACE
  - DCConnectionErrorDomain
  - DCHttpErrorDomain
  - DCResponseBodyParseErrorDomain
  - DCTokenExpiredErrorDomain

  Detail of errors are described at
  getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:

  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns Maximum space and free space of this user. maximum
  space can be negative if server does not response maximum
  space. nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (DCCapacityInfo *)getCapacityInfoWithError:(NSError **)error;

@end
