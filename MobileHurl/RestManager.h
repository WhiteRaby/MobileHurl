//
//  RestManager.h
//  MobileHurl
//
//  Created by Alexandr on 16.03.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestManager : NSObject

+ (RestManager*)sharedManager;

- (void)getRequestToURL:(NSURL*)url withParam:(NSDictionary*)param success:(void(^)(NSDictionary *result))success failure:(void(^)(NSError *error))failure;
@end
