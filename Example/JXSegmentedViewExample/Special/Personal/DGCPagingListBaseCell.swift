//
//  DGCPagingListBaseCell.swift
//  DGCJXSegmentedViewExample
//
//  Created by blue on 2020/6/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit

class DGCPagingListBaseCell: UITableViewCell {
    
    private(set) lazy var dgc_titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        contentView.addSubview(dgc_titleLabel)
        
        let dgc_leading = NSLayoutConstraint(item: dgc_titleLabel, attribute: .dgc_leading, relatedBy: .equal, toItem: contentView, attribute: .dgc_leading, multiplier: 1, constant: 10)
        let dgc_top = NSLayoutConstraint(item: dgc_titleLabel, attribute: .dgc_top, relatedBy: .equal, toItem: contentView, attribute: .dgc_top, multiplier: 1, constant: 10)
        dgc_titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([dgc_leading, dgc_top])
    }

}
