#import <Foundation/Foundation.h>
@interface BaseRequest : NSObject
    
@property (nonatomic, readwrite, retain) NSMutableURLRequest *request;

@property void (^actionSuccess)(NSDictionary *dic);

@property void (^actionUnSuccess)(void);


-(id)initWith:(NSString*) url;

-(void)defineMethodWith:(NSString*)Method;




@end
