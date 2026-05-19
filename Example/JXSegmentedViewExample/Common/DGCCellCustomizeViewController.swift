//
//  DGCCellCustomizeViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCCellCustomizeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dgc_cell = tableView.cellForRow(at: indexPath)
        var dgc_itemTitle: String?
        for subview in dgc_cell!.contentView.subviews {
            if let dgc_label = subview as? UILabel {
                dgc_itemTitle = dgc_label.text
                break
            }
        }

        let dgc_titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙"]
        let dgc_numbers = [1, 22, 333, 44444, 0, 66, 777, 0, 99999, 10]
        let dgc_dotStates = [false, true, true, true, false, false, true, true, false, true]
        let dgc_vc = DGCContentBaseViewController()
        dgc_vc.title = dgc_itemTitle

        switch dgc_itemTitle! {
        case "颜色渐变":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.titleSelectedColor = UIColor.red
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "文字渐变":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleGradientDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.titleSelectedColor = UIColor.red
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "大小缩放":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.titleSelectedColor = UIColor.red
            dgc_dataSource.isTitleZoomEnabled = true
            dgc_dataSource.titleSelectedZoomScale = 1.3
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "大小缩放+字体粗细":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.titleSelectedColor = UIColor.red
            dgc_dataSource.isTitleZoomEnabled = true
            dgc_dataSource.titleSelectedZoomScale = 1.3
            dgc_dataSource.isTitleStrokeWidthEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "大小缩放+点击动画":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.titleSelectedColor = UIColor.red
            dgc_dataSource.isTitleZoomEnabled = true
            dgc_dataSource.titleSelectedZoomScale = 1.3
            dgc_dataSource.isTitleStrokeWidthEnabled = true
            dgc_dataSource.isSelectedAnimable = true
            dgc_dataSource.dgc_titles = dgc_titles
            let dgc_indicator = DGCJXSegmentedIndicatorLineView()
            dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
            dgc_vc.segmentedView.indicators = [dgc_indicator]

            dgc_vc.segmentedDataSource = dgc_dataSource
        case "大小缩放+Cell宽度缩放":
            //高仿汽车之家
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.titleSelectedColor = UIColor.red
            dgc_dataSource.isTitleZoomEnabled = true
            dgc_dataSource.titleSelectedZoomScale = 1.3
            dgc_dataSource.isTitleStrokeWidthEnabled = true
            dgc_dataSource.isSelectedAnimable = true
            dgc_dataSource.isItemWidthZoomEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles

            let dgc_indicator = DGCJXSegmentedIndicatorLineView()
            dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
            dgc_vc.segmentedView.indicators = [dgc_indicator]

            dgc_vc.segmentedDataSource = dgc_dataSource
        case "数字":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedNumberDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_dataSource.dgc_numbers = dgc_numbers
//            dgc_dataSource.numberHeight = 20
//            dgc_dataSource.numberFont = .systemFont(ofSize: 15)
            dgc_dataSource.numberStringFormatterClosure = {(number) -> String in
                if number > 999 {
                    return "999+"
                }
                return "\(number)"
            }
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "红点":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedDotDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_dataSource.dgc_dotStates = dgc_dotStates
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "文字和图片":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleImageDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_dataSource.titleImageType = .rightImage
            dgc_dataSource.isImageZoomEnabled = true
            dgc_dataSource.normalImageInfos = ["monkey", "frog", "dog", "pig", "sheep", "chicken", "horse", "cow", "elephant", "dragon"]
            dgc_dataSource.loadImageClosure = {(imageView, normalImageInfo) in
                //如果normalImageInfo传递的是图片的地址，你需要借助SDWebImage等第三方库进行图片加载。
                //加载bundle内的图片，就用下面的方式，内部默认也采用该方法。
                imageView.image = UIImage(named: normalImageInfo)
            }
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "文字或者图片":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleOrImageDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.titleSelectedColor = UIColor.red
            dgc_dataSource.isTitleZoomEnabled = true
            dgc_dataSource.titleSelectedZoomScale = 1.3
            dgc_dataSource.isTitleStrokeWidthEnabled = true
            dgc_dataSource.isItemTransitionEnabled = false
            dgc_dataSource.isSelectedAnimable = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_dataSource.selectedImageInfos = ["monkey", nil, "dog", nil, "sheep", "chicken", "horse", nil, nil, "dragon"]
            dgc_dataSource.loadImageClosure = {(imageView, normalImageInfo) in
                //如果normalImageInfo传递的是图片的地址，你需要借助SDWebImage等第三方库进行图片加载。
                //加载bundle内的图片，就用下面的方式，内部默认也采用该方法。
                imageView.image = UIImage(named: normalImageInfo)
            }
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "多行文字(自己添加换行符)":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.titleSelectedColor = UIColor.red
            dgc_dataSource.titleNumberOfLines = 2
            dgc_dataSource.dgc_titles = ["猴哥\nmonkey", "青蛙王子\nfrog", "旺财\ndot", "粉红猪\npig", "喜羊羊\nsheep", "黄焖鸡\nchicken", "小马哥\nhorse", "牛魔王\ncow", "大象先生\nelepant", "神龙\ndragon"]
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "多行文字(固定宽度自动换行)":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.titleSelectedColor = UIColor.red
            dgc_dataSource.titleNumberOfLines = 2
            dgc_dataSource.itemWidth = 60
            dgc_dataSource.dgc_titles = ["猴哥 monkey", "青蛙王子 frog", "旺财 dot", "粉红猪 pig", "喜羊羊 sheep", "黄焖鸡 chicken", "小马哥 horse", "牛魔王 cow", "大象先生 elepant", "神龙 dragon"]
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "多行富文本":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleAttributeDataSource()
            func formatNormal(attriText: NSMutableAttributedString) {
                attriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))
                attriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)], range: NSRange(location: 2, length: attriText.string.count - 2))
            }
            func formatSelected(attriText: NSMutableAttributedString) {
                attriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: 2))
                attriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], range: NSRange(location: 2, length: attriText.string.count - 2))
            }
            let dgc_mondayAttriText = NSMutableAttributedString(string: "周一\n1月7号")
            formatNormal(attriText: dgc_mondayAttriText)
            let dgc_tuesdayAttriText = NSMutableAttributedString(string: "周二\n1月8号")
            formatNormal(attriText: dgc_tuesdayAttriText)
            let dgc_wednesdayAttriText = NSMutableAttributedString(string: "周三\n1月9号")
            formatNormal(attriText: dgc_wednesdayAttriText)
            dgc_dataSource.attributedTitles = [dgc_mondayAttriText.copy(), dgc_tuesdayAttriText.copy(), dgc_wednesdayAttriText.copy()] as! [NSAttributedString]

            formatSelected(attriText: dgc_mondayAttriText)
            formatSelected(attriText: dgc_tuesdayAttriText)
            formatSelected(attriText: dgc_wednesdayAttriText)
            dgc_dataSource.selectedAttributedTitles = [dgc_mondayAttriText.copy(), dgc_tuesdayAttriText.copy(), dgc_wednesdayAttriText.copy()] as? [NSAttributedString]
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
            dgc_indicator.indicatorHeight = 40
            dgc_indicator.indicatorCornerRadius = 5
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "多种cell":
            let dgc_dataSource = DGCJXSegmentedMixcellDataSource()
            dgc_vc.segmentedDataSource = dgc_dataSource
        case "Title Configuration":
            let dgc_vc = DGCTitleConfigurationViewController()
            navigationController?.pushViewController(dgc_vc, animated: true)
            return
        default:
            break
        }
        navigationController?.pushViewController(dgc_vc, animated: true)
    }


}
