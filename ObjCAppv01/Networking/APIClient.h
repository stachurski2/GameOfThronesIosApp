#import "BaseRequest.h"


@interface APIClient : NSObject

@property NSURLResponse *response;

@property NSError *error;

+(id)shared;

-(void)requestServer:(BaseRequest*)WithRequest;

@end
