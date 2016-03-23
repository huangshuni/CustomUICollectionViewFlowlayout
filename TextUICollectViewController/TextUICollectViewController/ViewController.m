//
//  ViewController.m
//  TextUICollectViewController
//
//  Created by huangshuni on 16/1/15.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewController.h"

#define TextFiled_Tag 2000

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic,assign)NSInteger column;
@property (nonatomic,assign)NSInteger margin;
@property (nonatomic,assign)NSInteger cellMinHeight;
@property (nonatomic,assign)NSInteger cellMaxHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *arr = [NSArray arrayWithObjects:@"Column(列数):",@"Margin(边距):",@"Cell Min Height",@"Cell Max Height", nil];
    
    for (int i = 0; i < arr.count; i++) {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 100+(30+10)*i, 150, 30)];
        lbl.text = arr[i];
        [self.view addSubview:lbl];
        
        UITextField *textFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame)+10, 100+(30+10)*i, 180, 30)];
        textFiled.delegate  = self;
//        [textFiled addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
        textFiled.tag  = TextFiled_Tag + i;
        textFiled.borderStyle  = UITextBorderStyleBezel;
        textFiled.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:textFiled];
        
        if (i == arr.count - 1) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(self.view.bounds.size.width/2 - 100/2, CGRectGetMaxY(textFiled.frame) + 100, 100, 30);
            btn.backgroundColor = [UIColor redColor];
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(setAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
    }
    
    
}

#pragma mark === UITextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag - TextFiled_Tag) {
        case 0:
            self.column = [textField.text integerValue];
            
            break;
        case 1:
            self.margin = [textField.text integerValue];
            
            break;
        case 2:
            self.cellMinHeight = [textField.text integerValue];
            
            break;
        case 3:
            self.cellMaxHeight = [textField.text integerValue];
            
            break;
            
        default:
            break;
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

    switch (textField.tag - TextFiled_Tag) {
        case 0:
            self.column = [textField.text integerValue];
            
            break;
        case 1:
            self.margin = [textField.text integerValue];
            
            break;
        case 2:
            self.cellMinHeight = [textField.text integerValue];
            
            break;
        case 3:
            self.cellMaxHeight = [textField.text integerValue];
            
            break;
            
        default:
            break;
    }

}

-(void)setAction:(UIButton *)btn
{
    for (int i = 0; i<4; i++) {
        UITextField *textFiled = [self.view viewWithTag:TextFiled_Tag + i];
        [textFiled resignFirstResponder];
    }
    
    MyCollectionViewController *vc = [[MyCollectionViewController alloc]initWithColumn:self.column Margin:self.margin cellMinHeight:self.cellMinHeight cellMaxHeight:self.cellMaxHeight];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
