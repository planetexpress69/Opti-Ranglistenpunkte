//
//  TokenSender.h
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 23.01.15.
//  Copyright (c) 2015 Martin Kautz. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface TokenSenderEngine : MKNetworkEngine
// -----------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)sendToken:(NSString *)token toPath:(NSString *)path
     onCompletion:(MKNKResponseBlock)completionBlock
          onError:(MKNKErrorBlock)errorBlock;
// -----------------------------------------------------------------------------------------------------------------------------------------------------------
@end
