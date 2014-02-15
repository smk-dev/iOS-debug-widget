//
//  SMKDebugWidget.h
//  iOS debug widget example
//
//  Created by smk-dev on 15.02.2014.
//  Copyright (c) 2014 smk-dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMKDebugWidget : UIView

// class methods
+ (SMKDebugWidget *)addToWindow:(UIWindow *)window;
+ (SMKDebugWidget *)addToMainWindow;

@end

@interface SMKDebugWidgetButton : UIButton

@property (nonatomic, weak) UIView *toggleView;

@end
