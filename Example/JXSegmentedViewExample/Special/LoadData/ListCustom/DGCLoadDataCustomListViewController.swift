//
//  DGCLoadDataCustomListViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/7.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class DGCLoadDataCustomListViewController: UITableViewController {
    var typeString: String = ""
    weak var naviController: UINavigationController?
    private var dgc_dataSource = [String]()
    private var dgc_isDataLoaded = false
    private var dgc_isRequesting = false

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Loading...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        refreshControl?.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
        tableView.register(DGCPagingListBaseCell.self, forCellReuseIdentifier: "cell")
    }

    func loadDataForFirst() {
        if !dgc_isDataLoaded {
            //为什么要手动设置contentoffset：https://stackoverflow.com/questions/14718850/uirefreshcontrol-beginrefreshing-not-working-when-uitableviewcontroller-is-ins
            tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl!.bounds.size.height), animated: true)
            headerRefresh()
        }
    }

    @objc func headerRefresh() {
        guard !dgc_isRequesting else {
            return
        }

        dgc_isRequesting = true
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
            self.refreshControl?.endRefreshing()
            self.dgc_dataSource.removeAll()
            let dgc_dateFormatter = DateFormatter()
            dgc_dateFormatter.dateFormat = "HH:mm:ss"
            let dgc_dateString = dgc_dateFormatter.string(from: Date())
            for index in 0..<20 {
                self.dgc_dataSource.append(String(format: "%@ 时间：%@ index:%d", self.typeString, dgc_dateString, index))
            }
            self.dgc_isDataLoaded = true
            self.dgc_isRequesting = false
            self.tableView.reloadData()
        }
    }

    //MARK: - UITableViewDataSource & UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dgc_dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dgc_cell = tableView.dequeueReusableCell(withIdentifier: "dgc_cell", for: indexPath) as! DGCPagingListBaseCell
        dgc_cell.titleLabel.text = dgc_dataSource[indexPath.row]
        return dgc_cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dgc_vc = DGCLoadDataDetailViewController()
        dgc_vc.detailText = dgc_dataSource[indexPath.row]
        naviController?.pushViewController(dgc_vc, animated: true)
    }
}
