//
//  DetailViewController.h
//  Refresher
//
//  Created by Brandon Smith on 6/10/13.
//  Copyright (c) 2013 GUEF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
