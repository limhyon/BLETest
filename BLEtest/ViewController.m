//
//  ViewController.m
//  BLEtest
//
//  Created by snu on 2014. 10. 15..
//  Copyright (c) 2014년 snu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)dealloc
{
    [CenManager release]; CenManager = nil;
    [groundImageView release]; groundImageView = nil;
    [skyImageView release]; skyImageView = nil;
    [yawScrollView release]; yawScrollView = nil;
    [pitchScrollView release]; pitchScrollView = nil;
    
    [_rollLabel release];
    [_pitchLabel release];
    [_yawLabel release];
    [_throttleLabel release];
    [_graphBtnRef release];
    [_blackImageView release];
    [_commandLabel release];
    [super dealloc];
}



- (void)viewDidLoad
{

    [super viewDidLoad];
    
    skyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 320)];
    [skyImageView setBackgroundColor:[UIColor colorWithRed:145/(float)255 green:220/(float)255 blue:255/(float)255 alpha:1]];
    [self.view insertSubview:skyImageView belowSubview:_blackImageView];
    
    groundImageView = [[UIImageView alloc] initWithFrame:CGRectMake((375/(float)2) - 400, -90, 800, 500)];
    [groundImageView.layer setAnchorPoint:CGPointMake(0.5, 0)];
    [groundImageView setBackgroundColor:[UIColor brownColor]];
    [self.view insertSubview:groundImageView belowSubview:_blackImageView];
    
    
    
    
    yawScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((375-250)/(float)2 , 50, 250, 50)];
    [yawScrollView setContentSize:CGSizeMake(2050, 50)];
    [yawScrollView setBackgroundColor:[UIColor clearColor]];
    [yawScrollView setShowsHorizontalScrollIndicator:NO];
    [yawScrollView setUserInteractionEnabled:NO];
    [self.view addSubview:yawScrollView];
    
    UIView* yawContentsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2050, 50)];
    [yawContentsView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [arrowImage setImage:[UIImage imageNamed:@"arrowDown.png"]];
    [arrowImage setCenter:CGPointMake(375/(float)2, 50)];
    [self.view addSubview:arrowImage];
    [arrowImage release];
    
    for (int i = 1; i<38; i++)
    {
        UIImageView* tempImage = [[UIImageView alloc] initWithFrame:CGRectMake(123 + 50*(i-1), 10, 4, 40)];
        [tempImage setBackgroundColor:[UIColor colorWithRed:253/(float)255 green:1 blue:107/(float)255 alpha:1]];
        [yawContentsView addSubview:tempImage];
        
        UILabel* tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [tempLabel setCenter:tempImage.center];
        [tempLabel setFont:[UIFont systemFontOfSize:20]];
        [tempLabel setTextAlignment:NSTextAlignmentCenter];
        tempLabel.text = [NSString stringWithFormat:@"%d",-180+10*(i-1)];
        [yawContentsView addSubview:tempLabel];
        
        [tempImage release];
        [tempLabel release];
    }
    
    [yawScrollView addSubview:yawContentsView];
    [yawContentsView release];

    [yawScrollView setContentOffset:CGPointMake(900, 0)];
    
    
    
    
    int buffer = 58;
    
    pitchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 40, 120)];
    [pitchScrollView setCenter:CGPointMake(82.5, 160)];
    [pitchScrollView setContentSize:CGSizeMake(40, 900 + 4 + buffer*2)];
    [pitchScrollView setBackgroundColor:[UIColor clearColor]];
    [pitchScrollView setShowsVerticalScrollIndicator:NO];
    [pitchScrollView setUserInteractionEnabled:NO];
    [self.view addSubview:pitchScrollView];
    
    UIView* rollContentsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 900 + 4 + buffer*2, 40)];
    [rollContentsView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* arrowRightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [arrowRightImage setImage:[UIImage imageNamed:@"arrowRight.png"]];
    [arrowRightImage setCenter:CGPointMake(53, 160)];
    [self.view addSubview:arrowRightImage];
    [arrowRightImage release];
    
    
    for (int i = 1; i<20; i++)
    {
        UIImageView* tempImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, buffer + 50*(i-1), 40, 4)];
        [tempImage setBackgroundColor:[UIColor colorWithRed:253/(float)255 green:1 blue:107/(float)255 alpha:1]];
        [rollContentsView addSubview:tempImage];
        
        UILabel* tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [tempLabel setCenter:tempImage.center];
        [tempLabel setFont:[UIFont systemFontOfSize:20]];
        [tempLabel setTextAlignment:NSTextAlignmentCenter];
        tempLabel.text = [NSString stringWithFormat:@"%d",90-10*(i-1)];
        [rollContentsView addSubview:tempLabel];
        
        [tempImage release];
        [tempLabel release];
    }
    
    [pitchScrollView addSubview:rollContentsView];
    [rollContentsView release];
    
    [pitchScrollView setContentOffset:CGPointMake(0, 450)];

    
    
    
    
    alertView = [[UIAlertView alloc] initWithTitle:@"Connecting bluetooth device\nPlease Wait..."
                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alertView show];

    CenManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    [CenManager scanForPeripheralsWithServices:nil options:nil];

}


#pragma mark - CBCentralManager Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([peripheral.name isEqualToString:@"QD14070013"])
    {
       // NSLog(@"Descovered BLE");
        
        peripheral.delegate = self;
        [CenManager connectPeripheral:peripheral options:nil];
        self.ConPeripheral = peripheral;
        
        [CenManager stopScan];
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
   // NSLog(@"Peripheral connect");
    [self.ConPeripheral discoverServices:nil];
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _rollLabel.text = @"";
    _pitchLabel.text = @"";
    _yawLabel.text = @"";
    _throttleLabel.text = @"";
    _commandLabel.text = @"";
    
    alertView = [[UIAlertView alloc] initWithTitle:@"Connecting bluetooth device\nPlease Wait..."
                                           message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alertView show];
    [CenManager release]; CenManager = nil;
    CenManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    [CenManager scanForPeripheralsWithServices:nil options:nil];

}





#pragma mark - CBPeripheral Delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService* service in peripheral.services)
    {
        // NSLog(@"Discovered service %@", service);
        [self.ConPeripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *Charac in service.characteristics)
    {
       // NSLog(@"Discovered characteristic %@", [NSNumber numberWithInt:Charac.properties]);
        if ([[NSNumber numberWithInt:Charac.properties] isEqualToNumber:[NSNumber numberWithInt:18]])
        {
            self.myCharac = Charac;
            [self.ConPeripheral setNotifyValue:YES forCharacteristic:self.myCharac];
            [alertView dismissWithClickedButtonIndex:1 animated:NO];

            [alertView release];

            //[self.ConPeripheral readValueForCharacteristic:Charac];
       }
        if ([[NSNumber numberWithInt:Charac.properties] isEqualToNumber:[NSNumber numberWithInt:10]]) self.comCharac = Charac;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([[NSNumber numberWithInteger:characteristic.properties] isEqualToNumber:[NSNumber numberWithInteger:18]])
    {
        NSData* chaData = characteristic.value;
        
        NSData* rollData = [chaData subdataWithRange:NSMakeRange(0, 2)];
        NSData* pitchData = [chaData subdataWithRange:NSMakeRange(2, 2)];
        NSData* yawData = [chaData subdataWithRange:NSMakeRange(6, 2)];
        
        const unsigned* chaDataConst = [chaData bytes];
        NSString* chaDataString = [NSString stringWithFormat:@"%08x%08x%08x", ntohl(chaDataConst[0]),ntohl(chaDataConst[1]),ntohl(chaDataConst[2])];
        NSString* thrString = [chaDataString substringWithRange:NSMakeRange(8, 4)];
        
        NSString* frontSt = [thrString substringWithRange:NSMakeRange(0, 2)];
        NSString* rearSt = [thrString substringWithRange:NSMakeRange(2, 2)];
        NSString* thrStringInv = [NSString stringWithFormat:@"%@%@",rearSt,frontSt];
        
        unsigned int thrValue;
        NSScanner* scanner = [NSScanner scannerWithString:thrStringInv];
        [scanner scanHexInt:&thrValue];
        
        int16_t* rollInt = (int16_t*)rollData.bytes;
        float rollAngle = (*rollInt)/(float)100;
        int16_t* pitchInt = (int16_t*)pitchData.bytes;
        float pitchAngle = (*pitchInt)/(float)100;
        int16_t* yawInt = (int16_t*)yawData.bytes;
        float yawAngle = (*yawInt)/(float)100;
        
        _rollLabel.text = [NSString stringWithFormat:@"%.2f", rollAngle];
        _pitchLabel.text = [NSString stringWithFormat:@"%.2f", pitchAngle];
        _yawLabel.text = [NSString stringWithFormat:@"%.2f", yawAngle];
        _throttleLabel.text = [NSString stringWithFormat:@"%d", thrValue];
        
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0,(32/(float)9)*[self saturation:pitchAngle :45]);
        groundImageView.transform = translate;
        groundImageView.transform = CGAffineTransformRotate(groundImageView.transform, rollAngle*(M_PI/180));
        
        [yawScrollView setContentOffset:CGPointMake((float)5*yawAngle + 900, 0)];
        [pitchScrollView setContentOffset:CGPointMake(0, (float)(-5*pitchAngle) + 450)];

    }
   else
   {
       NSData* chaData = characteristic.value;
       
       const unsigned* chaDataConst = [chaData bytes];
       NSString* chaDataString = [NSString stringWithFormat:@"%08x", ntohl(chaDataConst[0])];
       
       _commandLabel.text = [chaDataString substringWithRange:NSMakeRange(1, 1)];
    }
}





#pragma mark - Custom Function
-(float)saturation:(float)value :(float)thr
{
    if (thr < value)
        value = thr;
    if (-thr > value)
        value = -thr;
    return value;
}


#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Method
- (IBAction)graphBtnClick:(id)sender
{
    
}


- (IBAction)sliderValueChange:(id)sender
{
    UISlider* senderSlider = sender;

    int i = (int)(9*senderSlider.value);
    [self.ConPeripheral writeValue:[NSData dataWithBytes: &i length: sizeof(i)] forCharacteristic:self.comCharac type:CBCharacteristicWriteWithResponse];
    [self.ConPeripheral readValueForCharacteristic:self.comCharac];

}
@end
