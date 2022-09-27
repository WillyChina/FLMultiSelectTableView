//
//  HospitalModel.m
//  CR-HepB-MHD
//
//  Created by it on 2018/12/20.
//  Copyright © 2018年 peter.ye. All rights reserved.
//

#import "HospitalModel.h"

@implementation HospitalModel
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"value"])
    {
        _Value = value;
        return;
    }
    if ([key isEqualToString:@"text"])
    {
        _Text = value;
        return;
    }
    
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
