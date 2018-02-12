//
//  ViewController.swift
//  SimpleWeather
//
//  Created by James Yoo on 2018-02-10.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private static let weatherQueryString = "https://api.openweathermap.org/data/2.5/weather?q={CITY},ca?&units=metric&APPID=29fcb86c6d19d850226cce991fa6985e"
    private var defaultCity = "Coquitlam"
    private var userSelectedCity:String = "Coquitlam"

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var cityTextInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather(selectedCity: defaultCity)
        cityTextInput.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // TEXT FIELD BEHAVIOR
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextInput.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        userSelectedCity = sanitizeInput(selectedCity: textField.text!)
        getWeather(selectedCity: userSelectedCity)
    }
    
    func sanitizeInput(selectedCity: String) -> String {
        let cleanedCity = selectedCity.trimmingCharacters(in: .whitespaces)
        return cleanedCity
    }

    @IBAction func weatherButtonTapped(_ sender: UIButton) {
        if userSelectedCity == defaultCity {
            getWeather(selectedCity: defaultCity);
        } else {
            getWeather(selectedCity: userSelectedCity)
        }
    }
    
    // Touching anything other than keyboard cancels input
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func getConditions(_ jsonObj: NSDictionary?) {
        if let weatherDict = jsonObj?.object(forKey: "weather") as? NSArray {
            if let condition = weatherDict[0] as? NSDictionary {
                DispatchQueue.main.async {
                    self.setConditionText(conditionArray: condition)
                }
            }
        }
    }
    
    fileprivate func setConditionText(conditionArray: NSDictionary) {
        let currentCondition = conditionArray.value(forKey: "main") as! String
        self.conditionsLabel.text = "\(String(describing: currentCondition))"
    }
    
    func getWeather(selectedCity: String) {
        
        let session = URLSession.shared;
        let queryString = ViewController.weatherQueryString.replacingOccurrences(of: "{CITY}", with: userSelectedCity)
        let weatherURL = URL(string: queryString)
        
        let dataTask = session.dataTask(with: weatherURL!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print("Data error:\n\(error)")
            } else {
                if let data = data {
                    
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                    print("Weather data:\n\(dataString!)")
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        
                        self.getConditions(jsonObj)
                        
                        if let mainDictionary = jsonObj!.object(forKey: "main") as? NSDictionary {
                            if let temperature = mainDictionary.value(forKey: "temp") {
                                DispatchQueue.main.async {
                                    self.weatherLabel.text = selectedCity + " Temperature: \(temperature)°c"
                                }
                            }
                        }
                        
                        else {
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
