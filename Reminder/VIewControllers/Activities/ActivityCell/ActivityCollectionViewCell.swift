//
//  ActivityCollectionViewCell.swift
//  Reminder
//
//  Created by Rusłan Chamski on 12/10/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {

    // MARK: - Views
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var progressView: UIView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Methods
    func configure(content: WeekActivity) {
        dayLabel.text = content.day
        progressView.backgroundColor = content.color
        progressLabel.text = "\(content.progress)"
        progressViewHeightConstraint.constant = CGFloat(content.progress) * 10
    }
}
