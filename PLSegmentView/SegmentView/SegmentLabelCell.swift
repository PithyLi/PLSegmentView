//
//  SegmentLabelCell.swift
//  Test2
//
//  Created by Jayz Zz on 2019/4/14.
//  Copyright © 2019 Pithy'L. All rights reserved.
//

import UIKit

class SegmentLabelCell: SegmentCell {
    
    override func setupConstraintsForSubviews() {
        super.setupConstraintsForSubviews()
        
        guard let containerView = containerView, let segmentTitleLabel = segmentTitleLabel else {
            return
        }
        
        let containerTop = containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0)
        let containerBottom = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
        let containerLeading = containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0)
        let containerTrailing = containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0)
        
        NSLayoutConstraint.activate([containerTop, containerBottom, containerLeading, containerTrailing])
        
        let titleTop = segmentTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0)
        let titleBottom = segmentTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0)
        let titleLeading = segmentTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0)
        let titleTrailing = segmentTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0)
        
        NSLayoutConstraint.activate([titleTop, titleBottom, titleLeading, titleTrailing])
    }
}

class SegmentImageCell: SegmentCell {
    override func setupConstraintsForSubviews() {
        super.setupConstraintsForSubviews()
        guard let imageContainerView = imageContainerView else {
            return
        }
        
        let views = ["imageContainerView": imageContainerView]
        
        
        let segmentImageViewlHorizontConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "|-[imageContainerView]-|",
            options: [],
            metrics: nil,
            views: views)
        NSLayoutConstraint.activate(segmentImageViewlHorizontConstraint)
        
        
        topConstraint = NSLayoutConstraint(
            item: imageContainerView,
            attribute: .top,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .top,
            multiplier: 1,
            constant: padding
        )
        topConstraint?.isActive = true
        
        bottomConstraint = NSLayoutConstraint(
            item: contentView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: imageContainerView,
            attribute: .bottom,
            multiplier: 1,
            constant: padding
        )
        bottomConstraint?.isActive = true
    }
}

class SegmentImageWithLabelCell: SegmentCell {
    
}
