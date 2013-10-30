//
//  DHUpdaterView.m
//
//  Created by Mike Post on 21/04/13.
//  Copyright (c) 2013 Dashend. All rights reserved.
//
//  Github:
//
/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
 following conditions:
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
 OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 */


#import <QuartzCore/QuartzCore.h>
#import "DHUpdaterView.h"

CGFloat const DH_BACKGROUND_VIEW_RADIUS = 10.0;


@interface DHUpdaterView()

@property (nonatomic, assign) NSTimeInterval lastFadeInTime;

@property (nonatomic, assign, readwrite) BOOL isFlashing;

@property (nonatomic, strong) UIColor *flashColorOne;

@property (nonatomic, strong) UIColor *flashColorTwo;

/**
 Returns a default font to use when the updaterText hasn't been set, or returns the default font.
 @returns The font for the updaterText.
 */
- (UIFont *)defaultUpdaterTextFont;

/**
 Returns a default color to use when the updaterText hasn't been set, or returns the default color.
 @returns The color for the updaterText.
 */
- (UIColor *)defaultUpdaterTextColor;

/**
 Adds the backgroundAlphaView to the view with the alpha value set to the property.
 */
- (void)addBackgroundAlphaView;

/**
 Sets up deactivationSubview as a clear layer to the size of the device, and adds as a subview.
 */
- (void)addDeactivationSubview;

- (void)animateFlashAtInterval:(NSTimeInterval)flashInterval;

@end


@implementation DHUpdaterView


- (id)initWithFrame:(CGRect)frame withDeactivatedBackground:(BOOL)deactivate fadeDuration:(NSTimeInterval)fadeDuration
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.fadeDuration = fadeDuration;
        
        self.numberOfLines = 1;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self addBackgroundAlphaView];        
        
        if (deactivate == YES) {
            [self addDeactivationSubview];
        }
        
        [self centerUpdaterView];
        [self setupActivityIndicatorInFrame:self.bounds.size];        
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        self.numberOfLines = 1;
        
        //Setting background anywhere other than init is useless - to reset do it from the calling view controller, before setNeedsDisplay!
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self addBackgroundAlphaView];
        [self centerUpdaterView];        
        
        [self setupActivityIndicatorInFrame:self.bounds.size];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{    
    [self.layer setMasksToBounds:YES];

    [self.backgroundAlphaView.layer setCornerRadius:DH_BACKGROUND_VIEW_RADIUS];
}


#pragma mark - Getters
- (NSTimeInterval)fadeDuration
{
    //Set default to 500 milliseconds. The fadeDuration never needs to be 0, a no-fade can be specified by a non-aminated call to displayWithAnimation.
    if (_fadeDuration == 0) {
        _fadeDuration = 0.5;
    }
    
    return _fadeDuration;
}


#pragma mark - Custom Layout methods
- (void)addBackgroundAlphaView
{
    if ([[self subviews] containsObject:_backgroundAlphaView]) {
        [self.backgroundAlphaView removeFromSuperview];
    }
    
    if (_backgroundAlphaView == nil)
    {
        self.backgroundAlphaView = [[UIView alloc] initWithFrame:self.bounds];
        [self.backgroundAlphaView setBackgroundColor:[UIColor blackColor]];
        [self.backgroundAlphaView setAlpha:0.8];         
    }
        
    [self addSubview:_backgroundAlphaView];
}


- (void)addDeactivationSubview
{
    //Sets up deactivationSubview as a clear layer to the size of the device, and adds as a subview.
    if ([[self subviews] containsObject:_deactivationSubview]) {
        [self.deactivationSubview removeFromSuperview];
    }
    
    if (_deactivationSubview == nil)
    {
        CGSize screen = [[UIScreen mainScreen] bounds].size;        
        
        self.deactivationSubview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.width, screen.height)];
        [self.deactivationSubview setBackgroundColor:[UIColor clearColor]];
        [self.deactivationSubview setAlpha:0];
        
        //Resize overall frame to compensate...
        CGRect background = self.bounds;
        background.size = CGSizeMake(screen.width, screen.height);
        [self setFrame:background];                
    }
    
    [self insertSubview:_deactivationSubview
           belowSubview:_backgroundAlphaView];
}


- (void)centerUpdaterView
{
    //Center main view...
    CGSize screen = [[UIScreen mainScreen] bounds].size;

    CGFloat centerX = (screen.width - self.frame.size.width) / 2;
    CGFloat centerY = (screen.height - self.frame.size.height) / 2;;
    
    CGRect defaultFrame = self.frame;
    defaultFrame.origin = CGPointMake(centerX, centerY);
    [self setFrame:defaultFrame];
    
    //Center backgroundAlphaView...
    CGRect bgFrame = _backgroundAlphaView.frame;
    
    centerX = (self.frame.size.width - bgFrame.size.width) / 2;
    centerY = (self.frame.size.height - bgFrame.size.height) / 2;;
    
    bgFrame.origin = CGPointMake(centerX, centerY);
    [self.backgroundAlphaView setFrame:bgFrame];
}


- (void)setupActivityIndicatorInFrame:(CGSize)defaultSize
{
    if ([[self subviews] containsObject:_activityIndicator]) {
        [self.activityIndicator removeFromSuperview];
    }    
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityIndicator.frame = CGRectMake((defaultSize.width / 2) - (_activityIndicator.frame.size.width / 2),
                                              (defaultSize.height / 2) - (_activityIndicator.frame.size.height / 2),
                                              _activityIndicator.frame.size.width,
                                              _activityIndicator.frame.size.height);
    
    [self.activityIndicator startAnimating];    
    [self addSubview:_activityIndicator];
}


#pragma mark - UILabel Handling
- (void)addUpdaterText:(NSString *)text inRelationToAnimator:(DHUpdaterViewPosition)position
{
    CGSize textSize = [text sizeWithFont: [self defaultUpdaterTextFont]];
    
    if (_updaterText == nil)
    {
        CGRect labelFrame = CGRectMake(0, 0,
                                       _backgroundAlphaView.frame.size.width, (textSize.height * self.numberOfLines));
        UILabel *newUpdaterText = [[UILabel alloc] initWithFrame:labelFrame];
        
        [self setUpdaterText:newUpdaterText withDefaults:YES];
        [self addSubview: _updaterText];
        
        //Position in relation to activityIndicator...
        CGRect indctrFrame = _activityIndicator.frame;
        
        switch (position) 
        {
            case DHUpdaterViewPositionBottom:
            {
                //Shift activityIndicator up...
                indctrFrame.origin = CGPointMake( (indctrFrame.origin.x), 
                                                 (indctrFrame.origin.y - textSize.height) );
                
                //Set updaterText below activityIndicator...
                CGPoint labelCenter = _activityIndicator.center;
                labelCenter.y += textSize.height;
                [self.updaterText setCenter: labelCenter];
            }
                break;
                
            case DHUpdaterViewPositionTop:
            {
                //Shift activityIndicator down...
                indctrFrame.origin = CGPointMake( (indctrFrame.origin.x), 
                                                 (indctrFrame.origin.y + textSize.height) );
                
                //Set updaterText above activityIndicator...
                CGPoint labelCenter = _activityIndicator.center;
                labelCenter.y -= textSize.height;
                [self.updaterText setCenter: labelCenter];
                
            }
                break;            
                
            case DHUpdaterViewPositionExclusive:
            default:
                break;
        }
        
        [[self activityIndicator] setFrame: indctrFrame];        
    }
    
    [[self updaterText] setText: text];
}


- (void)setUpdaterText:(UILabel *)newUpdaterText withDefaults:(BOOL)setToDefault
{
    if (newUpdaterText == nil) {
        [self.updaterText removeFromSuperview];
    }
    
    if (setToDefault == YES) {
        [newUpdaterText setFont: [self defaultUpdaterTextFont]];
        [newUpdaterText setTextColor: [self defaultUpdaterTextColor]];
    }
    
    [newUpdaterText setTextAlignment:NSTextAlignmentCenter];
    [newUpdaterText setNumberOfLines:_numberOfLines];
    
    [newUpdaterText setBackgroundColor:[UIColor clearColor]];
    [self setUpdaterText: newUpdaterText];
}
                                       

- (UIFont *)defaultUpdaterTextFont
{    
    UIFont *defaultFont = nil;
    
    if (_updaterText == nil) {
        defaultFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:24.0];
    }
    else {
        defaultFont = [_updaterText font];
    }
    
    return defaultFont;
}


- (UIColor *)defaultUpdaterTextColor
{    
    UIColor *defaultColor = nil;
    
    if (_updaterText == nil) {
        defaultColor = [UIColor whiteColor];
    }
    else {
        defaultColor = [_updaterText textColor];
    }
    
    return defaultColor;
}


- (UIColor *)flashColorOne
{
    if (_flashColorOne == nil) {
        _flashColorOne = [UIColor yellowColor];
    }
    
    return _flashColorOne;
}


- (UIColor *)flashColorTwo
{
    if (_flashColorTwo == nil) {
        _flashColorTwo = [UIColor redColor];
    }
    
    return _flashColorTwo;
}


#pragma mark - Animations
- (void)startDeactivationViewFlashAtInterval:(NSTimeInterval)flashInterval
{
    self.isFlashing = YES;
    [self animateFlashAtInterval:flashInterval];
}


- (void)animateFlashAtInterval:(NSTimeInterval)flashInterval
{
    //Swap colors...
    if ([[_deactivationSubview backgroundColor] isEqual:_flashColorTwo]) {
        [self.deactivationSubview setBackgroundColor:[self flashColorOne]];
    }
    else {
        [self.deactivationSubview setBackgroundColor:[self flashColorTwo]];
    }    
    
    //Nest the fade-out animation within the fade-in animation, to create a loop...
    [UIView animateWithDuration:flashInterval
                          delay:0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^(void) {
                         [self.deactivationSubview setAlpha:0.7];
                     }
                     completion:^(BOOL finished){
                         
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                        {
                                            [UIView animateWithDuration:(flashInterval / 2)
                                                                  delay:0
                                                                options:UIViewAnimationOptionTransitionCrossDissolve
                                                             animations:^(void) {
                                                                 [self.deactivationSubview setAlpha:0.4];
                                                             }
                                                             completion:^(BOOL finished){
                                                                 if (self.isFlashing == YES) {
                                                                     [self animateFlashAtInterval:flashInterval];
                                                                 }
                                                                 else {
                                                                     finished = YES;
                                                                     [self.deactivationSubview setBackgroundColor:[self flashColorTwo]];
                                                                 }
                                                             }];
                                        });
                     }];    
}


- (void)stopDeactivationViewFlash {
    self.isFlashing = NO;
}


- (void)displayWithAnimation:(BOOL)animate completion:(animation_completion_block)completionBlock
{
    [self setNeedsDisplay];
    [self setAlpha:0];
    NSTimeInterval delay = 0;
    
    if (animate == YES)
    {
        [self setLastFadeInTime:(self.fadeDuration + delay)];
        
        [UIView animateWithDuration:self.fadeDuration
                              delay:delay
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^(void) {
                             [self setAlpha:1.0];
                         }
                         completion:^(BOOL finished){
                             if (completionBlock) {
                                 completionBlock();
                             }                             
                         }];
    }
    else {
        [self setAlpha:1.0];
    }
}


- (void)disappearWithAnimation:(BOOL)animate afterTimeout:(NSTimeInterval)timeout
{    
    [self disappearWithAnimation:animate
                    afterTimeout:timeout
                      completion:NULL];
}


- (void)disappearWithAnimation:(BOOL)animate afterTimeout:(NSTimeInterval)timeout completion:(animation_completion_block)completionBlock
{
    if (animate == YES)
    {
        //Wait for time of lastFadeInTime...
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_lastFadeInTime * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [UIView animateWithDuration:self.fadeDuration
                                  delay:timeout
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^(void) {
                                 [self setAlpha:0.0];
                             }
                             completion:^(BOOL finished)
             {
                 if (completionBlock) {
                     completionBlock();
                 }
                 
                 if ([self.delegate respondsToSelector:@selector(didRemoveUpdaterView:)]) {
                     [self.delegate didRemoveUpdaterView:self];
                 }
             }];
        });
    }
    else
    {
        if (completionBlock) {
            completionBlock();
        }
        
        if ([self.delegate respondsToSelector:@selector(didRemoveUpdaterView:)]) {
            [self.delegate didRemoveUpdaterView:self];
        }
    }
}


@end
