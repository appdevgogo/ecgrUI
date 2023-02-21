import SwiftUI

struct Filter : View {
    
    @Binding var logininfo : LogInInfo
    
    @Binding var filtershow : Bool
    @Binding var afcompletion : Bool
    @Binding var bfcompletion : Bool
    @Binding var afilterarray : [Int]
    @Binding var bfilterarray : [BFilterInfo]
    
    let chartype = ["DC콤보", "DC차데모", "AC단상", "AC3상"]
    
    var body : some View {
    
        VStack(alignment: .leading){
            
            HStack() {
                
                Button(action: {
                    
                    filtershow = false
                    afcompletion = false
                    bfcompletion = false
                    

                }) {
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.gray_t1)
                        .font(.system(size:22))
                }
                
                Spacer()
                
            }
            .padding(.top, 15)
            .padding(.horizontal, 15)
            
            if afcompletion == false || bfcompletion == false  {
                
                Spacer()
                
                HStack(){
                    
                    Spacer()
                    
                    if #available(iOS 14.0, *) {
                        
                        ProgressView()
                        
                    } else {
                        
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
                
            } else {
                
                HStack() {
                    
                    Text("OFF")
                        .font(.system(size:15))
                        .foregroundColor(afilterarray[0] == 1 ? .gray_t1 : .black)
                        .padding(.trailing, 5)
                    
                    Button(action: {
                            
                        if afilterarray[0] == 1 {
                        
                            getafilterInfo(dist: "remove", snsid: logininfo.snsid, appid: logininfo.appid, aidx: 0)
                            
                            print("토글 remove실행")


                        } else {

                            getafilterInfo(dist: "add", snsid: logininfo.snsid, appid: logininfo.appid, aidx: 0)
                            
                            print("토글 add실행")
                            
                        }

                    }) {
                        
                        HStack{
                            
                            if afilterarray[0] == 1 {
                                
                                Spacer()
                                
                            }
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .frame(width: 15, height: 15)
                                //.padding(.horizontal, 3)
                            
                            if afilterarray[0] == 0 {
                                
                                Spacer()
                                
                            }
                            
                        }.padding(.horizontal, 3)
                        
                        
                    }
                    .frame(width: 50, height: 20)
                    .background(afilterarray[0] == 1 ? Color.green : Color.gray_t1)
                    .cornerRadius(20)
                    .animation(.easeInOut(duration: 0))

                    Text("ON")
                        .font(.system(size:15))
                        .foregroundColor(afilterarray[0] == 1 ? .green : .gray_t1)
                        .padding(.leading, 5)
                        
                    Spacer()
                
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                
                HStack{
                    
                    Image(systemName: "checkmark.square")
                        .foregroundColor(afilterarray[1] == 0 ? .gray_t1 : .green)
                        .font(.system(size:22))
                    
                    
                    Button(action: {
                        
                        if afilterarray[1] == 1 {
                        
                            getafilterInfo(dist: "remove", snsid: logininfo.snsid, appid: logininfo.appid, aidx: 1)


                        } else if afilterarray[1] == 0 {

                            getafilterInfo(dist: "add", snsid: logininfo.snsid, appid: logininfo.appid, aidx: 1)
                            
                        }
                        
                    }) {
                        
                        Text("충전가능만표시")
                            .font(.system(size:18))
 
                    }
                    .foregroundColor(Color.black)
                    .animation(.easeInOut(duration: 0))
                    
                    
                    
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Divider()
                    .frame(height: 0.5)
                    .background(Color.gray_t0)
                    .padding(.top, 15)
                    .padding(.horizontal, 15)
                
                Text("충전기타입")
                    .foregroundColor(.gray_t3)
                    .font(.system(size:15))
                    .padding(.top, 15)
                    .padding(.horizontal, 20)
                
                ForEach(0..<chartype.count/2) { row in
                    
                    HStack {
                        
                        ForEach(0..<2) { column in
                            
                            
                            HStack{
                                
                                Image(systemName: "checkmark.square")
                                    .foregroundColor(afilterarray[row * 2 + column + 2] == 0 ? .gray_t1 : .green)
                                    .font(.system(size:22))
                                    .padding(.leading, column == 0 ? 20 : 0)
                                
                                Button(action: {
                                    
                                    if afilterarray[row * 2 + column + 2] == 0 {
                                        
                                        getafilterInfo(dist: "add", snsid: logininfo.snsid, appid: logininfo.appid, aidx: row * 2 + column + 2)
                                        
                                    } else {
                                        
                                        getafilterInfo(dist: "remove", snsid: logininfo.snsid, appid: logininfo.appid, aidx: row * 2 + column + 2)
                                        
                                    }
                                    
                                }) {
                                    
                                    Text(chartype[row * 2 + column])
                                        .font(.system(size:18))
                                }
                                .foregroundColor(Color.black)
                                .animation(.easeInOut(duration: 0))
                                
                                Spacer()
                                
                            }.frame(width: (UIScreen.main.bounds.width * 0.8)/2)
                            
                        }
                        
                    }.padding(.top, 10)
                
                }
                
                Divider()
                    .frame(height: 0.5)
                    .background(Color.gray_t0)
                    .padding(.top, 15)
                    .padding(.horizontal, 15)
                
                HStack{
                    
                    Text("공급업체")
                        .foregroundColor(.gray_t3)
                        .font(.system(size:15))
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        getbfilterInfo(dist: "addall", snsid: logininfo.snsid, appid: logininfo.appid, stid: "")

                    }) {
                        
                        Text("모두선택")
                            .foregroundColor(.gray_t3)
                            .font(.system(size:14))
                            .padding(.top, 15)
                            //.padding(.trailing, 20)
                    }
                    
                    
                    Button(action: {
                        
                        getbfilterInfo(dist: "removeall", snsid: logininfo.snsid, appid: logininfo.appid, stid: "")

                    }) {
                        
                        Text("모두해제")
                            .foregroundColor(.gray_t3)
                            .font(.system(size:14))
                            .padding(.top, 15)
                            .padding(.trailing, 20)
                    }
                    
                }
                
                ScrollView{
                    
                    ForEach(bfilterarray, id: \.stnm) {item in
                        
                        HStack{
                            
                            Image(systemName: "checkmark.square")
                                .foregroundColor(item.on == 0 ? .gray_t1 : .green)
                                .font(.system(size:22))
                                //.animation(.easeOut(duration: 0.1))
                            
                            Button(action: {
                                
                                if item.on == 0 {
                                    
                                    getbfilterInfo(dist: "add", snsid: logininfo.snsid, appid: logininfo.appid, stid: item.stid)
                                    
                                } else {
                                    
                                    
                                    getbfilterInfo(dist: "remove", snsid: logininfo.snsid, appid: logininfo.appid, stid: item.stid)
                                    
                                }

                               
                            }){
                                
                                Text(item.stnm)
                                    .font(.system(size:18))
                                
                            }
                            .foregroundColor(Color.black)
                            .animation(.easeInOut(duration: 0))
                            
                            Spacer()
                            
                        }
                        .padding(.top, 10)
                        
                    }
                    //.padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                }
                
            }
            
            Spacer()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
            
    }
    
    func getafilterInfo(dist: String, snsid: String, appid: String, aidx: Int){
        
        let endPoint = "https://sh6jq8ndp4.execute-api.ap-northeast-2.amazonaws.com/getfiltera?dist=\(dist)&snsid=\(snsid)&appid=\(appid)&aidx=\(aidx)"
        let url = NSURL(string: endPoint)
        let session = URLSession.shared

        let task = session.dataTask(with: url! as URL, completionHandler:
        {
            (data, response, error) -> Void in
            
            do {
                
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers])
                
                guard let newValue = jsonResult as? [Any] else {
                    print("data type error")
                    return
                    
                }
                
                //수정하는 것과 이니셜 로딩으로 나뉨
                if newValue[0] as! Int == 1 {
                      
                    switch dist {

                    case "add":
                        
                        DispatchQueue.main.async {
                        
                            self.afilterarray[aidx] = 1
                            
                        }
                        
                    case "remove":
                        
                        DispatchQueue.main.async {
                        
                            self.afilterarray[aidx] = 0
                            
                        }
                        
                    default:
                        print("default")
                    }
                    
                } else {
                    
                    let dataString = (newValue[0] as AnyObject).data(using: String.Encoding.utf8.rawValue)
                    
                    let newArray = try JSONSerialization.jsonObject(with: dataString!, options: []) as! Array<Any>
                    
                    self.afilterarray = [0, 0, 0, 0, 0, 0]
                    
                    for (idx, item) in newArray.enumerated(){
                        
                        DispatchQueue.main.async {
                        
                            self.afilterarray[idx] = item as! Int
                            
                        }
                    }
                    
                    
                }
                
            } catch {
                print("raw data error")
                
            }
            
            DispatchQueue.main.async {
                self.afcompletion = true
            }

        })
        task.resume()
        
    }
    
    func getbfilterInfo(dist: String, snsid: String, appid: String, stid: String) {
        
        let endPoint = "https://jit5xflq56.execute-api.ap-northeast-2.amazonaws.com/getfilter?dist=\(dist)&snsid=\(snsid)&appid=\(appid)&stid=\(stid)"
        let url = NSURL(string: endPoint)
        let session = URLSession.shared

        let task = session.dataTask(with: url! as URL, completionHandler:
        {
            (data, response, error) -> Void in
            
            do {
                
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers])
                
                guard let newValue = jsonResult as? [Any] else {
                    print("data type error")
                    return
                    
                }
                
                if newValue[0] as! Int == 1 {
                    
                    switch dist {

                    case "add":
                        
                        let idx = bfilterarray.firstIndex(where: {$0.stid == stid}) as Any
                        bfilterarray[idx as! Int].on = 1
                        
                    case "addall":
                        
                        bfilterarray.mutateEach { $0.on = 1 }
                     
                    case "remove":
                        
                        let idx = bfilterarray.firstIndex(where: {$0.stid == stid}) as Any
                        bfilterarray[idx as! Int].on = 0
                        
                    case "removeall":
                        
                        bfilterarray.mutateEach { $0.on = 0 }
                     
                    default:
                        print("default")
                    }
                    
                    
                }

                
            } catch {
                print("raw data error")
                
            }
            DispatchQueue.main.async {
                self.bfcompletion = true
            }

        })
        task.resume()
        
    }

}


struct FilterCover : View {
    
    @Binding var filtershow : Bool
    @Binding var afilterarray : [Int]
    //@Binding var filteron : Bool
    
    
    var body : some View {
        
        VStack{
            
            Spacer()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .background(Color.white.opacity(afilterarray[0] == 0 && filtershow ? 0.7 : 0))
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

