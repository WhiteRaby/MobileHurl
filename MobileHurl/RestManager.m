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
                headers:(NSDictionary*)headers
                success:(void(^)(NSString *result))success
                failure:(void(^)(NSError *error))failure {
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client setDefaultHeader:@"" value:@""];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    for (NSString *key in headers) {
        [objectManager.HTTPClient setDefaultHeader:key value:headers[key]];
    }
    
    [objectManager
     getObjectsAtPath:@""
     parameters:param
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         
         NSError *error = nil;
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingMutableLeaves error:&error];
         NSString *result = [NSString stringWithFormat:@"Status code = %ld\n\nBody = \n%@",
                             operation.HTTPRequestOperation.response.statusCode,
                             json];
         if (success) {
             success(result);
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
