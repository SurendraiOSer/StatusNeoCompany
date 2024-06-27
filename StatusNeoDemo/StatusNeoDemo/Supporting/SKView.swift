//
//  SKView.swift
//

import Foundation
import UIKit

@IBDesignable
class SKView: UIView
{
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var masksToBounds: Bool = false {
        didSet {
            self.layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var midColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    
    @IBInspectable var horizontal: Bool = false
    let gradient: CAGradientLayer = CAGradientLayer()
    
    @IBInspectable var shadowLayer: CALayer = CALayer()

    @IBInspectable var shadowColor: UIColor = UIColor.clear
    @IBInspectable var shadowOpacity: Float = 0
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowOffset: CGSize = CGSize(width: -1, height: 1)
    @IBInspectable var shadowScale: Bool = false
    
    @IBInspectable var canShowShadow: Bool = false
    
    @IBInspectable var isDottedborder: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect)
    {
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: self.frame.size.width,
                                height: self.frame.size.height)
        
        if midColor != UIColor.clear {
            gradient.colors = [startColor.cgColor, midColor.cgColor ,endColor.cgColor]
        }
        else {
            gradient.colors = [startColor.cgColor, endColor.cgColor]
        }
        
        if horizontal {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        gradient.zPosition = -1
        layer.addSublayer(gradient)
        
        if canShowShadow
        {
            showShadow()
        }
    }
    
    
    
    /// To show shadow if enabled
    func showShadow()
    {
        //self.layer.removeFromSuperlayer()
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    
    func updateChanges()
    {
        if midColor != UIColor.clear {
            gradient.colors = [startColor.cgColor, midColor.cgColor ,endColor.cgColor]
        }
        else {
            gradient.colors = [startColor.cgColor, endColor.cgColor]
        }
        
        self.layoutSubviews()
    }
    
}

class RDPickerView: UIPickerView
{
    @IBInspectable var selectorColor: UIColor? = nil

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if let color = selectorColor
        {
            if subview.bounds.height <= 1.0
            {
                subview.backgroundColor = color
            }
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()

        if let color = selectorColor
        {
            for subview in subviews {
                if subview.bounds.height <= 1.0
                {
                    subview.backgroundColor = color
                }
            }
        }
    }
}

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
