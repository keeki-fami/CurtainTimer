//
//  WeekSetting.swift
//  TimerApp
//
//  Created by 桜田聖和 on 2025/07/23.
//

import SwiftUI
import SwiftData

struct WeekSetting:View{
    
    @State private var sundayTime = Date()
    @State private var mondayTime = Date()
    @State private var tuesdayTime = Date()
    @State private var wednesdayTime = Date()
    @State private var thursdayTime = Date()
    @State private var fridayTime = Date()
    @State private var saturdayTime = Date()
    
    let dayKey:[String] = ["Sunday",
                        "Monday",
                        "Tuesday",
                        "Wednesday",
                        "Thursday",
                        "Friday",
                        "Saturday"]
    
    var body:some View{
        NavigationStack{
            VStack(spacing: 20) {
                // ホイール形式の時刻ピッカー
                DatePicker("日曜日", selection: $sundayTime, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .frame(maxHeight: 150)
                
                DatePicker("月曜日", selection: $mondayTime, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .frame(maxHeight: 150)
                
                DatePicker("火曜日", selection: $tuesdayTime, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .frame(maxHeight: 150)
                
                DatePicker("水曜日", selection: $wednesdayTime, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .frame(maxHeight: 150)
                
                DatePicker("木曜日", selection: $thursdayTime, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .frame(maxHeight: 150)
                
                DatePicker("金曜日", selection: $fridayTime, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .frame(maxHeight: 150)
                
                DatePicker("土曜日", selection: $saturdayTime, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .frame(maxHeight: 150)
                
                Button(action:{
                    request()
                    saveDateTimer()
                },label:{
                    ZStack{
                        Rectangle()
                            .fill(.cyan)
                            .frame(width:200,height:75)
                        Text("送信する")
                            .foregroundColor(.white)
                    }
                })
                // 確認表示（例: 07:30）
                
                /*
                 Text("選択した時間: \(formattedTime(sundayTime))")
                 Text("選択した時間: \(formattedTime(mondayTime))")
                 Text("選択した時間: \(formattedTime(tuesdayTime))")
                 Text("選択した時間: \(formattedTime(wednesdayTime))")
                 Text("選択した時間: \(formattedTime(thursdayTime))")
                 Text("選択した時間: \(formattedTime(fridayTime))")
                 Text("選択した時間: \(formattedTime(saturdayTime))")
                 */
            }
            .padding()
            .onAppear(){
                setStatePropertyDate()
            }
            
        }
    }
    
    func saveDateTimer(){
        UserDefaults.standard.set(sundayTime,forKey:"Sunday")
        UserDefaults.standard.set(mondayTime,forKey:"Monday")
        UserDefaults.standard.set(tuesdayTime,forKey:"Tuesday")
        UserDefaults.standard.set(wednesdayTime,forKey:"Wednesday")
        UserDefaults.standard.set(thursdayTime,forKey:"Thursday")
        UserDefaults.standard.set(fridayTime,forKey:"Friday")
        UserDefaults.standard.set(saturdayTime,forKey:"Saturday")
    }
    
    func setStatePropertyDate(){
        for day in dayKey{
            if let temp = UserDefaults.standard.object(forKey: day),
               let date = temp as? Date{
                if day == "Sunday"{sundayTime = date}
                else if day == "Monday"{mondayTime = date}
                else if day == "Tuesday"{tuesdayTime = date}
                else if day == "Wednesday"{wednesdayTime = date}
                else if day == "Thursday"{thursdayTime = date}
                else if day == "Friday"{fridayTime = date}
                else if day == "Saturday"{saturdayTime = date}
                else{print("曜日が不明[setStateProperty()]")}
            }
        }
    }
    
    func formattedTime(_ Time:Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Time)
    }
    
    func request(){
        guard let url = URL(string:"http://192.168.4.1/set_timer")else{
            return
        }
        
        let json:[String:String] = [
            "mon":formattedTime(mondayTime),
            "tue":formattedTime(tuesdayTime),
            "wed":formattedTime(wednesdayTime),
            "thu":formattedTime(thursdayTime),
            "fri":formattedTime(fridayTime),
            "sat":formattedTime(saturdayTime),
            "sun":formattedTime(sundayTime)
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("data型にできませんでした")
            return
        }
        
        print("\(json)")
        
        //リクエスト
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("送信失敗: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTPステータス: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}
