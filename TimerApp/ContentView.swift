//
//  ContentView.swift
//  TimerApp
//
//  Created by 桜田聖和 on 2025/07/22.
//

import SwiftUI

struct ContentView: View {
    @State var date = Date()
    @AppStorage("Sunday") var sundayTimer:Date?
    @AppStorage("Monday") var mondayTimer:Date?
    @AppStorage("Tuesday") var tuesdayTimer:Date?
    @AppStorage("Wednesday") var wednesdayTimer:Date?
    @AppStorage("Thursday") var thursdayTimer:Date?
    @AppStorage("Friday") var fridayTimer:Date?
    @AppStorage("Saturday") var saturdayTimer:Date?
    
    var body: some View {
        NavigationStack{
            VStack{
                TabView{
                    WeekSetting()
                        .tabItem {
                            Image("globe")
                            Text("全体の設定")
                        }
                    TodayTimer()
                        .tabItem {
                            Image("globe")
                            Text("今日の設定")
                        }
                }
            }
            .toolbar{
                ToolbarItem(placement:.principal){
                    VStack{
                        Text("今日の日付")
                        Text("\(dateFormatter(date))")
                    }
                }
            }
        }
    }
    
    func dateFormatter(_ date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "dMMMEEE",
            options: 0,
            locale: Locale(identifier: "ja_JP")
        )
        
        return formatter.string(from:date)
        
    }
}
