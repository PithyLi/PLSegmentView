//
//  SegmentView.swift
//  Test2
//
//  Created by Jayz Zz on 2019/4/14.
//  Copyright © 2019 Pithy'L. All rights reserved.
//

import UIKit
import QuartzCore

typealias SegmentViewSelectionCallback = ((_ segmentView: SegmentView, _ selectedSegmentViewIndex: Int) -> Void)

class SegmentView: UIView {
    
    internal struct Points {
        var startPoint: CGPoint
        var endPoint: CGPoint
    }
    
    internal struct ItemInSuperview {
        var collectionViewWidth: CGFloat
        var cellFrameInSuperview: CGRect
        var shapeLayerWidth: CGFloat
        var startX: CGFloat
        var endX: CGFloat
    }
    
    var valueDidChange: SegmentViewSelectionCallback?
    var selectedSegmentViewIndex = -1 {
        didSet {
            if selectedSegmentViewIndex != oldValue {
                reloadSegmentView()
                valueDidChange?(self, selectedSegmentViewIndex)
            }
        }
    }
    
    private(set) var segmentViewItems = [SegmentViewItem]()
    private var segmentCollectionView: UICollectionView?
    private var segmentViewOptions = SegmentViewOptions()
    private var segmentViewStyle = SegmentViewStyle.onlyLabel
    private var isPerformingScrollAnimation = false
    private var isCollectionViewScrolling = false
    private var didScrollToSelectedItem = false
    
    private var topSeparatorView: UIView?
    private var bottomSeparatorView: UIView?
    private var indicatorLayer: CAShapeLayer?
    private var selectedLayer: CAShapeLayer?
    
    // MARK: - Lifecycle
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadSegmentView()
    }
    
    private func commonInit() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(
            frame: frameForSegmentCollectionView(),
            collectionViewLayout: layout
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = true
        collectionView.isScrollEnabled = segmentViewOptions.scrollEnabled
        collectionView.backgroundColor = .clear
        collectionView.accessibilityIdentifier = "SegmentView_collection_view"
        
        segmentCollectionView = collectionView
        
        if let segmentCollectionView = segmentCollectionView {
            addSubview(segmentCollectionView, options: .overlay)
        }
    }
    
    private func frameForSegmentCollectionView() -> CGRect {
        let separatorsHeight: CGFloat = 0
        let collectionViewFrameMinY: CGFloat = 0
        
        return CGRect(
            x: 0,
            y: collectionViewFrameMinY,
            width: bounds.width,
            height: bounds.height - separatorsHeight
        )
    }
    
    func setup(content: [SegmentViewItem], style: SegmentViewStyle, options: SegmentViewOptions?) {
        segmentViewItems = content
        segmentViewStyle = style
        
        selectedLayer?.removeFromSuperlayer()
        indicatorLayer?.removeFromSuperlayer()
        
        if let options = options {
            segmentViewOptions = options
            segmentCollectionView?.isScrollEnabled = segmentViewOptions.scrollEnabled
            backgroundColor = options.backgroundColor
        }
        
        if segmentViewOptions.states.selectedState.backgroundColor != .clear {
            selectedLayer = CAShapeLayer()
            if let selectedLayer = selectedLayer, let sublayer = segmentCollectionView?.layer {
                setupShapeLayer(
                    shapeLayer: selectedLayer,
                    backgroundColor: segmentViewOptions.states.selectedState.backgroundColor,
                    height: bounds.height,
                    sublayer: sublayer
                )
            }
        }
        
        if let indicatorOptions = segmentViewOptions.indicatorOptions {
            indicatorLayer = CAShapeLayer()
            if let indicatorLayer = indicatorLayer {
                setupShapeLayer(
                    shapeLayer: indicatorLayer,
                    backgroundColor: indicatorOptions.color,
                    height: indicatorOptions.height,
                    sublayer: layer
                )
            }
        }
        
        setupCellWithStyle(segmentViewStyle)
        segmentCollectionView?.reloadData()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    private func setupCellWithStyle(_ style: SegmentViewStyle) {
        var cellClass: SegmentCell.Type {
            switch style {
            case .onlyLabel:
                return SegmentLabelCell.self
            case .onlyImage:
                return SegmentImageCell.self
            case .imageBeforeLabel:
                return SegmentImageWithLabelCell.self
            }
        }
        
        segmentCollectionView?.register(
            cellClass,
            forCellWithReuseIdentifier: segmentViewStyle.rawValue
        )
        
        segmentCollectionView?.layoutIfNeeded()
    }
    
    // MARK: CAShapeLayers setup
    
    private func setupShapeLayer(shapeLayer: CAShapeLayer, backgroundColor: UIColor, height: CGFloat,
                                 sublayer: CALayer) {
        shapeLayer.fillColor = backgroundColor.cgColor
        shapeLayer.strokeColor = backgroundColor.cgColor
        shapeLayer.lineWidth = height
        layer.insertSublayer(shapeLayer, below: sublayer)
    }
    
    // MARK: - Actions:
    // MARK: Reload SegmentView
    public func reloadSegmentView() {
        didScrollToSelectedItem = false
        segmentCollectionView?.collectionViewLayout.invalidateLayout()
        segmentCollectionView?.reloadData()
        guard selectedSegmentViewIndex >= 0 else { return }
        scrollToItemAtContext()
        moveShapeLayerAtContext()
    }
    
    // MARK: Move shape layer to item
    
    private func moveShapeLayerAtContext() {
        let itemWitdh = segmentViewItems.enumerated().map { (index, _) -> CGFloat in
            return segmentWidth(for: IndexPath(item: index, section: 0))
        }
        if let indicatorLayer = indicatorLayer, let options = segmentViewOptions.indicatorOptions {
            let item = itemInSuperview(ratio: options.ratio)
            
            let points = Points(
                item: item,
                atIndex: selectedSegmentViewIndex,
                allItemsCellWidth: itemWitdh,
                pointY: indicatorPointY(),
                position: segmentViewOptions.segmentPosition,
                style: segmentViewStyle
            )
            let insetX = ((points.endPoint.x - points.startPoint.x) - (item.endX - item.startX))/2
            moveShapeLayer(
                indicatorLayer,
                startPoint: CGPoint(x: points.startPoint.x + insetX, y: points.startPoint.y),
                endPoint: CGPoint(x: points.endPoint.x - insetX, y: points.endPoint.y),
                animated: true
            )
        }
        
        if let selectedLayer = selectedLayer {
            let item = itemInSuperview()
            
            let points = Points(
                item: item,
                atIndex: selectedSegmentViewIndex,
                allItemsCellWidth: itemWitdh,
                pointY: bounds.midY,
                position: segmentViewOptions.segmentPosition,
                style: segmentViewStyle
            )
            
            moveShapeLayer(
                selectedLayer,
                startPoint: points.startPoint,
                endPoint: points.endPoint,
                animated: true
            )
        }
    }
    
    private func scrollToItemAtContext() {
        guard selectedSegmentViewIndex != -1 else {
            return
        }
        
        let item = itemInSuperview()
        segmentCollectionView?.scrollRectToVisible(centerRect(for: item), animated: true)
    }
    
    private func centerRect(for item: ItemInSuperview) -> CGRect {
        guard let collectionView = segmentCollectionView else {
            fatalError("segmentCollectionView should exist")
        }
        
        let item = itemInSuperview()
        var centerRect = item.cellFrameInSuperview
        
        if (item.startX + collectionView.contentOffset.x) - (item.collectionViewWidth - centerRect.width) / 2 < 0 {
            centerRect.origin.x = 0
            let widthToAdd = item.collectionViewWidth - centerRect.width
            centerRect.size.width += widthToAdd
        } else if collectionView.contentSize.width - item.endX < (item.collectionViewWidth - centerRect.width) / 2 {
            centerRect.origin.x = collectionView.contentSize.width - item.collectionViewWidth
            centerRect.size.width = item.collectionViewWidth
        } else {
            centerRect.origin.x = item.startX - (item.collectionViewWidth - centerRect.width) / 2
                + collectionView.contentOffset.x
            centerRect.size.width = item.collectionViewWidth
        }
        
        return centerRect
    }
    
    // MARK: Move shape layer
    
    private func moveShapeLayer(_ shapeLayer: CAShapeLayer, startPoint: CGPoint, endPoint: CGPoint,
                                animated: Bool = false) {
        var endPointWithVerticalSeparator = endPoint
        let isLastItem = selectedSegmentViewIndex + 1 == segmentViewItems.count
        endPointWithVerticalSeparator.x = endPoint.x - (isLastItem ? 0 : 1)
        
        let shapeLayerPath = UIBezierPath()
        shapeLayerPath.move(to: startPoint)
        shapeLayerPath.addLine(to: endPointWithVerticalSeparator)
        
        if animated == true {
            isPerformingScrollAnimation = true
            isUserInteractionEnabled = false
            
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = shapeLayer.path
            animation.toValue = shapeLayerPath.cgPath
            animation.duration = segmentViewOptions.animationDuration
            CATransaction.setCompletionBlock() {
                self.isPerformingScrollAnimation = false
                self.isUserInteractionEnabled = true
            }
            shapeLayer.add(animation, forKey: "path")
            CATransaction.commit()
        }
        
        shapeLayer.path = shapeLayerPath.cgPath
    }
    
    // MARK: - Item in superview
    
    private func itemInSuperview(ratio: CGFloat = 1) -> ItemInSuperview {
        var collectionViewWidth: CGFloat = 0
        var cellWidth: CGFloat = 0
        var cellRect = CGRect.zero
        var shapeLayerWidth: CGFloat = 0
        
        if let collectionView = segmentCollectionView, selectedSegmentViewIndex != -1 {
            collectionViewWidth = collectionView.frame.width
            cellWidth = segmentWidth(for: IndexPath(row: selectedSegmentViewIndex, section: 0))
            var x: CGFloat = 0
            
            switch segmentViewOptions.segmentPosition {
            case .fixed:
                x = floor(CGFloat(selectedSegmentViewIndex) * cellWidth - collectionView.contentOffset.x)
                
            case .dynamic:
                for i in 0..<selectedSegmentViewIndex {
                    x += segmentWidth(for: IndexPath(item: i, section: 0))
                }
                
                x -= collectionView.contentOffset.x
            }
            
            cellRect = CGRect(
                x: x,
                y: 0,
                width: cellWidth,
                height: collectionView.frame.height
            )
            
            shapeLayerWidth = floor(cellWidth * ratio)
        }
        
        return ItemInSuperview(
            collectionViewWidth: collectionViewWidth,
            cellFrameInSuperview: cellRect,
            shapeLayerWidth: shapeLayerWidth,
            startX: floor(cellRect.midX - (shapeLayerWidth / 2)),
            endX: floor(cellRect.midX + (shapeLayerWidth / 2))
        )
    }
    
    // MARK: - Segment Width
    
    private func segmentWidth(for indexPath: IndexPath) -> CGFloat {
        guard let collectionView = segmentCollectionView else {
            return 0
        }
        
        var width: CGFloat = 0
        let collectionViewWidth = collectionView.frame.width
        
        switch segmentViewOptions.segmentPosition {
        case .fixed(let maxVisibleItems):
            let maxItems = maxVisibleItems > segmentViewItems.count ? segmentViewItems.count : maxVisibleItems
            width = maxItems == 0 ? 0 : floor(collectionViewWidth / CGFloat(maxItems))
            
        case .dynamic:
            guard !segmentViewItems.isEmpty else {
                break
            }
            
            var dynamicWidth: CGFloat = 0
            for item in segmentViewItems {
                dynamicWidth += intrinsicWidth(for: item, style: segmentViewStyle)
            }
            let itemWidth = intrinsicWidth(for: segmentViewItems[indexPath.row], style: segmentViewStyle)
            width = dynamicWidth > collectionViewWidth ? itemWidth
                : itemWidth + ((collectionViewWidth - dynamicWidth) / CGFloat(segmentViewItems.count))
        }
        
        return width
    }
    
    private func intrinsicWidth(for item: SegmentViewItem, style: SegmentViewStyle) -> CGFloat {
        var itemWidth = style.isWithText() ? item.intrinsicWidth : (item.image?.size.width ?? 0)
        itemWidth += style.layoutMargins
        
        if style == .imageBeforeLabel {
            itemWidth += 22.0
        }
        
        return itemWidth
    }
    
    // MARK: - Indicator point Y
    
    private func indicatorPointY() -> CGFloat {
        var indicatorPointY: CGFloat = 0
        
        guard let indicatorOptions = segmentViewOptions.indicatorOptions else {
            return indicatorPointY
        }
        
        indicatorPointY = frame.height - (indicatorOptions.height / 2)
        
        return indicatorPointY
    }
}

// MARK: - UICollectionViewDataSource

extension SegmentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentViewItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: segmentViewStyle.rawValue,
            for: indexPath) as! SegmentCell
        
        let content = segmentViewItems[indexPath.row]
        
        cell.configure(
            content: content,
            style: segmentViewStyle,
            options: segmentViewOptions,
            isLastCell: indexPath.row == segmentViewItems.count - 1
        )
        
        cell.configure(
            selected: (indexPath.row == selectedSegmentViewIndex),
            selectedImage: content.selectedImage,
            image: content.image
        )
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension SegmentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegmentViewIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !didScrollToSelectedItem {
            scrollToItemAtContext()
            didScrollToSelectedItem = true
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SegmentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: segmentWidth(for: indexPath), height: collectionView.frame.height)
    }
    
}

// MARK: - UIScrollViewDelegate

extension SegmentView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isPerformingScrollAnimation {
            return
        }
        
        if let options = segmentViewOptions.indicatorOptions, let indicatorLayer = indicatorLayer {
            let item = itemInSuperview(ratio: options.ratio)
            moveShapeLayer(
                indicatorLayer,
                startPoint: CGPoint(x: item.startX, y: indicatorPointY()),
                endPoint: CGPoint(x: item.endX, y: indicatorPointY()),
                animated: false
            )
        }
        
        if let selectedLayer = selectedLayer {
            let item = itemInSuperview()
            moveShapeLayer(
                selectedLayer,
                startPoint: CGPoint(x: item.startX, y: bounds.midY),
                endPoint: CGPoint(x: item.endX, y: bounds.midY),
                animated: false
            )
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isCollectionViewScrolling = false
    }
    
}

extension SegmentView.Points {
    
    init(item: SegmentView.ItemInSuperview, atIndex index: Int, allItemsCellWidth: [CGFloat], pointY: CGFloat, position: SegmentViewPosition, style: SegmentViewStyle) {
        let cellWidth = item.cellFrameInSuperview.width
        var startX = item.startX
        var endX = item.endX
        var spaceBefore: CGFloat = 0
        var spaceAfter: CGFloat = 0
        var i = 0
        allItemsCellWidth.forEach { width in
            if i < index { spaceBefore += width }
            if i > index { spaceAfter += width }
            i += 1
        }
     
        startX = (item.collectionViewWidth / 2) - (cellWidth / 2 )
        if spaceBefore < (item.collectionViewWidth - cellWidth) / 2 {
            startX = spaceBefore
        }
        if spaceAfter < (item.collectionViewWidth - cellWidth) / 2 {
            startX = item.collectionViewWidth - spaceAfter - cellWidth
        }
        endX = startX + cellWidth
        
        startPoint = CGPoint(x: startX, y: pointY)
        endPoint = CGPoint(x: endX, y: pointY)
    }
    
}

