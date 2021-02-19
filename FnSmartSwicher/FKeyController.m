//
//  FKeyController.m
//  FnSmartSwicher
//
//  Created by Raccoon on 2021/2/20.
//

#import "FKeyController.h"

@import IOKit;

@implementation FKeyController

- (io_connect_t) getIOConnect {
    kern_return_t kern_ret = 0;
    io_connect_t connect = 0;
    
    io_registry_entry_t entry = IORegistryEntryFromPath(kIOMasterPortDefault, kIOServicePlane ":/IOResources/IOHIDSystem");
    
    if (!entry) {
        return -1;
    }
    
    kern_ret = IOServiceOpen(entry, mach_task_self(), kIOHIDParamConnectType, &connect);
    IOObjectRelease(entry);
    
    if (kern_ret != kHIDSuccess) {
        if (!entry) IOObjectRelease(entry);
        return -1;
    }
    return connect;
}


- (void) toggleFnKey {
    FnKeyState state = [self getCurrentMode];
    if (state == FnStateAppleMode) {
        [self setMode:1];
    } else {
        [self setMode:0];
    }
}

- (void) setFnMode {
    [self setMode:1];
}

- (void) setAppleMode {
    [self setMode:0];
}

- (void) setMode:(long) mode {
    io_connect_t connect = [self getIOConnect];
    if (connect == -1) {
        return;
    }
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberLongType, &mode);
    
    IOConnectSetCFProperty(connect, CFSTR(kIOHIDFKeyModeKey), num);
    IOObjectRelease(connect);
}

- (FnKeyState) getCurrentMode {
    
    io_connect_t connect = [self getIOConnect];
    if (connect == -1) {
        return FnStateGetError;
    }
    
    CFTypeRef typeRef = NULL;
    CFNumberRef num;
    IOHIDCopyCFTypeParameter(connect, CFSTR(kIOHIDFKeyModeKey) , &typeRef);
    
    IOObjectRelease(connect);
    
    if (CFGetTypeID(typeRef) == CFNumberGetTypeID()) {
        num = (CFNumberRef) typeRef;
        if ([(__bridge NSNumber *)num isEqual:@0]) {
            return FnStateAppleMode;
        } else {
            return FnStateFnMode;
        }
    } else {
        return FnStateGetError;
    }
    
    return FnStateAppleMode;
}

@end
