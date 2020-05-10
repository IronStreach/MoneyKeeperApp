//
//  checkData.swift
//  MoneyKeeper
//
//  Created by Станислав Никишков on 10.05.2020.
//  Copyright © 2020 Станислав Никишков. All rights reserved.
//

import Foundation
import UIKit

func checkDataIsEmpty(data: UITextField) -> Bool {
    guard data.text != nil && data.text != "" else { return false }
    return true
}

func checkDataIsPositiveNumber(data: UITextField) -> Bool {
    guard data.text != nil && data.text != "" && Double(data.text!) != nil
        && Double(data.text!)! > 0 else { return false }
    return true
}
