//
//  SegmentCell.swift
//  Test2
//
//  Created by Jayz Zz on 2019/4/14.
//  Copyright © 2019 Pithy'L. All rights reserved.
//

import UIKit

class SegmentCell: UICollectionViewCell {
    
    let padding: CGFloat = 0
    
    var verticalSeparatorView: UIView?
    var segmentTitleLabel: UILabel?
    var segmentImageView: UIImageView?
    var containerView: UIView?
    var imageContainerView: UIView?
    
    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var cellSelected = false
    
    private var options = SegmentViewOptions()
    private var style = SegmentViewStyle.onlyLabel
    private let verticalSeparatorLayer = CAShapeLayer()
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        
        set {
            if newValue != isHighlighted {
                super.isHighlighted = newValue
                
                let highlightedState = options.states.highlightedState
                let defaultState = options.states.defaultState
                let selectedState = options.states.selectedState
                
                if style.isWithText() {
                    let highlightedTitleTextColor = cellSelected ? selectedState.titleTextColor
                        : defaultState.titleTextColor
                    let highlightedTitleFont = cellSelected ? selectedState.titleFont : defaultState.titleFont
                    
                    segmentTitleLabel?.textColor = isHighlighted ? highlightedState.titleTextColor
                        : highlightedTitleTextColor
                    segmentTitleLabel?.font = isHighlighted ? highlightedState.titleFont : highlightedTitleFont
                }
                
                backgroundColor = isHighlighted ? highlightedState.backgroundColor : .clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageContainerView = UIView(frame: CGRect.zero)
        if let imageContainerView = imageContainerView {
            contentView.addSubview(imageContainerView)
        }
        
        segmentImageView = UIImageView(frame: CGRect.zero)
        if let segmentImageView = segmentImageView, let imageContainerView = imageContainerView {
            imageContainerView.addSubview(segmentImageView)
        }
        
        containerView = UIView(frame: CGRect.zero)
        if let containerView = containerView {
            contentView.addSubview(containerView)
        }
        
        segmentTitleLabel = UILabel(frame: CGRect.zero)
        if let segmentTitleLabel = segmentTitleLabel, let containerView = containerView {
            containerView.addSubview(segmentTitleLabel)
        }
        
        segmentImageView?.translatesAutoresizingMaskIntoConstraints = false
        segmentTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView?.translatesAutoresizingMaskIntoConstraints = false
        
        segmentImageView?.layer.masksToBounds = true
        segmentTitleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        
        setupConstraintsForSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        verticalSeparatorLayer.removeFromSuperlayer()
        super.prepareForReuse()
        
        switch style {
        case .onlyLabel:
            segmentTitleLabel?.text = nil
        case .onlyImage:
            segmentImageView?.image = nil
        default:
            segmentTitleLabel?.text = nil
            segmentImageView?.image = nil
        }
    }
    
    // MARK: - Configure
    
    func configure(content: SegmentViewItem, style: SegmentViewStyle, options: SegmentViewOptions, isLastCell: Bool) {
        self.options = options
        self.style = style
        setupContent(content: content)
    }
    
    func configure(selected: Bool, selectedImage: UIImage? = nil, image: UIImage? = nil) {
        cellSelected = selected
        
        let selectedState = options.states.selectedState
        let defaultState = options.states.defaultState
        
        if style.isWithText() {
            segmentTitleLabel?.textColor = selected ? selectedState.titleTextColor : defaultState.titleTextColor
            segmentTitleLabel?.font = selected ? selectedState.titleFont : defaultState.titleFont
            segmentTitleLabel?.minimumScaleFactor = 0.5
            segmentTitleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        if (style != .onlyLabel) {
            segmentImageView?.image = selected ? selectedImage : image
        }
    }
    
    func setupConstraintsForSubviews() {

    }

    private func setupContent(content: SegmentViewItem) {
        if style.isWithImage() {
            segmentImageView?.contentMode = options.imageContentMode
            segmentImageView?.image = content.image
        }
        
        if style.isWithText() {
            segmentTitleLabel?.textAlignment = options.labelTextAlignment
            segmentTitleLabel?.numberOfLines = options.labelTextNumberOfLines
            let defaultState = options.states.defaultState
            segmentTitleLabel?.textColor = defaultState.titleTextColor
            segmentTitleLabel?.font = defaultState.titleFont
            segmentTitleLabel?.text = content.title
            segmentTitleLabel?.minimumScaleFactor = 0.5
            segmentTitleLabel?.adjustsFontSizeToFitWidth = true
            segmentTitleLabel?.transform = CGAffineTransform(a: 1, b: 0, c: -CGFloat(tanf(15 * Float.pi / 360)), d: 1, tx: 0, ty: 0)

        }
    }
}
