import SwiftUI
import UIKit

struct Review : View {
    
    @Binding var reviewshow : Bool
    @Binding var rcompletion : Bool
    @Binding var reviewid : String
    @Binding var reviewinfo : ReviewInfo
    @Binding var reviewarray : [ReviewInfo]
    
    @Binding var logininfo : LogInInfo
    @Binding var stationid : String
    
    @Binding var reviewupdateshow : Bool
    @Binding var reviewupdatetxt : String
    
    @Binding var replyshow : Bool
    @Binding var replycompletion : Bool
    @Binding var replyarray : [ReplyInfo]
    
    @State private var reviewtxt = ""
    @State private var reviewdelalert = false
    @State private var idx = 0
    
    
    var body : some View {
        
        VStack(spacing: 0){
            
            if rcompletion == false {
                
                if #available(iOS 14.0, *) {
                    
                    ProgressView()
                    
                } else {
                    
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                
            } else {
                
                HStack (spacing: 0){
                    
                    Button(action: {
                        
                        reviewshow = false
                        reviewtxt = ""
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
                    
                    HStack{
                        
                        MultilineTextField("리뷰작성", text: $reviewtxt)
                            .padding(.horizontal, 10)
                        // .font(.system(size:15, weight: .regular))
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray_t2, lineWidth: 1)
                            )
                            .onReceive(reviewtxt.publisher.collect()) {
                                self.reviewtxt = String($0.prefix(500))
                                }
                        
                    }
                    //.font(.system(size:20, weight: .regular))
                    .padding(.horizontal, 20)
                    .padding(.top, 1)
                    
                    VStack{
                        
                        HStack{
                            
                            Text("\(reviewtxt.count)/500")
                                .font(.system(size:13, weight: .regular))
                                .foregroundColor(.gray_t3)
                            
                            Spacer()
                            
                            Button(action: {
                                
                                getReview(dist: "insert", no: 0, snsid: logininfo.snsid, appid: logininfo.appid, nickname: logininfo.nickname, stid: stationid, reviewid: "", review: reviewtxt, level: "1", time: "")
                                
                                reviewtxt = ""
                                hideKeyboard()
                                
                            }) {
                                
                                Text("입력")
                                    .font(.system(size:14, weight: .regular))
                                    .foregroundColor((reviewtxt.count < 1) ? .gray_t2 : .blue)
                                
                            }
                            .disabled(reviewtxt.count < 1)
                            
                        }
                        .padding(.horizontal, 25)
                            
                        ForEach(reviewarray, id: \.reviewid) {item in
                            
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
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                            
                            HStack {
                                
                                if item.reviewlong == 1 {
                                    
                                    Text(item.review.prefix(100) + "..")
                                        .foregroundColor(.black)
                                        .font(.system(size:15, weight: .regular))
                                    
                                } else if item.reviewlong == 2 {
                                    
                                    //let sreviewarray = sreview.indices(of: "\n")
                                   // idx = sreviewarray[1] as Any
                                    //print(sreviewarray)
                                    let countreview =  item.review.components(separatedBy:"\n")
                                    let sreview = countreview[0] + "\n" + countreview[2]
            
                                    Text(sreview + "..")
                                        .foregroundColor(.black)
                                        .font(.system(size:15, weight: .regular))
                                    
                                } else {
                                    
                                    Text(item.review)
                                        .foregroundColor(.black)
                                        .font(.system(size:15, weight: .regular))
                                    
                                }
                                
                                Spacer()
                                
                            }
                            .padding(.top, 5)
                            .padding(.horizontal, 20)
                            
                            HStack {
                                
                                if item.reviewlong == 1 || item.reviewlong == 2 {
                                    
                                    Button(action: {
                                        
                                        let idx = reviewarray.enumerated().filter({ $0.element.reviewid == "\(item.reviewid)" }).map({ $0.offset })
                                        
                                        //reviewarray.indexes(of: "B")
                                        reviewarray[idx[0]].reviewlong = 0
                                        
                                    }) {
                                        
                                        Text("자세히보기")
                                            .foregroundColor(.black)
                                            .font(.system(size:14, weight: .regular))
                                            .underline()
                                        
                                    }
                                    .padding(.trailing, 5)
                                    
                                }
                                
                                Spacer()
                                
                            }
                            .padding(.top, 2)
                            .padding(.horizontal, 20)
                            
                            HStack {
                                
                                Button(action: {
                                    
                                    replyshow = true
                                    replycompletion = false
                                    reviewid = item.reviewid
                                    reviewinfo.nickname = item.nickname
                                    reviewinfo.timediffer = item.timediffer
                                    reviewinfo.review = item.review
                                    
                                    hideKeyboard()
                                    
                                    getReply(dist: "initselect", no: 0, snsid: logininfo.snsid, appid: logininfo.appid, nickname: "", stid: stationid, reviewid: reviewid, replyid: "", reply: "", level: "2", time: "")
                                    
                                }) {
                                    
                                    Text("댓글 \(item.replycount)개")
                                        .foregroundColor(.black)
                                        .font(.system(size:14, weight: .semibold))
                                    
                                }
                                .padding(.trailing, 5)
                                
                                Spacer()
                                
                                if item.mine == 1 {
                                    
                                    Button(action: {
                                        
                                        hideKeyboard()
                                        
                                        reviewupdateshow = true
                                        reviewupdatetxt = item.review
                                        reviewid = item.reviewid
                                        
                                    }) {
                                        Text("수정")
                                            .foregroundColor(.black)
                                            .font(.system(size:14, weight: .light))
                                        
                                    }
                                    .padding(.trailing, 5)
                                    
                                    Button(action: {
                                        
                                        reviewid = item.reviewid //이렇게 할당을 해줘야함
                                        reviewdelalert = true
                                        
                                    }) {
                                        Text("삭제")
                                            .foregroundColor(.black)
                                            .font(.system(size:14, weight: .light))
                                        
                                    }
                                    .padding(.trailing, 5)
                                    .alert(isPresented: $reviewdelalert) {
                                                Alert(title: Text("리뷰를 완전히 삭제 하시겠습니까?"), message: Text(""), primaryButton: .destructive(Text("삭제")) {
                                                    
                                                    getReview(dist: "delete", no: 0, snsid: logininfo.snsid, appid: logininfo.appid, nickname: "", stid: stationid, reviewid: reviewid, review: "", level: "1", time: "")
                                                    
                                                    hideKeyboard()
                                                    
                                                }, secondaryButton: .cancel(Text("취소")))
                                            }
                                    
                                }
                                
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            
                            Divider()
                                .padding(.top, 5)
                                .padding(.horizontal, 20)

                        }
                        
                        HStack{
                            
                            Button(action: {
                                
                                hideKeyboard()
                                
                                print(reviewarray.last!.no)
                                
                                getReview(dist: "addselect", no: reviewarray.last!.no, snsid: logininfo.snsid, appid: logininfo.appid, nickname: logininfo.nickname, stid: stationid, reviewid: reviewid, review: reviewupdatetxt, level: "1", time: "")
                                
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
                    .contentShape(Rectangle())
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
        
        if dist == "initselect" {
            
            reviewarray = []
            
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
                            
                            var temp = ReviewInfo()
                            
                            temp.nickname = stdata[0] as! String
                            temp.stid = stdata[1] as! String
                            temp.reviewid = stdata[2] as! String
                            temp.review = stdata[3] as! String
                            
                            //리뷰 글자수 및 줄바꿈이 2개 이상 더보기 기능
                            let checkreview = stdata[3] as! String
                            let smallreview = String(checkreview.prefix(100))
                            let countreview =  smallreview.components(separatedBy:"\n")
                                                            
                            if checkreview.count > 100 {
                                
                                temp.reviewlong = 1
                                
                            } else if countreview.count > 2 {
                                
                                temp.reviewlong = 2
                                
                            } else {
                                
                                temp.reviewlong = 0
                                
                            }
                            
                            temp.level = stdata[4] as! String
                            temp.time = stdata[5] as! String
                            temp.timediffer = timeDiffer(time: stdata[5] as! String)
                            temp.no = stdata[6] as! Int
                            temp.mine = stdata[7] as! Int
                            temp.replycount = stdata[8] as! Int
                            
                            DispatchQueue.main.async {
                                
                                switch dist {

                                case "insert":
                                    
                                    reviewarray.insert(temp, at: 0)
                                    
                                case "delete":
                                    
                                    let idx = reviewarray.firstIndex(where: {$0.reviewid == reviewid}) as Any
                                    reviewarray[idx as! Int] = temp
                                    

                                default:
                                    
                                    reviewarray.append(temp)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
                if newValue.count == 0 && dist == "delete" {
                    
                    let idx = reviewarray.firstIndex(where: {$0.reviewid == reviewid})!
                    reviewarray.remove(at: idx)
                    
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
        
        if dist == "initselect" {
        
            replyarray = []
            
        }
        
        let task = session.dataTask(with: requestURL, completionHandler:
        {
            (data, response, error) -> Void in
            
            do {
                
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers])

                print(jsonResult)
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
                
            } catch {
                print("raw data error")
                
            }
            replycompletion = true

        })
        task.resume()
        
    }
    
}


struct ReviewUpdate : View {
    
    @Binding var reviewupdateshow : Bool
    @Binding var reviewupdatetxt : String
    @Binding var reviewid : String
    
    @Binding var reviewarray : [ReviewInfo]
    
    @Binding var logininfo : LogInInfo
    @Binding var stationid : String
    
    @State var showalert = false
    
    var body : some View {
        
        VStack{
            
            ScrollView{
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        
                        reviewupdateshow = false
                        hideKeyboard()

                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray_t2)
                            //.font(.system(size:15, weight: .regular))
                    }
                    
                }
                
                HStack{
                    
                    Text("리뷰 수정")
                        .foregroundColor(.gray_t3)
                        .font(.system(size:15, weight: .regular))
                    Spacer()
                    
                }
                
                MultilineTextField("", text: $reviewupdatetxt)
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
                    .onReceive(reviewupdatetxt.publisher.collect()) {
                        self.reviewupdatetxt = String($0.prefix(500))
                        }
                    
                //Spacer()
                HStack{
                    
                    Text("\(reviewupdatetxt.count)/500")
                        .font(.system(size:13, weight: .regular))
                        .foregroundColor(.gray_t3)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        hideKeyboard()
                        
                        getReview(dist: "update", no: 0, snsid: logininfo.snsid, appid: logininfo.appid, nickname: logininfo.nickname, stid: stationid, reviewid: reviewid, review: reviewupdatetxt, level: "1", time: "")
                        
                    }) {
                        Text("확인")
                            .foregroundColor(.blue)
                            .font(.system(size:14, weight: .regular))
                        
                    }
                    //.padding(.vertical, 10)
                    .background(Color.white)
                    .alert(isPresented: $showalert) {
                        Alert(title: Text("리뷰가 수정되었습니다."),
                              message: Text(""),
                              dismissButton: .default(Text("확인"), action: {
                                                        reviewupdateshow = false
                                                        reviewupdatetxt = ""}
                                
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
    
    func getReview(dist: String, no: Int, snsid: String, appid: String, nickname: String, stid: String, reviewid: String, review: String, level: String, time: String) {

        let endPoint = "https://lzt8xnncia.execute-api.ap-northeast-2.amazonaws.com/getreview?dist=\(dist)&no=\(no)&snsid=\(snsid)&appid=\(appid)&nickname=\(nickname)&stid=\(stid)&reviewid=\(reviewid)&review=\(review)&level=\(level)&time=\(time)"
        
        let encodedQuery: String = endPoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
        
        let requestURL = URLRequest(url: queryURL)
        let session = URLSession.shared
        
        /*
        if dist == "initselect" {
            
            reviewarray = []
            
        }
         */
        
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
                            
                            var temp = ReviewInfo()
                            
                            temp.nickname = stdata[0] as! String
                            temp.stid = stdata[1] as! String
                            temp.reviewid = stdata[2] as! String
                            temp.review = stdata[3] as! String
                            
                            //리뷰 글자수 및 줄바꿈이 2개 이상 더보기 기능
                            let checkreview = stdata[3] as! String
                            let smallreview = String(checkreview.prefix(100))
                            let countreview =  smallreview.components(separatedBy:"\n")
                                                            
                            if checkreview.count > 100 {
                                
                                temp.reviewlong = 1
                                
                            } else if countreview.count > 2 {
                                
                                temp.reviewlong = 2
                                
                            } else {
                                
                                temp.reviewlong = 0
                                
                            }
                            
                            temp.level = stdata[4] as! String
                            temp.time = stdata[5] as! String
                            temp.timediffer = timeDiffer(time: stdata[5] as! String)
                            temp.no = stdata[6] as! Int
                            temp.mine = stdata[7] as! Int
                            temp.replycount = stdata[8] as! Int
                            
                            DispatchQueue.main.async {
                                
                                switch dist {
                                    
                                case "update":
                                    
                                    let idx = reviewarray.firstIndex(where: {$0.reviewid == reviewid}) as Any
                                    reviewarray[idx as! Int] = temp

                                default:
                                    
                                    reviewarray.append(temp)
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

