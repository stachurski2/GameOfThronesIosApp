#import "CategoryRequest.h"

@implementation CategoryRequest

-(void)defineCategory:(NSString *)Category {
   // [self.request setValue:Category forKey:@"category"];
    //[self.request.URL setValue:Category forKey:@"category"];
    NSLog(@"%@", Category);
}

-(void)defineMaxItem:(NSString *)Number {

}

-(id)initWith:(NSString*)url :(NSString*)limit :(NSString*)category :(NSString*)parameter {
    self = [super init];
    NSString *temp = url;
    temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%@&%@&%@",parameter,limit,category]];
    NSURL *tempURL = [NSURL URLWithString:temp];
    self.request = [[NSMutableURLRequest alloc] initWithURL:tempURL];
    return self;
}

@end
