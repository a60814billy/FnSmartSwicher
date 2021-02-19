//
//  AppDelegate.m
//  FnSmartSwicher
//
//  Created by Raccoon on 2021/2/19.
//

#import "AppDelegate.h"
#import "MyWindowController.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property (weak) IBOutlet MyWindowController *controller;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserverForName:NSWorkspaceDidActivateApplicationNotification object:nil queue:nil usingBlock:^(NSNotification *notify) {
        
        NSRunningApplication *runningApp = [notify.userInfo valueForKey:@"NSWorkspaceApplicationKey"];
        NSLog(@"%@", [runningApp bundleIdentifier]);
        
        [[self controller] onAppChanged:[runningApp bundleIdentifier]];
        
    }];
    
    [[self controller] viewLoaded];
    
}

@end
