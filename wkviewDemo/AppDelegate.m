//
//  AppDelegate.m
//  wkviewDemo
//
//  Created by yj on 2020/7/22.
//  Copyright © 2020 yj. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
@interface AppDelegate ()
@property (strong) WKWebView* pWebView;
@property (strong) NSString* jsCode;
@end

@implementation AppDelegate{
    WKWebView* _webView;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _jsCode=@"navigator.userAgent";
    for (int i=0; i<100; i++) {
        [self setWebViewWithTemp];
        [self setWebViewWithBlock];
        [self setWebViewWithStructures];
        [self setWebViewWithProperty];
    }
    
    return YES;
}

- (void)setWebViewWithTemp
{
    WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    id count=[webView valueForKey:@"retainCount"];
    NSLog(@"%@",count);
    [webView evaluateJavaScript:_jsCode completionHandler:^(id _Nullable userAgent, NSError * _Nullable error) {
        NSLog(@"Temp:   %@-%@",userAgent,error);
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (void)setWebViewWithBlock
{
    __block WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    id count=[webView valueForKey:@"retainCount"];
    NSLog(@"%@",count);
    [webView evaluateJavaScript:_jsCode completionHandler:^(id _Nullable userAgent, NSError * _Nullable error) {
        NSLog(@"Block:   %@-%@",userAgent,error);
        webView=nil;
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}
- (void)setWebViewWithStructures{
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            // Save WKWebView (it might deallocate before we ask for user Agent)
            strongSelf->_webView = [[WKWebView alloc] init];
            id count=[self->_webView valueForKey:@"retainCount"];
            NSLog(@"%@",count);
            [strongSelf->_webView evaluateJavaScript:strongSelf->_jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"Structures:   %@-%@",result,error);
                self->_webView = nil;
             
                if (error) {
                    NSLog(@"%@",error);
                }
            }];
        }
    });
}
- (void)setWebViewWithProperty{
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            // Save WKWebView (it might deallocate before we ask for user Agent)
            strongSelf.pWebView = [[WKWebView alloc] init];
            id count=[strongSelf.pWebView valueForKey:@"retainCount"];
            NSLog(@"%@",count);
            [strongSelf.pWebView evaluateJavaScript:strongSelf.jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"Property:   %@-%@",result,error);
                strongSelf.pWebView = nil;
             
                if (error) {
                    NSLog(@"%@",error);
                }
            }];
        }
    });
}
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {

    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


@end
