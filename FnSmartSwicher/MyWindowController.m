//
//  MyWindowController.m
//  FnSmartSwicher
//
//  Created by Raccoon on 2021/2/19.
//

#import "MyWindowController.h"
#import "FKeyController.h"

@import Cocoa;
@import IOKit;

@interface MyWindowController()

@property (weak) IBOutlet NSTextField *stateLabel;
@property (weak) IBOutlet NSButton *changeBtn;

@end

@implementation MyWindowController
{
    NSArray *fnModeWhiteList;
    FKeyController *keyController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        fnModeWhiteList = @[
            @"com.apple.dt.Xcode",
            @"com.googlecode.iterm2"
        ];
        keyController = [FKeyController new];
    }
    return self;
}

- (void)onAppChanged:(NSString *)appIdentify
{
    if ([fnModeWhiteList containsObject:appIdentify]) {
        [keyController setFnMode];
    } else {
        [keyController setAppleMode];
    }
    NSLog(@"Change FKeyState to :%d", [keyController getCurrentMode]);
}

- (IBAction)onChangeBtnClick:(id)sender {
    [keyController toggleFnKey];
    NSLog(@"Change FKeyState to :%d", [keyController getCurrentMode]);
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

@end
