//
//  BlogPost.h
//  BlogReader
//
//  Created by Brandon Smith on 3/15/13.
//  Copyright (c) 2013 Brandon Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogPost : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *author;

// Dedicated Initializer
-(id) initWithTitle:(NSString *)title;
+(id) blogPostWithTitle:(NSString *)title;
@end
