//
//  DGCPagingListBaseView.swift
//  DGCJXPagingView
//
//  Created by jiaxin on 2018/5/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

@objc public class DGCPagingListBaseView: UIView {
    @objc public var tableView: UITableView!
    @objc public var dataSource: [String]?
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    private var dgc_isHeaderRefreshed: Bool = false
    deinit {
        listViewDidScrollCallback = nil
    }

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

    func beginFirstRefresh() {
        if !dgc_isHeaderRefreshed {
            self.dgc_isHeaderRefreshed = true
            self.tableView.reloadData()
        }
    }


    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        tableView.frame = self.bounds
    }

}

extension DGCPagingListBaseView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dgc_isHeaderRefreshed {
            return dataSource?.count ?? 0
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dgc_cell = tableView.dequeueReusableCell(withIdentifier: "dgc_cell", for: indexPath) as! DGCPagingListBaseCell
        dgc_cell.titleLabel.text = dataSource?[indexPath.row]
        return dgc_cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}

extension DGCPagingListBaseView: DGCJXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return self
    }
    
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.tableView
    }
}
