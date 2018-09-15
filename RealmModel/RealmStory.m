#import "RealmStory.h"

@implementation RealmStory

-(id)initWith:(Story *)story {
    self = [super init];
    self.title = story.title;
    self.abstract = story.abstract;
    self.thumbnail = story.thumbnail;
    self.url = story.url;
    return self;
}

@end

