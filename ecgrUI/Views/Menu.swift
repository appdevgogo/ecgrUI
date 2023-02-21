import SwiftUI
import RealmSwift


struct Menu : View {
    
    @Binding var menushow : Bool
    @Binding var menusubshow : Bool
    @Binding var menusubtitle : String
    @Binding var mscompletion : Bool
    @Binding var logoutexe : Bool
    @Binding var logininfo : LogInInfo
    @Binding var bookmarkinfo : BookMarkInfo
    @Binding var bookmarkarray : [BookMarkInfo]
    
    //유져인포는 상시 최신정보가 업데이트 되는것이 좋으므로 init필요 로딩에 조건 필요 없음
    init(menushow: Binding<Bool>, menusubshow: Binding<Bool>, menusubtitle: Binding<String>, mscompletion: Binding<Bool>, logoutexe: Binding<Bool>, logininfo: Binding<LogInInfo>, bookmarkinfo: Binding<BookMarkInfo>, bookmarkarray: Binding<[BookMarkInfo]>){
        
        _menushow = menushow
        _menusubshow = menusubshow
        _menusubtitle = menusubtitle
        _mscompletion = mscompletion
        _logoutexe = logoutexe
        _logininfo = logininfo
        _bookmarkinfo = bookmarkinfo
        _bookmarkarray = bookmarkarray
        
        loaduserinfo()
            
    }
 
    var body : some View{
        
        VStack(alignment: .leading){
            
            HStack() {
                
                Spacer()
                
                Button(action: {
                    
                    menushow = false

                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray_t1)
                        .font(.system(size:22))
                }
                
                
            }
            .padding(.top, 15)
            .padding(.horizontal, 15)
            
            HStack(){
                 
                switch logininfo.sns {
                
                case "naver":
                    Image("login_o_n")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                    
                case "kakao":
                    Image("login_o_k")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                    
                case "facebook":
                    Image("login_o_f")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                    
                default:
                    Text("")
                }
                
                
                /*
                Image(systemName: "person.crop.circle")
                    .foregroundColor(Color("gray_t1"))
                    .font(.system(size:25))
                */
                VStack(alignment: .leading) {
                    
                    Text(logininfo.nickname)
                        .foregroundColor(.black)
                        .font(.system(size:15, weight: .regular))
                    
                    Text(logininfo.email)
                        .foregroundColor(.gray)
                        .font(.system(size:14, weight: .regular))
                    
                }
                .padding(.leading, 5)
                
                Spacer()
                
            }
            .padding(.horizontal, 15)
            .padding(.top, 0)
            
           // Divider()
            
            VStack(alignment: .leading, spacing: 20) {
                
                Button(action: {
                    
                    menusubshow = true
                    menusubtitle = "bookmark"
                    getBookMark(dist: "select", snsid: logininfo.snsid, appid: logininfo.appid, stnm: "", stid: "")
                    
                }) {
                    
                    Text("즐겨찾기")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .font(.system(size:18, weight: .semibold))
                    
                }
                
                /*
                Button(action: {
                    
                    menusubshow = true
                    menusubtitle = "review"
                    
                }) {
                    
                    Text("내 댓글확인")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .font(.system(size:18, weight: .semibold))
                    
                }
                
                Button(action: {
                    
                    menusubshow = true
                    menusubtitle = "repair"
                    
                }) {
                    
                    Text("고장 신고내역")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .font(.system(size:18, weight: .semibold))
                    
                }
                 */
                
                Button(action: {
                    
                    menusubshow = true
                    menusubtitle = "nickname"
                    mscompletion = true
                    
                    
                }) {
                    
                    Text("닉네임변경")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .font(.system(size:18, weight: .semibold))
                    
                }
                
            }
            .padding(.top, 30)
            .padding(.leading, 30)
            
            HStack() {
                
                Spacer()
                
                Button(action: {
                    
                    logoutexe = true
                    
                }) {
                    
                    Text("로그아웃")
                        .foregroundColor(.gray_t3)
                        .font(.system(size:14, weight: .regular))
                    
                }
                
            }
            .padding(.top, 20)
            .padding(.trailing, 15)
            
            HStack() {
                
                Spacer()

                Text("앱전용 아이디 : \(String(logininfo.appid.prefix(7)))")
                    .foregroundColor(.gray_t3)
                    .font(.system(size:14, weight: .regular))

            }
            .padding(.top, 5)
            .padding(.trailing, 15)

            Spacer()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func loaduserinfo() {
        
        print("========================> Menu.swift의 loaduserinfo 실행됨")
        
        let realm = try! Realm()
        let logininfodb = realm.objects(loginDB.self)
        
        if logininfodb.count > 0 {
            
            DispatchQueue.main.async {
                
                logininfo.sns = logininfodb[0].sns
                logininfo.snsid = logininfodb[0].snsid
                logininfo.name = logininfodb[0].name
                logininfo.nickname = logininfodb[0].nickname
                logininfo.email = logininfodb[0].email
                logininfo.appid = logininfodb[0].appid
                
            }
        }
        
    }
 
    
    func getBookMark(dist: String, snsid : String, appid : String, stnm: String, stid: String) {

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
                        
                        print(stdata[0])
                        print(stdata[1])
                        
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
    
    func getNickName(snsid: String, appid: String, nicknameto: String) {
        
        let endPoint = "https://o3y6a82aq9.execute-api.ap-northeast-2.amazonaws.com/modifynickname?snsid=\(snsid)&appid=\(appid)&nicknameto=\(nicknameto)"
        
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
                
                for item in newValue{
                    
                    if let stdata = item as? [Any]{
                        
                        let newnickname = stdata[0] as! String
                        
                        let realm = try! Realm()
                        let toModify = realm.objects(loginDB.self).filter("snsid == \(snsid) AND appid == \(appid)").first
                    
                        try! realm.write {
                            toModify!.nickname = newnickname
                        }
                        
                        DispatchQueue.main.async {
                            
                            logininfo.nickname = newnickname
                            
                        }
     
                    }

                }
                
            } catch {
                print("raw data error")
                
            }

        })
        task.resume()
        
    }
    
}


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
                        
                        Text("즐겨찾기")
                            .modifier(MenuSubTitle())
                        
                    case "review":
                        
                        Text("내 댓글확인")
                            .modifier(MenuSubTitle())
                        
                    case "repair":
                        
                        Text("고장신고 내역")
                            .modifier(MenuSubTitle())
                        
                    case "nickname":
                        
                        Text("닉네임변경")
                            .modifier(MenuSubTitle())
                        
                    default:
                        Text("")
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.left")
                        .foregroundColor(.clear)
                    
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
                                    .foregroundColor(.black)
                                    
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
                        
                        Text("댓글")
                        
                    case "repair":
                        
                        Text("수리")
                        
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
                            
                            Text("2자이상 10자 이하의 한글, 영문, 숫자, 조합가능")
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
                                
                                Text("확인")
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
                                Alert(title: Text("닉네임이 변경되었습니다"),
                                      message: Text(""),
                                      dismissButton: .default(Text("확인"), action: {
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
        
        let charset = CharacterSet(charactersIn: " !@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")
        
        if nickname.rangeOfCharacter(from: charset) != nil {
            
            nicknamealert = "공백 또는 특수문자를 제거해 주시길 바랍니다"
            
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
                        
                        nicknamealert = "다른 사용자와 닉네임이 중복됩니다"
                        
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
