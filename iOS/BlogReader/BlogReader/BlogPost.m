//
//  BlogPost.m
//  BlogReader
//
//  Created by Brandon Smith on 3/15/13.
//  Copyright (c) 2013 Brandon Smith. All rights reserved.
//

#import "BlogPost.h"

@implementation BlogPost

-(id) initWithTitle:(NSString *)title {

    self = [super init];
    
    if ( self ) {
        self.title = title;
    }
    
    return self;
}

+ (id) blogPostWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle: title];
}


@synthesize title = title;

@end
