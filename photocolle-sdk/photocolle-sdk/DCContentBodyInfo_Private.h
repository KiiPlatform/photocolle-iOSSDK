#import "DCContentBodyInfo.h"

@interface DCContentBodyInfo ()

@property (nonatomic, readwrite) DCMimeType contentType;
@property (nonatomic, readwrite, strong) NSInputStream *inputStream;

- (id)initWithContentType:(DCMimeType)contentType
              inputStream:(NSInputStream *)inputStream;

- (void)dealloc;

@end
