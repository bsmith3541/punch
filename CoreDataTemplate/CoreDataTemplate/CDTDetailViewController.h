//
//  CDTDetailViewController.h
//  CoreDataTemplate
//
//  Created by Brandon Smith on 8/5/13.
//  Copyright (c) 2013 Brandon Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDTDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
