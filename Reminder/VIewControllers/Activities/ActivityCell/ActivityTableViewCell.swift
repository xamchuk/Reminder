//
//  ActivityTableViewCell.swift
//  Reminder
//
//  Created by Rusłan Chamski on 12/10/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    // MARK: - Views
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Properties
    var days: [WeekActivity] = [
        WeekActivity(day: "S", progress: 1, isToday: false),
        WeekActivity(day: "M", progress: 8, isToday: false),
        WeekActivity(day: "T", progress: 6, isToday: false),
        WeekActivity(day: "W", progress: 4, isToday: false),
        WeekActivity(day: "T", progress: 10, isToday: false),
        WeekActivity(day: "F", progress: 7, isToday: false),
        WeekActivity(day: "S", progress: 9, isToday: false)
        ]

    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ActivityTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionCell", for: indexPath) as! ActivityCollectionViewCell
        cell.configure(content: days[indexPath.item])
        return cell
    }
}

extension ActivityTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 16, height: collectionView.frame.height)
    }
}
