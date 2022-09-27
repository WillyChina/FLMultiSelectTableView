//
//  HospitalModel.m
//  PatientLeftNoDataView
//
//  Created by liweiwei on 2022/8/17.
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
