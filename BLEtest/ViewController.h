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
    UIView* windowView;
    int windowFlag;
    
    UILabel* rollLabel;
    UILabel* pitchLabel;
    UILabel* yawLabel;
    UILabel* thrLabel;
    UILabel* comLabel;
}
@property (strong) CBPeripheral* ConPeripheral;
@property (strong) CBCharacteristic* myCharac;
@property (strong) CBCharacteristic* comCharac;

- (IBAction)graphBtnClick:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *graphBtnRef;
@property (retain, nonatomic) IBOutlet UIImageView *blackImageView;
- (IBAction)sliderValueChange:(id)sender;
- (IBAction)brightValueChange:(id)sender;
- (IBAction)sliderGreenValueChange:(id)sender;
- (IBAction)sliderBlueValueChange:(id)sender;
- (IBAction)motorValueChange:(id)sender;




@end

