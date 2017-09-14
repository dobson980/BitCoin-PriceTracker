//
//  ViewController.swift
//  BitCoin-PriceTracker
//
//  Created by Tom Dobson on 08/31/17.
//  Copyright © 2017 Dobson Studios. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var currencySelected = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
                label.textColor = .white
                label.text = currencyArray[row]
                label.textAlignment = NSTextAlignment.center
        
        
                return label
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("\(currencyArray[row]) selected")
        
        finalURL = baseURL + currencyArray[row]
        currencySelected = currencySymbolArray[row]
        
        getBitCoinData(url: finalURL)
        print(finalURL)
        
    }

//    //MARK: - Networking
//    /***************************************************************/
    
    func getBitCoinData(url: String) {
        
        Alamofire.request(url).responseJSON { response in
            
            
            if response.result.isSuccess {
                
                print("Got bitCoin Data")
                let bitCoinJson = JSON(response.result.value!)
                self.parseBitCoinData(json: bitCoinJson)
                
            } else {
                
                print("The was a problem connecting to the server")
                
            }
            
            
        }
        
    }
    
//    //MARK: - JSON Parsing
//    /***************************************************************/

    func parseBitCoinData (json: JSON) {
        
        print("Parsing JSON")
        //print(json)
        
        if let askingPrice = json["ask"].double {
            
            bitcoinPriceLabel.text = "\(currencySelected)\(askingPrice)"
            
        } else {
            
            bitcoinPriceLabel.text = "Unavail."
            
        }
        
    }
    
}

