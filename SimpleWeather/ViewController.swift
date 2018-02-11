//
//  ViewController.swift
//  SimpleWeather
//
//  Created by James Yoo on 2018-02-10.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private static let getWeatherString = "https://api.openweathermap.org/data/2.5/weather?q=London,uk?&units=metric&APPID=29fcb86c6d19d850226cce991fa6985e"
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var conditionsLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func weatherButtonTapped(_ sender: UIButton) {
        getWeather()
    }
    
    func getWeather() {
        
        let session = URLSession.shared;
        let weatherURL = URL(string: ViewController.getWeatherString)
        
        let dataTask = session.dataTask(with: weatherURL!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print("Error:\n\(error)")
            } else {
                if let data = data {
                    
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                    print("All the weather data:\n\(dataString!)")
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        
                        if let weatherDict = jsonObj?.object(forKey: "weather") as? NSArray {
                            if let condition = weatherDict[0] as? NSDictionary {
                                DispatchQueue.main.async {
                                    let currentCondition = condition.value(forKey: "main") as! String
                                    self.conditionsLabel.text = "\(String(describing: currentCondition))"
                                }
                            }
                        }
                        
                        if let mainDictionary = jsonObj!.object(forKey: "main") as? NSDictionary {
                            if let temperature = mainDictionary.value(forKey: "temp") {
                                DispatchQueue.main.async {
                                    self.weatherLabel.text = "Vancouver Temperature: \(temperature)°c"
                                }
                            }
                        } else {
                            print("Error: unable to find temperature in dictionary")
                        }
                    } else {
                        print("Error: unable to convert json data")
                    }
                } else {
                    print("Error: did not receive data")
                }
            }
        }
        
        dataTask.resume()
    }
    
    
}
