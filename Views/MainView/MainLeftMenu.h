//
//  MainLeftMenu.h
//  ObjectiveC App
//
//  Created by Stanisaw Sobczyk on 04/05/2018.
//  Copyright © 2018 Stanisaw Sobczyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainLeftMenu : UIView

-(id)initWithFrame:(CGRect)frame;

-(void)addButtonWith:(NSString*)Name refferedTo:(NSObject*)Object with:(SEL)Selector;

-(void)Refresh;

@end
