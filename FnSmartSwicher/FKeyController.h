//
//  FKeyController.h
//  FnSmartSwicher
//
//  Created by Raccoon on 2021/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum _FnKeyState {
    FnStateGetError = -1,
    FnStateAppleMode = 0,
    FnStateFnMode = 1
} FnKeyState;

@interface FKeyController : NSObject
- (void) toggleFnKey;
- (void) setFnMode;
- (void) setAppleMode;
- (FnKeyState) getCurrentMode;
@end

NS_ASSUME_NONNULL_END
