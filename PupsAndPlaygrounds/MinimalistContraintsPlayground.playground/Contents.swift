//: Playground - noun: a place where people can play

import UIKit
import SnapKit
import PlaygroundSupport
import XCPlayground

var str = "Hello, playground"

class LocationView: UIView {
    var scrollView: UIScrollView!
    var streetView: UIView!

    
    func configure() {
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
        
        backgroundColor = UIColor.blue

        streetView = UIView()
        streetView.backgroundColor = UIColor.cyan

        
    }
    
    func constrain() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        addSubview(streetView)
        streetView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(scrollView)
            $0.height.equalTo(streetView.snp.width)
            
        }
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        configure()
        constrain()
    }
    
}


var locationView = LocationView()
let container = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))

container.addSubview(locationView)
container.bringSubview(toFront: locationView)

PlaygroundPage.current.liveView = container
