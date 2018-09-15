#import <UIKit/UIKit.h>
#import "APIClient.h"


@implementation APIClient
    
+ (id)shared {
    static APIClient *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}


- (id)init {
    self = [super init];
    return self;
}

- (void)requestServer:(BaseRequest*)WithRequest {

    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithRequest:WithRequest.request
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              NSInteger statusCode = 0;
                                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                  statusCode = httpResponse.statusCode;
                                                  if (statusCode == 200){
                                                      NSError *parseError = nil;
                                                      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                      WithRequest.actionSuccess(responseDictionary);
                                                  }
                                                  else {
                                                      WithRequest.actionUnSuccess();
                                                  }
                                                 NSLog(@"Server response at code: %ld",(long)statusCode);
                                          }];

    [downloadTask resume];
}
    @end
