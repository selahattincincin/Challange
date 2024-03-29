//
//  RandomChartsViewController.swift
//  Challange
//
//  Created by Selahattin Cincin on 21.09.2019.
//  Copyright © 2019 Selahattin Cincin. All rights reserved.
//

import UIKit

class RandomChartsViewController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var curvedlineChart: LineChart!
    @IBOutlet weak var randomizeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0.3529411765, blue: 0.6156862745, alpha: 1)
        
        randomizeButton.layer.cornerRadius = 5
        randomizeButton.layer.shadowRadius = 2
        randomizeButton.layer.shadowOffset = .zero
        randomizeButton.layer.shadowOpacity = 0.2
        
    }
    @IBAction func tappedRandomize(_ sender: Any) {
        let dataEntries = generateRandomEntries()
        
        lineChart.dataEntries = dataEntries
        lineChart.isCurved = false
        
        curvedlineChart.dataEntries = dataEntries
        curvedlineChart.isCurved = true
    }
    
    private func generateRandomEntries() -> [PointEntry] {
        var result: [PointEntry] = []
        for i in 0..<100 {
            let value = Int(arc4random() % 500)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            
            result.append(PointEntry(value: value, label: formatter.string(from: date)))
        }
        return result
    }
}
   
