#import "BaseRequest.h"

@interface CategoryRequest : BaseRequest

-(void)defineCategory:(NSString *)Category;

-(void)defineMaxItem:(NSString *)Number;

-(id)initWith:(NSString*)url :(NSString*)limit :(NSString*)category :(NSString*)parameter;

@end
