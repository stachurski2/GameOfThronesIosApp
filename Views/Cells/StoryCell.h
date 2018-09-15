#import <UIKit/UIKit.h>
#import "Story.h"
#import "Masonry.h"

@interface StoryCell : UITableViewCell

@property UIView *myView;

@property UILabel *labelTitle;

@property UILabel *labelAbstract;

@property UIButton *buttonGoToWiki;

@property UIButton *buttonAddToFavorites;

@property UIButton *buttonShowLess;

@property UIImageView *image;

@property void (^detailAction)(void);

@property void (^addToFavAction)(void);

@property void (^deleteFromFavAction)(void);


-(void)loadImageFrom:(NSString*)URL;

-(void) extendCell;

-(void)setupConstraints;

-(void)showDetails;

-(void)addToFav;

-(void)deleteFromFav;

@end
