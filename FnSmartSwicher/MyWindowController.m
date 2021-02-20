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
    [self showCurrentState];
}

- (IBAction)onChangeBtnClick:(id)sender {
    [keyController toggleFnKey];
    [self showCurrentState];
}

-(void) showCurrentState {
    FnKeyState state = [keyController getCurrentMode];
    NSLog(@"Change FKeyState to :%d", state);
    
    NSMutableString *labelStr = [[NSMutableString alloc] initWithString:@"Current State: "];
    
    switch (state) {
        case FnStateAppleMode:
            [labelStr appendString:@"Apple Mode"];
            break;
        case FnStateFnMode:
            [labelStr appendString:@"Fn Mode"];
            break;
        default:
            [labelStr appendString:@"Unknown Mode"];
            break;
    }
    
    [[self stateLabel] setStringValue:labelStr];
}

@end
