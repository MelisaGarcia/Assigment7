//
//  HorizontalItemList.swift
//  Assigment7
//
//  Created by Andrea Dancek on 2020-05-23.
//  Copyright © 2020 Melisa Garcia. All rights reserved.
//

import UIKit

//
// A scroll view, which loads all 10 images, and has a callback
// for when the user taps on one of the images
//
class HorizontalItemList: UIScrollView {

    var didSelectItem: ((_ index: Int) -> ())?
    
    let buttonWidth: CGFloat = 100.0
    let padding: CGFloat = 5.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(inView: UIView) {
        let rect = CGRect(x: inView.bounds.width, y: 120.0, width: inView.bounds.width, height: 100.0)
        self.init(frame: rect)
        
        alpha = 0.0
        
        for i in 0..<5 {
            let image =  UIImage(named: "Snack_0\(i).png")
            let imageView = UIImageView(image: image)
            imageView.center = CGPoint(x: CGFloat(i) * buttonWidth + buttonWidth / 2, y: buttonWidth / 2)
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            addSubview(imageView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage(_:)))
            imageView.addGestureRecognizer(tap)
        }
        
        contentSize = CGSize(width: padding * buttonWidth, height: buttonWidth + 2 * buttonWidth)
    }

    @objc func didTapImage(_ tap: UITapGestureRecognizer) {
        didSelectItem?(tap.view!.tag)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard superview != nil else {
            return
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.01, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
            self.center.x -= self.frame.size.width
        }, completion: nil)
    }
    
}
