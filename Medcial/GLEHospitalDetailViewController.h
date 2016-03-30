//
//  GLEHospitalDetailViewController.h
//  Medcial
//
//  Created by Khachuong on 7/13/14.
//  Copyright (c) 2014 Khachuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
@interface GLEHospitalDetailViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) NSString *hospitalID;
@property (strong, nonatomic) PFObject *currentHospital;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@end
