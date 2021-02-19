//
//  MyWindowController.m
//  FnSmartSwicher
//
//  Created by Raccoon on 2021/2/19.
//

#import "MyWindowController.h"

@import Cocoa;
@import IOKit;

@interface MyWindowController()

@property (weak) IBOutlet NSTextField *stateLabel;
@property (weak) IBOutlet NSButton *changeBtn;

@end

@implementation MyWindowController
{
    NSArray *fnModeWhiteList;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init MyWindowController");
        fnModeWhiteList = @[
            @"com.apple.dt.Xcode",
            @"com.googlecode.iterm2"
        ];
    }
    return self;
}

- (void)onAppChanged:(NSString *)appIdentify
{
    if ([fnModeWhiteList containsObject:appIdentify]) {
        [self testSetToEnable];
    } else {
        [self testSetToDisable];
    }
}

- (IBAction)onChangeBtnClick:(id)sender {
    NSLog(@"change fn setting");
    
    NSNumber *currentMode = [self getFKeyState];
    
    if ([currentMode isEqual:@0]) {
        [self testSetToEnable];
    } else {
        [self testSetToDisable];
    }
    [self printFnKeyMode];
}

- (IBAction)onLoopClick:(id)sender {
    NSLog(@"test");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (true) {
            usleep(100);
            
            [self onChangeBtnClick:nil];
            
        }
    });
}


- (void)viewLoaded
{
    [self printFnKeyMode];
}

- (void)printFnKeyMode{
    NSLog(@"%@", [self getFKeyState]);
}

- (NSNumber *)getFKeyState {
    io_service_t service = IORegistryEntryFromPath(kIOMasterPortDefault, kIOServicePlane ":/IOResources/IOHIDSystem");
    CFDictionaryRef parameter = IORegistryEntryCreateCFProperty(service,CFSTR(kIOHIDParametersKey), kCFAllocatorDefault, kNilOptions);
    IOObjectRelease(service);
    
    NSDictionary *hidParas = (__bridge NSDictionary *)parameter;
    return hidParas[@"HIDFKeyMode"];
}

-(void)testSet{
    io_service_t service = IORegistryEntryFromPath(kIOMasterPortDefault, kIOServicePlane ":/IOResources/IOHIDSystem");
    
    NSDictionary *params = (__bridge NSDictionary *) IORegistryEntryCreateCFProperty(service,CFSTR(kIOHIDParametersKey), kCFAllocatorDefault, kNilOptions);
    
    NSMutableDictionary *newParam = [params mutableCopy];
    
    long mode = 0;
    
    newParam[@"HIDFKeyMode"] = (__bridge NSNumber*)CFNumberCreate(kCFAllocatorDefault, kCFNumberLongType, &mode);
    
    kern_return_t kern_ret = IORegistryEntrySetCFProperty(service, CFSTR(kIOHIDParametersKey), (__bridge CFDictionaryRef)newParam);
    
    NSLog(@"%u", kern_ret);
    
    IOObjectRelease(service);
}

-(void)testSetToEnable {
    io_connect_t handle = NXOpenEventStatus();
    if (handle) {
        long mode = 1;
        IOHIDSetParameter(handle, CFSTR(kIOHIDFKeyModeKey), &mode, sizeof(UInt32));
        
        NXCloseEventStatus(handle);
    }
}

-(void)testSetToDisable {
    io_connect_t handle = NXOpenEventStatus();
    if (handle) {
        long mode = 0;
        IOHIDSetParameter(handle, CFSTR(kIOHIDFKeyModeKey), &mode, sizeof(UInt32));
        
        NXCloseEventStatus(handle);
    }
}

@end
