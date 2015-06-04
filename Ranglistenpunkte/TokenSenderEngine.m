//
//  TokenSender.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 23.01.15.
//  Copyright (c) 2015 Martin Kautz. All rights reserved.
//

#import "TokenSenderEngine.h"

@implementation TokenSenderEngine
- (void)sendToken:(NSString *)token toPath:(NSString *)path
     onCompletion:(MKNKResponseBlock)completionBlock
          onError:(MKNKErrorBlock)errorBlock
{
    NSDictionary *params = @{
                             @"token" : token
                             };

    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:NO];

    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock(completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];

    [self enqueueOperation:op];
}
@end
