//
//  ViewController.h
//  BLEtest
//
//  Created by snu on 2014. 10. 15..
//  Copyright (c) 2014년 snu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate, UIScrollViewDelegate>
{
    CBCentralManager* CenManager;
    UIAlertView* alertView;
    UIImageView* groundImageView;
    UIImageView* skyImageView;
    UIScrollView* yawScrollView;
    UIScrollView* pitchScrollView;
}
@property (strong) CBPeripheral* ConPeripheral;
@property (strong) CBCharacteristic* myCharac;
@property (strong) CBCharacteristic* comCharac;
@property (retain, nonatomic) IBOutlet UILabel *rollLabel;
@property (retain, nonatomic) IBOutlet UILabel *pitchLabel;
@property (retain, nonatomic) IBOutlet UILabel *yawLabel;
@property (retain, nonatomic) IBOutlet UILabel *throttleLabel;
- (IBAction)graphBtnClick:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *graphBtnRef;
@property (retain, nonatomic) IBOutlet UIImageView *blackImageView;
- (IBAction)sliderValueChange:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *commandLabel;



@end

