#import <UIKit/UIKit.h>


@interface Story : NSObject

@property NSString *title;

@property NSString *abstract;

@property NSString *thumbnail;

@property NSString *url;

-(id)initWith :(NSString*)title :(NSString*)abstract :(NSString*)thumbnail :(NSString*)url;

@end

