//
//  DGCJXSegmentedListContainerView.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

/// 列表容器视图的类型
///- ScrollView: UIScrollView。优势：没有其他副作用。劣势：视图内存占用相对大一点。因为所有的列表视图都在UIScrollView的视图层级里面。
/// - CollectionView: 使用UICollectionView。优势：因为列表被添加到cell上，视图的内存占用更少，适合内存要求特别高的场景。劣势：因为cell重用机制的问题，导致列表下拉刷新视图(比如MJRefresh)，会因为被removeFromSuperview而被隐藏。所以，列表有下拉刷新需求的，请使用scrollView type。
public enum DGCJXSegmentedListContainerType {
    case scrollView
    case collectionView
}

@objc
public protocol DGCJXSegmentedListContainerViewListDelegate {
    /// 如果列表是VC，就返回VC.view
    /// 如果列表是View，就返回View自己
    ///
    /// - Returns: 返回列表视图
    func listView() -> UIView
    @objc optional func dgc_listWillAppear()
    @objc optional func dgc_listDidAppear()
    @objc optional func dgc_listWillDisappear()
    @objc optional func dgc_listDidDisappear()
}

@objc
public protocol DGCJXSegmentedListContainerViewDataSource {
    /// 返回list的数量
    func numberOfLists(in listContainerView: DGCJXSegmentedListContainerView) -> Int

    /// 根据index初始化一个对应列表实例，需要是遵从`DGCJXSegmentedListContainerViewListDelegate`协议的对象。
    /// 如果列表是用自定义UIView封装的，就让自定义UIView遵从`DGCJXSegmentedListContainerViewListDelegate`协议，该方法返回自定义UIView即可。
    /// 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`DGCJXSegmentedListContainerViewListDelegate`协议，该方法返回自定义UIViewController即可。
    /// 注意：一定要是新生成的实例！！！
    ///
    /// - Parameters:
    ///   - listContainerView: DGCJXSegmentedListContainerView
    ///   - index: 目标index
    /// - Returns: 遵从JXSegmentedListContainerViewListDelegate协议的实例
    func listContainerView(_ listContainerView: DGCJXSegmentedListContainerView, initListAt index: Int) -> DGCJXSegmentedListContainerViewListDelegate


    /// 控制能否初始化对应index的列表。有些业务需求，需要在某些情况才允许初始化某些列表，通过通过该代理实现控制。
    @objc optional func listContainerView(_ listContainerView: DGCJXSegmentedListContainerView, canInitListAt index: Int) -> Bool

    /// 返回自定义UIScrollView或UICollectionView的Class
    /// 某些特殊情况需要自己处理UIScrollView内部逻辑。比如项目用了FDFullscreenPopGesture，需要处理手势相关代理。
    ///
    /// - Parameter listContainerView: DGCJXSegmentedListContainerView
    /// - Returns: 自定义UIScrollView实例
    @objc optional func scrollViewClass(in listContainerView: DGCJXSegmentedListContainerView) -> AnyClass
}

open class DGCJXSegmentedListContainerView: UIView, DGCJXSegmentedViewListContainer, DGCJXSegmentedViewRTLCompatible {
    open private(set) var type: DGCJXSegmentedListContainerType
    open private(set) weak var dataSource: DGCJXSegmentedListContainerViewDataSource?
    open private(set) var scrollView: UIScrollView!
    /// 已经加载过的列表字典。key是index，value是对应的列表
    open private(set) var validListDict = [Int:DGCJXSegmentedListContainerViewListDelegate]()
    /// 滚动切换的时候，滚动距离超过一页的多少百分比，就触发列表的初始化。默认0.01（即列表显示了一点就触发加载）。范围0~1，开区间不包括0和1
    open var initListPercent: CGFloat = 0.01 {
        didSet {
            if initListPercent <= 0 || initListPercent >= 1 {
                assertionFailure("initListPercent值范围为开区间(0,1)，即不包括0和1")
            }
        }
    }
    open var listCellBackgroundColor: UIColor = .white
    /// 需要和segmentedView.defaultSelectedIndex保持一致，用于触发默认index列表的加载
    open var defaultSelectedIndex: Int = 0 {
        didSet {
            dgc_currentIndex = defaultSelectedIndex
        }
    }
    private var dgc_currentIndex: Int = 0
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        if let collectionViewClass = dataSource?.scrollViewClass?(in: self) as? UICollectionView.Type {
            return collectionViewClass.init(frame: CGRect.zero, collectionViewLayout: layout)
        }else {
            return UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        }
    }()
    private lazy var dgc_containerVC = DGCJXSegmentedListContainerViewController()
    private var dgc_willAppearIndex: Int = -1
    private var dgc_willDisappearIndex: Int = -1

    public init(dataSource dataSource: DGCJXSegmentedListContainerViewDataSource, type type: DGCJXSegmentedListContainerType = .scrollView) {
        self.dataSource = dataSource
        self.type = type
        super.init(frame: CGRect.zero)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func commonInit() {
        dgc_containerVC.view.backgroundColor = .clear
        addSubview(dgc_containerVC.view)
        dgc_containerVC.viewWillAppearClosure = {[weak self] in
            self?.dgc_listWillAppear(at: self?.dgc_currentIndex ?? 0)
        }
        dgc_containerVC.viewDidAppearClosure = {[weak self] in
            self?.dgc_listDidAppear(at: self?.dgc_currentIndex ?? 0)
        }
        dgc_containerVC.viewWillDisappearClosure = {[weak self] in
            self?.dgc_listWillDisappear(at: self?.dgc_currentIndex ?? 0)
        }
        dgc_containerVC.viewDidDisappearClosure = {[weak self] in
            self?.dgc_listDidDisappear(at: self?.dgc_currentIndex ?? 0)
        }
        if type == .scrollView {
            if let dgc_scrollViewClass = dataSource?.dgc_scrollViewClass?(in: self) as? UIScrollView.Type {
                scrollView = dgc_scrollViewClass.init()
            }else {
                scrollView = UIScrollView.init()
            }
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.scrollsToTop = false
            scrollView.bounces = false
            if #available(iOS 11.0, *) {
                scrollView.contentInsetAdjustmentBehavior = .never
            }
            if segmentedViewShouldRTLLayout() {
                segmentedView(horizontalFlipForView: scrollView)
            }else{
                scrollView.transform = .identity
            }
            dgc_containerVC.view.addSubview(scrollView)
        }else if type == .collectionView {
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.scrollsToTop = false
            collectionView.bounces = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(DGCJXSegmentedRTLCollectionCell.self, forCellWithReuseIdentifier: "cell")
            if #available(iOS 10.0, *) {
                collectionView.isPrefetchingEnabled = false
            }
            if #available(iOS 11.0, *) {
                self.collectionView.contentInsetAdjustmentBehavior = .never
            }
            if segmentedViewShouldRTLLayout() {
                collectionView.semanticContentAttribute = .forceLeftToRight
                segmentedView(horizontalFlipForView: collectionView)
            }else{
                collectionView.semanticContentAttribute = .forceLeftToRight
                collectionView.transform = .identity
            }
            dgc_containerVC.view.addSubview(collectionView)
            //让外部统一访问scrollView
            scrollView = collectionView
        }
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        var dgc_next: UIResponder? = newSuperview
        while dgc_next != nil {
            if let dgc_vc = dgc_next as? UIViewController{
                dgc_vc.addChild(dgc_containerVC)
                break
            }
            dgc_next = dgc_next?.dgc_next
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        dgc_containerVC.view.frame = bounds
        guard let dgc_count = dataSource?.numberOfLists(in: self) else {
            return
        }
        if type == .scrollView {
            if scrollView.frame == CGRect.zero || scrollView.bounds.size != bounds.size {
                scrollView.frame = bounds
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(dgc_count), height: scrollView.bounds.size.height)
                for (index, list) in validListDict {
                    list.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
                }
                scrollView.contentOffset = CGPoint(x: CGFloat(dgc_currentIndex)*scrollView.bounds.size.width, y: 0)
            }else {
                scrollView.frame = bounds
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(dgc_count), height: scrollView.bounds.size.height)
            }
        }else {
            if collectionView.frame == CGRect.zero || collectionView.bounds.size != bounds.size {
                collectionView.frame = bounds
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.setContentOffset(CGPoint(x: CGFloat(dgc_currentIndex)*collectionView.bounds.size.width, y: 0), animated: false)
            }else {
                collectionView.frame = bounds
            }
        }
    }

    //MARK: - DGCJXSegmentedViewListContainer

    public func contentScrollView() -> UIScrollView {
           return scrollView
       }

    public func scrolling(from leftIndex: Int, to rightIndex: Int, percent: CGFloat, selectedIndex: Int) {
    }

    open func didClickSelectedItem(at index: Int) {
        guard dgc_checkIndexValid(index) else {
            return
        }
        dgc_willAppearIndex = -1
        dgc_willDisappearIndex = -1
        if dgc_currentIndex != index {
            dgc_listWillDisappear(at: dgc_currentIndex)
            dgc_listWillAppear(at: index)
            dgc_listDidDisappear(at: dgc_currentIndex)
            dgc_listDidAppear(at: index)
        }
    }

    open func reloadData() {
        guard let dataSource = dataSource else { return }
        if dgc_currentIndex < 0 || dgc_currentIndex >= dataSource.numberOfLists(in: self) {
            defaultSelectedIndex = 0
            dgc_currentIndex = 0
        }
        validListDict.values.forEach { (list) in
            if let dgc_listVC = list as? UIViewController {
                dgc_listVC.removeFromParent()
            }
            list.listView().removeFromSuperview()
        }
        validListDict.removeAll()
        if type == .scrollView {
            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(dataSource.numberOfLists(in: self)), height: scrollView.bounds.size.height)
            
            if segmentedViewShouldRTLLayout() {
                segmentedView(horizontalFlipForView: scrollView)
            }else{
                scrollView.transform = .identity
            }
            
        }else {
            collectionView.reloadData()
        }
        dgc_listWillAppear(at: dgc_currentIndex)
        dgc_listDidAppear(at: dgc_currentIndex)
    }

    //MARK: - Private
    func initListIfNeeded(at index: Int) {
        guard let dataSource = dataSource else { return }
        if dataSource.listContainerView?(self, canInitListAt: index) == false {
            return
        }
        var dgc_existedList = validListDict[index]
        if dgc_existedList != nil {
            //列表已经创建好了
            return
        }
        dgc_existedList = dataSource.listContainerView(self, initListAt: index)
        guard let dgc_list = dgc_existedList else {
            return
        }
        if let dgc_vc = dgc_list as? UIViewController {
            dgc_containerVC.addChild(dgc_vc)
        }
        validListDict[index] = dgc_list
        if type == .scrollView {
            dgc_list.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            scrollView.addSubview(dgc_list.listView())
            
            if segmentedViewShouldRTLLayout() {
                segmentedView(horizontalFlipForView: dgc_list.listView())
            }else{
                dgc_list.listView().transform = .identity
            }
        }else {
            let dgc_cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0))
            dgc_cell?.contentView.subviews.forEach { $0.removeFromSuperview() }
            dgc_list.listView().frame = dgc_cell?.contentView.bounds ?? CGRect.zero
            dgc_cell?.contentView.addSubview(dgc_list.listView())
        }
    }

    private func dgc_listWillAppear(at index: Int) {
        guard let dataSource = dataSource else { return }
        guard dgc_checkIndexValid(index) else {
            return
        }
        var dgc_existedList = validListDict[index]
        if dgc_existedList != nil {
            dgc_existedList?.dgc_listWillAppear?()
            if let dgc_vc = dgc_existedList as? UIViewController {
                dgc_vc.beginAppearanceTransition(true, animated: false)
            }
        }else {
            //当前列表未被创建（页面初始化或通过点击触发的listWillAppear）
            guard dataSource.listContainerView?(self, canInitListAt: index) != false else {
                return
            }
            dgc_existedList = dataSource.listContainerView(self, initListAt: index)
            guard let dgc_list = dgc_existedList else {
                return
            }
            if let dgc_vc = dgc_list as? UIViewController {
                dgc_containerVC.addChild(dgc_vc)
            }
            validListDict[index] = dgc_list
            if type == .scrollView {
                if dgc_list.listView().superview == nil {
                    dgc_list.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
                    scrollView.addSubview(dgc_list.listView())
                    
                    if segmentedViewShouldRTLLayout() {
                        segmentedView(horizontalFlipForView: dgc_list.listView())
                    }else{
                        dgc_list.listView().transform = .identity
                    }
                }
                dgc_list.dgc_listWillAppear?()
                if let dgc_vc = dgc_list as? UIViewController {
                    dgc_vc.beginAppearanceTransition(true, animated: false)
                }
            }else {
                let dgc_cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                dgc_cell?.contentView.subviews.forEach { $0.removeFromSuperview() }
                dgc_list.listView().frame = dgc_cell?.contentView.bounds ?? CGRect.zero
                dgc_cell?.contentView.addSubview(dgc_list.listView())
                dgc_list.dgc_listWillAppear?()
                if let dgc_vc = dgc_list as? UIViewController {
                    dgc_vc.beginAppearanceTransition(true, animated: false)
                }
            }
        }
    }

    private func dgc_listDidAppear(at index: Int) {
        guard dgc_checkIndexValid(index) else {
            return
        }
        dgc_currentIndex = index
        let dgc_list = validListDict[index]
        dgc_list?.dgc_listDidAppear?()
        if let dgc_vc = dgc_list as? UIViewController {
            dgc_vc.endAppearanceTransition()
        }
    }

    private func dgc_listWillDisappear(at index: Int) {
        guard dgc_checkIndexValid(index) else {
            return
        }
        let dgc_list = validListDict[index]
        dgc_list?.dgc_listWillDisappear?()
        if let dgc_vc = dgc_list as? UIViewController {
            dgc_vc.beginAppearanceTransition(false, animated: false)
        }
    }

    private func dgc_listDidDisappear(at index: Int) {
        guard dgc_checkIndexValid(index) else {
            return
        }
        let dgc_list = validListDict[index]
        dgc_list?.dgc_listDidDisappear?()
        if let dgc_vc = dgc_list as? UIViewController {
            dgc_vc.endAppearanceTransition()
        }
    }

    private func dgc_checkIndexValid(_ index: Int) -> Bool {
        guard let dataSource = dataSource else { return false }
        let dgc_count = dataSource.numberOfLists(in: self)
        if dgc_count <= 0 || index >= dgc_count {
            return false
        }
        return true
    }

    private func dgc_listDidAppearOrDisappear(scrollView: UIScrollView) {
        let dgc_currentIndexPercent = scrollView.contentOffset.x/scrollView.bounds.size.width
        if dgc_willAppearIndex != -1 || dgc_willDisappearIndex != -1 {
            let dgc_disappearIndex = dgc_willDisappearIndex
            let dgc_appearIndex = dgc_willAppearIndex
            if dgc_willAppearIndex > dgc_willDisappearIndex {
                //将要出现的列表在右边
                if dgc_currentIndexPercent >= CGFloat(dgc_willAppearIndex) {
                    dgc_willDisappearIndex = -1
                    dgc_willAppearIndex = -1
                    dgc_listDidDisappear(at: dgc_disappearIndex)
                    dgc_listDidAppear(at: dgc_appearIndex)
                }
            }else {
                //将要出现的列表在左边
                if dgc_currentIndexPercent <= CGFloat(dgc_willAppearIndex) {
                    dgc_willDisappearIndex = -1
                    dgc_willAppearIndex = -1
                    dgc_listDidDisappear(at: dgc_disappearIndex)
                    dgc_listDidAppear(at: dgc_appearIndex)
                }
            }
        }
    }
}

extension DGCJXSegmentedListContainerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.numberOfLists(in: self)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dgc_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dgc_cell", for: indexPath)
        dgc_cell.contentView.backgroundColor = listCellBackgroundColor
        dgc_cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let dgc_list = validListDict[indexPath.item]
        if dgc_list != nil {
            dgc_list?.listView().frame = dgc_cell.contentView.bounds
            dgc_cell.contentView.addSubview(dgc_list!.listView())
        }
        return dgc_cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating else {
            return
        }
        let dgc_percent = scrollView.contentOffset.x/scrollView.bounds.size.width
        let dgc_maxCount = Int(round(scrollView.contentSize.width/scrollView.bounds.size.width))
        var dgc_leftIndex = Int(floor(Double(dgc_percent)))
        dgc_leftIndex = max(0, min(dgc_maxCount - 1, dgc_leftIndex))
        let dgc_rightIndex = dgc_leftIndex + 1;
        if dgc_percent < 0 || dgc_rightIndex >= dgc_maxCount {
            dgc_listDidAppearOrDisappear(scrollView: scrollView)
            return
        }
        let dgc_remainderRatio = dgc_percent - CGFloat(dgc_leftIndex)
        if dgc_rightIndex == dgc_currentIndex {
            //当前选中的在右边，用户正在从右边往左边滑动
            if validListDict[dgc_leftIndex] == nil && dgc_remainderRatio < (1 - initListPercent) {
                initListIfNeeded(at: dgc_leftIndex)
            }else if validListDict[dgc_leftIndex] != nil {
                if dgc_willAppearIndex == -1 {
                    dgc_willAppearIndex = dgc_leftIndex;
                    dgc_listWillAppear(at: dgc_willAppearIndex)
                }
            }

            if dgc_willDisappearIndex == -1 {
                dgc_willDisappearIndex = dgc_rightIndex
                dgc_listWillDisappear(at: dgc_willDisappearIndex)
            }
        }else {
            //当前选中的在左边，用户正在从左边往右边滑动
            if validListDict[dgc_rightIndex] == nil && dgc_remainderRatio > initListPercent {
                initListIfNeeded(at: dgc_rightIndex)
            }else if validListDict[dgc_rightIndex] != nil {
                if dgc_willAppearIndex == -1 {
                    dgc_willAppearIndex = dgc_rightIndex
                    dgc_listWillAppear(at: dgc_willAppearIndex)
                }
            }
            if dgc_willDisappearIndex == -1 {
                dgc_willDisappearIndex = dgc_leftIndex
                dgc_listWillDisappear(at: dgc_willDisappearIndex)
            }
        }
        dgc_listDidAppearOrDisappear(scrollView: scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //滑动到一半又取消滑动处理
        if dgc_willAppearIndex != -1 || dgc_willDisappearIndex != -1 {
            dgc_listWillDisappear(at: dgc_willAppearIndex)
            dgc_listWillAppear(at: dgc_willDisappearIndex)
            dgc_listDidDisappear(at: dgc_willAppearIndex)
            dgc_listDidAppear(at: dgc_willDisappearIndex)
            dgc_willDisappearIndex = -1
            dgc_willAppearIndex = -1
        }
    }
}

class DGCJXSegmentedListContainerViewController: UIViewController {
    var viewWillAppearClosure: (()->())?
    var viewDidAppearClosure: (()->())?
    var viewWillDisappearClosure: (()->())?
    var viewDidDisappearClosure: (()->())?
    override var shouldAutomaticallyForwardAppearanceMethods: Bool { return false }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearClosure?()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearClosure?()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearClosure?()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappearClosure?()
    }
}
