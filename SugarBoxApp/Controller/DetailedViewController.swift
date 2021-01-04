//
//  DetailedViewController.swift
//  SugarBoxApp
//
//  Created by Sanjay Mali on 04/01/21.
//

import UIKit
import SDWebImage
class DetailedViewController: UIViewController {
    var restoData:RestaurantData?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblratings: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblVotes: UILabel!
    @IBOutlet weak var lblRating: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
    }
    func displayData(){
        guard let featuredImage = restoData?.featured_image, featuredImage.count > 0 else {
            imgImage.image = UIImage(named: "ImgPlacholder")
            return
        }
        var resImageURL = featuredImage.components(separatedBy: "?")[0]
        if let params = ("fit=around|200:200&crop=\(imgImage.frame.size.width*2):\(imgImage.frame.size.height*2)").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), params.count > 0 {
            resImageURL = "\(resImageURL)?\(params)"
        }
        imgImage.sd_setImage(with: URL(string:resImageURL ), placeholderImage: UIImage(named: "ImgPlaceholder"), options: .continueInBackground) { [self] (image, error, type, url) in
            if let img = image {
               imgImage.image = img
            }
        }
        lblName.text = restoData?.name
        lblAddress.text = restoData?.cuisines
        self.lblRating.text = " Ratings : \(restoData?.user_rating?.rating_text ?? "0.0")"
        self.lblRating.textColor = UIColor.init(named:(self.restoData?.user_rating!.rating_color)!)
        
    }
}
