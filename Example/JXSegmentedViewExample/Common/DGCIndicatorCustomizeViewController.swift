//
//  DGCIndicatorCustomizeViewController.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import DGCJXSegmentedView

class DGCIndicatorCustomizeViewController: UITableViewController {

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
        let dgc_vc = DGCContentBaseViewController()
        dgc_vc.title = dgc_itemTitle

        switch dgc_itemTitle! {
        case "LineView固定长度":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorLineView()
            dgc_indicator.indicatorWidth = 20
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "LineView与Cell同宽":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorLineView()
            dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "LineView延长style":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorLineView()
            dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
            dgc_indicator.lineStyle = .lengthen
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "LineView延长+偏移style":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorLineView()
            dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
            dgc_indicator.lineStyle = .lengthenOffset
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "LineView彩虹":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorRainbowLineView()
            dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
            dgc_indicator.lineStyle = .lengthenOffset
            dgc_indicator.indicatorColors = [.red, .green, .blue, .orange, .purple, .cyan, .gray, .red, .yellow, .blue]
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "TriangleView三角形":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorTriangleView()
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "BallView小红点":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
            dgc_indicator.indicatorHeight = 30
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "BackgroundView椭圆形":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
            dgc_indicator.indicatorHeight = 30
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "BackgroundView椭圆形+阴影":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
            dgc_indicator.indicatorHeight = 30
            dgc_indicator.layer.shadowColor = UIColor.red.cgColor
            dgc_indicator.layer.shadowRadius = 3
            dgc_indicator.layer.shadowOffset = CGSize(width: 3, height: 4)
            dgc_indicator.layer.shadowOpacity = 0.6
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "BackgroundView遮罩有背景":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = false
            dgc_dataSource.isTitleMaskEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
            dgc_indicator.isIndicatorConvertToItemFrameEnabled = true
            dgc_indicator.indicatorHeight = 30
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "BackgroundView遮罩无背景":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = false
            dgc_dataSource.isTitleMaskEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
            dgc_indicator.alpha = 0
            dgc_indicator.isIndicatorConvertToItemFrameEnabled = true
            dgc_indicator.indicatorHeight = 30
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "BackgroundView渐变色":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorBackgroundView()
            dgc_indicator.clipsToBounds = true
            dgc_indicator.indicatorHeight = 30
//            dgc_indicator.indicatorHeight = 3
//            dgc_indicator.indicatorPosition = .bottom
            //相当于把JXSegmentedIndicatorBackgroundView当做视图容器，你可以在上面添加任何想要的效果
            //这里的方案主要提供一个可以在指示器视图添加自己视图的思路，如果只是需要渐变色lineView。请参考下面的【GradientLine渐变色】示例，使用JXSegmentedIndicatorGradientLineView类即可。
            let dgc_gradientView = DGCJXSegmentedComponetGradientView()
            dgc_gradientView.gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            dgc_gradientView.gradientLayer.colors = [UIColor(red: 90/255, green: 215/255, blue: 202/255, alpha: 1).cgColor, UIColor(red: 122/255, green: 232/255, blue: 169/255, alpha: 1).cgColor]
            //设置gradientView布局和JXSegmentedIndicatorBackgroundView一样
            dgc_gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            dgc_indicator.addSubview(dgc_gradientView)
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "GradientLine渐变色":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorGradientLineView()
            dgc_indicator.colors = [UIColor.red, UIColor.green]
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "ImageView底部":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorImageView()
            dgc_indicator.image = UIImage(named: "car")
            dgc_indicator.indicatorWidth = 24
            dgc_indicator.indicatorHeight = 18
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "ImageView背景":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorImageView()
            dgc_indicator.indicatorWidth = 50
            dgc_indicator.indicatorHeight = 50
            dgc_indicator.image = UIImage(named: "light")
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "混合使用":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_lineIndicator = DGCJXSegmentedIndicatorLineView()
            dgc_lineIndicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
            dgc_lineIndicator.lineStyle = .normal

            let dgc_bgIndicator = DGCJXSegmentedIndicatorBackgroundView()
            dgc_bgIndicator.indicatorHeight = 30
            dgc_vc.segmentedView.indicators = [dgc_lineIndicator, dgc_bgIndicator]
        case "DotLine点线效果":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorDotLineView()
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "DoubleLine双线效果":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorDoubleLineView()
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "GradientView渐变色":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = dgc_titles
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorGradientView()
//            dgc_indicator.indicatorHeight = 3
//            dgc_indicator.indicatorPosition = .bottom

            dgc_vc.segmentedView.indicators = [dgc_indicator]
        case "指示器宽度跟随内容而不是cell宽度":
            //配置数据源
            let dgc_dataSource = DGCJXSegmentedTitleDataSource()
            dgc_dataSource.isTitleColorGradientEnabled = true
            dgc_dataSource.dgc_titles = ["很长的第一名", "第二", "普通第三"]
            dgc_dataSource.itemWidth = view.bounds.size.width/3
            dgc_dataSource.itemSpacing = 0
            dgc_dataSource.isTitleZoomEnabled = true
            dgc_vc.segmentedDataSource = dgc_dataSource
            //配置指示器
            let dgc_indicator = DGCJXSegmentedIndicatorLineView()
            dgc_indicator.indicatorWidth = DGCJXSegmentedViewAutomaticDimension
            dgc_indicator.isIndicatorWidthSameAsItemContent = true
            dgc_vc.segmentedView.indicators = [dgc_indicator]
        default:
            break
        }
        navigationController?.pushViewController(dgc_vc, animated: true)
    }
}
