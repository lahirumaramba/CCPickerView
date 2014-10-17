//
//  MainScene.h
//  CCPickerViewExample
//
//  Created by Lahiru on 17/10/14.
//  Copyright (c) 2013 SoundofCode. All rights reserved.
//

#import "CCNode.h"
#import "CCPickerView/CCPickerView.h"

@interface MainScene : CCNode <CCPickerViewDataSource, CCPickerViewDelegate> {
    
    CCPickerView* pickerView;
    CCSprite* m_slotwindow;
}

@end
