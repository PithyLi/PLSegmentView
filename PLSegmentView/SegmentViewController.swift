//
//  SegmentViewController.swift
//  Test2
//
//  Created by Jayz Zz on 2019/4/14.
//  Copyright © 2019 Pithy'L. All rights reserved.
//

import UIKit

struct SegmentBuilder {
    
    static func buildSegmentView(segmentViewView: SegmentView, segmentViewStyle: SegmentViewStyle = .onlyLabel, segmentViewPosition: SegmentViewPosition = .fixed(maxVisibleItems: 5)) {
        segmentViewView.setup(
            content: segmentViewContent(),
            style: segmentViewStyle,
            options: segmentViewOptions(segmentViewStyle: segmentViewStyle, segmentViewPosition: segmentViewPosition)
        )
    }
    
    private static func segmentViewContent() -> [SegmentViewItem] {
        return [
            SegmentViewItem(title: "年龄"),
            SegmentViewItem(title: "Jay"),
            SegmentViewItem(title: "热门"),
            SegmentViewItem(title: "风格"),
            SegmentViewItem(title: "主题"),
            SegmentViewItem(title: "嘻哈"),
            SegmentViewItem(title: "性别")
        ]
    }
    
    private static func segmentViewOptions(segmentViewStyle: SegmentViewStyle, segmentViewPosition: SegmentViewPosition = .fixed(maxVisibleItems: 4)) -> SegmentViewOptions {
        var imageContentMode = UIView.ContentMode.center
        switch segmentViewStyle {
        case .imageBeforeLabel:
            imageContentMode = .scaleAspectFit
        default:
            break
        }
        
        return SegmentViewOptions(
            backgroundColor: UIColor(displayP3Red: 42.0 / 255.0, green: 42.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0),
            segmentPosition: segmentViewPosition,
            scrollEnabled: true,
            indicatorOptions: segmentViewIndicatorOptions(),
            imageContentMode: imageContentMode,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: segmentViewStates(),
            animationDuration: 0.3
        )
    }
    
    private static func segmentViewStates() -> SegmentViewStates {
        let font = UIFont.systemFont(ofSize: 16.0, weight: .black)
        let selectfont = UIFont.systemFont(ofSize: 18.0, weight: .black)
        return SegmentViewStates(
            defaultState: segmentViewState(
                backgroundColor: .clear,
                titleFont: font,
                titleTextColor: UIColor.lightGray
            ),
            selectedState: segmentViewState(
                backgroundColor: .clear,
                titleFont: selectfont,
                titleTextColor: UIColor.white
            ),
            highlightedState: segmentViewState(
                backgroundColor: .clear,
                titleFont: selectfont,
                titleTextColor: UIColor.white
            )
        )
    }
    
    private static func segmentViewState(backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentViewState {
        return SegmentViewState(
            backgroundColor: backgroundColor,
            titleFont: titleFont,
            titleTextColor: titleTextColor
        )
    }
    
    private static func segmentViewIndicatorOptions() -> SegmentViewIndicatorOptions {
        return SegmentViewIndicatorOptions(
            ratio: 0.3,
            height: 3,
            color: UIColor.orange
        )
    }
    
}

public struct Shadow {
    let color: UIColor
    let offset: CGSize
    let blur: CGFloat
    
    public init(color: UIColor, offset: CGSize, blur: CGFloat) {
        self.color = color
        self.offset = offset
        self.blur = blur
    }
    
    func apply(to layer: CALayer) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = blur
        layer.shadowOpacity = 1
    }
}

class SegmentViewController: UIViewController {

    private var segmentView: SegmentView?
    
    private var segmentBackView: UIView?
    
    private var categaryTitleLabel: UILabel?
    
    private var categaryView: SessionCategaryView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        segmentBackView = UIView(frame: CGRect(x: 0, y: 100.0, width: UIScreen.main.bounds.width, height: 54.0))
        segmentBackView?.backgroundColor = UIColor(displayP3Red: 42.0 / 255.0, green: 42.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0)
        view.addSubview(segmentBackView!)
        
        segmentView = SegmentView(frame: CGRect(x: 0, y: 0.0, width: UIScreen.main.bounds.width - 62.0, height: 54.0))
        segmentView?.clipsToBounds = true
        segmentBackView?.addSubview(segmentView!)
        
        categaryTitleLabel = UILabel(frame: CGRect(x: 15, y: 0.0, width: 100.0, height: 54.0))
        categaryTitleLabel?.text = "全部分类"
        categaryTitleLabel?.textColor = UIColor.white
        segmentBackView?.insertSubview(categaryTitleLabel!, belowSubview: segmentView!)
        
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 58.0, y: 0.0, width: 58.0, height: 54.0))
        button.setImage(UIImage(named: "path20"), for: .normal)
        button.addTarget(self, action: #selector(categaryAction), for: .touchUpInside)
        segmentBackView?.addSubview(button)
        
        let shadowView = UIView(frame: CGRect(x: UIScreen.main.bounds.width - 62.0, y: 0.0, width: 4.0, height: 54.0))
        segmentBackView?.addSubview(shadowView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = shadowView.bounds
        shadowView.layer.addSublayer(gradientLayer)
        
        gradientLayer.colors = [UIColor(displayP3Red: 42.0 / 255.0, green: 42.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor,
                                UIColor(displayP3Red: 35.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0).cgColor]
        let gradientLocations:[NSNumber] = [0.0,0.8,1.0]
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
       
        categaryView = SessionCategaryView(frame: CGRect(x: 0, y: segmentBackView!.frame.maxY, width: UIScreen.main.bounds.width, height: 0.0))
        categaryView?.backgroundColor = UIColor(displayP3Red: 42.0 / 255.0, green: 42.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0)
        categaryView?.clipsToBounds = true
        view.addSubview(categaryView!)
        
        Shadow(color: UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5), offset: CGSize(width: 0, height: 4), blur: 4.0).apply(to: segmentBackView!.layer)

        SegmentBuilder.buildSegmentView(segmentViewView: segmentView!, segmentViewStyle: .onlyLabel)
        segmentView?.valueDidChange = { [weak self] _, segmentIndex in
            print(segmentIndex)
        }
        segmentView?.selectedSegmentViewIndex = -1
        // Do any additional setup after loading the view.
    }

    @objc private func categaryAction() {
        
        var frame = CGRect(x: 0, y: segmentBackView!.frame.maxY, width: UIScreen.main.bounds.width, height: 0.0)
        if segmentView!.isHidden {
            frame = CGRect(x: 0, y: segmentBackView!.frame.maxY, width: UIScreen.main.bounds.width, height: 0.0)
        } else {
            frame = CGRect(x: 0, y: segmentBackView!.frame.maxY, width: UIScreen.main.bounds.width, height: 204.0)
        }
        
    
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.segmentView?.alpha = self.segmentView!.isHidden ? 1.0 : 0.0
            self.categaryView?.frame = frame
            
        }) { (finished) in
//            self.categaryView?.frame = frame
            self.segmentView?.isHidden = !self.segmentView!.isHidden
        }
    }

}
