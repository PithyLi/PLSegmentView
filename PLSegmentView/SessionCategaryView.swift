//
//  SessionCategaryView.swift
//  Test2
//
//  Created by Jayz Zz on 2019/4/15.
//  Copyright © 2019 Pithy'L. All rights reserved.
//

import UIKit

class SessionCategaryView: UIView {

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentOffset = CGPoint.zero
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        collectionView.register(SessionCategaryCell.self, forCellWithReuseIdentifier: "SessionCategaryCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let containerTop = collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0)
        let containerBottom = collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
        let containerLeading = collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0)
        let containerTrailing = collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0)

        NSLayoutConstraint.activate([containerTop, containerBottom, containerLeading, containerTrailing])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func configure() {
        
    }
}

extension SessionCategaryView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCategaryCell", for: indexPath) as! SessionCategaryCell
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 20) / 3, height: 60.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
