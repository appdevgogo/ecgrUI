import SwiftUI
import RealmSwift

struct MenuSub : View {
    
    @Binding var menushow : Bool
    @Binding var menusubshow : Bool
    @Binding var menusubtitle : String
    @Binding var mscompletion : Bool
    
    @Binding var checkbookmark : Bool
    @Binding var bookmarkarray : [BookMarkInfo]
    
    @Binding var stationshow : Bool
    @Binding var stationgetdata : Bool
    @Binding var scompletion : Bool
    @Binding var stationid : String
    
    @Binding var logininfo : LogInInfo
    
    @State var nicknameto = ""
    @State var nicknamealert = ""
    @State var showalert = false
    
    /*
    init(menushow: Binding<Bool>, menusubshow: Binding<Bool>, menusubtitle: Binding<String>, mscompletion: Binding<Bool>, checkbookmark: Binding<Bool>, bookmarkarray: Binding<[BookMarkInfo]>, stationshow: Binding<Bool>, stationgetdata: Binding<Bool>, scompletion: Binding<Bool>, stationid: Binding<String>, logininfo: Binding<LogInInfo>){
        
        _menushow = menushow
        _menusubshow = menusubshow
        _menusubtitle = menusubtitle
        _mscompletion = mscompletion
        
        _checkbookmark = checkbookmark
        _bookmarkarray = bookmarkarray
        
        _stationshow = stationshow
        _stationgetdata = stationgetdata
        _scompletion = scompletion
        _stationid = stationid
        
        _logininfo = logininfo
        
    }
 */

    var body : some View{
        
        VStack(spacing: 0){
            
            if mscompletion == false {
                
                if #available(iOS 14.0, *) {
                    
                    ProgressView()
                    
                } else {
                    
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                
            } else {
                
                HStack (spacing: 0){
                    
                    Button(action: {
                        
                        menusubshow = false
                        mscompletion = false
                        menusubtitle = ""
                        
                        nicknameto = ""
                        nicknamealert = ""

                    }) {
                        Image(systemName: "arrow.left")
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                    
                    switch menusubtitle {
                    
                    case "bookmark":
                        
                        Text("????????????")
                            .modifier(MenuSubTitle())
                        
                    case "review":
                        
                        Text("??? ????????????")
                            .modifier(MenuSubTitle())
                        
                    case "repair":
                        
                        Text("???????????? ??????")
                            .modifier(MenuSubTitle())
                        
                    case "nickname":
                        
                        Text("???????????????")
                            .modifier(MenuSubTitle())
                        
                    default:
                        Text("")
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color(.clear))
                    
                }
                .foregroundColor(.gray_t1)
                .font(.system(size:25, weight: .regular))
                .padding(.horizontal, 10)
                .padding(.top, 15)
                .padding(.bottom, 15)
                
                ScrollView{
                    
                    switch menusubtitle {
                    
                    case "bookmark":
                        
                        if bookmarkarray.count != 0 {
                            
                            ForEach(bookmarkarray, id: \.statid) {item in
                                
                                HStack() {
                                    
                                    Button(action: {
                                        
                                        stationid = item.statid
                                        scompletion = false
                                        stationshow = true
                                        stationgetdata = true
                                        checkbookmark = true
                                        
                                       // menushow = false
                                      //  menusubshow = false
                                        
                                    }){
                                        
                                        HStack{
                                            
                                            Image(systemName: "flag")
                                                .foregroundColor(.gray)
                                                .font(.system(size:17, weight: .semibold))
                                            
                                            Text(item.name)
                                            
                                            Spacer()
                                            
                                        }
                                        .padding(.leading, 20)
                                        
                                    }
                                    .foregroundColor(Color.black)
                                    
                                    Button(action: {
                                        
                                        getBookMark(dist: "remove", snsid: logininfo.snsid, appid: logininfo.appid, stnm: "", stid: item.statid)
                                        
                                    }){
                                        
                                        Image(systemName: "xmark")
                                            .foregroundColor(.gray)
                                            .font(.system(size:15, weight: .regular))
                                        
                                    }
                                    .padding(.trailing, 20)
                                }
                                
                            }
                            .padding(.vertical, 10)
                            
                        }
                        
                    case "review":
                        
                        Text("??????")
                        
                    case "repair":
                        
                        Text("??????")
                        
                    case "nickname":
                        
                        VStack() {
                            
                            TextField("\(logininfo.nickname)", text: $nicknameto)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .font(.system(size:15, weight: .regular))
                                .foregroundColor(.black)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onReceive(nicknameto.publisher.collect()) {
                                    self.nicknameto = String($0.prefix(10))
                                    }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray_t2, lineWidth: 1)
                                )
                              //  .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("2????????? 10??? ????????? ??????, ??????, ??????, ????????????")
                               // .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 0)
                                .font(.system(size:14, weight: .regular))
                                .foregroundColor(.gray_t2)
                            
                            Text(nicknamealert)
                                .padding(.top, 3)
                                .font(.system(size:14, weight: .regular))
                                .foregroundColor(.red)
                            
                            
                            Button(action: {
                                
                                updateNickName(snsid: logininfo.snsid, appid: logininfo.appid, nickname: nicknameto)
                                
                            }){
                                
                                Text("??????")
                                    .font(.system(size:15, weight: .semibold))
                                    .padding(.vertical, 10)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .background((nicknameto.count < 3) ? Color.gray_t2 : Color.blue)
                                    .cornerRadius(5)
                                
                            }
                            .padding(.top, 10)
                            .disabled(nicknameto.count < 3)
                            .alert(isPresented: $showalert) {
                                Alert(title: Text("???????????? ??????????????? ?????????????????????"),
                                      message: Text(""),
                                      dismissButton: .default(Text("??????"), action: {
                                                                menusubshow = false
                                                                mscompletion = false
                                                                menusubtitle = ""
                                                                nicknameto = ""
                                                                nicknamealert = ""}
                                        
                                      )
                                )
                            }
                            
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 50)
                        
                        
                    default:
                        Text("")
                    }
                    
                }
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func updateNickName(snsid: String, appid: String, nickname: String) {
        
        let charset = CharacterSet(charactersIn: " !@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\??'???????")
        
        if nickname.rangeOfCharacter(from: charset) != nil {
            
            nicknamealert = "?????? ?????? ??????????????? ????????? ????????? ????????????"
            
        } else {
            
            let endPoint = "https://jfftw26xr4.execute-api.ap-northeast-2.amazonaws.com/getnickname?snsid=\(snsid)&appid=\(appid)&nickname=\(nickname)"
            
            let encodedQuery: String = endPoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let queryURL: URL = URL(string: encodedQuery)!
            
            let requestURL = URLRequest(url: queryURL)
            let session = URLSession.shared
                
            let task = session.dataTask(with: requestURL, completionHandler:
            {
                (data, response, error) -> Void in
                
                do {
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers])

                    guard let newValue = jsonResult as? [Any] else {
                        print("data type error")
                        return
                           
                    }
                    
                    if newValue[0] as! String == "1" {
                        
                        nicknamealert = "?????? ???????????? ???????????? ???????????????"
                        
                    } else {
                        
                        let realm = try! Realm()
                        
                        let toUpdate = realm.objects(loginDB.self).filter("snsid = '\(logininfo.snsid)' AND appid = '\(logininfo.appid)'").first
                        
                        try! realm.write {
                            toUpdate!.nickname = newValue[0] as! String
                        }
                        
                        DispatchQueue.main.async {
                            
                            logininfo.nickname = newValue[0] as! String
                            
                        }
                        
                        showalert = true
                        
                    }
                          
                } catch {
                    print("raw data error")
                    
                }

            })
            task.resume()
            
        }
        
    }
    
    
    func getBookMark(dist: String, snsid : String, appid : String, stnm: String, stid: String) {
        
        print(dist, snsid, appid, stnm, stid)

        let endPoint = "https://5lur7ptc38.execute-api.ap-northeast-2.amazonaws.com/getbookmark?dist=\(dist)&snsid=\(snsid)&appid=\(appid)&stnm=\(stnm)&stid=\(stid)"
        
        let encodedQuery: String = endPoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
        
        let requestURL = URLRequest(url: queryURL)
        let session = URLSession.shared
            
        let task = session.dataTask(with: requestURL, completionHandler:
        {
            (data, response, error) -> Void in
            
            do {
                
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers])

                guard let newValue = jsonResult as? [Any] else {
                    print("data type error")
                    return
                       
                }
                
                let dataString = (newValue[0] as AnyObject).data(using: String.Encoding.utf8.rawValue)
                
                let newArray = try JSONSerialization.jsonObject(with: dataString!, options: []) as! Array<Any>

                bookmarkarray = []
                
                for item in newArray{
                    
                    if let stdata = item as? [Any]{
                        
                        var temp = BookMarkInfo()
                        
                        temp.name = stdata[0] as! String
                        temp.statid = stdata[1] as! String
                        
                        DispatchQueue.main.async {
                            bookmarkarray.append(temp)
                        }
                        
                    }
                    
                }


            } catch {
                print("raw data error")
                
            }
            mscompletion = true

        })
        task.resume()
            

    }
}


struct MenuSubTitle: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content
          //  .padding(.top, 15)
           // .padding(.bottom, 5)
           // .padding(.horizontal, 20)
            .font(.system(size:17, weight: .semibold))
            .foregroundColor(.gray_t2)
           // .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
}

