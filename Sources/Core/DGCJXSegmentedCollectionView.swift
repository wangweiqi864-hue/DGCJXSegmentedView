//
//  DGCJXSegmentedCollectionView.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedCollectionView: UICollectionView {

    open var indicators = [DGCJXSegmentedIndicatorProtocol]() {
        willSet {
            for indicator in indicators {
                indicator.removeFromSuperview()
            }
        }
        didSet {
            for indicator in indicators {
                addSubview(indicator)
            }
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        for indicator in indicators {
            sendSubviewToBack(indicator)
            if let dgc_backgroundView = dgc_backgroundView {
                sendSubviewToBack(dgc_backgroundView)
            }
        }
    }

}
