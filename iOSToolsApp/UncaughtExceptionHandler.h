//
//  UncaughtExceptionHandler.h
//  iOSToolsApp
//
//  Created by jointsky on 16/9/19.
//  Copyright © 2016年 陈帆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject {
    BOOL dismissed;
}

@end

void HandleException(NSException *exception);
void SignalHandler(int signal);

void InstallUncaughtExceptionHandler(void);