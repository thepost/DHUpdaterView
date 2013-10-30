//
//  DHViewController.h
//  UpdaterViewDemo
//
//  Created by Mike Post on 29/10/13.
//  Copyright (c) 2013 Dashend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHUpdaterView.h"


@interface DHViewController : UIViewController

@property (nonatomic, strong) DHUpdaterView *updaterView;

- (IBAction)startUpdateAction:(id)sender;

@end
