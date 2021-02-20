//
//  AppDelegate.m
//  FnSmartSwicher
//
//  Created by Raccoon on 2021/2/19.
//

#import "AppDelegate.h"
#import "MyWindowController.h"
#import <ApplicationServices/ApplicationServices.h>

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property (weak) IBOutlet MyWindowController *controller;
@property (weak) IBOutlet NSButton *showInDockCheckBox;

@end

@implementation AppDelegate
@synthesize menubar = _menubar;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserverForName:NSWorkspaceDidActivateApplicationNotification object:nil queue:nil usingBlock:^(NSNotification *notify) {
        
        NSRunningApplication *runningApp = [notify.userInfo valueForKey:@"NSWorkspaceApplicationKey"];
        NSLog(@"%@", [runningApp bundleIdentifier]);
        
        [[self controller] onAppChanged:[runningApp bundleIdentifier]];
    }];
    
    [self setAgent];
    [self setUpStatusBar];
    [[self controller] showCurrentState];
    
}

- (IBAction)onShowInDockClick:(id)sender {
    NSButtonCell *cell = [sender selectedCell];
    
    if (cell.state == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AgentApp"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AgentApp"];
    }
    [self setAgent];
}

- (void) setAgent
{
    ProcessSerialNumber psn = {0, kCurrentProcess};
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AgentApp"]) {
        TransformProcessType(&psn, kProcessTransformToUIElementApplication);
    } else {
        TransformProcessType(&psn, kProcessTransformToForegroundApplication);
    }
}

- (void) setUpStatusBar
{
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    _menubar = [statusBar statusItemWithLength:NSVariableStatusItemLength];
     //NSImage *image = [NSImage imageNamed:@"fan.png"];
    
    _menubar.title = @"fn";
     //item.image = image;
    _menubar.highlightMode = YES;
    
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItem:[[NSMenuItem alloc] initWithTitle:@"Preference" action:@selector(showWindow) keyEquivalent:@""]];
    [menu addItem:[[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""]];
    
    
    _menubar.menu = menu;
}

- (void)showWindow
{
    [[self window] setLevel:NSFloatingWindowLevel];
    
    [[self window] makeKeyAndOrderFront:self];
}


@end
