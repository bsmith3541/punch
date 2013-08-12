//
//  MapViewController.m
//  Socialyte
//
//  Created by Brandon Smith on 6/28/13.
//
//

#import "MapViewController.h"
#import "GeoPointAnnotation.h"
#import "EventViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialize Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    // Configure Location Manager
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            // orient the map around the current location
            [self orientMap:geoPoint];
            
            // place markers for each of the events near the user
            [self queryGeoPoints:geoPoint];
        } else {
            NSLog(@"there was an error obtaining your current location");
        }
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    	// Do any additional setup after loading the view.
    
    // Listen for annotation updates. Triggers a refresh whenever an annotation is dragged and dropped.
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"geoPointAnnotationUpdated" object:nil];
}

-(void)orientMap:(PFGeoPoint *)currLoc
{
    [self.mapView setRegion:MKCoordinateRegionMake(
                                                   CLLocationCoordinate2DMake(currLoc.latitude, currLoc.longitude),
                                                   MKCoordinateSpanMake(0.01, 0.01)
                                                   )];
}

#pragma mark - geoPoint

- (void)queryGeoPoints:(PFGeoPoint *)geoPoint
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    // Interested in locations near user.
    // we'll make this request on a separate thread
    dispatch_queue_t findEvents = dispatch_queue_create("find events", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(findEvents, ^{
        [query whereKey:@"PFGeoPoint" nearGeoPoint:geoPoint withinMiles:10.0];
        // Limit what could be a lot of points.
        //query.limit = 10;
        // Final list of objects
        NSArray *events = [query findObjects];
        NSLog(@"There are %d event(s) near you!", [events count]);
        for (PFObject *object in events) {
            NSLog(@"Event Name: %@", [object valueForKey:@"name"]);
            [self plotGeoPoint:object];
            [self createGeofence:object[@"PFGeoPoint"]];
        };
    });
}

- (void)createGeofence:(PFGeoPoint *)loc
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
    // place geofences on each of the event locations...
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:center radius:10.0 identifier:[[NSUUID UUID] UUIDString]];
    // Start Monitoring Region
    [self.locationManager startMonitoringForRegion:region];
}

- (void)plotGeoPoint:(PFObject *)event
{
    GeoPointAnnotation *annotation = [[GeoPointAnnotation alloc] initWithObject:event];
    [self.mapView addAnnotation:annotation];
    //[self performSelector:@selector(mapView:viewForAnnotation:) withObject:self.mapView withObject:annotation];
    //[self.mapView.window setNeedsDisplay];
}

-(void)loadDetailView:(PFObject *)clickedPin
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    EventViewController *eventDetail = (EventViewController *)[storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    eventDetail.event = clickedPin;
    [self presentViewController:eventDetail animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
       NSLog(@"nil"); return nil;
    }
    
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
    
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
        //annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        //annotationView.draggable = NO;
        annotationView.animatesDrop = YES;
        //annotationView.annotation = annotation;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    //annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    NSLog(@"I added sumthin!");
}

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    
//}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    GeoPointAnnotation *clickedEvent = (GeoPointAnnotation *)view.annotation;
    [self loadDetailView:clickedEvent.object];
}


#pragma mark - ECSlidingViewController
- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  //
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // display alert if user is not connected to wifi
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-in"
                                                    message:@"Do you want to check into Event1?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes!", nil];
    [alert show];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes!"])
    {
        NSLog(@"User checked in!");
    } else {
        NSLog(@"User did not check-in");
    }
}

@end
