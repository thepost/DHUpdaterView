DHUpdaterView
=============

A progress view with text and an activity indicator, centered in a flashing background of 2 colors. Used as an overlay in FitFriend when some kind of synchronous update occurs.

![Screenshot](https://github.com/thepost/DHUpdaterView/raw/master/screenshot.png)

## Installation

To use `DHUpdaterView`:

- Copy over the `DHUpdaterView` folder to your project folder.
- Add `#import "DACircularProgressView.h"` in any class that wants to add it to view. 
- Initialise and display it, as demonstrated below.

### Example Code

1) Ideally create a property for the DHUpdaterView so you can dismiss it when needed.

```objective-c
@property (nonatomic, strong) DHUpdaterView *updaterView;
```


2) Initialise the view with a frame. The 2nd parameter specifies whether a transparent background view is present over the whole screen, to deactivate the remaining visible content. The 3rd parameter specifies how long the fades last. 

```objective-c
   	self.updaterView = [[DHUpdaterView alloc] initWithFrame:CGRectMake(0, 0, 260, 200)
                                  withDeactivatedBackground:YES
                                               fadeDuration:0.3];
```

3) Call addUpdaterText:inRelationToAnimator and set the text to display, and the position related to the activity indicator. Then add it as a subview and call displayWithAnimation:completion.

```objective-c
    [self.updaterView addUpdaterText:@"Updating..."
                inRelationToAnimator:DHUpdaterViewPositionTop];
    
    [self.view addSubview:_updaterView];
    
    [self.updaterView displayWithAnimation:YES
                                completion:^(void) {
                                    [self.updaterView startDeactivationViewFlashAtInterval:0.8];
                                }];

```

4) Finally, dismiss the DHUpdaterView when appropriate. The 2 second delay in the afterTimeout parameter allows it to display the final message of "Goodbye!":

```objective-c
        [self.updaterView addUpdaterText:@"Goodbye!"
                    inRelationToAnimator:DHUpdaterViewPositionTop];
        
        //Remove view...
        [self.updaterView disappearWithAnimation:YES
                                    afterTimeout:2
                                      completion:^(void) {
                                          [self.updaterView stopDeactivationViewFlash];
                                          [self.updaterView removeFromSuperview];
                                      }];
```

## Contact

- [Twitter is best](http://twitter.com/PostTweetism)

