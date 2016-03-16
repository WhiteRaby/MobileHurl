//
//  RestManager.m
//  MobileHurl
//
//  Created by Alexandr on 16.03.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "RestManager.h"
#import <RestKit/RestKit.h>

@implementation RestManager

+ (RestManager*)sharedManager {
    
    static RestManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RestManager alloc] init];
    });
    
    return manager;
}

- (void)getRequestToURL:(NSURL*)url
              withParam:(NSDictionary*)param
                success:(void(^)(NSDictionary *result))success
                failure:(void(^)(NSError *error))failure {
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager
     getObjectsAtPath:@""
     parameters:param
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         NSError *error = nil;
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingMutableLeaves error:&error];
         if (success) {
             success(json);
         }
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         } else {
             NSLog(@"ERRRRRROR %@", error);
         }
     }];
}

@end
