//
//  DHViewController.m
//  UpdaterViewDemo
//
//  Created by Mike Post on 29/10/13.
//  Copyright (c) 2013 Dashend. All rights reserved.
//

#import "DHViewController.h"

@interface DHViewController ()

- (void)dismissUpdaterView:(NSTimer *)timeout;

@end


@implementation DHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.updaterView = [[DHUpdaterView alloc] initWithFrame:CGRectMake(0, 0, 260, 200)
                                  withDeactivatedBackground:YES
                                               fadeDuration:0.3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startUpdateAction:(id)sender
{
    //Set text...
    [self.updaterView setNumberOfLines:2];
    
    [self.updaterView addUpdaterText:@"The DHUpdaterView will dismiss in 5 seconds..."
                inRelationToAnimator:DHUpdaterViewPositionTop];
    
    //Resize font...
    UIFont *msgFont = [UIFont fontWithName:[[[self.updaterView updaterText] font] fontName]
                                      size:18];
    [[self.updaterView updaterText] setFont:msgFont];
    
    //Add and display view...
    [self.view addSubview:_updaterView];
    
    [self.updaterView displayWithAnimation:YES
                                completion:^(void) {
                                    [self.updaterView startDeactivationViewFlashAtInterval:0.8];
                                }];
    
    //Time out after 5 seconds for the sake of the demo...
    [NSTimer scheduledTimerWithTimeInterval:5
                                   target:self
                                 selector:@selector(dismissUpdaterView:)
                                 userInfo:nil
                                  repeats:NO];
}


- (void)dismissUpdaterView:(NSTimer *)timeout
{
    if ([[self.view subviews] containsObject:_updaterView] == YES)
    {
        [self.updaterView addUpdaterText:@"Goodbye!"
                    inRelationToAnimator:DHUpdaterViewPositionTop];
        
        //Remove view...
        [self.updaterView disappearWithAnimation:YES
                                    afterTimeout:2
                                      completion:^(void) {
                                          [self.updaterView stopDeactivationViewFlash];
                                          [self.updaterView removeFromSuperview];
                                      }];
    }
}


@end
