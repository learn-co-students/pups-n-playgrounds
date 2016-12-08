//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

import UIKit
import SnapKit
import PlaygroundSupport
import XCPlayground
/*
public final class StarReview: UIControl {
    public var starCount:Int = 5{ //可以用来打分的星星的数量
        didSet{
            maxmunValue = Float(starCount) //再设最大值
            setNeedsDisplay()
        }
    }
    public var starFillColor:UIColor = UIColor.blue{ //星星的填充颜色
        didSet{
            setNeedsDisplay()
        }
    }
    public var starBackgroundColor:UIColor = UIColor.gray{
        didSet{
            setNeedsDisplay()
        }
    }
    public var allowEdit:Bool = true
    public var allowAccruteStars:Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }
    public    var starMarginScale:Float = 0.3{
        didSet{
            if starMarginScale > 0.9
            {
                starMarginScale = 0.9
            }
            if starMarginScale < 0.1{
                starMarginScale = 0.1
            }
            setNeedsDisplay()
        }
    }
    public var value:Float {
        get{
            if allowAccruteStars{
                let index = getStarIndex()
                if index.0 != -1{  //如果是在星上
                    let a = Float((1 + starMarginScale) * Float(starRadius) * (Float(index.0) - 1)) //按下的那颗星开始的坐标点
                    return  (Float(starPixelValue * (1 + starMarginScale) * starRadius) - a) / Float(starRadius) + Float(index.0) - 1
                }
                else{ //如果不在星上
                    return Float(index.1 + 1)
                }
                
            }
            else{
                return starPixelValue
            }
        }
        set{
            if newValue > Float(starCount){
                starPixelValue  = Float(starCount)
            }
            else  if newValue < 0{
                starPixelValue  = 0
            }
            else{
                if allowAccruteStars{
                    //starValue  = CGFloat(newValue - 0.08) //这样不精确 需要将值进行转化,虽然这两者很相近,想并不相等
                    //先取出整数部分
                    let intPart = Int(newValue)
                    //取出小数部分
                    let floatPart = newValue - Float(intPart)
                    //转化成坐标点
                    let x = (1 + starMarginScale) * starRadius * Float(intPart) + starRadius * Float(floatPart)
                    //坐标转化成 starValue
                    starPixelValue = x / starRadius / (1 + starMarginScale)
                }
                else{
                    starPixelValue = Float(lroundf(newValue))
                }
            }
            
        }
    }
    public var maxmunValue:Float = 5{
        didSet{
            setNeedsDisplay()
        }
    }
    public  var minimunValue:Float = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    fileprivate var starRadius:Float = 0.0; //表示Star的大小,其实也就是半径
    fileprivate weak var target:AnyObject?
    fileprivate var selector:Selector?
    fileprivate var event:UIControlEvents?
    
    fileprivate var offsetX:Float{
        get{
            //    return ratio > startReviewWidthScale ? Float(self.frame.width) / 2 - startReviewWidthScale / 2 * Float(self.frame.height) + Float(layer.borderWidth) : Float(layer.borderWidth)  //左边的空白处
            return ratio > startReviewWidthScale ? Float(self.frame.width) / 2 - startReviewWidthScale / 2 * Float(self.frame.height)  : 0.0  //左边的空白处
        }
    }
    
    fileprivate var offsetY:Float{
        get{
            return ratio < startReviewWidthScale ? (Float(self.frame.height)  - starRadius) / 2 : 0.0  //上面的空白处
        }
    }
    
    fileprivate var ratio:Float{ //长宽比
        get{
            return Float(self.frame.width) / Float(self.frame.height)
        }
    }
    fileprivate var startReviewWidthScale:Float{  //这个是5个星星们的长宽比.
        get {
            return Float(starCount) + Float((starCount - 1)) * starMarginScale
        }
    }
    
    fileprivate var starPixelValue:Float = 0.0{
        didSet{
            if starPixelValue > Float(starCount){
                starPixelValue = Float(starCount)
            }
            if starPixelValue < 0{
                starPixelValue = 0
            }
            setNeedsDisplay()
            if target != nil && event != nil{
                if event == UIControlEvents.valueChanged{
                    self.sendAction(selector!, to: target, for: nil)
                }
            }
            
        }
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        starRadius = Float(self.frame.size.height) - Float(layer.borderWidth * 2)
        if ratio < startReviewWidthScale{
            starRadius = Float(self.frame.width) / startReviewWidthScale - Float(layer.borderWidth * 2)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        starRadius = Float(self.frame.size.height) - Float(layer.borderWidth * 2)
        if ratio < startReviewWidthScale{
            starRadius = Float(self.frame.width) / startReviewWidthScale - Float(layer.borderWidth * 2)
        }
    }
    override public func draw(_ rect: CGRect) {
        //对于View的尺寸是有要求的,如果过长,那么5颗星排起来也排不满整个长度,如果太高的话,那么又占不了整个高度,如果一个星是正文形,长宽都是1的话,那么总长宽比可以是
        //所以可以计算一下应该取多少
        clipsToBounds = false
        starRadius = Float(self.frame.size.height) - Float(layer.borderWidth * 2)
        if ratio < startReviewWidthScale{
            starRadius = Float(self.frame.width) / startReviewWidthScale - Float(layer.borderWidth * 2)
        }
        //        print("startReviewWidthScale\(startReviewWidthScale)")
        //        print("offsetX:\(offsetX)")
        //        print("offsetY:\(offsetY)")
        let ctx = UIGraphicsGetCurrentContext()
        for s in 0...(starCount-1){
            let x = starMarginScale * Float(s) * starRadius + starRadius * (0.5 + Float(s))
            var starCenter = CGPoint(x: CGFloat(x), y: (self.frame.height) / 2) //第个星的中心
            if ratio > startReviewWidthScale{
                starCenter = CGPoint(x: CGFloat(x)+CGFloat(offsetX), y: self.frame.height / 2)
            }
            //print("第\(s)个星的中心x:\(starCenter.x) y:\(starCenter.y)")
            let radius = starRadius / 2 //半径
            //print("星圆的半径:\(radius)")
            let p1 = CGPoint(x: starCenter.x, y: starCenter.y - CGFloat(radius)) //
            
            ctx?.setFillColor(starBackgroundColor.cgColor)
            ctx?.setStrokeColor(starBackgroundColor.cgColor)
            ctx?.setLineCap(CGLineCap.butt)
            ctx?.move(to: CGPoint(x: p1.x, y: p1.y))
            let angle = Float(4 * M_PI / 5)
            for i in 1...5{
                let x = Float(starCenter.x) - sinf(angle * Float(i)) * Float(radius)
                let y = Float(starCenter.y) - cosf(angle * Float(i)) * Float(radius)
                ctx?.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
            ctx?.drawPath(using: CGPathDrawingMode.fillStroke)
        }
        ctx?.setFillColor(starFillColor.cgColor)
        ctx?.setBlendMode(CGBlendMode.sourceIn)
        //        print(offsetX)
        //        print(level)
        //        print(starValue)
        //        print(starValue * starLength * ( 1 + gapStarLengthScale))
        //        print(starLength)
        //        print(gapStarLengthScale * starLength)
        let temp = starRadius * ( 1 + starMarginScale) * starPixelValue
        ctx?.fill(CGRect(x: CGFloat(offsetX), y: CGFloat(offsetY), width: CGFloat(temp), height: CGFloat(starRadius)))
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch:UITouch = touches.first{
            let point = touch.location(in: self)
            let temp = (Float(point.x) - offsetX) / (starRadius * ( 1 + starMarginScale))
            if allowAccruteStars{
                starPixelValue = temp
            }
            else{
                starPixelValue = Float(Int(temp) + 1)
            }
            // print("starPicelValue:\(starPixelValue)")
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !allowEdit
        {
            return
        }
        if let touch:UITouch = touches.first{
            let point = touch.location(in: self)
            let temp = (Float(point.x) - offsetX) / (starRadius * ( 1 + starMarginScale))
            if allowAccruteStars{
                starPixelValue = temp
            }
            else{
                starPixelValue = Float(Int(temp) + 1)
            }
            // print("starPicelValue:\(starPixelValue)")
        }
    }
    override public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        self.target = target as AnyObject?
        self.selector = action
        self.event = controlEvents
    }
    
    fileprivate func getStarIndex()->(Int,Int){  //判断坐标在第几个星上,如果不在星上,返回在第几个间隙上
        let i = Int(starPixelValue)
        if  starPixelValue - Float(i) <= 1 / (1 + starMarginScale)
        {
            return (i + 1,-1)
        }
        else{
            return (-1, i)
        }
    }
}
*/
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


class Playground {
    
    let playgroundID: String
    let name: String
    let address: String
    var isHandicap = "false"
    let latitude: Double
    let longitude: Double
//    var profileImage: UIImage = #imageLiteral(resourceName: "playgroundTemplate")
    var reviewsID = [String?]()
    var photos = [UIImage?]()
    var isFlagged = "false"
    var rating = String(1)
    
    
    init(ID: String, name: String, address: String, isHandicap: String, latitude: Double, longitude: Double, reviewsID: [String?], photos: [UIImage?], isFlagged: String) {
        self.playgroundID = ID
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.reviewsID = reviewsID
        self.photos = photos
        self.isFlagged = isFlagged
        self.isHandicap = isHandicap
    }
    
}


class LocationProfileView: UIView {
    
    let location = Playground(ID: "1234567890", name: "This is a really long playground name", address: "123 Main St", isHandicap: "no", latitude: 0.0, longitude: 0.0, reviewsID: [], photos: [], isFlagged: "false")
    
    var locationProfileImage: UIView!
    var locationNameLabel: UILabel!
    var locationAddressLabel: UILabel!
    var submitReviewButton: UIButton!
    var scrollView: UIScrollView!
    
    func configure() {
        
        backgroundColor = UIColor.themeLightBlue

        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: 375, height: 1000)
        
        locationProfileImage = UIView()
        locationProfileImage.backgroundColor = UIColor.white
        locationProfileImage.layer.cornerRadius = 20
        locationProfileImage.clipsToBounds = true
        
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
        locationAddressLabel.text = location.address
        locationAddressLabel.numberOfLines = 3
        locationAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        submitReviewButton = UIButton()
        submitReviewButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        submitReviewButton.setTitle("Review This Location", for: .normal)
        submitReviewButton.titleLabel?.font = UIFont.themeSmallBold
        submitReviewButton.setTitleColor(UIColor.themeWhite, for: .normal)
        submitReviewButton.layer.cornerRadius = 4
        submitReviewButton.layer.borderWidth = 2
        submitReviewButton.layer.borderColor = UIColor.themeWhite.cgColor
        
    }
    
    func constrain() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        /*
        scrollView.addSubview(locationProfileImage)
        locationProfileImage.snp.makeConstraints {
            $0.leadingMargin.equalTo(scrollView.snp.leading).offset(20)
            $0.topMargin.equalTo(scrollView.snp.top).offset(20)
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(locationProfileImage.snp.width)
        }
        
        scrollView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(5)
            $0.width.equalToSuperview()
            $0.topMargin.equalTo(locationProfileImage.snp.top).offset(10)

        }
        
        addSubview(locationAddressLabel)
        locationAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(5)
            $0.height.equalTo(locationNameLabel.snp.height).dividedBy(2)
        }
        addSubview(submitReviewButton)
        submitReviewButton.snp.makeConstraints {
            $0.leading.equalTo(locationProfileImage.snp.trailing).offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalTo(locationProfileImage.snp.bottom)
        }
        */
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


class LocationProfileViewController: UIViewController {
    
    var locationProfileView: LocationProfileView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configure() {
        
        self.view.addSubview(locationProfileView)
        locationProfileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
var locationView = LocationProfileView()
let container = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))

container.addSubview(locationView)
container.bringSubview(toFront: locationView)

var VC = LocationProfileViewController()

PlaygroundPage.current.liveView = container

PlaygroundPage.current.needsIndefiniteExecution = true


//XCPlaygroundPage.currentPage.liveView = locationView

