//
//  InventoryGraph.swift
//  SIMS
//
//  Created by Mohd Danish Khan  on 20/04/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import UIKit
import Charts
class InventoryGraph: UIViewController {
    
    @IBOutlet weak var basicBarChart: BasicBarChart!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var radarChartView: RadarChartView!
    @IBOutlet weak var horizontalChartView: HorizontalBarChartView!
    
    var numberOfNewEq = 0
    var numberOfGoodEq = 0
    var numberOfAvgEq = 0
    var numberOfBadEq = 0
    var numberOfNotWorkingEq = 0
    
    var months: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.processGraphData()
        
        //Hard coded data for Inventory Sells Graph
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        setChart(dataPoints: months, values: unitsSold)
    }
    
    func processGraphData() {
        let inventoryData = DataManager.dataManagerInstance.equipmentList
        
        inventoryData.forEach { (equipment) in
            switch (equipment.equipmentCondition) {
                case "New":
                    numberOfNewEq += 1
                    break;
                case "Good":
                    numberOfGoodEq += 1
                    break;
                case "Average":
                    numberOfAvgEq += 1
                    break;
                case "Bad":
                    numberOfBadEq += 1
                    break;
                case "Not Working":
                    numberOfNotWorkingEq += 1
                    break;
                default:
                    break;
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateDataEntries()
        basicBarChart.dataEntries = dataEntries
    }
    
    func getCountOfEquipmentforCondition(condition: Int) -> Int {
        var countOfEquip = 0
        switch (condition) {
            case 0:
                countOfEquip = numberOfNewEq
            break;
            case 1:
                countOfEquip = numberOfGoodEq
            break;
            case 2:
                countOfEquip = numberOfAvgEq
            break;
            case 3:
                countOfEquip = numberOfBadEq
            break;
            case 4:
                countOfEquip = numberOfNotWorkingEq
            break;
            default:
            break;
        }
        return countOfEquip
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        //Dummy chart entires...
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        let radarChartDataSet = RadarChartDataSet(values: dataEntries, label: "Units Sold")
        let radarChartData = RadarChartData(dataSet: radarChartDataSet)
        
        radarChartView.data = radarChartData
        radarChartDataSet.colors = [ #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1) ]
        
        //PIE CHART
        self.setPieChart()
        
        //BAR CHART
        self.setBarChart(dataPoints: months, values: values)
    }
    
    func setPieChart() {
        //-----_This is for pie chart --------//
        
        //Dummy chart entires...
        var dataEntries: [ChartDataEntry] = []
        var values = [60.0, 40.0]
        for i in 0..<2 {
            let dataEntry = ChartDataEntry(x: Double(i) , y: values[i])
            dataEntries.append(dataEntry)
        }
        
       
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Task Allocated/ Task Completed")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        let colors: [UIColor] = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)]
        pieChartDataSet.colors = colors
    }
    
    
    
    func setBarChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])

            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Sales Record")
         chartDataSet.colors = ChartColorTemplates.colorful()
        let chartData = BarChartData(dataSet: chartDataSet)

        
        horizontalChartView.data = chartData
        horizontalChartView.xAxis.labelPosition = .bottom
    }
    
    //--------- This is live bar chart linked with inventory data ----//
    func generateDataEntries() -> [BarEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [BarEntry] = []
        for i in 0..<5 {
            let value = self.getCountOfEquipmentforCondition(condition: i)
            let height: Float = Float(value) / 100.0
            
            var title = "";
            switch (i) {
                case 0:
                    title = "New"
                    break;
                case 1:
                    title = "Good"
                    break;
                case 2:
                    title = "Average"
                    break;
                case 3:
                    title = "Bad"
                    break;
                case 4:
                    title = "Not Working"
                    break;
            default:
                    break;
            }
            result.append(BarEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: title))
        }
        return result
    }
    
    
}
