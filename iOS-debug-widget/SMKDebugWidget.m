//
//  SMKDebugWidget.m
//  iOS debug widget example
//
//  Created by smk-dev on 15.02.2014.
//  Copyright (c) 2014 smk-dev. All rights reserved.
//

#import "SMKDebugWidget.h"
#import <QuartzCore/QuartzCore.h>
#define SMKLogBorderSize 20

@interface SMKDebugWidget ()

- (void)panGesture:(UIPanGestureRecognizer *)recognizer;
- (void)orientationDidChangeNotification:(NSNotification *)notification;

@end

@implementation SMKDebugWidget

#pragma mark - Logging

static SMKDebugWidget *cSelfRef; //reference of self for the C method to call on

void SMKLog(NSString *format, ...) {
    va_list argumentList;
    va_start(argumentList, format);
    NSMutableString * message = [[NSMutableString alloc] initWithFormat:format arguments:argumentList];
    
    //Output message into our console
    [cSelfRef writeToLog:message];
    
    NSLogv(message, argumentList);
    va_end(argumentList);
}

- (void)writeToLog:(NSString*)newLine{
    if(enableNSLogging)
    {
        loggingView.text = [loggingView.text stringByAppendingString:[NSString stringWithFormat:@" - %@\n",newLine]];
        [loggingView scrollRangeToVisible:NSMakeRange([loggingView.text length], 0)]; //Scroll to bottom
    }
}

- (void)enableLogging {
    enableNSLogging = true;
    cSelfRef = self;
    [self setupLogging];
}

#pragma mark - Lifecycle

- (void)awakeFromNib {
    self.layer.cornerRadius = 5.0f;
    
    // add pan gesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
    
    // watch for orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setupLogging {
    loggingView = [[UITextView alloc]initWithFrame:CGRectMake((SMKLogBorderSize/2), (SMKLogBorderSize/2), self.frame.size.width-SMKLogBorderSize, self.frame.size.height-SMKLogBorderSize) ]; //Put in the center of our area
    
    //Log Style
    [loggingView setBackgroundColor:[UIColor lightGrayColor]];
    [loggingView setTextColor:[UIColor blueColor]];
    
    [self addSubview:loggingView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - Private methods

- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    
    // handle move
    if ((recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [recognizer translationInView:recognizer.view.superview];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    }
    
    // handle offscreen
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGRect frame = recognizer.view.frame;
        if (frame.origin.x < 0.0f) {
            frame.origin.x = 0.0f;
        }
        if (frame.origin.y < 0.0f) {
            frame.origin.y = 0.0f;
        }
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        if (frame.origin.x + frame.size.width > screenRect.size.width) {
            frame.origin.x = screenRect.size.width - frame.size.width;
        }
        if (frame.origin.y + frame.size.height > screenRect.size.height) {
            frame.origin.y = screenRect.size.height - frame.size.height;
        }
        
        recognizer.view.frame = frame;
    }
}

- (void)orientationDidChangeNotification:(NSNotification *)notification {
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    BOOL changed = NO;
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft) {
        transform = CGAffineTransformMakeRotation(-M_PI_2);
        changed = YES;
    }
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {
        transform = CGAffineTransformMakeRotation(M_PI_2);
        changed = YES;
    }
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait) {
        transform = CGAffineTransformMakeRotation(0);
        changed = YES;
    }
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
        transform = CGAffineTransformMakeRotation(M_PI);
        changed = YES;
    }
    
    // animated
    if (changed) {
        [UIView animateWithDuration:0.3f animations:^{
            self.transform = transform;
        }];
    }
}

#pragma mark - Class methods

+ (SMKDebugWidget *)addToMainWindow {
    return [SMKDebugWidget addToWindow:[UIApplication sharedApplication].keyWindow];
}

+ (SMKDebugWidget *)addToWindow:(UIWindow *)window {
    
    // add only in debug mode - prevents from using widget by end users
#ifdef DEBUG
    
    // load widget from xib
    SMKDebugWidget *debugWidget = [[[NSBundle mainBundle] loadNibNamed:@"SMKDebugWidget" owner:nil options:nil] lastObject];
    debugWidget.center = window.center;
    
    // this is required to append subview
    [window makeKeyAndVisible];
    [window addSubview:debugWidget];
    
    // because window doesn't receive orientation changes we must watch the by ourselves
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    // also add button to toggle visibility of widget
    SMKDebugWidgetButton *toggleButton = [[SMKDebugWidgetButton alloc] init];
    toggleButton.toggleView = debugWidget;
    [window addSubview:toggleButton];
    
    return debugWidget;
    
#endif
    
    return nil;
}

@end

@implementation SMKDebugWidgetButton

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.frame = CGRectMake(0, 0, 25, 25);
        self.layer.cornerRadius = 13.0f;
        [self orientationDidChangeNotification:nil];
        
        // button action
        [self addTarget:self action:@selector(toogleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // watch for orientation changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - Private methods

- (void)orientationDidChangeNotification:(NSNotification *)notification {
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect frame = self.frame;
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft) {
        frame = CGRectMake(screenRect.size.width - frame.size.width, 0, frame.size.width, frame.size.height);
    }
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {
        frame = CGRectMake(0, screenRect.size.height - frame.size.height, frame.size.width, frame.size.height);
    }
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait) {
        frame = CGRectMake(screenRect.size.width - frame.size.width, screenRect.size.height - frame.size.height, frame.size.width, frame.size.height);
    }
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown) {
        frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    self.frame = frame;
}

- (void)toogleButtonAction:(id)sender {
    
    // show
    if (self.toggleView) {
        self.toggleView.hidden = !self.toggleView.hidden;
    }
}

@end
