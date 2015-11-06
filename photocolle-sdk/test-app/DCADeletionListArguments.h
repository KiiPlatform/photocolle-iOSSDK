#import <Foundation/Foundation.h>
#import "DCEnumerations.h"

@interface DCADeletionListArguments : NSObject

@property (nonatomic, readwrite) DCFileType fileType;

@property (nonatomic, readwrite, strong) NSDate *minDateDeleted;

@property (nonatomic, readwrite, strong) NSNumber *maxResults;

@property (nonatomic, readwrite, strong) NSNumber *start;

- (id)init;

@end
