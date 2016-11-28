//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import SnapKit


class Playground {
    
    let playgroundID: String
    let name: String
    let location: String
    var isHandicap: Bool = false
    let latitude: String
    let longitude: String
//    var profileImage: UIImage = #imageLiteral(resourceName: "playgroundTemplate.jpg")

    init(ID: String, name: String, location: String, handicap: String, latitude: String, longitude: String) {
        self.playgroundID = ID
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        
        if handicap == "Yes" {
            self.isHandicap = true
        }
    }

}

class LocationProfileView: UIView {
    
    var location: Playground!
    var locationProfileImage: UIImageView!
    var locationNameLabel: UILabel!
    var locationAddressLabel: UILabel!
    var submitButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(playground: Playground) {
        self.init(frame: CGRect.zero)
        location = playground
        configure()
        constrain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        backgroundColor = UIColor.themeLightBlue
        
        //image is color instead
        locationProfileImage = UIImageView()
        locationProfileImage.backgroundColor = UIColor.white
        locationProfileImage.layer.cornerRadius = 20
        
        locationNameLabel = UILabel()
        locationNameLabel.font = UIFont.themeMediumBold
        locationNameLabel.textColor = UIColor.themeDarkBlue
        locationNameLabel.text = location.name
        locationNameLabel.adjustsFontSizeToFitWidth = true
        locationNameLabel.numberOfLines = 2
        locationNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        
        locationAddressLabel = UILabel()
        locationAddressLabel.font = UIFont.themeSmallRegular
        locationAddressLabel.textColor = UIColor.themeDarkBlue
        locationAddressLabel.text = location.location
        
        submitButton = UIButton()
        submitButton.contentEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16)
        submitButton.setTitle("Review This Location", for: .normal)
        submitButton.titleLabel?.font = UIFont.themeSmallBold
        submitButton.setTitleColor(UIColor.themeWhite, for: .normal)
        submitButton.layer.cornerRadius = 20
        submitButton.layer.borderWidth = 2
        submitButton.layer.borderColor = UIColor.themeWhite.cgColor
        
    }
    
    func constrain() {
        addSubview(locationProfileImage)
        locationProfileImage.snp.makeConstraints {
            $0.leadingMargin.equalToSuperview().offset(10)
            $0.topMargin.equalToSuperview().offset(35)
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(locationProfileImage.snp.width)
        }
        
        addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.topMargin.equalTo(locationProfileImage.snp.top)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
        addSubview(locationAddressLabel)
        locationAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(10)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
        addSubview(submitButton)
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationProfileImage.snp.bottom).offset(10)
        }
    }
}

extension UIColor {
    public static let themeLightBlue = UIColor(red: 106 / 255, green: 138 / 255, blue: 166 / 255, alpha: 1)
    public static let themeMediumBlue = UIColor(red: 59 / 255, green: 75 / 255, blue: 89 / 255, alpha: 1)
    public static let themeDarkBlue = UIColor(red: 20 / 255, green: 31 / 255, blue: 38 / 255, alpha: 1)
    public static let themeWhite = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
    public static let themeRed = UIColor(red: 242 / 255, green: 82 / 255, blue: 68 / 255, alpha: 1)
}

extension UIFont {
    
    // Tiny Fonts
    public static let themeTinyThin = UIFont(name: "HelveticaNeue-Thin", size: 12)
    public static let themeTinyLight = UIFont(name: "HelveticaNeue-Light", size: 12)
    public static let themeTinyRegular = UIFont(name: "HelveticaNeue", size: 12)
    public static let themeTinyBold = UIFont(name: "HelveticaNeue-Bold", size: 12)
    
    // Small Fonts
    public static let themeSmallThin = UIFont(name: "HelveticaNeue-Thin", size: 16)
    public static let themeSmallLight = UIFont(name: "HelveticaNeue-Light", size: 16)
    public static let themeSmallRegular = UIFont(name: "HelveticaNeue", size: 16)
    public static let themeSmallBold = UIFont(name: "HelveticaNeue-Bold", size: 16)
    
    // Medium Fonts
    public static let themeMediumThin = UIFont(name: "HelveticaNeue-Thin", size: 24)
    public static let themeMediumLight = UIFont(name: "HelveticaNeue-Light", size: 24)
    public static let themeMediumRegular = UIFont(name: "HelveticaNeue", size: 24)
    public static let themeMediumBold = UIFont(name: "HelveticaNeue-Bold", size: 24)
    
    // Large Fonts
    public static let themeLargeThin = UIFont(name: "HelveticaNeue-Thin", size: 32)
    public static let themeLargeLight = UIFont(name: "HelveticaNeue-Light", size: 32)
    public static let themeLargeRegular = UIFont(name: "HelveticaNeue", size: 32)
    public static let themeLargeBold = UIFont(name: "HelveticaNeue-Bold", size: 32)
    
    // Oversize Fonts
    public static let themeOversizeThin = UIFont(name: "HelveticaNeue-Thin", size: 58)
    public static let themeOversizeLight = UIFont(name: "HelveticaNeue-Light", size: 58)
    public static let themeOversizeRegular = UIFont(name: "HelveticaNeue", size: 58)
    public static let themeOversizeBold = UIFont(name: "HelveticaNeue-Bold", size: 58)
}

class LocationProfileViewController: UIViewController {
    
    var playground: Playground = Playground(ID: "B001", name: "American Playground", location: "Noble, Franklin, Milton Sts", handicap: "N", latitude: "40.7288", longitude: "-73.9579")
    var locationProfileView: LocationProfileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationProfileView = LocationProfileView(playground: playground)
        view = locationProfileView
        
        navigationItem.title = "Location"
        navigationController?.isNavigationBarHidden = true
        
    }
}



var locationsVCPG = LocationProfileViewController()
XCPlaygroundPage.currentPage.liveView = locationsVCPG


