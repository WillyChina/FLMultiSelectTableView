//
//  PatientSelectTableCell.m
//  PatientLeftNoDataView
//
//  Created by liweiwei on 2022/6/6.
//

#import "PatientSelectTableCell.h"

@implementation PatientSelectTableCell

-(void)configData:(HospitalModel *)model{
    _titleLab.text = model.Text;
    _selectBtn.hidden = !model.IsChoose;
    if (model.IsChoose) {
//        _titleLab.textColor = Color_hex(@"#4CC5CD");
    }else{
//        _titleLab.textColor = Color_hex(@"#595959");
    }
}

-(void)configCenterData:(HospitalModel *)model{
    _titleLab.text = model.Name;
    _selectBtn.hidden = !model.IsChoose;
    if (model.IsChoose) {
//        _titleLab.textColor = Color_hex(@"#4CC5CD");
    }else{
//        _titleLab.textColor = Color_hex(@"#595959");
    }}


- (void)awakeFromNib {
    [super awakeFromNib];
    _selectBtn.hidden = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
