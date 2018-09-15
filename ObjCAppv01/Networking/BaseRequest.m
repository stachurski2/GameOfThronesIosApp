#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@implementation BaseRequest

-(id)initWith:(NSString*) url {
    self = [super init];
    NSURL *tempURL = [NSURL URLWithString:url];
    self.request = [[NSMutableURLRequest alloc] initWithURL:tempURL];
    return self; 
}

-(void)defineMethodWith:(NSString *)Method{
    _request.HTTPMethod = Method;
    [_request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

}



@end
