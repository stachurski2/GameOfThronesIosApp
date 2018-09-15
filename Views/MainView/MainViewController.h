#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "MainView.h"
#import "APIClient.h"
#import "CategoryRequest.h"
#import "Story.h"
#import "StoryCell.h"
#import "RealmStory.h"

typedef enum dataSourceType : NSUInteger {
    realm,
    web
} dataSourceType;


@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(void)configureBlock;

@property MainView *contentView;

@property void (^block)(NSDictionary* dic);

@property NSMutableArray *stories;

@property CategoryRequest *req;

@property dataSourceType dst;

@property NSMutableArray* extentedCells; 

@end

