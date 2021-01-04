//
//  HomeViewController.swift
//  SugarBoxApp
//
//  Created by Sanjay Mali on 31/12/20.
//

import UIKit
import SDWebImage
class HomeViewController: UITableViewController {
    private var arrRestaurants: [RestaurantData] = [RestaurantData]()
    private var viewModel: RestaurantListViewModel = RestaurantListViewModel()
    
    var currentRecord = 1
    var lastLatValue = 19.076090
    var lastLngValue = 72.877426
    var isLoadingData = false
    
    var dictLocalCacheImages = [String : UIImage?]()
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonWidth = CGFloat(30)
        let buttonHeight = CGFloat(30)
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "vector_smart_object"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        
        let buttonWidth1 = CGFloat(30)
        let buttonHeight1 = CGFloat(30)
        
        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage(named: "noun_location_1547089"), for: .normal)
        button1.setTitle("Mumbai", for: .normal)
        button1.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button1.widthAnchor.constraint(equalToConstant: buttonWidth1).isActive = true
        button1.heightAnchor.constraint(equalToConstant: buttonHeight1).isActive = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button1)
        viewModel.restaurantListDelegate = self
        self.tableView.rowHeight = 200
        fetchRestaurantsData(isFresh:false)
        
    }
    @objc func buttonTapped(sender:UIButton){
        
    }
    //Fetch Restuarants from APIs
    func fetchRestaurantsData(isFresh: Bool) {
        self.isLoadingData = true
        let reqParams = String(format: "lat=%.3f&lon=%.3f&entity_type=city&start=%d&count=20", self.lastLatValue, self.lastLngValue, self.currentRecord)
        self.viewModel.fetchNewRestaurantData(params: reqParams, isFreshDataRequired: isFresh)
    }
}

extension HomeViewController: RestaurantViewModelDelegate {
    
    func didReceiveRestaurantData(restaurants: [RestaurantData], isFreshData: Bool, success: Bool, error: String?) {
        self.isLoadingData = false
        if success {
            if isFreshData {
                self.arrRestaurants = restaurants
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
            else {
                var indexPaths = [IndexPath]()
                let currentCount = self.arrRestaurants.count
                
                for i in 0..<restaurants.count {
                    self.arrRestaurants.append(restaurants[i])
                    indexPaths.append(IndexPath(item: currentCount + i, section: 0))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    self.tableView.endUpdates()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
        else {
            print("Error ===> \(error ?? "")")
        }
    }
}
//MARK: Table View Methods

extension HomeViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objRestaurant = self.arrRestaurants[indexPath.row]
        performSegue(withIdentifier:"DetailedVC", sender:nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRestaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objRestaurant = self.arrRestaurants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        cell.configureCell(restaurant: objRestaurant)
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //Load Image
        if let resCell = cell as? RestaurantCell {
        
            let objRestaurant = self.arrRestaurants[indexPath.row]
            guard let featuredImage = objRestaurant.featured_image, featuredImage.count > 0 else {
                resCell.imgImage.image = UIImage(named: "ImgPlacholder")
                return
            }
            
            var resImageURL = featuredImage.components(separatedBy: "?")[0]
            if let params = ("fit=around|200:200&crop=\(resCell.frame.size.width*2):\(resCell.frame.size.height*2)").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), params.count > 0 {
                resImageURL = "\(resImageURL)?\(params)"
            }
            
            resCell.imgImage.sd_setImage(with: URL(string: resImageURL), placeholderImage: UIImage(named: "ImgPlaceholder"), options: .continueInBackground) { (image, error, type, url) in
                
                if let img = image {
                    resCell.imgImage.image = img
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailedVC"{
            guard let selectedPath = tableView.indexPathForSelectedRow else { return }
            let vc  = segue.destination as! DetailedViewController
            vc.restoData = self.arrRestaurants[selectedPath.row]
        }
     }
  }
