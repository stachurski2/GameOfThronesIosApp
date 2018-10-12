#import "MainViewController.h"
#import "Story.h"




@implementation MainViewController

-(void)loadView{
    _contentView = [[MainView alloc]initWithFrame:CGRectZero];
    self.view = _contentView;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [_contentView.menuButton  addTarget:_contentView action:@selector(menuShowing) forControlEvents:UIControlEventTouchUpInside];
    [_contentView.clearButton addTarget:self action:@selector(exitApp) forControlEvents:UIControlEventTouchUpInside];
    [_contentView.menu addButtonWith:@"Favorites" refferedTo:self with:@selector(getFavorites)];
    [_contentView.menu addButtonWith:@"Most viewed" refferedTo:self with:@selector(getMostViewed)];
    [_contentView.menu addButtonWith:@"Characters" refferedTo:self with:@selector(getCharacters)];
    [_contentView.menu addButtonWith:@"New arcticles" refferedTo:self with:@selector(getNewArticles)];
    [_contentView.menu Refresh];
    _contentView.tableView.dataSource = self;
    _contentView.tableView.delegate = self;
    _contentView.tableView.estimatedRowHeight = 50;
    _contentView.tableView.rowHeight = UITableViewAutomaticDimension;
    self.req = [[CategoryRequest alloc]  initWith:@"http://gameofthrones.wikia.com/api/v1/Articles/New?" :@"limit=75" :@"" :@"expand=1"];
    [self configureBlock];
    [APIClient.shared requestServer:_req];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]  initWithTarget:self action:@selector(extendCell:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    [self.contentView.tableView addGestureRecognizer:lpgr ];
    self.dst = web;

                                          
}

-(void)exitApp {
    exit(0);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

-(void)getNewArticles {
    self.req = [[CategoryRequest alloc]  initWith:@"http://gameofthrones.wikia.com/api/v1/Articles/New?" :@"limit=75" :@"" :@"expand=1"];
    [self configureBlock];
    self.dst = web;
    [APIClient.shared requestServer:_req];
    [_contentView menuShowing];
}

-(void)getCharacters {
    self.req =  [[CategoryRequest alloc] initWith:@"http://gameofthrones.wikia.com/api/v1/Articles/Top?" :@"limit=75" :@"category=Characters":@"expand=1"];
    [self configureBlock];
    self.dst = web;
    [APIClient.shared requestServer:_req];
    [_contentView menuShowing];
}

-(void)getMostViewed {
    self.req = [[CategoryRequest alloc]  initWith:@"http://gameofthrones.wikia.com/api/v1/Articles/Top?" :@"limit=75" :@"" :@"expand=1"];
    [self configureBlock];
    self.dst = web;
    [APIClient.shared requestServer:_req];
    [_contentView menuShowing];
}


-(void)getFavorites {
    self.dst = realm;
    [_contentView menuShowing];
    [_contentView.tableView reloadData];
    
}

- (void)extendCell:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint p = [gestureRecognizer locationInView:self.contentView.tableView];
        
        NSIndexPath *indexPath = [self.contentView.tableView indexPathForRowAtPoint:p];
        if (indexPath == nil) {
            NSLog(@"long press on table view but not on a row");
        } else {
             StoryCell *cell = [self.contentView.tableView cellForRowAtIndexPath:indexPath];
             [cell extendCell];
            NSLog(@"%f",cell.frame.size.height);

            [_contentView.tableView beginUpdates];
            [_contentView.tableView endUpdates];
            _extentedCells[indexPath.row] = [NSNumber numberWithBool:YES];
            NSLog(@"%f",cell.frame.size.height);
            _cellsHeight[indexPath.row] = [NSNumber numberWithFloat:cell.frame.size.height];
        }
    
}


- (void)configureBlock {
    void (^block)(NSDictionary* dic) = ^(NSDictionary* dic) {
        self.stories = [NSMutableArray array];
        NSArray *items = dic[@"items"];
        self->_extentedCells =  [[NSMutableArray alloc] init];
        self->_cellsHeight = [[NSMutableArray alloc] init];
        for(int i=0;i<items.count;i++){
            NSDictionary *item = items[i];
            Story *s = [[Story alloc] initWith:item[@"title"] :item[@"abstract"] :item[@"thumbnail"] :item[@"url"]];
            s.abstract = item[@"abstract"];
            [self->_extentedCells addObject:[NSNumber numberWithBool:NO]];
            [self->_cellsHeight addObject:[NSNumber numberWithFloat:0]];
            [self.stories addObject:s];
        }
     
        NSLog(@"%lu",(unsigned long)self.stories.count);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self->_contentView.tableView reloadData];
          
        });
    };
    
    void (^unSuccesBlock)(void) = ^(){
        [self.stories removeAllObjects];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self->_contentView.tableView reloadData];
        });
    };


    _req.actionUnSuccess = unSuccesBlock;
    _req.actionSuccess = block;
    
    
};


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    StoryCell *cell = (StoryCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[StoryCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSString *thumbnail = @"";
    
    if(_dst == realm) {
        RLMResults<RealmStory *> *realmStories = [RealmStory allObjects];
        RealmStory *s = realmStories[indexPath.row];
        cell.labelTitle.text = s.title;
        cell.labelAbstract.text = s.abstract;
        thumbnail  = s.thumbnail;
        
        void (^action)(void) = ^(){
            NSString *base = @"http://gameofthrones.wikia.com/";
            base =  [base stringByAppendingString:s.url];
            NSURL *nsUrl = [NSURL URLWithString:base];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:nsUrl options:[NSDictionary new] completionHandler:^(BOOL success) {
                    
                }];
            }
            
        };
        cell.detailAction = action;

        [cell.buttonAddToFavorites setImage:[UIImage imageNamed:@"MarkedStar"] forState:UIControlStateNormal];
        [cell.buttonAddToFavorites addTarget:cell action:@selector(deleteFromFav) forControlEvents:UIControlEventTouchUpInside];
        NSString *firstString = @"url == \'";
        firstString = [firstString stringByAppendingString:s.url];
        firstString = [firstString stringByAppendingString:@"\'"];

        cell.deleteFromFavAction = ^{
            NSLog(@"rem");
            RLMResults<RealmStory *> *favs = [RealmStory objectsWhere:firstString];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                [realm deleteObjects:favs];
            }];
            [self->_contentView.tableView reloadData];
         
        };
    } else {
        if(self.stories.count == 0){
        cell.textLabel.text = @"No results or connection error.";

    }
    else {
        if(indexPath.row < _stories.count) {
            Story *s = _stories[indexPath.row];
            cell.labelTitle.text = s.title;
            cell.labelAbstract.text = s.abstract;
            thumbnail = s.thumbnail;
            
            void (^action)(void) = ^(){
                NSString *base = @"http://gameofthrones.wikia.com/";
                base =  [base stringByAppendingString:s.url];
                NSURL *nsUrl = [NSURL URLWithString:base];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:nsUrl options:[NSDictionary new] completionHandler:^(BOOL success) {
                        
                    }];
                }
            };
            cell.detailAction = action;
                NSString *firstString = @"url == \'";
                firstString = [firstString stringByAppendingString:s.url];
                firstString = [firstString stringByAppendingString:@"\'"];
            
            cell.addToFavAction = ^(){
                 NSLog(@"add");
                RealmStory *r = [[RealmStory new]initWith:s];
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    [realm addObject:r];
                }];
                };
            
            cell.deleteFromFavAction = ^{
                NSLog(@"rem");
                RLMResults<RealmStory *> *favs = [RealmStory objectsWhere:firstString];
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    [realm deleteObjects:favs];
                }];
            };
            
            RLMResults<RealmStory *> *favs = [RealmStory objectsWhere:firstString];
            
            if(favs.count>0){
                 [cell.buttonAddToFavorites setImage:[UIImage imageNamed:@"MarkedStar"] forState:UIControlStateNormal];
                 [cell.buttonAddToFavorites addTarget:cell action:@selector(deleteFromFav) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [cell.buttonAddToFavorites setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
                [cell.buttonAddToFavorites addTarget:cell action:@selector(addToFav) forControlEvents:UIControlEventTouchUpInside];
            }
            
 
            
        }
    
        
    }
        
    }
    [cell setupConstraints];
    
    if (_extentedCells[indexPath.row] == [NSNumber numberWithBool:YES]) {
        {
            [cell extendCell];
        }
    }

   [cell loadImageFrom:thumbnail];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RLMResults<RealmStory *> *favs = [RealmStory allObjects];

    switch (_dst) {
            case realm:
            
            _extentedCells = [NSMutableArray array];
            _cellsHeight = [NSMutableArray array];
            for(int i=0;i < favs.count; i++) {
                [_extentedCells addObject:[NSNumber numberWithBool:NO]];
                [_cellsHeight addObject:[NSNumber numberWithFloat:82]];
            }
            return favs.count;
            
            break;
            case web:
                if(self.stories.count == 0) {
                    return 1;
                }
                return self.stories.count;
            break;
    }
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeZero;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return true;
}

- (void)updateFocusIfNeeded {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (_extentedCells[indexPath.row] == [NSNumber numberWithBool:YES]) {
              return [_cellsHeight[indexPath.row] floatValue];
      } else {
          return UITableViewAutomaticDimension;
      }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end

