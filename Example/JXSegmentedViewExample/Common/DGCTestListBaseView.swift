//
//  TestListView.swift
//  DGCJXPagingView
//
//  Created by jiaxin on 2018/5/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCTestListBaseView: UIView {
    var tableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DGCPagingListBaseCell.self, forCellReuseIdentifier: "cell")
        addSubview(tableView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.frame = bounds
    }

}

extension DGCTestListBaseView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dgc_cell = tableView.dequeueReusableCell(withIdentifier: "dgc_cell", for: indexPath) as! DGCPagingListBaseCell
        dgc_cell.titleLabel.text = "row:\(indexPath.row)"
        return dgc_cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

extension DGCTestListBaseView: DGCJXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
