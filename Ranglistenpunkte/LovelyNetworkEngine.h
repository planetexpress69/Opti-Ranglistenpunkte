//
//  LovelyNetworkEngine.h
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 21.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "MKNetworkEngine.h"


@interface LovelyNetworkEngine : MKNetworkEngine
//----------------------------------------------------------------------------------------------------------------------
- (void)fetchPayloadForPath:(NSString *)path
               onCompletion:(MKNKResponseBlock)completionBlock
                      onError:(MKNKErrorBlock)errorBlock;
//----------------------------------------------------------------------------------------------------------------------
@end
