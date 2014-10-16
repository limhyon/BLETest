//
//  ViewController.h
//  BLEtest
//
//  Created by snu on 2014. 10. 15..
//  Copyright (c) 2014년 snu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager* CenManager;
}
@property (strong) CBPeripheral* ConPeripheral;
@property (strong) CBCharacteristic* myCharac;

@property (retain, nonatomic) IBOutlet UILabel *rollLabel;
@property (retain, nonatomic) IBOutlet UILabel *pitchLabel;
@property (retain, nonatomic) IBOutlet UILabel *thrLabel;
@property (retain, nonatomic) IBOutlet UILabel *yawLabel;
- (IBAction)updateBtn:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *updateBtnRef;


@end

