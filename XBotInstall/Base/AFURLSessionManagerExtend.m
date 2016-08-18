//
//  AFURLSessionManagerExtend.m
//  XBotInstall
//
//  Created by Xiu on 15/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "AFURLSessionManagerExtend.h"

@implementation AFURLSessionManagerExtend

/**
 *  信任不安全证书
 *  TODO 只信任指定证书
 */
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
    }else {
        if (challenge.previousFailureCount > 0) {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        } else {
            credential = [self.session.configuration.URLCredentialStorage defaultCredentialForProtectionSpace:challenge.protectionSpace];
            
            if (credential != nil) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            }
        }
    }
    completionHandler(disposition, credential);
}

@end
