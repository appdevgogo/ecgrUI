import SwiftUI

struct Reply : View {
    
    @Binding var reviewinfo : ReviewInfo
    @Binding var reviewarray : [ReviewInfo]
    
    @Binding var replyshow : Bool
    @Binding var replycompletion : Bool
    @Binding var replyid : String
    @Binding var replyarray : [ReplyInfo]
    
    @Binding var logininfo : LogInInfo
    @Binding var stationid : String
    @Binding var reviewid : String
    
    @Binding var replyupdateshow : Bool
    @Binding var replyupdatetxt : String
    
    @State private var replytxt = ""
    @State private var replydelalert = false
    
    var body : some View {
        
        VStack(spacing: 0){
            
            if replycompletion == false {
                
                if #available(iOS 14.0, *) {
                    
                    ProgressView()
                    
                } else {
                    
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                
            } else {
                
                HStack (spacing: 0){
                    
                    Button(action: {
                        
                        replyshow = false
                        
                        getReview(dist: "countselect", no: 0, snsid: logininfo.snsid, appid: logininfo.appid, nickname: "", stid: stationid, reviewid: "", review: "", level: "1", time: "")
                        
                        replytxt = ""
                        hideKeyboard()
                        

                    }) {
                        Image(systemName: "arrow.left")
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                        
                    Button(action: {
                        
                        
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(.clear)
                        
                    }
                    .padding(.trailing, 5)
                        
                    
                    
                }
                .foregroundColor(.gray_t1)
                .font(.system(size:25, weight: .regular))
                .padding(.horizontal, 10)
                .padding(.top, 15)
                .padding(.bottom, 15)
                
                ScrollView {
                    
                    HStack {
                        
                        Text(reviewinfo.nickname)
                            .foregroundColor(.black)
                            .font(.system(size:14, weight: .light))
                        
                        Text(reviewinfo.timediffer)
                            .padding(.leading, 5)
                            .foregroundColor(.gray_t2)
                            .font(.system(size:13, weight: .regular))
                        
                        Spacer()
                        
                    }
                    .padding(.top, 0)
                    .padding(.horizontal, 20)
                    
                    HStack {

                        Text(reviewinfo.review)
                            .foregroundColor(.black)
                            .font(.system(size:15, weight: .regular))
                            
                        Spacer()
                        
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                    
                    HStack{
                        
                        MultilineTextField("댓글작성", text: $replytxt)
                            .padding(.horizontal, 10)
                           // .font(.system(size:15, weight: .regular))
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray_t2, lineWidth: 1)
                            )
                            .onReceive(replytxt.publisher.collect()) {
                                self.replytxt = String($0.prefix(200))
                                }
                        
                    }
                    //.font(.system(size:20, weight: .regular))
                    .padding(.horizontal, 20)
                    
                    VStack{
                        
                        HStack{
                            
                            Text("\(replytxt.count)/200")
                                .font(.system(size:13, weight: .regular))
                                .foregroundColor(.gray_t3)
                            
                            Spacer()
                            
                            Button(action: {
                                
                                getReply(dist: "insert", no: 0, snsid: logininfo.snsid, appid: logininfo.appid, nickname: logininfo.nickname, stid: stationid, reviewid: reviewid, replyid: "", reply: replytxt, level: "2", time: "")
                                
                                replytxt = ""
                                hideKeyboard()
                                
                            }) {
                                
                                Text("입력")
                                    .font(.system(size:14, weight: .regular))
                                    .foregroundColor((replytxt.count < 1) ? .gray_t2 : .blue)
                                
                            }
                            .disabled(replytxt.count < 1)
                            
                        }
                        .padding(.horizontal, 25)
                        
                        
                        ForEach(replyarray, id: \.time) {item in
                            
                            VStack{
                                
                                HStack {
                                    
                                    Text(item.nickname)
                                        .foregroundColor(.black)
                                        .font(.system(size:14, weight: .light))
                                    
                                    Text(item.timediffer)
                                        .padding(.leading, 5)
                                        .foregroundColor(.gray_t2)
                                        .font(.system(size:13, weight: .regular))
                                    
                                    Spacer()
                                    
                                }
                                .padding(.top, 10)
                                .padding(.horizontal, 10)
                                
                                HStack {
              
                                    Text(item.reply)
                                        .foregroundColor(.black)
                                        .font(.system(size:15, weight: .regular))
                                        
                                    Spacer()
                                    
                                }
                                .padding(.top, 5)
                                .padding(.horizontal, 10)
                                
                                HStack {
                                    
                                    Spacer()
                                    
                                    if item.mine == 1 {
                                        
                                        Button(action: {
                                            
                                            hideKeyboard()
                                            replyupdateshow = true
                                            replyupdatetxt = item.reply
                                            replyid = item.replyid
                                            
                                        }) {
                                            Text("수정")
                                                .foregroundColor(.black)
                                                .font(.system(size:14, weight: .light))
                                            
                                        }
                                        .padding(.trailing, 5)
                                        
                                        Button(action: {
                                            
                                            replyid = item.replyid
                                            replydelalert = true
                                            
                                        }) {
                                            Text("삭제")
                                                .foregroundColor(.black)
                                                .font(.system(size:14, weight: .light))
                                            
                                        }
                                        .padding(.trailing, 5)
                                        .alert(isPresented: $replydelalert) {
                                                    Alert(title: Text("댓글을 완전히 삭제 하시겠습니까?"), message: Text(""), primaryButton: .destructive(Text("삭제")) {
                                                        
                                                        getReply(dist: "delete", no: 0, snsid: logininfo.snsid, appid: logininfo.appid, nickname: "", stid: stationid, reviewid: reviewid, replyid: replyid, reply: "", level: "2", time: "")
                                                        
                                                        hideKeyboard()
                                                        
                                                    }, secondaryButton: .cancel(Text("취소")))
                                                }
                                        
                                    }
                                    
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                
                            }
                            .background(Color.gray_t0)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        
                        }
                        
                        HStack{
                            
                            Button(action: {
                                
                                hideKeyboard()
                                
                                print(replyarray.last!.no)
                                
                                getReply(dist: "addselect", no: replyarray.last!.no, snsid: logininfo.snsid, appid: logininfo.appid, nickname: logininfo.nickname, stid: stationid, reviewid: reviewid, replyid: replyid, reply: replyupdatetxt, level: "2", time: "")
                                
                            }) {
                                
                                Text("더보기")
                                    .foregroundColor(.gray_t3)
                                    .font(.system(size:14, weight: .regular))
                                
                            }
                            .padding(.vertical, 5)
                        }
                        
                        HStack{}
                        .padding(.bottom, 100)
                        
                    }
                    .contentShape(Rectangle()) //제스쳐탭이 클릭이 안되는 문제롤 해결(탭영역설정)
                    .simultaneousGesture(
                        TapGesture().onEnded { _ in hideKeyboard()})
                    
                }
                //.keyboardAware()
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { gesture in hideKeyboard()})
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)

    }
    
    func getReview(dist: String, no: Int, snsid: String, appid: String, nickname: String, stid: String, reviewid: String, review: String, level: String, time: String) {

        let endPoint = "https://lzt8xnncia.execute-api.ap-northeast-2.amazonaws.com/getreview?dist=\(dist)&no=\(no)&snsid=\(snsid)&appid=\(appid)&nickname=\(nickname)&stid=\(stid)&reviewid=\(reviewid)&review=\(review)&level=\(level)&time=\(time)"
        
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
                
                if newValue.count > 0 {
                    
                    for item in newValue{
                        
                        if let stdata = item as? [Any]{
                            
                            let reviewidto = stdata[0] as! String
                            let replycountto = stdata[1] as! Int
                            
                            DispatchQueue.main.async {
                                
                                guard let idx = reviewarray.firstIndex(where: {$0.reviewid == reviewidto}) else {
                                    
                                    //print("no match reviewid") //이렇게 하는 이유는 보여지는 카운터만 수정하기 위함
                                    
                                    return
                                }
                                
                                reviewarray[idx].replycount = replycountto
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            } catch {
                print("raw data error")
                
            }
            //mscompletion = true

        })
        task.resume()
        
    }
    
    func getReply(dist: String, no: Int, snsid: String, appid: String, nickname: String, stid: String, reviewid: String, replyid: String, reply: String, level: String, time: String) {

        let endPoint = "https://ds5kbt8gk7.execute-api.ap-northeast-2.amazonaws.com/getreply?dist=\(dist)&no=\(no)&snsid=\(snsid)&appid=\(appid)&nickname=\(nickname)&stid=\(stid)&reviewid=\(reviewid)&replyid=\(replyid)&reply=\(reply)&level=\(level)&time=\(time)"
        
        let encodedQuery: String = endPoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
        
        let requestURL = URLRequest(url: queryURL)
        let session = URLSession.shared
        
        if dist == "initselect" || dist == "insert" {
            
            replyarray = []
            
        }
        
        let task = session.dataTask(with: requestURL, completionHandler:
        {
            (data, response, error) -> Void in
            
            do {
                
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers])

                guard let newValue = jsonResult as? [Any] else {
                    print("data type error")
                    return
                       
                }
                
                if newValue.count > 0 {
                    
                    for item in newValue{
                        
                        if let stdata = item as? [Any]{
                            
                            var temp = ReplyInfo()
                            
                            temp.nickname = stdata[0] as! String
                            temp.stid = stdata[1] as! String
                            temp.replyid = stdata[2] as! String
                            temp.reply = stdata[3] as! String
                            temp.level = stdata[4] as! String
                            temp.time = stdata[5] as! String
                            temp.timediffer = timeDiffer(time: stdata[5] as! String)
                            temp.no = stdata[6] as! Int
                            temp.mine = stdata[7] as! Int
                            
                            DispatchQueue.main.async {
                                    
                                replyarray.append(temp)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                if newValue.count == 0 && dist == "delete" {
                    
                    let idx = replyarray.firstIndex(where: {$0.replyid == replyid})!
                    replyarray.remove(at: idx)
                    
                }
                
            } catch {
                print("raw data error")
                
            }
            //mscompletion = true

        })
        task.resume()
        
    }
    
}


struct ReplyUpdate : View {
    
    @Binding var replyupdateshow : Bool
    @Binding var replyupdatetxt : String
    @Binding var replyid : String
    
    @Binding var replyarray : [ReplyInfo]
    
    @Binding var logininfo : LogInInfo
    @Binding var stationid : String
    @Binding var reviewid : String
    
    @State var showalert = false
    
    var body : some View {
        
        VStack{
            
            ScrollView{
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        
                        replyupdateshow = false
                        hideKeyboard()
                            
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray_t2)
                            //.font(.system(size:15, weight: .regular))
                    }
                    
                }
                
                HStack{
                    
                    Text("댓글 수정")
                        .foregroundColor(.gray_t3)
                        .font(.system(size:15, weight: .regular))
                    Spacer()
                    
                }
                
                MultilineTextField("", text: $replyupdatetxt)
                   // .padding(.horizontal, 10)
                    .font(.system(size:15, weight: .regular))
                    .foregroundColor(.black)
                    .background(Color.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.gray_t2, lineWidth: 1)
                    )
                    .onReceive(replyupdatetxt.publisher.collect()) {
                        self.replyupdatetxt = String($0.prefix(200))
                        }
                    
                //Spacer()
                HStack{
                    
                    Text("\(replyupdatetxt.count)/200")
                        .font(.system(size:13, weight: .regular))
                        .foregroundColor(.gray_t3)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        hideKeyboard()
                        
                        getReply(dist: "update", no: 0, snsid: logininfo.snsid, appid: logininfo.appid, nickname: logininfo.nickname, stid: stationid, reviewid: reviewid, replyid: replyid, reply: replyupdatetxt, level: "2", time: "")
                        
                    }) {
                        Text("확인")
                            .foregroundColor(.blue)
                            .font(.system(size:14, weight: .regular))
                        
                    }
                    //.padding(.vertical, 10)
                    .background(Color.white)
                    .alert(isPresented: $showalert) {
                        Alert(title: Text("댓글이 수정되었습니다."),
                              message: Text(""),
                              dismissButton: .default(Text("확인"), action: {
                                                        replyupdateshow = false
                                                        replyupdatetxt = ""}
                                
                              )
                        )
                    }
                    
                    
                }
                .padding(.top, 5)
                
            }
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.4)
            .padding(.all, 20)
            .background(Color.white)
            
            Spacer()
        }
        
    }
    
    func getReply(dist: String, no: Int, snsid: String, appid: String, nickname: String, stid: String, reviewid: String, replyid: String, reply: String, level: String, time: String) {

        let endPoint = "https://ds5kbt8gk7.execute-api.ap-northeast-2.amazonaws.com/getreply?dist=\(dist)&no=\(no)&snsid=\(snsid)&appid=\(appid)&nickname=\(nickname)&stid=\(stid)&reviewid=\(reviewid)&replyid=\(replyid)&reply=\(reply)&level=\(level)&time=\(time)"
        
        let encodedQuery: String = endPoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
        
        let requestURL = URLRequest(url: queryURL)
        let session = URLSession.shared
        
        //replyarray = []
        
        let task = session.dataTask(with: requestURL, completionHandler:
        {
            (data, response, error) -> Void in
            
            do {
                
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers])

                guard let newValue = jsonResult as? [Any] else {
                    print("data type error")
                    return
                       
                }
                
                print(newValue)
                
                if newValue.count > 0 {
                    
                    for item in newValue{
                        
                        if let stdata = item as? [Any]{
                            
                            var temp = ReplyInfo()
                            
                            temp.nickname = stdata[0] as! String
                            temp.stid = stdata[1] as! String
                            temp.replyid = stdata[2] as! String
                            temp.reply = stdata[3] as! String
                            temp.level = stdata[4] as! String
                            temp.time = stdata[5] as! String
                            temp.timediffer = timeDiffer(time: stdata[5] as! String)
                            temp.no = stdata[6] as! Int
                            temp.mine = stdata[7] as! Int
                            
                            DispatchQueue.main.async {
                                
                                switch dist {
                                    
                                case "update":
                                    
                                    let idx = replyarray.firstIndex(where: {$0.replyid == replyid}) as Any
                                    
                                    print(idx)
                                    
                                    replyarray[idx as! Int] = temp

                                default:
                                    
                                    replyarray.append(temp)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    DispatchQueue.main.async {
                        
                        showalert = true
                        
                    }
                    
                }
                
            } catch {
                print("raw data error")
                
            }
            //mscompletion = true

        })
        task.resume()
        
    }
    
}
