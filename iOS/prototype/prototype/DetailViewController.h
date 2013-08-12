//
//  DetailViewController.h
//  prototype
//
//  Created by Brandon Smith on 3/20/13.
//  Copyright (c) 2013 Brandon Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
