#import "DCDataID.h"

@interface DCDataID ()

@property (nonatomic, readwrite, strong) NSString *stringValue;

- (id)initWithID:(NSString *)string;

@end
