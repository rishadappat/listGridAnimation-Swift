//
//  UIView+Extension.swift
//  ADP Prototype
//
//  Created by ADPolice on 3/18/18.
//  Copyright © 2018 ADPolice. All rights reserved.
//

import UIKit

extension UIView {
    
    enum Visibility: String {
        case visible = "visible"
        case invisible = "invisible"
        case gone = "gone"
    }

    var visibility: Visibility {
        get {
            let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
            if let constraint = constraint, constraint.isActive {
                return .gone
            } else {
                return self.isHidden ? .invisible : .visible
            }
        }
        set {
            if self.visibility != newValue {
                self.setVisibility(newValue)
            }
        }
    }

    @IBInspectable
    var visibilityState: String {
        get {
            return self.visibility.rawValue
        }
        set {
            let _visibility = Visibility(rawValue: newValue)!
            self.visibility = _visibility
        }
    }

    private func setVisibility(_ visibility: Visibility) {
        let constraints = self.constraints.filter({$0.firstAttribute == .height && $0.constant == 0 && $0.secondItem == nil && ($0.firstItem as? UIView) == self})
        let constraint = (constraints.first)

        switch visibility {
        case .visible:
            constraint?.isActive = false
            self.isHidden = false
            break
        case .invisible:
            constraint?.isActive = false
            self.isHidden = true
            break
        case .gone:
            self.isHidden = true
            if let constraint = constraint {
                constraint.isActive = true
            } else {
                let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                // constraint.priority = UILayoutPriority(rawValue: 999)
                self.addConstraint(constraint)
                constraint.isActive = true
            }
            self.setNeedsLayout()
            self.setNeedsUpdateConstraints()
        }
    }
    
    public class func fromNib(nibName: String? = nil) -> Self {
        return fromNib(nibName: nibName, type: self)
    }

    public class func fromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T {
        return fromNib(nibName: nibName, type: T.self)!
    }

    public class func fromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String

        if let nibName = nibName {
            name = nibName
        } else {
            name = self.nibName
        }

        if let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil) {
            for nibView in nibViews {
                if let tog = nibView as? T {
                    view = tog
                }
            }
        }

        return view
    }

    public class var nibName: String {
        return "\(self)".components(separatedBy: ".").first ?? ""
    }

    public class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func setCardGradientBackground(color1: UIColor, color2: UIColor)
    {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color1.withAlphaComponent(0.5).cgColor , color1.withAlphaComponent(0.2).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1, y: 0.0)
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.cornerRadius = cornerRadius
    }
    
    func setHorizontalGradientBackground(color1: UIColor, color2: UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setGradientBackground(color1: UIColor, color2: UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setDiagonalGradient(color1: UIColor, color2: UIColor)
    {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.name = "diagonal"
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func removeDiagonalGradient()
    {
        for layer in self.layer.sublayers! {
            if layer.name == "diagonal" {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    enum Direction: Int {
      case topToBottom = 0
      case bottomToTop
      case leftToRight
      case rightToLeft
    }
    
    func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                  direction: Direction = .leftToRight,
                                  repeatCount: Float = MAXFLOAT) {
      
        let lightColor = UIColor(named:"primaryColor")?.withAlphaComponent(0.2).cgColor
        let blackColor = UIColor(named:"primaryColor")!.cgColor
        
        // Create a CAGradientLayer  ->3
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blackColor, lightColor!, blackColor]
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
        
        switch direction {
        case .topToBottom:
          gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
          gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
          
        case .bottomToTop:
          gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
          gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
          
        case .leftToRight:
          gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
          gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
          
        case .rightToLeft:
          gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
          gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        gradientLayer.locations =  [0.8, 0.9, 0.95] //[0.4, 0.6]
        self.layer.mask = gradientLayer
        
        // Add animation over gradient Layer  ->4
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock { [weak self] in
          guard let strongSelf = self else { return }
          strongSelf.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()// Create color  ->2
        
    }
    
    func stopShimmeringAnimation() {
        self.layer.mask = nil
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor:layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat{
        get {
            return layer.shadowRadius
        }
        set {
            if(shadowRadius != 0)
            {
                layer.masksToBounds = false
                layer.shadowColor = shadowColor
                layer.shadowOffset = shadowOffset
                layer.shadowOpacity = shadowOpacity
                layer.shadowRadius = newValue
            }
        }
    }
    
    @IBInspectable
    var shadowColor: CGColor{
        get {
            return UIColor(red:0.11, green:0.12, blue:0.17, alpha:1.0).cgColor
        }
        set {
            if(shadowOpacity != 0)
            {
                layer.shadowColor = newValue
            }
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float{
        get {
            return 0.3
        }
        set {
            if(shadowOpacity != 0)
            {
                layer.shadowOpacity = newValue
            }
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize{
        get {
            return CGSize.init(width: 0, height: 3)
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    static func nibForClass() -> Self {
        return loadNib(self)
        
    }
    
    var X: CGFloat{
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    var Y: CGFloat{
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    static func loadNib<A>(_ owner: AnyObject, bundle: Bundle = Bundle.main) -> A {
        
        let nibName = NSStringFromClass(classForCoder()).components(separatedBy: ".").last!
        
        let nib = bundle.loadNibNamed(nibName, owner: owner, options: nil)!
        
        for item in nib {
            if let item = item as? A {
                return item
            }
        }
        
        return nib.last as! A
    }
    
    func addBlureEffect(style: UIBlurEffect.Style)
    {
        addBlureEffect(style: style, tapGesture: nil)
    }
    
    func addBlureEffect(style: UIBlurEffect.Style, tapGesture: UITapGestureRecognizer?)
    {
        self.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.cornerRadius = self.cornerRadius
        if((tapGesture) != nil)
        {
            blurEffectView.isUserInteractionEnabled = true
            blurEffectView.addGestureRecognizer(tapGesture!)
        }
        self.insertSubview(blurEffectView, at: 0)
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func copyView() -> UIView?
    {
        return self.snapshotView(afterScreenUpdates: true)
    }
    
    func searchVisualEffectsSubview() -> UIVisualEffectView?
    {
        if let visualEffectView = self as? UIVisualEffectView
        {
            return visualEffectView
        }
        else
        {
            for subview in subviews
            {
                if let found = subview.searchVisualEffectsSubview()
                {
                    return found
                }
            }
        }
        
        return nil
    }
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.3,withTranslation translation : Float = 5) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIScrollView {
    func screenshot() -> UIImage? {
        // begin image context
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
        // save the orginal offset & frame
        let savedContentOffset = contentOffset
        let savedFrame = frame
        // end ctx, restore offset & frame before returning
        defer {
            UIGraphicsEndImageContext()
            contentOffset = savedContentOffset
            frame = savedFrame
        }
        // change the offset & frame so as to include all content
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
}
