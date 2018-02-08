//
//  CharactersRemoteDataSource.h
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 04..
//  Copyright © 2018. W.UP. All rights reserved.
//

#import "CharactersDataSource.h"

@class AFHTTPSessionManager;

@interface CharactersRemoteDataSource : NSObject<CharactersDataSource>

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)sessionManager NS_DESIGNATED_INITIALIZER;

@end
