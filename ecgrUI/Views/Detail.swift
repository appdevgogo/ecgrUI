import SwiftUI
import MessageUI


struct Detail : View {
    
    @Binding var searchshow : Bool
    @Binding var stationshow : Bool
    @Binding var stationmapshow : Bool
    @Binding var stationinfo : StationInfo
    @Binding var stationarray : [StationInfo]
    @Binding var scompletion : Bool
    @Binding var stationid : String
    
    @Binding var logininfo : LogInInfo
    @Binding var checkbookmark : Bool
    @Binding var mscompletion : Bool
    
    @Binding var bookmarkarray : [BookMarkInfo]
    
    @Binding var reviewshow : Bool
    @Binding var rcompletion : Bool
    @Binding var rfcompletion : Bool
    @Binding var reviewfirstcount : Int
    @Binding var reviewfirsttxt : String
    @Binding var reviewarray : [ReviewInfo]
    
    @Binding var repairshow : Bool
    
    //상세페이지는 검색, 북마크 등 경로가 다양하므로 init문구를 작성하여 단일화해야함
    init(searchshow: Binding<Bool>, stationshow: Binding<Bool>, stationmapshow: Binding<Bool>, stationinfo: Binding<StationInfo>, stationarray: Binding<[StationInfo]>, scompletion: Binding<Bool>, stationid: Binding<String>, logininfo: Binding<LogInInfo>, checkbookmark: Binding<Bool>, mscompletion: Binding<Bool>, bookmarkarray: Binding<[BookMarkInfo]>, reviewshow: Binding<Bool>, rcompletion: Binding<Bool>, rfcompletion: Binding<Bool>, reviewfirstcount: Binding<Int>, reviewfirsttxt: Binding<String>, reviewarray: Binding<[ReviewInfo]>, repairshow: Binding<Bool>){
        
        _searchshow = searchshow
        _stationshow = stationshow
        _stationmapshow = stationmapshow
        _stationinfo = stationinfo
        _stationarray = stationarray
        _scompletion = scompletion
        _stationid = stationid
        
        _logininfo = logininfo
        _checkbookmark = checkbookmark
        _mscompletion = mscompletion
        
        _bookmarkarray = bookmarkarray
        
        _reviewshow = reviewshow
        _rcompletion = rcompletion
        _rfcompletion = rfcompletion
        _reviewfirstcount = reviewfirstcount
        _reviewfirsttxt = reviewfirsttxt
        _reviewarray = reviewarray
        
        _repairshow = repairshow
        
        //if self.stationshow 문구를 바로 사용하지 않는 이유는 가끔 작동이 틀어져서 안될때가 있음
        checkBookMark()
        getFirstReview()
            
    }
    
    var body : some View {
        
        VStack(spacing: 0){
            
            if scompletion == false {
                
                if #available(iOS 14.0, *) {
                    
                    ProgressView()
                    
                } else {
                    
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                
            } else {
                
                HStack (spacing: 0){
                    
                    Button(action: {
                        
                        stationshow = false
                        rfcompletion = false

                    }) {
                        Image(systemName: "arrow.left")
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                    
                    if checkbookmark {
                        
                        Button(action: {
                            
                            checkbookmark = false
                                
                            updateBookMark(dist: "remove", snsid: logininfo.snsid, appid: logininfo.appid, stnm: stationarray[0].statNm, stid: stationarray[0].statId)
                            
                        }) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            
                        }
                        .padding(.trailing, 5)
                        
                    } else {
                        
                        Button(action: {
                            
                            checkbookmark = true
                                
                            updateBookMark(dist: "add", snsid: logininfo.snsid, appid: logininfo.appid, stnm: stationarray[0].statNm, stid: stationarray[0].statId)
                                
                        }) {
                            Image(systemName: "star")
                            
                        }
                        .padding(.trailing, 5)
                        
                    }
                    
                }
                .foregroundColor(.gray_t1)
                .font(.system(size:25, weight: .regular))
                .padding(.horizontal, 10)
                .padding(.top, 15)
                .padding(.bottom, 15)
                
                /*
                Divider()
                    .frame(height:0.25)
                    .background(Color.gray_t1)
                */
 
                ScrollView {
                    
                    HStack (spacing: 0){
                        
                        VStack(alignment: .leading){
                            
                            HStack{
                                
                                Text(stationarray[0].statNm)
                                    .foregroundColor(.black)
                                    .font(.system(size:20, weight: .regular))
                                
                                Button(action: {
                                    
                                    searchshow = false
                                    stationshow = false
                                    stationmapshow = true
                                    
                                    rfcompletion = false

                                }) {
                                    Image(systemName: "map")
                                        .foregroundColor(.gray)
                                        .font(.system(size:20, weight: .semibold))
                                }
                                .padding(.leading, 0)
                                
                            }
         
                            Text(stationarray[0].addr)

                         //   Text("인천 연수구 아카데미로 119")

                        }
                        .foregroundColor(.gray)
                        .font(.system(size:15, weight: .regular))
                        .padding(.leading, 20)
                        .padding(.trailing, 8)
                        .padding(.vertical, 5)
                        
                        Spacer()
                                     
                        Text("\(stationarray.last!.num)대가능")
                            .font(.system(size:23, weight: .semibold))
                            .foregroundColor(.blue)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.blue, lineWidth: 5)
                            )

                    }
                    .padding(.top, 2)
                    .padding(.bottom, 20)
                    .padding(.trailing, 22)
                    
                    
                    //아이폰 판매량이 SE사용자 점유율이 그래도 12%대 임(아마 연령이 낮지 않을까), 그래서 화면을 작은것
                    VStack(spacing:0){
                        
                        ForEach(stationarray, id: \.chgerId ) { item in
                            
                            HStack(){
                                
                                Spacer()
                                
                                HStack(){
                                    
                                    VStack(alignment: .center){
                                        
                                        switch item.powerType {
                                        
                                        case "":
                                            Text("완속")
                                                .font(.system(size:18, weight: .regular))
                                            
                                        default:
                                            Text("고속")
                                                .font(.system(size:18, weight: .regular))
                                        }
                                        
                                        switch item.stat {
                                        
                                        case 2:
                                            Text("충전가능")
                                                .foregroundColor(.blue)
                                                .font(.system(size:14, weight: .regular))
                                            
                                        case 3:
                                            Text("충전중")
                                                .foregroundColor(.green)
                                                .font(.system(size:14, weight: .regular))
                                            
                                        default:
                                            Text("점검중")
                                                .foregroundColor(.red)
                                                .font(.system(size:14, weight: .regular))
                                        }
                                        
                                        
                                    }
                                }
                                .frame(width: 55)
                                
                                Spacer()
                                
                                Divider()
                                
                                HStack(){
                                    
                                    Spacer()
                                    
                                    switch item.chgerType {
                                    
                                    case 1:
                                        VStack(){
                                            Image("cha")
                                            Text("DC차데모")
                                        }
                                        
                                    case 2:
                                        VStack(){
                                            Image("ac")
                                            Text("AC완속")
                                        }
                                        
                                    case 3:
                                        VStack(){
                                            Image("cha")
                                            Text("DC차데모")
                                        }
                                        VStack(){
                                            Image("ac3")
                                            Text("AC3상")
                                        }
                                        
                                    case 4:
                                        VStack(){
                                            Image("dc")
                                            Text("DC콤보")
                                        }
                                        
                                    case 5:
                                        VStack(){
                                            Image("cha")
                                            Text("DC차데모")
                                        }
                                        VStack(){
                                            Image("dc")
                                            Text("DC콤보")
                                        }

                                    case 6:
                                        VStack(){
                                            Image("cha")
                                            Text("DC차데모")
                                        }
                                        VStack(){
                                            Image("ac3")
                                            Text("AC3상")
                                        }
                                        VStack(){
                                            Image("dc")
                                            Text("DC콤보")
                                        }
                                        
                                    case 7:
                                        VStack(){
                                            Image("ac3")
                                            Text("AC3상")
                                        }
                                        
                                    default:
                                        Text("")
                                    }
                                    
                                    Spacer()
                                }
                                .foregroundColor(.gray_t3)
                                .font(.system(size:11, weight: .regular))
                                
                                
                                Divider()
                            
                                HStack() {
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .center){
                                        
                                        switch item.statUpdDt {
                                        
                                        case "":
                                            
                                            Text("-")
                                                .font(.system(size:12, weight: .regular))
                                                .foregroundColor(.gray)
                                            
                                        default:
                                            
                                            Text(item.statUpdDt.substring(with:2..<4)+"."+item.statUpdDt.substring(with:4..<6)+"."+item.statUpdDt.substring(with:6..<8))
                                               .font(.system(size:12, weight: .regular))
                                                .padding(.bottom, 0.0)
                                           
                                           Text(item.statUpdDt.substring(with:8..<10)+":"+item.statUpdDt.substring(with:10..<12)+":"+item.statUpdDt.substring(with:12..<14))
                                               .font(.system(size:12, weight: .regular))
                                            .padding(.bottom, 0.5)
                                           
                                           Text("최근상태변경")
                                            .font(.system(size:10, weight: .regular))
                                               .foregroundColor(.gray_t3)
                                               .padding(.top, 0)
                                        }
                                        
                                    }
                                       
                                    Spacer()
                                    
                                }
                                .frame(width: 70)
                                
                            }
                            .frame(height:90)
                            
                            Divider()
                                
                       }
                        
                    }
                    .border(Color.gray_t1, width:1)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 0)
                    
                    HStack{
                        
                        Spacer()
                        
                        Button(action: {
                            
                            stationinfo.statId = stationarray[0].statId
                            stationinfo.statNm = stationarray[0].statNm
                            
                            repairshow = true
                                
                        }) {
                            Text("고장신고")
                                .foregroundColor(.gray_t2)
                                .font(.system(size:14, weight: .regular))
                            
                        }
                        .padding(.trailing, 5)
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        
                        //globalTest()
                        
                        reviewshow = true
                        rcompletion = false
                        rcompletion = true
                        stationid = stationarray[0].statId
                        
                        getReview(dist: "initselect", no: 0, snsid: logininfo.snsid, appid: logininfo.appid, nickname: "", stid: stationid, reviewid: "", review: "", level: "1", time: "")
                                
                    }) {
                        
                        VStack{
                            
                            if rfcompletion == false {
                                
                                if #available(iOS 14.0, *) {
                                    
                                    ProgressView()
                                    
                                } else {
                                    
                                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                                }
                                
                            } else {
                                
                                HStack{
                                    
                                    Text("리뷰")
                                        .foregroundColor(.black)
                                        .font(.system(size:18, weight: .regular))
                                    
                                    Text("\(reviewfirstcount)개")
                                        .foregroundColor(.gray)
                                        .font(.system(size:18, weight: .regular))
                                    
                                    /*
                                    Image(systemName: "chevron.down.square")
                                        .foregroundColor(.gray)
                                        .font(.system(size:18, weight: .regular))
                                    */
     
                                    Spacer()
                                    
                                }
                                
                                HStack{
                                    
                                    Text(String(reviewfirsttxt.prefix(50)) + " ..")
                                        .foregroundColor(.gray)
                                        .font(.system(size:15, weight: .regular))
                                    
                                    Spacer()
                                        
                                }
                                .padding(.top, 2)

                            }
                            
                        }
                        
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    
                    
                    HStack{
                        
                        Text("사진")
                            .font(.system(size:18, weight: .regular))
                        
                        /*
                        if stationshow == true {
                            
                            ImageView(withURL: "https://www.ev.or.kr/file/viewImage/?atch_id=13698")
                        }
                        */
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    
                }
                  
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
    func checkBookMark() {
        
        if stationshow == true && reviewshow == false && repairshow == false {
            
            print("========================> Detail.swift의 checkBookMark 실행")
            
            let dist = "check"
            let snsid = logininfo.snsid
            let appid = logininfo.appid
            let stnm = ""
            let stid = stationid

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

                    guard let newValue = jsonResult as? [Int] else {
                        print("data type error")
                        return
                           
                    }
                    
                    if newValue[0] == 1 {
                        
                        self.checkbookmark = true
                        
                    } else {
                        
                        self.checkbookmark = false
                        
                    }
                    
                    
                } catch {
                    print("raw data error")
                    
                }

            })
            task.resume()
        }
        
    }
    
    func updateBookMark(dist: String, snsid: String, appid: String, stnm : String, stid: String) {

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
    
    func getFirstReview() {
        
        if stationshow == true && reviewshow == false && repairshow == false {
            
            print("========================> Detail.swift의 getFirstReview 실행")
            
            let dist = "firstselect"
            let no = 0
            let snsid = logininfo.snsid
            let appid = logininfo.appid
            let nickname = ""
            let stid = stationid
            let reviewid = ""
            let review = ""
            let level = "1"
            let time = ""

            let endPoint = "https://lzt8xnncia.execute-api.ap-northeast-2.amazonaws.com/getreview?dist=\(dist)&no=\(no)&snsid=\(snsid)&appid=\(appid)&nickname=\(nickname)&stid=\(stid)&reviewid=\(reviewid)&review=\(review)&level=\(level)&time=\(time)"
            
            let encodedQuery: String = endPoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let queryURL: URL = URL(string: encodedQuery)!
            
            let requestURL = URLRequest(url: queryURL)
            let session = URLSession.shared
            
            DispatchQueue.main.async {
                
                reviewfirstcount = 0
                reviewfirsttxt = ""
                rfcompletion = true
                
            }
            
            let task = session.dataTask(with: requestURL, completionHandler:
            {
                (data, response, error) -> Void in
                
                do {
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers])

                    guard let newValue = jsonResult as? [Any] else {
                        print("no first review")
                        return
                           
                    }
                    
                    DispatchQueue.main.async {
                        
                        reviewfirstcount = newValue[0] as! Int
                        reviewfirsttxt = newValue[2] as! String
                        
                    }
                    
                } catch {
                    print("raw data error")
                    
                }
                DispatchQueue.main.async {
                
                    rfcompletion = true
                    
                }

            })
            task.resume()
            
        }
        
    }
    
    func getReview(dist: String, no: Int, snsid: String, appid: String, nickname: String, stid: String, reviewid: String, review: String, level: String, time: String) {
        
        if reviewshow {

            let endPoint = "https://lzt8xnncia.execute-api.ap-northeast-2.amazonaws.com/getreview?dist=\(dist)&no=\(no)&snsid=\(snsid)&appid=\(appid)&nickname=\(nickname)&stid=\(stid)&reviewid=\(reviewid)&review=\(review)&level=\(level)&time=\(time)"
            
            let encodedQuery: String = endPoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let queryURL: URL = URL(string: encodedQuery)!
            
            let requestURL = URLRequest(url: queryURL)
            let session = URLSession.shared
            
            reviewarray = []
                
            let task = session.dataTask(with: requestURL, completionHandler:
            {
                (data, response, error) -> Void in
                
                do {
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers])
                    
                    guard let newValue = jsonResult as? Array<Any> else {
                        print("data type error get reivew")
                        return
                           
                    }
                    
                    if newValue.count > 0 {
                        
                        for item in newValue{
                            
                            if let stdata = item as? [Any]{
                                
                                //print(stdata)
                                
                                var temp = ReviewInfo()
                                
                                temp.nickname = stdata[0] as! String
                                temp.stid = stdata[1] as! String
                                temp.reviewid = stdata[2] as! String
                                temp.review = stdata[3] as! String
                                
                                //리뷰 글자수 및 줄바꿈이 2개 이상 더보기 기능
                                let checkreview = stdata[3] as! String
                                let smallreview = String(checkreview.prefix(100))
                                let countreview =  smallreview.components(separatedBy:"\n")
                                
                                print(countreview)
                                                                
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
                                    
                                    reviewarray.append(temp)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }

                } catch {
                    print("raw data error")
                    
                }
                rcompletion = true

            })
            task.resume()
            
        }
    }

}

