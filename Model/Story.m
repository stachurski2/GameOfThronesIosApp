

#import "Story.h"


@implementation Story

-(id)initWith:(NSString*)title :(NSString*)abstract :(NSString*)thumbnail :(NSString*)url {
    self = [super init];
    self.title = title;
    self.abstract = abstract;
    self.thumbnail = thumbnail;
    self.url = url;
    return self;
}
    
//-(id)initWith:(RealmStory*)rstory {
//    self = [super init];
//    
//}


@end


