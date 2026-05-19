<div align=center><img src="Example/DGCJXSegmentedViewExample/Image/DGCJXSegmentedViewSmall.png" width="467" height="84" /></div>

[![platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=plastic)](#)
[![languages](https://img.shields.io/badge/language-swift-blue.svg)](#) 
[![cocoapods](https://img.shields.io/badge/cocoapods-supported-4BC51D.svg?style=plastic)](https://cocoapods.org/pods/DGCJXSegmentedView)
[![support](https://img.shields.io/badge/support-ios%208%2B-orange.svg)](#) 

A powerful and easy to use segmented view (segmentedcontrol, pagingview, pagerview, pagecontrol, categoryview) 

Advantages compared to other similar tripartite libraries:
- Indicator logic use Protocol Oriented Programming, which can be easily to extension;
- Provide more comprehensive and rich effects, and support almost all popular APP effects;
- Use subclassing to manage cell styles, with clearer logic and simpler extensions;

## Objective-C Version

If you are looking for the Objective-C version, please click to view
[JXCategoryView](https://github.com/pujiaxin33/JXCategoryView)

## Preview

### Indicator Preview

Description | Gif |
----|------|
Line fixed width  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/LineFixedWidth.gif" width="350" height="80"> |
Line flexible width  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/LineFlexibleWidth.gif" width="350" height="80"> |
Line lengthen  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/LineLengthen.gif" width="350" height="80"> |
Line lengthen and offset  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/LineLengthenOffset.gif" width="350" height="80"> |
RainbowLine  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/LineRainbow.gif" width="350" height="80"> |
DotLine |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/LineDot.gif" width="334" height="80"> |
DoubleLine  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/LineDouble.gif" width="350" height="80"> |
Triangle bottom  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/Triangle.gif" width="350" height="80"> |
Triangle top  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/TriangleTop.gif" width="350" height="80"> |
Background  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/IndicatorBackground.gif" width="350" height="80"> |
Background with shadow  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/IndicatorBackgroundShadow.gif" width="350" height="80"> |
Background mask  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/IndicatorBackgroundMask.gif" width="350" height="80"> |
Background mask without bottom view |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/IndicatorBackgroundMaskPure.gif" width="350" height="80"> |
Background gradient<br>(fixed)  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/IndicatorBackgroundGradient.gif" width="350" height="80"> |
Gradient<br>(change with position)  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/IndicatorGradient.gif" width="350" height="80"> |
Image bottom  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/IndicatorImageBottom.gif" width="350" height="80"> |
Image background  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/IndicatorImageBG.gif" width="350" height="80"> |
mixed indicators |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Indicator/IndicatorMixed.gif" width="350" height="80"> |

The following indicators support up and down position switching：
`DGCJXSegmentedIndicatorLineView`、`DGCJXSegmentedIndicatorRainbowLineView`、`DGCJXSegmentedIndicatorDotLineView`、`DGCJXSegmentedIndicatorDoubleLineView`、`DGCJXSegmentedIndicatorTriangleView`、`DGCJXSegmentedIndicatorImageView`

### Cell Preview

Description | Gif |
----|------|
title color gradient  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/ColorGradient.gif" width="350" height="80"> |
text color gradient  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/TextGradient.gif" width="350" height="80"> |
transform zoom  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/ZoomOnly.gif" width="350" height="80"> |
transform zoom + stroke width  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/ZoomStrokeWidth.gif" width="350" height="80"> |
transform zoom + selected animation  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/ZoomAnimation.gif" width="350" height="80"> |
transform zoom + cell width zoom  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/ZoomCellWidth.gif" width="350" height="80"> |
TitleImage_Top |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/TitleImageTop.gif" width="350" height="80"> |
TitleImage_Left |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/TitleImageLeft.gif" width="350" height="80"> |
TitleImage_Bottom |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/TitleImageBottom.gif" width="350" height="80"> |
TitleImage_Right |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/TitleImageRight.gif" width="350" height="80"> |
TitleImage_OnlyImage |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/TitleImageOnlyImage.gif" width="350" height="80"> |
TitleOrImage |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/TitleOrImage.gif" width="350" height="80"> |
number |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/Number.gif" width="350" height="80"> |
dot |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/CellDot.gif" width="350" height="80"> |
attributed text |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/TitleAttributed.gif" width="350" height="80"> |
mixed cells |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Cell/MixedCell.gif" width="350" height="80"> |

### Special Preview

Description | Gif |
----|------|
less data<br/> isItemSpacingAverageEnabled is true |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Special/ItemAveTrue.gif" width="350" height="80"> |
less data<br/> isItemSpacingAverageEnabled is false |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Special/ItemAveFalse.gif" width="350" height="80"> |
SegmentedControl<br/>reference[`DGCSegmentedControlViewController`](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/DGCJXSegmentedView/Special/SegmentedControl/DGCSegmentedControlViewController.swift) |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Special/SegmentedControl.gif" width="350" height="80"> |
SegmentedControl<br/>reference[`DGCSegmentedControlViewController`](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/DGCJXSegmentedView/Special/SegmentedControl/DGCSegmentedControlViewController.swift) |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Special/SegmentedControl.gif" width="350" height="80"> |
use in navigation bar <br/>reference[`DGCNaviSegmentedControlViewController`](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/DGCJXSegmentedView/Special/SegmentedControl/DGCNaviSegmentedControlViewController.swift) |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Special/NavigationBar.gif" width="350" height="80"> |
nestable<br/>reference[`DGCNestViewController`](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/DGCJXSegmentedView/Special/Nest/DGCNestViewController.swift) |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Special/Nest.gif" width="350" height="200"> |
user profile page<br/>reference[`DGCPagingViewController`](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/DGCJXSegmentedView/Special/Personal/DGCPagingViewController.swift)<br/> more styles just click[DGCJXPagingView](https://github.com/pujiaxin33/DGCJXPagingView) |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Special/Personal.gif" width="350" height="567"> |
data load & refresh<br/>reference[`DGCLoadDataViewController`](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/DGCJXSegmentedView/Special/LoadData/WithListContainerView/DGCLoadDataViewController.swift) |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/DGCJXSegmentedView/Special/LoadData.gif" width="350" height="200"> |


## Requirements

- iOS 9.0+
- Xcode 9+
- Swift 4.2、5.0

## Installation

### Manual

Clone the code and drag the Sources folder into the project to use it.

### CocoaPods

```ruby
target '<Your Target Name>' do
    pod 'DGCJXSegmentedView'
end
```
Execute `pod repo update` first, then execute `pod install`


## Usage

### `DGCJXSegmentedView` example

1.DGCJXSegmentedView initialize
```Swift
self.segmentedView = DGCJXSegmentedView()
self.segmentedView.delegate = self
self.view.addSubview(self.segmentedView)
```

2.dataSource initialize

The `dataSouce` type is the `DGCJXSegmentedViewDataSource` protocol. Use a separate class to implement the `DGCJXSegmentedViewDataSource` protocol for code isolation. By selecting different class assignments to `dataSource`, you can control the `DGCJXSegmentedView` display effect and implement plugin. For example, selecting the DGCJXSegmentedTitleImageDataSource class as the dataSource selects the display effect of the text image; selecting the DGCJXSegmentedNumberDataSource class as the dataSource selects the display effect of the text & number;
```Swift
//segmentedDataSource must be strongly held by the property, or it will be released
self.segmentedDataSource = DGCJXSegmentedTitleDataSource()
//Configuring data source related properties
self.segmentedDataSource.titles = ["猴哥", "青蛙王子", "旺财"]
self.segmentedDataSource.isTitleColorGradientEnabled = true
//The reloadData(selectedIndex:) method must be called, and the method will internally refresh the data source array.
self.segmentedDataSource.reloadData(selectedIndex: 0)
//Associated dataSource
self.segmentedView.dataSource = self.segmentedDataSource
```

3.Indicator initialize
```Swift
let indicator = DGCJXSegmentedIndicatorLineView()
indicator.indicatorWidth = 20
self.segmentedView.indicators = [indicator]
```

4.Implement `DGCJXSegmentedViewDelegate`
```Swift
//This method is called when you click to select or scroll to select. Applicable to only care about selected events, regardless of whether it is click or scroll.
func segmentedView(_ segmentedView: DGCJXSegmentedView, didSelectedItemAt index: Int) {}

// This method will be called when the selected condition is clicked.
func segmentedView(_ segmentedView: DGCJXSegmentedView, didClickSelectedItemAt index: Int) {}

// This method is called when the scroll is selected.
func segmentedView(_ segmentedView: DGCJXSegmentedView, didScrollSelectedItemAt index: Int) {}

// Then callback when scrolling
func segmentedView(_ segmentedView: DGCJXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {}
```

### `contentScrollView` list container usage example

#### Use the `UIScrollView` custom usage example directly

Because the code is scattered and the amount of code is large, it is not recommended. There are many places to pay attention to when using it properly, especially for students who are new to iOS.

Do not directly paste the code, click [DGCLoadDataCustomViewController](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/DGCJXSegmentedView/Special/LoadData/ListCustom/DGCLoadDataCustomViewController.swift) to view the source code.

As an alternative, the official use & is highly recommended to use the following in this way 👇👇👇.

#### Use the example of the `DGCJXSegmentedListContainerView` wrapper class

`DGCJXSegmentedListContainerView` is a highly encapsulated class for list views with the following advantages:
- Compared to the direct use of `UIScrollView` customization, the package is high, the code is centralized, and the use is simple;
- List lazy loading: List initialization is only performed when a list is displayed. Instead of loading all the lists at once, the performance is better;

1.`DGCJXSegmentedListContainerView` initialize
```Swift
self.listContainerView = DGCJXSegmentedListContainerView(dataSource: self)
self.view.addSubview(self.listContainerView)
//Associate the cotentScrollView
self.segmentedView.contentScrollView = self.listContainerView.scrollView
```

2.Implement `DGCJXSegmentedListContainerViewDataSource`
```Swift
//return numbers of lists
func numberOfLists(in listContainerView: DGCJXSegmentedListContainerView) -> Int {
    return self.segmentedDataSource.titles.count
}
//return the instance which comform `DGCJXSegmentedListContainerViewListDelegate`
func listContainerView(_ listContainerView: DGCJXSegmentedListContainerView, initListAt index: Int) -> DGCJXSegmentedListContainerViewListDelegate {
    return DGCListBaseViewController()
}
```

3.Implement `DGCJXSegmentedListContainerViewListDelegate` for list

Regardless of whether the type of the list is UIView or UIViewController
```Swift
/// If the list is VC, return VC.view
/// If the list is View, return to View itself
/// - Returns: list 
func listView() -> UIView {
    return view
}

//Optional use, when the list is displayed
func listDidAppear() {}

//Optional use, called when the list disappears
func listDidDisappear() {}
```

4.Tell the key event `DGCJXSegmentedListContainerView`

In the following two `DGCJXSegmentedViewDelegate` proxy methods, call the corresponding code, don't forget this one❗️❗️❗️
```Swift
func segmentedView(_ segmentedView: DGCJXSegmentedView, didClickSelectedItemAt index: Int) {
    //Pass the didClickSelectedItemAt event to the listContainerView, which must be called! ! !
    listContainerView.didClickSelectedItem(at: index)
}

func segmentedView(_ segmentedView: DGCJXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
    //Pass the scrolling event to the listContainerView, which must be called! ! !
    listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
}
```

Click [DGCLoadDataViewController](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/DGCJXSegmentedView/Special/LoadData/WithListContainerView/DGCLoadDataViewController.swift) to see the source code.

### Usage Summary

Because `DGCJXSegmentedView`  supports many features: indicators, cell styles, list containers, etc. How to manage the code orderly becomes a problem. The use of protocols, inheritance, and encapsulation classes greatly simplifies the use, and increases flexibility, making extensions quite easy.

- Core main class：`DGCJXSegmentedView`
- Data Source & Cell Style Custom Class: Classes that follow the `DGCJXSegmentedViewDataSource` protocol
- Indicator class: `UIView` class that complies with the `DGCJXSegmentedIndicatorProtocol` protocol
- List container: officially recommended `DGCJXSegmentedListContainerView` class, special case can be customized using `UIScrollView`

### Indicator style customization

- To inherit the `DGCJXSegmentedIndicatorProtocol` protocol, click on [DGCJXSegmentedIndicatorProtocol](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/Sources/Indicator/DGCJXSegmentedIndicatorProtocol.swift)
- The base class `DGCJXSegmentedIndicatorBaseView` inheriting the `DGCJXSegmentedIndicatorProtocol` protocol is provided, which provides many basic properties. Click to see [DGCJXSegmentedIndicatorBaseView](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/Sources/Indicator/DGCJXSegmentedIndicatorBaseView.swift)
- Custom indicator, please refer to the implemented indicator view, try more, think more, please ask Issue or join feedback QQ group if you have any questions.


### dataSource and Cell customization

- Need to inherit the `DGCJXSegmentedViewDataSource` protocol, click on [DGCJXSegmentedViewDataSource](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/Sources/Core/DGCJXSegmentedView.swift)
- Provides the base class `DGCJXSegmentedBaseDataSource` that inherits the `DGCJXSegmentedViewDataSource` protocol, which provides many basic properties. Click to see [DGCJXSegmentedBaseDataSource](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/Sources/Core/DGCJXSegmentedBaseDataSource.swift)
- Any custom requirements, dataSource, cell, itemModel must be subclassed. Even if a subclass cell does nothing. Used to maintain the inheritance chain, so as not to know who to inherit after subclassing;
- dataSource and Cell customization, please refer to the implemented dataSource, try more, think more, please ask Issue or join feedback QQ group if you have any questions.

## Common Attribute Description

[Common attribute description document address](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/Document/English/property.md)

## Other Usage Tips

[Other usage tips document address](https://github.com/pujiaxin33/DGCJXSegmentedView/blob/master/Document/English/tips.md)

## Supplement

If you are just starting to use `DGCJXSegmentedView`, be sure to search for the documentation or source code when you need to support certain features during development. Confirm that you have implemented the features you want to support. Please don't ask the documentation and source code to see it, just ask questions directly. This is a waste of time for everyone. If you don't support the features you want, feel free to ask for an discussion, or implement a PullRequest yourself.

If you have any suggestions or questions, you can contact me by：</br>
E-mail：317437084@qq.com </br>
QQ Group： 112440276

<img src="https://note.youdao.com/yws/public/resource/c6fa96a65e424afcf7f6304ddf5c283a/xmlnote/8dc821d271c35845acff3f853f434bce/3913" width="300" height="411">

If you like, just star❤️ it.

## License

DGCJXSegmentedView is released under the MIT license.
