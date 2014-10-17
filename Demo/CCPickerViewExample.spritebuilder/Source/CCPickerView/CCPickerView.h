//
//  CCPickerView.h
//  CCPickerView
//
//  Originally Created by Mick Lester on 5/16/12.
//  Copyright (c) 2012 fidgetware. All rights reserved.
//
//  Updated Code to Cocos2d v3 by Lahiru Lakmal on 17/10/14

#import "CCNode.h"
#import "ScrollLayer.h"

@protocol CCPickerViewDataSource;
@protocol CCPickerViewDelegate;

@interface CCPickerView : CCNode <ScrollLayerDelegate> {
    BOOL repeatNodes;
    CCClippingNode *scissor;
}
@property (nonatomic, assign) id <CCPickerViewDataSource> dataSource;
@property (nonatomic, assign) id <CCPickerViewDelegate> delegate;

@property(nonatomic, readonly) NSInteger numberOfComponents;

- (NSInteger)numberOfRowsInComponent:(NSInteger)component;
- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;
- (CGSize)rowSizeForComponent:(NSInteger)component;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (CCNode *)nodeForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)autoRepeatNodes:(BOOL)repeat;
- (void)spinComponent:(NSInteger)component speed:(float)speed easeRate:(float)rate repeat:(NSInteger)repeat stopRow:(NSInteger)row;
@end

@protocol CCPickerViewDataSource <NSObject>
- (NSInteger)numberOfComponentsInPickerView:(CCPickerView *)pickerView;
- (NSInteger)pickerView:(CCPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
@end

@protocol CCPickerViewDelegate <NSObject>
- (CGFloat)pickerView:(CCPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (CGFloat)pickerView:(CCPickerView *)pickerView widthForComponent:(NSInteger)component;
- (NSString *)pickerView:(CCPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (CCNode *)pickerView:(CCPickerView *)pickerView nodeForRow:(NSInteger)row forComponent:(NSInteger)component reusingNode:(CCNode *)node;
- (void)pickerView:(CCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSString*)component;
- (CGFloat)spaceBetweenComponents:(CCPickerView *)pickerView;
- (CGSize)sizeOfPickerView:(CCPickerView *)pickerView; 
- (CCNode *)overlayImage:(CCPickerView *)pickerView;
@optional
- (void)onDoneSpinning:(CCPickerView *)pickerView component:(NSString*)component;
@end
