//
//  ActivitiesViewController.swift
//  Reminder
//
//  Created by Rusłan Chamski on 12/10/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController {

    // MARK: - View
    @IBOutlet var tableView: UITableView!
    @IBOutlet var gradientView: GradientView!
    
    // MARK: - Properties
    var isTableViewScrolling: ((Bool) -> Void)?
    var isClosedState: Bool = false
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ActivitiesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      isTableViewScrolling?(tableView.contentOffset.y == 0)
//        
        if !isClosedState {
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
}

extension ActivitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
        return cell
    }
}
