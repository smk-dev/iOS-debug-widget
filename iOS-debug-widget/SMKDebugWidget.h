//
//  SMKDebugWidget.h
//  iOS debug widget example
//
//  Created by smk-dev on 15.02.2014.
//  Copyright (c) 2014 smk-dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NSLog(...) SMKLog(__VA_ARGS__); //Direct calls to NSLog to our logging method

@interface SMKDebugWidget : UIView {
    bool enableNSLogging;
    UITextView* loggingView; //Logs are printed to here
}

// class methods
+ (SMKDebugWidget *)addToWindow:(UIWindow *)window;
+ (SMKDebugWidget *)addToMainWindow;
- (void)writeToLog:(NSString*)newLine;
- (void)enableLogging;

void SMKLog(NSString *format, ...);

@end

@interface SMKDebugWidgetButton : UIButton

@property (nonatomic, weak) UIView *toggleView;

@end
