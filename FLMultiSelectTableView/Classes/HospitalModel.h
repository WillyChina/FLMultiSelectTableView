//
//  HospitalModel.h
//  PatientLeftNoDataView
//
//  Created by liweiwei on 2022/8/17.
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

