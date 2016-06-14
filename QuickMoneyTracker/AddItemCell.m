//
//  AddItemCell.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/10.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "AddItemCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Defs.h"

#define kHowMuchTextFieldTag            1
#define kKingCostTextFieldTag           2
#define kQueneCostTextFieldTag          3
#define kWhatTextFieldTag               4

@interface AddItemCell ()

@property (nonatomic) double howMuchValue;
@property (nonatomic) double kingCostValue;
@property (nonatomic) double queneCostValue;
@property (nonatomic) NSString *whatValue;

@property (nonatomic) BOOL howMuchValueHasChanged;

@end

@implementation AddItemCell

- (instancetype)initWithConsumeEventItem:(ConsumeEventItem *)item
{
    self = [super init];
    if (self)
    {
        double kSpaceXStart = 0;
        
        _howMuchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kHowMuchColumnWidth, kCellHeight)];
        [_howMuchTextField setTag:kHowMuchTextFieldTag];
        kSpaceXStart += kHowMuchColumnWidth + kGapWidth;
        
        _kingCostTextField = [[UITextField alloc] initWithFrame:CGRectMake(kSpaceXStart, 0, kKingCostColumnWidth, kCellHeight)];
        [_kingCostTextField setTag:kKingCostTextFieldTag];
        kSpaceXStart += kKingCostColumnWidth + kGapWidth;
        
        _queneCostTextField = [[UITextField alloc] initWithFrame:CGRectMake(kSpaceXStart, 0, kQueneCostColumnWidth, kCellHeight)];
        [_queneCostTextField setTag:kQueneCostTextFieldTag];
        kSpaceXStart += kQueneCostColumnWidth + kGapWidth;
        
        _whatTextField = [[UITextField alloc] initWithFrame:CGRectMake(kSpaceXStart, 0, kWhatColumnWidth, kCellHeight)];
        [_whatTextField setTag:kWhatTextFieldTag];
        
        [self.contentView addSubview:_howMuchTextField];
        [self.contentView addSubview:_kingCostTextField];
        [self.contentView addSubview:_queneCostTextField];
        [self.contentView addSubview:_whatTextField];
        
        [self setupTextFields];
        [_howMuchTextField becomeFirstResponder];
        
        [self setHowMuchValue:[item howMuch]];
        [self setKingCostValue:[item kingCost]];
        [self setQueneCostValue:[item queneCost]];
        [self setWhatValue:[item what]];
        
        _howMuchValueHasChanged = NO;
        
    }
    return self;
}

- (void) setupTextFields
{
    for (UITextField *textField in self.contentView.subviews)
    {
        [textField setTintColor:[UIColor greenColor]];
        
        //设置 borderColor
        textField.layer.cornerRadius=8.0f;
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor=[[UIColor greenColor]CGColor];
        textField.layer.borderWidth= 0.5f;
        
        [textField setTextAlignment:NSTextAlignmentCenter];
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [textField setReturnKeyType:UIReturnKeyNext];
        [textField setEnablesReturnKeyAutomatically:YES];
        [textField setDelegate:self];
        
        //whatTextField自定特性
        if (textField.tag == kWhatTextFieldTag)
        {
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setKeyboardType:UIKeyboardTypeDefault];
        }
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag < kWhatTextFieldTag)
    {
        UITextField *nextTextField = [self.contentView viewWithTag:(textField.tag + 1)];
        [nextTextField becomeFirstResponder];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSaveItemNotification object:[UIApplication sharedApplication]];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (![self isValid:textField])
    {
        [self setupForWrongInput:textField];
        return NO;
    }
    else
    {
        
        [self setupValueWithTextField:textField];
   
        
        [self setupForRightInput:textField];
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:self];
    if ([textField tag] == kHowMuchTextFieldTag || [textField tag] == kWhatTextFieldTag)
    {
        if ((!_howMuchValueHasChanged) && (_kingCostValue != 0 || _queneCostValue != 0))
            [self setHowMuchValue:(_kingCostValue + _queneCostValue)];
    }
}

#pragma mark - 辅助函数

- (BOOL) isValid:(UITextField *)textField
{
    if ([textField tag] == kWhatTextFieldTag)   return YES;
    
    NSScanner *scanner = [NSScanner scannerWithString:[textField text]];
    double val;
    while ([scanner scanDouble:&val])   ;
    return [scanner isAtEnd];
}

- (double) calculateValue:(UITextField *)textField
{
    double rlt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:[textField text]];
    double val;
    while ([scanner scanDouble:&val]) rlt += val  ;
    return rlt;
}

- (BOOL)canSave
{
    return [self isValid:_howMuchTextField] && [self isValid:_kingCostTextField] &&
    [self isValid:_queneCostTextField] && ([self calculateValue:_howMuchTextField] == [self calculateValue:_kingCostTextField] + [self calculateValue:_queneCostTextField]) && ([_whatTextField text] != nil) && ([[_whatTextField text] length] != 0);
}

/**
 *  当输入有误时设置该textField颜色
 *
 *  @param textField
 */
- (void)setupForWrongInput:(UITextField *)textField
{
    [textField setTextColor:[UIColor redColor]];
    textField.layer.borderColor=[[UIColor redColor]CGColor];
}
/**
 *  当输入有效时设置该textField颜色
 *
 *  @param textField
 */
- (void)setupForRightInput:(UITextField *)textField
{
    [textField setTextColor:[UIColor greenColor]];
    textField.layer.borderColor=[[UIColor greenColor]CGColor];
}

/**
 *  刷新value值同时检查有效性
 *
 *  @param textField
 *
 *  @return 返回值是否有效
 */
- (void) setupValueWithTextField:(UITextField *)textField;
{
    switch ([textField tag]) {
        case kHowMuchTextFieldTag:
        {
            if (_howMuchValue != [self calculateValue:textField])
            {
                _howMuchValueHasChanged = YES;
                [self setHowMuchValue:[self calculateValue:textField]];
            }
            if (_kingCostValue != 0 && _queneCostValue == 0)
                [self setQueneCostValue:(_howMuchValue - _kingCostValue)];
            else if(_queneCostValue != 0 && _kingCostValue == 0)
                [self setKingCostValue:(_howMuchValue - _queneCostValue)];
            else
            {
                [self setKingCostValue:_howMuchValue / 2.0];
                [self setQueneCostValue:_howMuchValue / 2.0];
            }
        }
            break;
        case kKingCostTextFieldTag:
        {
            [self setKingCostValue:[self calculateValue:textField]];
            if (_howMuchValueHasChanged)
                [self setQueneCostValue:(_howMuchValue - _kingCostValue)];
            else
                [self setHowMuchValue:(_kingCostValue + _queneCostValue)];
        }
            break;
        case kQueneCostTextFieldTag:
        {
            [self setQueneCostValue:[self calculateValue:textField]];

            if (_howMuchValueHasChanged)
                [self setKingCostValue:(_howMuchValue - _queneCostValue)];
            else
                [self setHowMuchValue:(_kingCostValue + _queneCostValue)];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark setters and getters

- (void)setHowMuchValue:(double)howMuchValue
{
    _howMuchValue = howMuchValue;
    [_howMuchTextField setText: [NSString stringWithFormat:@"%.1f", _howMuchValue]];
}

- (void)setKingCostValue:(double)kingCostValue
{
    _kingCostValue = kingCostValue;
    [_kingCostTextField setText: [NSString stringWithFormat:@"%.1f", _kingCostValue]];
}

- (void)setQueneCostValue:(double)queneCostValue
{
    _queneCostValue = queneCostValue;
    [_queneCostTextField setText: [NSString stringWithFormat:@"%.1f", _queneCostValue]];
}

- (void)setWhatValue:(NSString *)whatValue
{
    _whatValue = whatValue;
    [_whatTextField setText:_whatValue];
}

@end
