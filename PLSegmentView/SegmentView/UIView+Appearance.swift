//
//  UIView+Appearance.swift
//  Test2
//
//  Created by Jayz Zz on 2019/4/14.
//  Copyright © 2019 Pithy'L. All rights reserved.
//

import UIKit

private typealias SubviewTreeModifier = (() -> UIView)

struct SegmentAppearanceOptions: OptionSet {
    
    public static let overlay = SegmentAppearanceOptions(rawValue: 1 << 0)
    public static let useAutoresize = SegmentAppearanceOptions(rawValue: 1 << 1)
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension UIView {
    
    private func addSubviewUsingOptions(_ options: SegmentAppearanceOptions, modifier: SubviewTreeModifier) {
        let subview = modifier()
        if options.union(.overlay) == .overlay {
            if options.union(.useAutoresize) != .useAutoresize {
                subview.translatesAutoresizingMaskIntoConstraints = false
                let views = dictionaryOfNames([subview])
                
                let horisontalConstraints = NSLayoutConstraint.constraints(
                    withVisualFormat: "|[subview]|",
                    options: [],
                    metrics: nil,
                    views: views
                )
                addConstraints(horisontalConstraints)
                
                let verticalConstraints = NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[subview]|",
                    options: [],
                    metrics: nil,
                    views: views
                )
                addConstraints(verticalConstraints)
                
            } else {
                frame = bounds
                subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            }
        }
    }
    
    private func dictionaryOfNames(_ views: [UIView]) -> [String: UIView] {
        var container = [String: UIView]()
        for (_, value) in views.enumerated() {
            container["subview"] = value
        }
        return container
    }
    
    // MARK: - Interface methods
    
    func addSubview(_ subview: UIView, options: SegmentAppearanceOptions) {
        if subview.superview == self {
            return
        }
        addSubviewUsingOptions(options) { [weak self] in
            self?.addSubview(subview)
            return subview
        }
    }
    
    func insertSubview(_ subview: UIView, index: Int, options: SegmentAppearanceOptions) {
        if subview.superview == self {
            return
        }
        addSubviewUsingOptions(options) { [weak self] in
            self?.insertSubview(subview, at: index)
            return subview
        }
    }
    
}
