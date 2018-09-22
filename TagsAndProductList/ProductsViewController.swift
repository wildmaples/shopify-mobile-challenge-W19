//
//  ProductsViewController.swift
//  TagsAndProductList
//
//  Created by maple peijune on 2018-09-22.
//  Copyright © 2018 maple peijune. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var productListTableView: UITableView!
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productListTableView.delegate = self
        productListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.productListTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductListTableViewCell
            let product = products[indexPath.row]
            
            cell.backgroundColor = .white
            cell.productTitleLabel.text = product.title
            cell.vendorLabel.text = product.vendor
            product.countInventory()
            if let inventory = product.inventory {
                cell.productVariantCount.text = String(inventory)
            } else {
                cell.productVariantCount.text = "0"
            }
            cell.productTitleLabel.textColor = .black
            
            if let imageUrl = product.imageURL, let url = URL(string: imageUrl) {
                UIImage.downloadFromRemoteURL(url, completion:
                    { image, error in
                        guard let image = image, error == nil else {
                            return
                        }
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 15, width: 70, height: 70))
                        imageView.image = image
                        imageView.contentMode = .scaleAspectFit
                        cell.productImage = imageView
                        cell.contentView.addSubview(cell.productImage!)
                    })
            }
            print(cell.productImage)
            return cell
        }
        return cell
    }
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        productListTableView.reloadData()
    }
    
    @IBAction func backToMainScreen(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    static func downloadFromRemoteURL(_ url: URL, completion: @escaping (UIImage?,Error?)->()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async{
                    completion(nil,error)
                }
                return
            }
            DispatchQueue.main.async() {
                completion(image,nil)
            }
            }.resume()
    }
}
