//
//  HospitalModel.h
//  CR-HepB-MHD
//
//  Created by it on 2018/12/20.
//  Copyright © 2018年 peter.ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HospitalModel : NSObject

@property (nonatomic,strong) NSString *Name;

@property (nonatomic,strong) NSString *Id;

@property (nonatomic) BOOL IsChoose;
//是否显示
@property (nonatomic) BOOL IsShow;

@property (nonatomic,strong) NSString *Text;

@property (nonatomic,strong) NSString *Value;
@end

