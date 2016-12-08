//: Playground - noun: a place where people can play

import UIKit
import SnapKit
import PlaygroundSupport
import XCPlayground

var str = "Hello, playground"



class LocationView: UIView {
    var scrollView: UIScrollView!
    var streetView: UIView!
    var locationProfileImage: UIView!
    var locationNameLabel: UILabel!
    var locationAddressLabel: UILabel!

    
    func configure() {
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
        
        backgroundColor = UIColor.blue

        streetView = UIView()
        streetView.backgroundColor = UIColor.cyan

        locationProfileImage = UIView()
        locationProfileImage.backgroundColor = UIColor.magenta
        locationProfileImage.layer.cornerRadius = 10
        
        locationNameLabel = UILabel()
        locationNameLabel.text = "American Playground"
        locationNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        locationNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        locationNameLabel.numberOfLines = 2

        locationAddressLabel = UILabel()
        locationAddressLabel.text = "123 Main Street btw Dog and Child"
        locationAddressLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        locationAddressLabel.numberOfLines = 0
        locationAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
    }
    
    func constrain() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        scrollView.addSubview(streetView)
        streetView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.top)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(streetView.snp.width).multipliedBy(0.6)
        }
        
        scrollView.addSubview(locationProfileImage)
        locationProfileImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalTo(streetView.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalTo(locationProfileImage.snp.width)
        }
        
        scrollView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(10)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.top.equalTo(streetView.snp.bottom).offset(12)
            $0.height.equalTo(locationProfileImage).dividedBy(2)
            $0.width.equalToSuperview().multipliedBy(0.66)
        }
        
//        scrollView.addSubview(locationAddressLabel)
//        locationAddressLabel.snp.makeConstraints {
//            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(5)
//            $0.trailing.equalToSuperview()
//            $0.top.equalTo(locationNameLabel.snp.bottom).offset(10)
//            $0.height.equalTo(locationProfileImage).multipliedBy(0.66)
//        }
        
        
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
