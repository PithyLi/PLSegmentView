//
//  SegmentViewOptions.swift
//  Test2
//
//  Created by Jayz Zz on 2019/4/14.
//  Copyright © 2019 Pithy'L. All rights reserved.
//

import UIKit

struct SegmentViewItem {
    
    public var title: String?
    public var image: UIImage?
    public var selectedImage: UIImage?
    public var badgeCount: Int?
    public var badgeColor: UIColor?
    public var intrinsicWidth: CGFloat {
        let label = UILabel()
        label.text = self.title
        label.sizeToFit()
        return label.intrinsicContentSize.width
    }
    
    init(title: String?, image: UIImage? = nil, selectedImage: UIImage? = nil) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage ?? image
    }
}

// MARK: - Content view

struct SegmentViewState {
    
    var backgroundColor: UIColor
    var titleFont: UIFont
    var titleTextColor: UIColor
    
    init(
        backgroundColor: UIColor = .clear,
        titleFont: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
        titleTextColor: UIColor = .black) {
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
    }
    
}

// MARK: - Indicator

struct SegmentViewIndicatorOptions {
    
    var ratio: CGFloat
    var height: CGFloat
    var color: UIColor
    
    init(ratio: CGFloat = 1, height: CGFloat = 2,
                color: UIColor = .orange) {
        self.ratio = ratio
        self.height = height
        self.color = color
    }
    
}

// MARK: - Position

enum SegmentViewPosition {
    case dynamic
    case fixed(maxVisibleItems: Int)
}

// MARK: - Control options

enum SegmentViewStyle: String {
    
    case onlyLabel, onlyImage, imageBeforeLabel
    
    static let allStyles = [
        onlyLabel,
        onlyImage,
        imageBeforeLabel
    ]
    
    func isWithText() -> Bool {
        switch self {
        case .onlyLabel, .imageBeforeLabel:
            return true
        default:
            return false
        }
    }
    
    func isWithImage() -> Bool {
        switch self {
        case .imageBeforeLabel, .onlyImage:
            return true
        default:
            return false
        }
    }
    
    var layoutMargins: CGFloat {
        let defaultLayoutMargins: CGFloat = 8.0
        switch self {
        case .onlyLabel, .imageBeforeLabel:
            return 4 * defaultLayoutMargins
        case .onlyImage:
            return 2 * defaultLayoutMargins
        }
    }
}

typealias SegmentViewStates = (defaultState: SegmentViewState, selectedState: SegmentViewState,
    highlightedState: SegmentViewState)

struct SegmentViewOptions {
    
    var backgroundColor: UIColor
    var segmentPosition: SegmentViewPosition
    var scrollEnabled: Bool
    var indicatorOptions: SegmentViewIndicatorOptions?
    var imageContentMode: UIView.ContentMode
    var labelTextAlignment: NSTextAlignment
    var labelTextNumberOfLines: Int
    var states: SegmentViewStates
    var animationDuration: CFTimeInterval
    
    init() {
        self.backgroundColor = .lightGray
        self.segmentPosition = .fixed(maxVisibleItems: 4)
        self.scrollEnabled = true
        self.indicatorOptions = SegmentViewIndicatorOptions()
        self.imageContentMode = .center
        self.labelTextAlignment = .center
        self.labelTextNumberOfLines = 0
        self.states = SegmentViewStates(defaultState: SegmentViewState(),
                                      selectedState: SegmentViewState(),
                                      highlightedState: SegmentViewState())
        self.animationDuration = 0.1
    }
    
    init(backgroundColor: UIColor = .white,
                segmentPosition: SegmentViewPosition = .fixed(maxVisibleItems: 4),
                scrollEnabled: Bool = true,
                indicatorOptions: SegmentViewIndicatorOptions? = SegmentViewIndicatorOptions(),
                imageContentMode: UIView.ContentMode = .center,
                labelTextAlignment: NSTextAlignment = .center,
                labelTextNumberOfLines: Int = 0,
                segmentStates: SegmentViewStates = SegmentViewStates(defaultState: SegmentViewState(),
                                                                 selectedState: SegmentViewState(),
                                                                 highlightedState: SegmentViewState()),
                animationDuration: CFTimeInterval = 0.1) {
        self.backgroundColor = backgroundColor
        self.segmentPosition = segmentPosition
        self.scrollEnabled = scrollEnabled
        self.indicatorOptions = indicatorOptions
        self.imageContentMode = imageContentMode
        self.labelTextAlignment = labelTextAlignment
        self.labelTextNumberOfLines = labelTextNumberOfLines
        self.states = segmentStates
        self.animationDuration = animationDuration
    }
}
