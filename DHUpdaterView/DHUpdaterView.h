//
//  DHUpdaterView.h
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


@protocol DHUpdaterViewDelegate;

typedef void (^animation_completion_block)(void);

/**
 Used to automatically realign any subviews of the backgroundAlphaView, either above or below existing.
 DHUpdaterViewPositionExclusive is used to center the view, and hide any other subviews, making the specified view exclusive.
 */
typedef enum {
    DHUpdaterViewPositionTop        = 0,
    DHUpdaterViewPositionBottom     = 1,
    DHUpdaterViewPositionExclusive  = 2
} DHUpdaterViewPosition;


@interface DHUpdaterView : UIView {
}

#pragma mark - Properties
/**
 Use for animation completion as an alternative to completion blocks.
 */
@property (nonatomic, weak) id <DHUpdaterViewDelegate> delegate;

/**
 The black center view. This view contains the updaterText text label and the activityIndicator view.
 It's set on initialisation with default transparency and black color. The view is centered in the main view, no matter the size.
 */
@property (nonatomic, strong) UIView *backgroundAlphaView;

/**
 The view placed underneath the backgroundAlphaView. 
 Primarily exists to disable the main screen by occupying the screen space. But it's also set to 2 color tones that alternate by flashing. 
 */
@property (nonatomic, strong) UIView *deactivationSubview;

/**
 Active from the time the displayWithAnimation method is triggered, until the completion block executes.
 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

/**
 The main label that contains the progress text to display to the user. 
 This is positioned above or below the activityIndicator, depending on the DHUpdaterViewPosition value in addUpdaterText:inRelationToAnimator.
 */
@property (nonatomic, strong) UILabel *updaterText;

/**
 The number of lines that should be set in the updaterText label. Also used to calculate the size of the label frame.
 */
@property (nonatomic, assign) NSInteger numberOfLines;

/**
 The default fadeDuration property that'll dictate the fade times in animations. Animations will update to the most recent value set here.
 If this value isn't set, it defaults to 500 milliseconds.
 */
@property (nonatomic, assign) NSTimeInterval fadeDuration;

/**
 When stopDeactivationViewFlash is requested, isFlashing is set to NO. The completion handler only executes when isFlashing is NO.
 */
@property (nonatomic, assign, readonly) BOOL isFlashing;


//@property (nonatomic, strong) UIColor *updaterBorderColor;

//@property (nonatomic, assign) BOOL hasGradient;


#pragma mark - Methods
/**
 Alternative Designated initialiser. Calls initWithFrame, and sets the default fadeDuration property that'll dictate the fade times in animations. 
 */
- (id)initWithFrame:(CGRect)frame withDeactivatedBackground:(BOOL)deactivate fadeDuration:(NSTimeInterval)fadeDuration;

/**
 Centers overall view in relation to the device bounds.
 */
- (void)centerUpdaterView;

/**
 Centers UIActivityIndicatorView in relation to the defaultSize, not the size of the parent's frame. Adds as a subview.
 @param defaultSize
 */
- (void)setupActivityIndicatorInFrame:(CGSize)defaultSize;

/**
 Automatically realigns any other SPUpdaterView subviews, either above or below existing.
 Removes any subviews and centers the updaterText label, if SPUpdaterViewPositionExclusive is specified.
 @param text
 @param position Specifies where to position the updaterText label.
 */
- (void)addUpdaterText:(NSString *)text inRelationToAnimator:(DHUpdaterViewPosition)position;

/**
 Extended Setter to ensure the updaterText is removed from the superview before set to nil. Also sets font and text color if setToDefault is true.
 @param setToDefault YES to set the default font and text color.
 */
- (void)setUpdaterText:(UILabel *)newUpdaterText withDefaults:(BOOL)setToDefault;

/**
 The deactivationSubview is updated to visible, and a flash commences on the deactivationSubview to occur at the flashInterval, repeatedly.
 Colors are defaulted to white and grey.
 @param
 */
- (void)startDeactivationViewFlashAtInterval:(NSTimeInterval)flashInterval;

/**
 Stops any flash animations in effect.
 */
- (void)stopDeactivationViewFlash;

/**
 Fades in the alpha of the view. 
 Note: this DHUpdaterView has to be added to the superview before these animations.
 @param animate specifies whether to fadeout the view gracefully, or abruptly remove from screen.
 @param completionBlock. This is good place to remove the view from superview. 
 */
- (void)displayWithAnimation:(BOOL)animate completion:(animation_completion_block)completionBlock; 

/**
 Fades out the alpha of the view.
 @param animate specifies whether to fadeout the view gracefully, or abruptly remove from screen.
 @param completionBlock. This is good place to remove the view from superview.
 */
- (void)disappearWithAnimation:(BOOL)animate afterTimeout:(NSTimeInterval)timeout;

/**
 Similar to disappearWithAnimation except with the completionBlock.
 @param animate specifies whether to fadeout the view gracefully, or abruptly remove from screen.
 @param timeout the duration until the animation is performed.
 @param completionBlock. This is good place to remove the view from superview.
 */
- (void)disappearWithAnimation:(BOOL)animate afterTimeout:(NSTimeInterval)timeout
                    completion:(animation_completion_block)completionBlock;

@end


#pragma DHUpdaterViewDelegate
@protocol DHUpdaterViewDelegate <NSObject>

@optional
- (void)didRemoveUpdaterView:(DHUpdaterView *)updaterView;

@end
