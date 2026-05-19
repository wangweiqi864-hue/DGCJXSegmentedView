//
//  DGCJXSegmentedTitleOrImageCell.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class DGCJXSegmentedTitleOrImageCell: DGCJXSegmentedTitleCell {
    public let imageView = UIImageView()
    private var dgc_currentImageInfo: String?

    open override func prepareForReuse() {
        super.prepareForReuse()

        dgc_currentImageInfo = nil
    }

    open override func commonInit() {
        super.commonInit()

        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        imageView.center = contentView.center
    }

    open override func reloadData(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleOrImageItemModel else {
            return
        }

        if dgc_myItemModel.isSelected && dgc_myItemModel.selectedImageInfo != nil {
            titleLabel.isHidden = true
            imageView.isHidden = false
        }else {
            titleLabel.isHidden = false
            imageView.isHidden = true
        }

        imageView.bounds = CGRect(x: 0, y: 0, width: dgc_myItemModel.imageSize.width, height: dgc_myItemModel.imageSize.height)

        //因为`func reloadData(itemModel: DGCJXSegmentedBaseItemModel, selectedType: DGCJXSegmentedViewItemSelectedType)`方法会回调多次，尤其是左右滚动的时候会调用无数次。如果每次都触发图片加载，会非常消耗性能。所以只会在图片发生了变化的时候，才进行图片加载。
        if dgc_myItemModel.isSelected &&
            dgc_myItemModel.selectedImageInfo != nil &&
            dgc_myItemModel.selectedImageInfo != dgc_currentImageInfo {
            dgc_currentImageInfo = dgc_myItemModel.selectedImageInfo
            if dgc_myItemModel.loadImageClosure != nil {
                dgc_myItemModel.loadImageClosure!(imageView, dgc_myItemModel.selectedImageInfo!)
            }else {
                imageView.image = UIImage(named: dgc_myItemModel.selectedImageInfo!)
            }
        }

        setNeedsLayout()
    }

    open override func preferredTitleZoomAnimateClosure(itemModel: DGCJXSegmentedTitleItemModel, baseScale: CGFloat) -> JXSegmentedCellSelectedAnimationClosure {
        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleOrImageItemModel else {
            return super.preferredTitleZoomAnimateClosure(itemModel: itemModel, baseScale: baseScale)
        }
        if dgc_myItemModel.selectedImageInfo == nil && dgc_myItemModel.isSelected {
            //当前item没有选中图片且是将要选中的时候才做动画
            return super.preferredTitleZoomAnimateClosure(itemModel: itemModel, baseScale: baseScale)
        }else {
            let dgc_closure: JXSegmentedCellSelectedAnimationClosure = {[weak self] (percent) in
                if itemModel.isSelected {
                    //将要选中
                    itemModel.titleCurrentZoomScale = itemModel.titleSelectedZoomScale
                }else {
                    //将要取消选中
                    itemModel.titleCurrentZoomScale = itemModel.titleNormalZoomScale
                }
                let dgc_currentTransform = CGAffineTransform(scaleX: baseScale*itemModel.titleCurrentZoomScale, y: baseScale*itemModel.titleCurrentZoomScale)
                self?.titleLabel.transform = dgc_currentTransform
                self?.maskTitleLabel.transform = dgc_currentTransform
            }
            //手动调用closure，更新到最新状态
            dgc_closure(0)
            return dgc_closure
        }
    }

    open override func preferredTitleStrokeWidthAnimateClosure(itemModel: DGCJXSegmentedTitleItemModel, attriText: NSMutableAttributedString) -> JXSegmentedCellSelectedAnimationClosure {
        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleOrImageItemModel else {
            return super.preferredTitleStrokeWidthAnimateClosure(itemModel: itemModel, attriText: attriText)
        }
        if dgc_myItemModel.selectedImageInfo == nil && dgc_myItemModel.isSelected {
            //当前item没有选中图片且是将要选中的时候才做动画
            return super.preferredTitleStrokeWidthAnimateClosure(itemModel: itemModel, attriText: attriText)
        }else {
            let dgc_closure: JXSegmentedCellSelectedAnimationClosure = {[weak self] (percent) in
                if itemModel.isSelected {
                    //将要选中
                    itemModel.titleCurrentStrokeWidth = itemModel.titleSelectedStrokeWidth
                }else {
                    //将要取消选中
                    itemModel.titleCurrentStrokeWidth = itemModel.titleNormalStrokeWidth
                }
                attriText.addAttributes([NSAttributedString.Key.strokeWidth: itemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: attriText.string.count))
                self?.titleLabel.attributedText = attriText
            }
            //手动调用closure，更新到最新状态
            dgc_closure(0)
            return dgc_closure
        }
    }

    open override func preferredTitleColorAnimateClosure(itemModel: DGCJXSegmentedTitleItemModel) -> JXSegmentedCellSelectedAnimationClosure {
        guard let dgc_myItemModel = itemModel as? DGCJXSegmentedTitleOrImageItemModel else {
            return super.preferredTitleColorAnimateClosure(itemModel: itemModel)
        }
        if dgc_myItemModel.selectedImageInfo == nil && dgc_myItemModel.isSelected {
            //当前item没有选中图片且是将要选中的时候才做动画
            return super.preferredTitleColorAnimateClosure(itemModel: itemModel)
        }else {
            let dgc_closure: JXSegmentedCellSelectedAnimationClosure = {[weak self] (percent) in
                if itemModel.isSelected {
                    //将要选中
                    itemModel.titleCurrentColor = itemModel.titleSelectedColor
                }else {
                    //将要取消选中
                    itemModel.titleCurrentColor = itemModel.titleNormalColor
                }
                self?.titleLabel.textColor = itemModel.titleCurrentColor
            }
            //手动调用closure，更新到最新状态
            dgc_closure(0)
            return dgc_closure
        }
    }
    
}
