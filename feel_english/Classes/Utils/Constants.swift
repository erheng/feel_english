//
// Created by erheng on 2019/11/25.
// Copyright (c) 2019 deepfeel. All rights reserved.
//

import Foundation
import UIKit

// height and width
let SCREEN_FRAME: CGRect = UIScreen.main.bounds
let SCREEN_WIDTH = SCREEN_FRAME.size.width
let SCREEN_HEIGHT = SCREEN_FRAME.size.height
let STATUS_BAR_HEIGHT = UIApplication.shared.statusBarFrame.height
let SAFE_AREA_TOP_HEIGHT: CGFloat = (SCREEN_HEIGHT >= 812.0 && UIDevice.current.model == "iPhone" ? 88 : 64)
let SAFE_AREA_BOTTOM_HEIGHT: CGFloat = (SCREEN_HEIGHT >= 812.0 && UIDevice.current.model == "iPhone" ? 30 : 0)