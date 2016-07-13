#import <Foundation/Foundation.h>

/*!
  Context of an authentication.
 */
@interface DCAuthenticationContext : NSObject

/*!
 * An access token retrieved by DCAuthority.
 *
 * This is an access token retrieved by DCAuthority. If you want to
 * access PhotoColle server without PhotoColleSDK, you can use this
 * access token.
 */
@property (nonatomic, readonly) NSString *accessToken;

/*!
  Check whether AuthenticateContext has stored or not.

#### Errors

  A following error is notified from this method:

  - DCAuthenticationContextAccessErrorDomain

  Detail of errors are described at loadByKey:error:

  @param key A key to specify an AuthenticationContext object to
  check. must not be nil or empty.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Returns YES if DCAuthenticationContext exists, otherwise NO.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
+ (BOOL)hasSavedByKey:(NSString *)key
                error:(NSError **)error;

/*!
  Load DCAuthenticationContext object.

#### Errors

##### Error domains

  This method notifies NSError at error situation. Domains notified by
  this method are followings:

Domain name                    | Explanation
-------------------------------------------|---------------------------
DCAuthenticationContextAccessErrorDomain   | This error is raised when failed to access stored.
DCAuthenticationContextNotFoundErrorDomain | This error is raised when AuthenticationContext does not stored.

##### Error codes

  DCAuthenticationContextAccessErrorDomain have an error code to show
  detail of the error. Type of error codes was
  DCAuthenticationContextAccessErrorReason.

##### User information

  This section shows key and type of value in userInfo of NSError.

###### DCAuthenticationContextAccessErrorDomain

Key                       | Type of Value | Explanation
--------------------------|---------------|-----------
NSUnderlyingErrorKey      | NSError *     | Cause of authentication context access error.
NSLocalizedDescriptionKey | NSString *    | Description of this error.

NSUnderlyingErrorKey contains error raised from gtm-oauth2 and
KeyChain service since storing DCAuthenticationContext object depends
on those components.

NSUnderlyingErrorKey and NSLocalizedDescriptionKey are defined NSError.h

  @param key A key to specify an DCAuthenticationContext object to
  load. must not be nil or empty.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Loaded DCAuthenticationContext object. nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
  @warning This method is deprecated. replaced by <[DCAuthenticationContext loadByKey:clientId:clientSecret:error:]>.
  @deprecated This method is deprecated.
 */
+ (DCAuthenticationContext *)loadByKey:(NSString *)key
                                 error:(NSError **)error __attribute__((deprecated("Use [DCAuthenticationContext loadByKey:clientId:clientSecret:error]")));

/*!
  Load DCAuthenticationContext object.

#### Errors

##### Error domains

  This method notifies NSError at error situation. Domains notified by
  this method are followings:

Domain name                    | Explanation
-------------------------------------------|---------------------------
DCAuthenticationContextAccessErrorDomain   | This error is raised when failed to access stored.
DCAuthenticationContextNotFoundErrorDomain | This error is raised when AuthenticationContext does not stored.

##### Error codes

  DCAuthenticationContextAccessErrorDomain have an error code to show
  detail of the error. Type of error codes was
  DCAuthenticationContextAccessErrorReason.

##### User information

  This section shows key and type of value in userInfo of NSError.

###### DCAuthenticationContextAccessErrorDomain

Key                       | Type of Value | Explanation
--------------------------|---------------|-----------
NSUnderlyingErrorKey      | NSError *     | Cause of authentication context access error.
NSLocalizedDescriptionKey | NSString *    | Description of this error.

NSUnderlyingErrorKey contains error raised from gtm-oauth2 and
KeyChain service since storing DCAuthenticationContext object depends
on those components.

NSUnderlyingErrorKey and NSLocalizedDescriptionKey are defined NSError.h

  @param key A key to specify an DCAuthenticationContext object to
  load. must not be nil or empty.
  @param clientId A client ID issued by docomo Developer support. must
  not be nil or empty.
  @param clientSecret A client secret issued by docomo Developer
  support. must not be nil or empty.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Loaded DCAuthenticationContext object. nil on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
+ (DCAuthenticationContext *)loadByKey:(NSString *)key
                              clientId:(NSString *)clientId
                          clientSecret:(NSString *)clientSecret
                                 error:(NSError **)error;

/*!
  Remove an DCAuthenticationContext object.

  The DCAuthenticationContext object which is removed by this method can
  not load by the loadByKey:error:.

#### Errors

  Following errors are notified from this method:

  - DCAuthenticationContextAccessErrorDomain

  Detail of errors are described at loadByKey:error:

  @param key A key to specify an DCAuthenticationContext object to
  remove. must not be nil or empty.
  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Return YES if success, NO on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
+ (BOOL)removeByKey:(NSString *)key
              error:(NSError **)error;

/*!
  Remove all stored DCAuthenticationContext objects.

#### Errors

  Following errors are notified from this method:

  - DCAuthenticationContextAccessErrorDomain

  Detail of errors are described at loadByKey:error:

  @param error If an error occurs, upon returns contains an NSError
  object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Return YES if success, NO on failure.
*/
+ (BOOL)removeAllWithError:(NSError **)error;

/*!
  Save DCAuthenticationContext object.

#### Errors

  Following errors are notified from this method:

  - DCAuthenticationContextAccessErrorDomain

  Detail of errors are described at loadByKey:error:

  @param key A key to save an DCAuthenticationContext object. must not
  be nil or empty.
  @param accessibility Accessibility of saved authentication
  context. Acceptable values are followrings:

  - kSecAttrAccessibleWhenUnlocked
  - kSecAttrAccessibleAfterFirstUnlock
  - kSecAttrAccessibleAlways
  - kSecAttrAccessibleWhenUnlockedThisDeviceOnly
  - kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
  - kSecAttrAccessibleAlwaysThisDeviceOnly

  Detail of these value are described at [Keychain Services Reference](https://developer.apple.com/library/ios/documentation/Security/Reference/keychainservices/Reference/reference.html#//apple_ref/doc/uid/TP30000898-CH4g-SW318)

  @param error If an error occurs, upon returns contains an
  NSError object that describes the problem. nil can be passed but not
  recommended to handle errors property.
  @return Return YES if success, NO on failure.
  @exception NSInvalidArgumentException One or more arguments are invalid.
 */
- (BOOL) saveByKey:(NSString *)key
     accessibility:(CFTypeRef)accessibility
             error:(NSError **)error;

/*!
  Remaining time of this DCAuthenticationContext in seconds.

  Returns remaining time of this DCAuthenticationContext in seconds.
  If remaining time is more than 0, access token of this
  DCAuthenticationContext is valid at the time. If remaining time is
  equals or less than 0, applications should refresh access token.
 */
- (NSTimeInterval)remainingTimeInSeconds;

@end
