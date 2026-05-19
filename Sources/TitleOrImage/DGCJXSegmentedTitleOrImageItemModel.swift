//
//  DGCJXSegmentedTitleOrImageItemModel.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleOrImageItemModel: DGCJXSegmentedTitleItemModel {
    open var selectedImageInfo: String?
    open var loadImageClosure: LoadImageClosure?
    open var imageSize: CGSize = CGSize.zero
}
