
#import "StoryCell.h"
#import <SDWebImage/UIImageView+WebCache.h>



@implementation StoryCell


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.labelTitle = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.labelAbstract = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.image = [[UIImageView alloc] init];
    self.buttonGoToWiki = [[UIButton alloc] init];
    self.buttonAddToFavorites = [[UIButton alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.myView = [[UIView alloc]initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_myView];
    
    [_buttonGoToWiki setTitle:@"Wiki" forState:UIControlStateNormal];
  

    self.labelAbstract.numberOfLines = 2;
    self.labelAbstract.textAlignment = NSTextAlignmentJustified;
    self.labelTitle.numberOfLines = 0;
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    [self.labelAbstract sizeToFit];
    
    [self.myView addSubview:_labelTitle];
    [self.myView addSubview:_labelAbstract];
    [self.myView addSubview:_image];
    
   
    [self.myView addSubview:_buttonGoToWiki];
    [self.myView addSubview:_buttonShowLess];
    [self.myView addSubview:_buttonAddToFavorites];
    
    [_buttonGoToWiki setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_buttonAddToFavorites setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_buttonShowLess setTitleColor:UIColor.blueColor forState:UIControlStateNormal];

    [_buttonGoToWiki addTarget:self action:@selector(showDetails) forControlEvents:UIControlEventTouchUpInside];
    self.clipsToBounds = YES;

    return self;
}



-(void)loadImageFrom:(NSString*)URL {
    
    

        if ([URL isEqual:[NSNull null]] || URL == NULL) {
            
            return;
        }
        else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.image sd_setImageWithURL:[NSURL URLWithString:URL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                [self.labelTitle  mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.top.equalTo(self->_myView.mas_top).offset(10);
                                    make.width.equalTo(self->_myView.mas_width);
                                    make.left.equalTo(self->_buttonAddToFavorites.mas_right).inset(10);
                                }];
                                
                                [self.labelAbstract mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.top.equalTo(self->_labelTitle.mas_bottom).offset(10);
                                    make.width.equalTo(self->_myView.mas_width).multipliedBy(0.7);
                                    make.left.equalTo(self->_myView.mas_left).offset(10);
                                }];
                                
                                
                                
                                [self.image mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.centerY.equalTo(self->_myView.mas_centerY);
                                    make.right.equalTo(self->_myView.mas_right).inset(10).priority(1);
                                    make.left.equalTo(self->_labelAbstract.mas_right).offset(10);
                                    make.width.equalTo(self->_myView.mas_width).multipliedBy(0.22);
                                    make.height.equalTo(self->_image.mas_width).multipliedBy(self->_image.image.size.height/self->_image.image.size.width);
                                }];
                            }];
                        });
      
        }

}


-(void) extendCell {
    _labelAbstract.numberOfLines = 0;
    [_labelTitle sizeToFit];
    [_labelAbstract sizeToFit];
    
    [self.buttonGoToWiki mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@10);
    }];
    

    
    

}

-(void)setupConstraints {
    
    [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
    
    [self.buttonAddToFavorites mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@20);
        make.left.equalTo(self->_myView.mas_left).offset(5);
        make.top.equalTo(self->_myView.mas_top).offset(5);
    }];
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_myView.mas_top).offset(10);
        make.width.equalTo(self->_myView.mas_width);
        make.left.equalTo(self->_buttonAddToFavorites.mas_right).inset(10);
    //        if(self.image == nil) {
    //            make.right.equalTo(self->_myView.mas_right).inset(10);
    //        } else {
    //            make.right.equalTo(self->_image.mas_left).inset(10);
    //        }
    }];
    
    [self.labelAbstract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_labelTitle.mas_bottom).offset(10);
        make.left.equalTo(self->_myView.mas_left).offset(10);
        make.width.equalTo(self->_myView.mas_width).multipliedBy(0.9);
    }];
    


    
    [self.buttonGoToWiki mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.height.equalTo(@1);
        make.centerX.equalTo(self->_myView.mas_centerX);
        make.top.equalTo(self->_labelAbstract.mas_bottom).offset(5);
        make.bottom.equalTo(self->_myView.mas_bottom).inset(5);
        
    }];
    
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_myView.mas_right).offset(-50);
        make.centerY.equalTo(self->_myView.mas_centerY);
        make.width.equalTo(@1);
        make.height.equalTo(@1);
    }];
    

    
    
}



-(void)showDetails {
    _detailAction();
}

-(void)addToFav {
     _addToFavAction();
    [_buttonAddToFavorites setImage:[UIImage imageNamed:@"MarkedStar"] forState:UIControlStateNormal];
    [_buttonAddToFavorites removeTarget:self action:@selector(addToFavAction) forControlEvents:UIControlEventTouchUpInside];
    [_buttonAddToFavorites addTarget:self action:@selector(deleteFromFav) forControlEvents:UIControlEventTouchUpInside];
}

-(void)deleteFromFav {
    _deleteFromFavAction();
    [_buttonAddToFavorites setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
    [_buttonAddToFavorites removeTarget:self action:@selector(deleteFromFav) forControlEvents:UIControlEventTouchUpInside];
    [_buttonAddToFavorites addTarget:self action:@selector(addToFav) forControlEvents:UIControlEventTouchUpInside];
    
}



@end
