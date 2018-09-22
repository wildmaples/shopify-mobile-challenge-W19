//
//  ViewController.swift
//  TagsAndProductList
//
//  Created by maple peijune on 2018-09-18.
//  Copyright © 2018 maple peijune. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tagListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tagListTableView.delegate = self
        tagListTableView.dataSource = self
        tagListTableView.cellLayoutMarginsFollowReadableWidth = false

        self.getData2()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // For tag tableview, load cells
        if tableView == self.tagListTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagListTableViewCell
            let tagsList = Array(self.tagsDictionary.keys)
            let tags = tagsList[indexPath.row]
            
            cell.backgroundColor = .white
            cell.tagLabel.textColor = .black
            cell.tagLabel.text = tags
            
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tagsList = Array(self.tagsDictionary.keys)
        return tagsList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SeeProductsForTag", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeProductsForTag" {
            if let indexPath = self.tagListTableView.indexPathForSelectedRow {
                let controller = segue.destination as! ProductsViewController
                let tagsList = Array(self.tagsDictionary.keys)
                let tag = tagsList[indexPath.row]
                let productList = tagsDictionary[tag]
                controller.products = productList!
            }
        }
    }
    
    private func getData2() {
        guard let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                // Start parsing JsonArray here
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                
                // Now Check first type
                // Collect productList of dict
                guard let productsListofDict = jsonArray["products"] as? [[String:Any]], let _ = productsListofDict[0]["product_type"] as? String else { return }
                self.createProductObjectsAndShow(products: productsListofDict)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    var products = [Product]()
    private func createProductObjectsAndShow(products: [[String:Any]]) {
        for product in products {
            let newProduct = Product(product)
            self.products.append(newProduct)
        }
        createTagDictionary(self.products)
        DispatchQueue.main.async {
            self.tagListTableView.reloadData()
        }
    }
    
    var tagsDictionary = [String:[Product]]()
    private func createTagDictionary(_ products: [Product]) {
        for product in products {
            for tag in product.tags {
                var existingProd = tagsDictionary[tag] ?? [Product]()
                existingProd.append(product)
                tagsDictionary[tag] = existingProd
            }
        }
        print(tagsDictionary)
    }
}

