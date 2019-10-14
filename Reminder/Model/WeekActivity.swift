//
//  WeekActivity.swift
//  Reminder
//
//  Created by Rusłan Chamski on 12/10/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

struct WeekActivity {
    var day: String
    var progress: Int
    var isToday: Bool
    
    var color: UIColor {
        switch progress {
        case 0...2: return .red
        case 3...5: return .orange
        case 6...8: return .yellow
        default: return .green
        }
    }
}
