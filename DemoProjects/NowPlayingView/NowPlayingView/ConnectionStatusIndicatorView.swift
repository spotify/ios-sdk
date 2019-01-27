import UIKit

/// Connection status view
class ConnectionStatusIndicatorView : UIView {
    
    enum State {
        case disconnected
        case connecting
        case connected
    }
    
    var state: State = .disconnected {
        didSet {
            self.setNeedsDisplay()
            if state == .connecting {
                if displayLink == nil {
                    displayLink = CADisplayLink(target: self, selector: #selector(setNeedsDisplayProxy(_:)))
                }
                displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
            } else {
                displayLink?.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
                displayLink = nil;
            }
        }
    }
    
    var displayLink: CADisplayLink?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.clearsContextBeforeDrawing = true;
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let size = self.bounds.size
        let path = CGMutablePath()
        
        path.__addRoundedRect(transform: nil, rect: self.bounds, cornerWidth: size.width/2, cornerHeight: size.height/2)
        context.addPath(path)
        
        context.setFillColor(fillColor())
        context.fillPath()
    }
    
    fileprivate func timebasedValue() -> CGFloat {
        return CGFloat(abs(sin(Date().timeIntervalSinceReferenceDate*4)))
    }
    
    fileprivate func fillColor() -> CGColor {
        switch state {
        case .disconnected:
            return UIColor.red.cgColor
        case .connecting:
            return UIColor.orange.withAlphaComponent(0.5+timebasedValue()*0.3).cgColor
        case .connected:
            return UIColor.green.cgColor
        }
    }

    // Needed because CADisplayLink(target:, selector:)
    // waits for selector method having signature `(void)selector:(CADisplayLink *)sender`
    // https://developer.apple.com/documentation/quartzcore/cadisplaylink/1621228-init
    @objc private func setNeedsDisplayProxy(_ sender: CADisplayLink) {
        setNeedsLayout()
    }
}
