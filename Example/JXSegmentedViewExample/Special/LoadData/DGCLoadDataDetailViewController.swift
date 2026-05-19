//
//  DGCLoadDataDetailViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/7.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class DGCLoadDataDetailViewController: UIViewController {
    var detailText = ""
    private var dgc_textLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "测试详情页面"
        view.backgroundColor = UIColor.white

        dgc_textLabel.textAlignment = .center
        dgc_textLabel.textColor = UIColor.black
        dgc_textLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(dgc_textLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        dgc_textLabel.text = detailText
        dgc_textLabel.sizeToFit()
        dgc_textLabel.center = view.center
    }


}
