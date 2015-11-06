#import <Foundation/Foundation.h>

/*!
  Applications request permissions to Docomo Authentication server
  with these Scopes.

  This class provides scope strings defined in docomo Developer
  support API common reference version 2.0.0. Document is placed
  [here](http://dev.smt.docomo.ne.jp/).
 */
@interface DCScope : NSObject

/*!
  A scope to get a list of PhotoColle photos and movies.

  This scope enables following APIs:

  * [DCPhotoColle getContentIDListWithFileType:forDustbox:dateFilter:maxResults:start:sortType:error:]
  * [DCPhotoColle getContentDeletionHistoryWithFileType:minDateDeleted:maxResults:start:error:]

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)photoGetContentsList;

/*!
  A scope to get a PhotoColle photo or movie.

  This scope enables following APIs:

  * [DCPhotoColle getContentBodyInfoWithFileType:contentGUID:resizeType:error:]
  * [DCPhotoColle getContentThumbnailInfoWithContentGUIDArray:error:]

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)photoGetContent;

/*!
  A scope to upload a PhotoColle photo or movie.

  This scope enables following API:

  * [DCPhotoColle uploadContentBodyWithFileType:fileName:size:mimeType:bodyStream:error:]
  * [DCPhotoColle uploadContentBodyWithFileType:fileName:size:mimeType:bodyData:error:]

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)photoUploadContent;

/*!
  A scope to confirm vacant size of PhotoColle.

  This scope enables following API:

  * [DCPhotoColle getCapacityInfoWithError:]

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)photoGetVacantSize;

/*!
  A scope to update rotation information of a PhotoColle photo.

  Current PhotoColleSDK does not adapt this feature. The method using
  this feature will be provided in future.

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)photoUpdateRotateInfo;

/*!
  A scope to update trash information of a PhotoColle photo and movie.

  Current PhotoColleSDK does not adapt this feature. The method using
  this feature will be provided in future.

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)photoUpdateTrashInfo;

/*!
  A scope to get a list of tags and a list of PhotoColle photos and
  movies with tags.


  If applications want to use this scope, you need to demand to
  docomo. This scope enables following APIs:

  * [DCPhotoColle getContentIDListWithTagsWithProjectionType:fileType:criteriaList:forDustbox:dateFilter:maxResults:start:sortType:error:]
  * [DCPhotoColle getTagIDListWithCategory:fileType:minDateModified:error:]

  @return secret scope need to demand to docommo.
 */
+ (NSString *)photoGetGroupInfo;

/*!
  A scope to get allowed friends bidirectional information of Docomo
  phonebook.

  PhotoColleSDK does not have a method to use this feature.

  Current Docomo phonebook server does not adapt this feature. The
  feature concerned this scope will be provided in future.

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)phonebookAllowedFriendsBidirectional;

/*!
  A scope to post feed of Docomo phonebook.

  PhotoColleSDK does not have a method to use this feature.

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)phonebookPostFeed;

/*!
  A scope to add contact of Docomo phonebook.

  PhotoColleSDK does not have a method to use this feature.

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)phonebookAddContact;

/*!
  A scope to access service folder of data management box.

  PhotoColleSDK does not have a method to use this feature.

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)databoxAll;

/*!
  A scope to get user id.

  PhotoColleSDK does not have a method to use this feature.

  @return scope string defined in docomo Developer support version 2.0.0.
 */
+ (NSString *)userid;

@end
