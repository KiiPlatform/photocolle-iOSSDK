#import <Foundation/Foundation.h>

/*!
 * @constant DCApplicationLayerErrorDomain
 * @abstract Error domain araised when a request sending by PhotoColleSDK was
 * failed to execute on a server.
 */
extern NSString * const DCApplicationLayerErrorDomain;

/*!
 * @constant DCAuthenticationCanceledErrorDomain
 * @abstract Error domain araised when authentication is canceled by user.
 */
extern NSString * const DCAuthenticationCanceledErrorDomain;

/*!
 * @constant DCAuthenticationContextAccessErrorDomain
 * @abstract Error domain araised when failed to access stored
 * AuthenticationContext.
 */
extern NSString * const DCAuthenticationContextAccessErrorDomain;

/*!
 * @constant DCAuthenticationContextNotFoundErrorDomain
 * @abstract Error domain araised when AuthenticationContext does not stored.
 */
extern NSString * const DCAuthenticationContextNotFoundErrorDomain;

/*!
 * @constant DCAuthenticationErrorDomain
 * @abstract Error domain araised when authentication is failed.
 */
extern NSString * const DCAuthenticationErrorDomain;

/*!
 * @constant DCConnectionErrorDomain
 * @abstract Error domain araised when network IO error occurred.
 */
extern NSString * const DCConnectionErrorDomain;

/*!
 * @constant DCHttpErrorDomain
 * @abstract Error domain araised when PhotoColleSDK received unexpected status
 * code in HTTP session.
 */
extern NSString * const DCHttpErrorDomain;

/*!
 * @constant DCResponseBodyParseErrorDomain
 * @abstract Error domain araised when PhotoColleSDK receives unexptected
 * response body data from server, therefore, PhotoColleSDK failed to parse
 * response body data to return value of PhotoColleSDK methods.
 */
extern NSString * const DCResponseBodyParseErrorDomain;

/*!
 * @constant DCTokenExpiredErrorDomain
 * @abstract Error domain araised when token is expired.
*/
extern NSString * const DCTokenExpiredErrorDomain;

/*!
 * @constant DCUploadErrorDomain
 * @abstract Error domain araised when upload is failed.
 */
extern NSString * const DCUploadErrorDomain;

/**
  ErrorCode for DCApplicationLayerErrorDomain and DCUploadErrorDomain.
 */
typedef NS_ENUM(NSInteger, DCApplicationLayerErrorCode) {
    /** Something wrong with a parameter or parameters which a client sent.
     You need to fix parameters to retry the operation. */
    DCAPPLICATIONLAYERERRORCODE_PARAMETER_ERROR = 100,
    /** There is no targets to retrieve. You can not retry the operation. */
    DCAPPLICATIONLAYERERRORCODE_TARGET_NOT_FOUND = 101,
    /** Server process timeout. retry later. */
    DCAPPLICATIONLAYERERRORCODE_TIMEOUT = 110,
    /** Search result is empty. There is no result matched to query
     which client sent. */
    DCAPPLICATIONLAYERERRORCODE_NO_RESULTS = 113,
    /** Server process failed because of server internal error. You can not
     retry the operation. Please contact service provider. */
    DCAPPLICATIONLAYERERRORCODE_SERVER_ERROR = 900,
    /** Contents are duplicated. An uploading content is duplicated to other
     content in server. If you want to upload the content in client, you
     need to remove a duplicated content in server by other application. */
    DCAPPLICATIONLAYERERRORCODE_CONTENTS_DUPLICATED = 1101,
    /** Capacity of a user is over. Server reject an uploaded content
     because of capacity over. You need to remove conentes in server
     to upload new contents by other application. */
    DCAPPLICATIONLAYERERRORCODE_CAPACITY_OVER = 1102,
    /** Fail to get free space of a user. */
    DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_FREE_SPACE = 1103,
    /** Fail to get maximum space of a user. */
    DCAPPLICATIONLAYERERRORCODE_FAIL_TO_GET_MAXIMUM_SPACE = 1104,
    /** Contents not found. */
    DCAPPLICATIONLAYERERRORCODE_CONTENTS_NOT_FOUND = 1105,
    /** Mandatory parameter is missed. If you want to retry, check parameter. */
    DCAPPLICATIONLAYERERRORCODE_MANDATORY_PARAMETER_MISSED = 1110,
    /** Parameters sent by a client size is unmatched. If you want to retry,
     check parameter. */
    DCAPPLICATIONLAYERERRORCODE_PARAMETER_SIZE_UNMATCHED = 1111,
    /** Type of parameters are unmateched. If you want to retry,
     check parameter. */
    DCAPPLICATIONLAYERERRORCODE_PARAMETER_TYPE_UNMATCHED = 1112,
    /** Value of parameters are invalid. If you want to retry, check parameter. */
    DCAPPLICATIONLAYERERRORCODE_PARAMETER_VALUE_INVALID = 1113
};

/**
  Error reason for DCAuthenticationContextAccessErrorDomain
 */
typedef NS_ENUM(NSInteger, DCAuthenticationContextAccessErrorReason) {
    /** Fail to access AuthenticationContext. */
    DCAUTHENTICATIONCONTEXTACCESSERRORREASON_ACCESS_FAILED = 0
};

/**
  Error reason for DCAuthenticationErrorDomain.
 */
typedef NS_ENUM(NSInteger, DCAuthenticationErrorReason) {
    /** The request is missing a required parameter, includes an invalid
     parameter value, includes a parameter more than once, or is
     otherwise malformed. */
    DCAUTHENTICATIONERRORREASON_INVALID_REQUEST = 0,
    /** The authorization server does not support requested response
     type. */
    DCAUTHENTICATIONERRORREASON_UNSUPPORTED_RESPONSE_TYPE = 1,
    /** The authorization server encountered an unexpected condition
     that prevented it from fulfilling the request. */
    DCAUTHENTICATIONERRORREASON_SERVER_ERROR = 2,
    /** The provided authorization grant (e.g., authorization code,
     resource owner credentials) or refresh token is invalid, expired,
     revoked, does not match the redirection URI used in the
     authorization request, or was issued to another client. */
    DCAUTHENTICATIONERRORREASON_INVALID_GRANT = 3,
    /** Client authentication failed (e.g., unknown client, no client
     authentication included, or unsupported authentication method). */
    DCAUTHENTICATIONERRORREASON_INVALID_CLIENT = 4,
    /** The client is not authorized to request an authorization code
     using this method. */
    DCAUTHENTICATIONERRORREASON_UNAUTHORIZED_CLIENT = 5,
    /** The authorization grant type is not supported by the
     authorization server. */
    DCAUTHENTICATIONERRORREASON_UNSUPPORTED_GRANT_TYPE = 6,
    /** The requested scope is invalid, unknown, or malformed. */
    DCAUTHENTICATIONERRORREASON_INVALID_SCOPE = 7,
    /** The authorization server is currently unable to handle the request
     due to a temporary overloading or maintenance of the server. */
    DCAUTHENTICATIONERRORREASON_TEMPORARILY_UNAVAILABLE = 8,
    /** Refreshing access token is failed because of
     DCAuthenticationContext. This error occurs when
     DCAuthenticationContext does not have refresh token. */
    DCAUTHENTICATIONERRORREASON_NO_REFRESH_TOKEN = 9
};

/*!
 * Detail information of uploading error.
 */
@interface DCUploadErrorItem : NSObject

/*!
 * Error item name.
 */
@property (nonatomic, readonly) NSString *name;

/*!
 * Error code.
 */
@property (nonatomic, readonly) DCApplicationLayerErrorCode errorCode;

@end
