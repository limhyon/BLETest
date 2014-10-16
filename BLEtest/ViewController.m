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
    [_rollLabel release];
    [_pitchLabel release];
    [_thrLabel release];
    [_yawLabel release];
    [_updateBtnRef release];
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _updateBtnRef.enabled = NO;
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
        NSLog(@"Descovered BLE");
        
        peripheral.delegate = self;
        [CenManager connectPeripheral:peripheral options:nil];
        self.ConPeripheral = peripheral;
        
        [CenManager stopScan];
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral connect");
    [self.ConPeripheral discoverServices:nil];
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _updateBtnRef.enabled = NO;
    
    _rollLabel.text = @"";
    _pitchLabel.text = @"";
    _thrLabel.text = @"";
    _yawLabel.text = @"";
    
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
        //NSLog(@"Discovered characteristic %@", [NSNumber numberWithInt:Charac.properties]);
        if ([[NSNumber numberWithInt:Charac.properties] isEqualToNumber:[NSNumber numberWithInt:18]])
        {
            self.myCharac = Charac;
            _updateBtnRef.enabled = YES;
            //[self.ConPeripheral readValueForCharacteristic:Charac];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData* chaData = characteristic.value;
    
    const unsigned* dataBytes = [chaData bytes];
    NSString* dataString = [NSString stringWithFormat:@"%08x%08x%08x",ntohl(dataBytes[0]), ntohl(dataBytes[1]), ntohl(dataBytes[2])];
    
    NSString* rollString = [dataString substringWithRange:(NSRange){0,4}];
    NSString* pitchString = [dataString substringWithRange:(NSRange){4,4}];
    NSString* throString = [dataString substringWithRange:(NSRange){8,4}];
    NSString* yawString = [dataString substringWithRange:(NSRange){12,4}];
    
    
    //NSLog(@"Data : %@",chaData);
    //NSLog(@"String : %@  %@  %@  %@", rollString, pitchString, throString, yawString);
    _rollLabel.text = rollString;
    _pitchLabel.text = pitchString;
    _thrLabel.text = throString;
    _yawLabel.text = yawString;
}




#pragma mark - ButtonAction

- (IBAction)updateBtn:(id)sender
{
    [self.ConPeripheral readValueForCharacteristic:self.myCharac];
}




#pragma mark - MemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
