//
//  GLEHospitalDetailViewController.m
//  Medcial
//
//  Created by Khachuong on 7/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import "GLEHospitalDetailViewController.h"

@interface GLEHospitalDetailViewController ()

@end

@implementation GLEHospitalDetailViewController

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
    [self.mapView setRegion:region animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Hospital"];
        [query whereKey:@"objectId" equalTo:_hospitalID];
        [query getObjectInBackgroundWithId:_hospitalID block:^(PFObject *object, NSError *error) {
            _currentHospital = object;
            _mapView.showsUserLocation = YES;
            CLLocationCoordinate2D coordinate1;
            double lat = [object[@"latitude"] doubleValue];
            double longit = [object[@"longitude"] doubleValue];
            coordinate1.latitude = lat;
            coordinate1.longitude = longit;
            
            // Zoom map to annoatation center
            MKCoordinateRegion myRegion;
            MKCoordinateSpan mySpan;
            mySpan.latitudeDelta=1.0f;
            mySpan.longitudeDelta = 1.0f;
            myRegion.center = coordinate1;
            myRegion.span = mySpan;
            [self.mapView setRegion:myRegion animated:YES];
            
            MKPointAnnotation *point= [[MKPointAnnotation alloc] init];
            point.coordinate = coordinate1;
            point.title = object[@"name"];
            [self.mapView addAnnotation:point];
            _lblName.text = object[@"name"];
            _lblAddress.text = object[@"address"];
            [_lblAddress setLineBreakMode:NSLineBreakByWordWrapping];
            _lblAddress.numberOfLines = 0;
            [_lblAddress sizeToFit];

            _lblPhone.text = object[@"phone"];
        }];
    });
}

@end
