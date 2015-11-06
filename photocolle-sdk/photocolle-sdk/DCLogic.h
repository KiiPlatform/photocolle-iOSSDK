#import <Foundation/Foundation.h>

@protocol DCDTO;
@class DCArguments;

// FIXME: Protocol name DClogic does not match Naming rule of iOS.
// We should change this protocol name.
@protocol DCLogic <NSObject>

@required
- (NSMutableURLRequest *)createRequestWithURL:(NSURL *)url
                                    arguments:(DCArguments *)arguments
                                        error:(NSError **)error;

- (id)parseResponse:(NSURLResponse *)response
               data:(NSData *)data
              error:(NSError **)error;

- (NSURL *)getDefaultURL;

@end
