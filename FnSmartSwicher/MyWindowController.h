//
//  MyWindowController.h
//  FnSmartSwicher
//
//  Created by Raccoon on 2021/2/19.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface MyWindowController : NSObject

- (void)onAppChanged:(NSString *)appIdentify;
-(void) showCurrentState;

@end

NS_ASSUME_NONNULL_END
