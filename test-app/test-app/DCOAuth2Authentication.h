#import "GTMOAuth2Authentication.h"

@interface DCOAuth2Authentication : DCGTMOAuth2Authentication

@property (nonatomic, readwrite, assign) CFTypeRef accessibility;

// Override.
- (NSString *)persistenceResponseString;
- (void)setKeysForResponseString:(NSString *)str;

@end
