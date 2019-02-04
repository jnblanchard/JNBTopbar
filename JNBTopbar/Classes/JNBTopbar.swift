//
//  JNBTopbar.swift
//  JNBTopbar
//
//  Created by John N Blanchard on 2/3/19.
//  Copyright © 2019 John Norman Blanchard. All rights reserved.
//

public class JNBTopbar: NSObject {
  
  public static let shared = JNBTopbar()
  public var hitBoxSize = CGFloat(38)
  private var alertView: UIView? = nil
  private var innerAlertView: UIView? = nil
  
  private var showingViewController: UIViewController? = nil
  
  private var initialFrame: CGRect?
  
  override init() {
    super.init()
  }
  
  private func topViewController() -> UIViewController? {
    if showingViewController != nil {
      return showingViewController
    } else {
      return getTopViewController()
    }
  }
  
  private func getTopConstraint(from: UIViewController? = nil) -> NSLayoutConstraint? {
    guard let topVC = from ?? topViewController() else { return nil }
    return topVC.view?.constraints.first(where: { (temp) -> Bool in
      return (temp.firstAnchor == alertView?.topAnchor || temp.secondAnchor == alertView?.topAnchor) && (temp.firstAnchor == topVC.view.safeAreaLayoutGuide.topAnchor || temp.secondAnchor == topVC.view.safeAreaLayoutGuide.topAnchor) || (temp.firstAnchor == alertView?.topAnchor || temp.secondAnchor == alertView?.topAnchor) && (temp.firstAnchor == topVC.view.topAnchor || temp.secondAnchor == topVC.view.topAnchor)
    })
  }
  
  private func getHeightConstraint() -> NSLayoutConstraint? {
    guard let topVC = topViewController() else { return nil }
    return topVC.view?.constraints.first(where: { (temp) -> Bool in
      return temp.firstAnchor == alertView?.heightAnchor || temp.secondAnchor == alertView?.heightAnchor
    })
  }
  
  private func getTopViewController() -> UIViewController? {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      return topController
    }
    return nil
  }
  
  @objc private func handle(pan: UIPanGestureRecognizer) {
    guard let alert = alertView else { return }
    guard let topvc = topViewController() else { return }
    guard let topConstraint = getTopConstraint() else { return }
    let location = pan.location(in: topvc.view)
    guard abs(location.y - alert.frame.origin.y) < hitBoxSize else { return }
    
    func adjust() {
      guard location.y > topvc.view.frame.height - alert.frame.height else { return }
      alert.frame.origin = CGPoint(x: alert.frame.origin.x, y: location.y)
      UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.5, options: .beginFromCurrentState, animations: {
        topvc.view.layoutSubviews()
      }, completion: { (completed) in
        guard completed else { return }
      })
    }
    
    func ended() {
      UIView.animate(withDuration: 1.25, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.5, options: .beginFromCurrentState, animations: {
        alert.frame = pan.location(in: topvc.view).y > topvc.view.frame.height - ((alert.frame.height+20)/2) ? CGRect(x: 0, y: topvc.view.frame.height+150, width: topvc.view.frame.width, height: alert.frame.height) : self.initialFrame ?? CGRect.zero
        topvc.view.layoutSubviews()
      }, completion: { (completed) in
        guard completed else { return }
      })
    }
    
    switch pan.state {
    case .began:
      initialFrame = alert.frame
      adjust()
    case .changed:
      adjust()
    case .cancelled, .failed:
      ended()
    case .ended:
      ended()
    case .possible:
      break
    }
  }
  
  public func show(text: String, detailImage: UIImage? = nil) {
    if detailImage == nil {
      let label = UILabel(frame: CGRect.zero)
      label.textAlignment = .center
      label.font = UIFont.systemFont(ofSize: 25)
      label.textColor = UIColor.white
      label.text = text
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.4
      showWith(contentView: label)
    } else {
      let label = UILabel(frame: CGRect.zero)
      label.textAlignment = .center
      label.font = UIFont.boldSystemFont(ofSize: 25)
      label.textColor = UIColor.white
      label.text = text
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.4
      
      let imageView = UIImageView(image: detailImage)
      imageView.contentMode = .scaleAspectFit
      
      let stackView = UIStackView(arrangedSubviews: [imageView, label])
      stackView.spacing = 10
      stackView.distribution = .fillProportionally
      stackView.alignment = .center
      stackView.axis = .horizontal
      
      imageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
      showWith(contentView: stackView, contentInset: UIEdgeInsets(top: 0, left: -16, bottom: 0, right: -16))
    }
  }
  
  private func hide(onCompletion: @escaping () -> ()) {
    guard let topVC = topViewController(), let alert = alertView, let top = getTopConstraint() else { return }
    top.constant = -alert.frame.height-50
    UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.75, options: .transitionCurlDown, animations: {
      topVC.view.layoutSubviews()
    }) { (completed) in
      guard completed else { return }
      alert.removeFromSuperview()
      onCompletion()
    }
  }
  
  public func hide(completion: ((Bool) -> ())? = nil) {
    hide { completion?(true) }
  }
  
  
  public func showWith(contentView: UIView? = nil,
                       height: CGFloat = 80,
                       contentBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.8),
                       cornerRadius: CGFloat = 0,
                       screenInsets:  UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                       contentInset: UIEdgeInsets = UIEdgeInsets(top: -5, left: -8, bottom: 0, right: -8),
                       shadowColor: CGColor = UIColor.clear.cgColor,
                       shadowOpacity: Float = 0,
                       shadowOffset: CGSize = CGSize.zero,
                       shadowRadius: CGFloat = 0,
                       borderWidth: CGFloat = 0,
                       borderColor: CGColor = UIColor.clear.cgColor,
                       topAnchor: NSLayoutYAxisAnchor? = nil,
                       completion: ((Bool) -> Void)? = nil ) {
    
    guard let topVC = topViewController() else { return }
    showingViewController = topVC
    
    func createSnackBar() {
      alertView = UIView(frame: CGRect(x: 0, y: -height-40, width: topVC.view.frame.size.width, height: height))
      alertView?.isUserInteractionEnabled = true
      alertView?.backgroundColor = contentBackgroundColor
      alertView?.translatesAutoresizingMaskIntoConstraints = false
      alertView?.clipsToBounds = true
      alertView?.layer.cornerRadius = cornerRadius
      alertView?.layer.masksToBounds = false
      alertView?.layer.shadowColor = shadowColor
      alertView?.layer.shadowOpacity = shadowOpacity
      alertView?.layer.shadowOffset = shadowOffset
      alertView?.layer.shadowRadius = shadowRadius
      alertView?.layer.borderWidth = borderWidth
      alertView?.layer.borderColor = borderColor
      topVC.view.addSubview(alertView!)
      let pgr = UIPanGestureRecognizer(target: self, action: #selector(handle(pan:)))
      alertView?.addGestureRecognizer(pgr)
      alertView?.leadingAnchor.constraint(equalTo: topVC.view.leadingAnchor, constant: screenInsets.left).isActive = true
      alertView?.trailingAnchor.constraint(equalTo: topVC.view.trailingAnchor, constant: screenInsets.right).isActive = true
      alertView?.heightAnchor.constraint(equalToConstant: height).isActive = true
      alertView?.topAnchor.constraint(equalTo: topAnchor ?? topVC.view.safeAreaLayoutGuide.topAnchor, constant: screenInsets.top).isActive = true
      if let tempView = contentView {
        for tempView in alertView?.subviews ?? [] {
          tempView.removeFromSuperview()
        }
        alertView?.layoutSubviews()
        innerAlertView = tempView
        tempView.translatesAutoresizingMaskIntoConstraints = false
        alertView?.addSubview(tempView)
        tempView.leadingAnchor.constraint(equalTo: alertView!.leadingAnchor, constant: (-1)*contentInset.left).isActive = true
        tempView.topAnchor.constraint(equalTo: alertView!.topAnchor, constant: (-1)*contentInset.top).isActive = true
        tempView.trailingAnchor.constraint(equalTo: alertView!.trailingAnchor, constant: contentInset.right).isActive = true
        tempView.bottomAnchor.constraint(equalTo: alertView!.bottomAnchor, constant: (-1)*contentInset.bottom).isActive = true
      }
      UIView.animate(withDuration: 1.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .transitionCurlUp, animations: {
        topVC.view.layoutSubviews()
      }) { (completed) in
        completion?(completed)
      }
    }
    
    if alertView == nil {
      createSnackBar()
    } else {
      guard let _ = getTopConstraint() else {
        createSnackBar()
        return
      }
      // would like to have reuse optimization for showing the same view over
      // unless fall back on this hide call and remake the snackbar.
      hide(onCompletion: createSnackBar)
    }
  }
}

