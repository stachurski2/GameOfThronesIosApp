

#import "MainLeftMenu.h"
#import "Masonry.h"


@implementation MainLeftMenu

NSMutableArray *buttons;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    buttons = [NSMutableArray array];
    return self;
}

-(void)addButtonWith:(NSString*)Name refferedTo:(NSObject*)Object with:(SEL)Selector {
    UIButton* newButton = [UIButton new];
    [newButton setTitle:Name forState:UIControlStateNormal];
    [newButton addTarget:Object action:Selector forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:newButton];
}

-(void)Refresh {
    for (int i = 0; i<buttons.count; i++) {
        [self addSubview:buttons[i]];
        NSInteger number = buttons.count;
        NSLog(@"%li", (long)number);
        [buttons[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(5);
            make.height.offset(30);
            make.top.equalTo(self).offset(5*(i-1)+30*i);
        }];
    }
}


@end
