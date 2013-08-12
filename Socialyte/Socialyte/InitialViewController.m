//
//  InitialViewController.m
//  Socialyte
//
//  Created by Brandon Smith on 6/26/13.
//
//

#import "InitialViewController.h"
#import "EventsTableViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"eventsTableNav"];
    
    UINavigationController *eventsTableNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsTableNav"];
    eventsTableNavController = [eventsTableNavController initWithRootViewController:[[EventsTableViewController alloc] initWithStyle:UITableViewStylePlain]];
    self.topViewController = eventsTableNavController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
