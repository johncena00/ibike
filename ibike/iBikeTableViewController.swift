//
//  iBikeTableViewController.swift
//  ibike
//
//  Created by devilcry on 2016/7/29.
//  Copyright © 2016年 devilcry. All rights reserved.
//

import UIKit
import SwiftyJSON

class iBikeTableViewController: UITableViewController {
    
    let iBileURl = "http://ybjson01.youbike.com.tw:1002/gwjs.json"
    
    var ibikes = [ibike]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getLatestibikeInfo()
        
        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                
                //let sareaen = json["retVal"]["3001"]["sareaen"].stringValue
                
                //print(sareaen)
                
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    // we're OK to parse!
                    parse(json: json)
                }
            }
        }
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parse(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            
            print(title)
            //let obj = ["title": title, "body": body, "sigs": sigs]
            //petitions.append(obj)
        }
        
        //tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ibikes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        as! iBikeTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = ibikes[indexPath.row].name
        cell.locationLabel.text = ibikes[indexPath.row].location
        cell.rentLabel.text = ibikes[indexPath.row].rent
        cell.emptyLabel.text = ibikes[indexPath.row].empty

        return cell
    }
    
    func getLatestibikeInfo() {
        let requestURL = URLRequest(url: URL(string: iBileURl)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: requestURL, completionHandler:
            { (data, response, error) -> Void in
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                // 解析JSON資料
                //self.ibikes = self.parseJsonData(data!)
                
                
                let json = JSON(data:data!)
                
                for item in json["retVal"].arrayValue {
                    print(item["ar"].stringValue)
                }
                
                // 重新載入表格
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            })
        task.resume()
    }
    
    func parseJsonData (_ data:Data) -> [ibike] {
        /*
        var ibikes = [ibike]()
        do {
            //JSON資料處理
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            let jsonBikes = jsonResult?["retVal"] as! NSDictionary
            
            //let lazyMapCollection = jsonBikes.allKeys
            //let stringArray = Array(lazyMapCollection)
            
            for i in jsonBikes.allKeys
            {
                let ibiketemp = ibike()
                let stringx  = String(describing: i)
                let jsonBike = jsonBikes[stringx] as! NSDictionary
                
                ibiketemp.name = jsonBike["sna"] as! String
                ibiketemp.location = jsonBike["ar"] as! String
                ibiketemp.rent = jsonBike["sbi"] as! String
                ibiketemp.empty = jsonBike["bemp"] as! String
                ibiketemp.lat = jsonBike["lat"] as! String
                ibiketemp.lon = jsonBike["lng"] as! String
                ibiketemp.sarea = jsonBike["sarea"] as! String
                ibikes.append(ibiketemp)
            }
        } catch {
            print(error)
        }
        return ibikes
        
 */
        
        var ibikes = [ibike]()
        
        //let json = JSON(data: dataFromNetworking)
        
        
        return ibikes
    
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! MapViewController
                destinationController.ibikes = ibikes[indexPath.row]
            }
        }
    }
    
    @IBAction func homeScreen(_ segue:UIStoryboardSegue) {
    }

}
