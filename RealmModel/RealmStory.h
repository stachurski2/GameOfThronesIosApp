#import <Realm/Realm.h>
#import "Story.h"

@interface RealmStory: RLMObject

-(id) initWith:(Story*)story;

@property NSString *title;

@property NSString *abstract;

@property NSString *thumbnail;

@property NSString *url;

@end
