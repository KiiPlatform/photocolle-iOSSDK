#import <Foundation/Foundation.h>

@protocol DCDTO;
@protocol DCLogic;
@class DCArguments;
@class DCAuthenticationContext;

@interface DCCommand : NSObject

- (id)initWithLogic:(id <DCLogic>)logic
            baseURL:(NSURL *)baseURL;

- (id)executeWithArgument:(DCArguments *)arguments
                    error:(NSError **)error;

+ (BOOL)signRequest:(NSMutableURLRequest *)request
        withContext:(DCAuthenticationContext *)context
              error:(NSError **)error;

+ (void)setJSONData:(NSDictionary *)json
          toRequest:(NSMutableURLRequest *)request;

@end
