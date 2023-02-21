
import SwiftUI
import RealmSwift

struct Search : View {
    
    @Binding var logininfo : LogInInfo
    
    @Binding var qtxt : String
    @Binding var searchshow : Bool
    @Binding var searchmapshow : Bool
    @Binding var stationshow : Bool
    @Binding var stationgetdata : Bool
    @Binding var scompletion : Bool
    
    @Binding var asearchinfo : ASearchInfo
    @Binding var asearcharray : [ASearchInfo]
    
    @Binding var bsearchinfo : BSearchInfo
    @Binding var bsearcharray : [BSearchInfo]
    
    @Binding var csearchinfo : CSearchInfo
    @Binding var csearcharray : [CSearchInfo]
    
    @Binding var rsearchinfo : RSearchInfo
    @Binding var rsearcharray : [RSearchInfo]
    
    @Binding var lsearchinfo : LSearchInfo
    @Binding var stationid : String
    
    @Binding var latori : Double
    @Binding var lngori : Double
    
    
    //뷰가 시작되자마자 시작되는 함수(지속적으로 변경되야 하므로 필요함)
    init(logininfo: Binding<LogInInfo>, qtxt: Binding<String>, searchshow: Binding<Bool>, searchmapshow: Binding<Bool>, stationshow: Binding<Bool>, stationgetdata: Binding<Bool>, scompletion: Binding<Bool>, asearchinfo: Binding<ASearchInfo>, asearcharray: Binding<[ASearchInfo]>, bsearchinfo: Binding<BSearchInfo>, bsearcharray: Binding<[BSearchInfo]>, csearchinfo: Binding<CSearchInfo>, csearcharray: Binding<[CSearchInfo]>, rsearchinfo: Binding<RSearchInfo>, rsearcharray: Binding<[RSearchInfo]>, lsearchinfo: Binding<LSearchInfo>, stationid: Binding<String>, latori: Binding<Double>, lngori: Binding<Double>) {
        
        _logininfo = logininfo
        
        _qtxt = qtxt
        _searchshow = searchshow
        _searchmapshow = searchmapshow
        _stationshow = stationshow
        _stationgetdata = stationgetdata
        _scompletion = scompletion
        
        _asearchinfo = asearchinfo
        _asearcharray = asearcharray
        
        _bsearchinfo = bsearchinfo
        _bsearcharray = bsearcharray

        _csearchinfo = csearchinfo
        _csearcharray = csearcharray
        
        _rsearchinfo = rsearchinfo
        _rsearcharray = rsearcharray
        
        _lsearchinfo = lsearchinfo
        _stationid = stationid
        
        _latori = latori
        _lngori = lngori
        
        requestNAS()
        requestALB()
        requestALS()
        
    }
    
    var body : some View {
        
        if asearcharray.count != 0 {
            
            Text("장소주변 지도로 보기")
                .modifier(SearchTitle())
                .padding(.top, 5)
           
            ForEach(asearcharray, id: \.id) {item in
                
                Button(action: {
                    
                    let rsid = item.name + "+" + item.addr
                    
                    searchBtnAct(snsid: logininfo.snsid, appid: logininfo.appid, dist: "add", group: 1, name: item.name, lat: item.lat, lng: item.lng, rsid: rsid)
                    
                    print("A클릭")
                    print(item.lat, item.lng)
                
                }){
                    
                    SearchBtnView(group: 1, icon: "location", qtxt: qtxt, name: item.name, addr: item.addr)
                    
                }
                .foregroundColor(Color.black)
                
            }
            .padding(.vertical, 10)
            
            Divider()
                .padding(.vertical, 10)
                
        }
        
        if bsearcharray.count != 0 {
            
            Text("지역 지도로 보기")
                .modifier(SearchTitle())
            
            ForEach(bsearcharray, id: \.bcode) {item in
                
                Button(action: {
            
                    searchBtnAct(snsid: logininfo.snsid, appid: logininfo.appid, dist: "add", group: 2, name: item.addr, lat: item.lat, lng: item.lng, rsid: item.bcode)
                    
                    print("B클릭")
                                   
                }){
                           
                    SearchBtnView(group: 2, icon: "aspectratio", qtxt: qtxt, name: item.addr, addr: "")
                    
                }
                .foregroundColor(Color.black)
                
            }
            .padding(.vertical, 10)
            
            Divider()
                .padding(.vertical, 10)
        }
        
        if csearcharray.count != 0 {
            
            Text("충전소 바로가기")
                .modifier(SearchTitle())
            
            ForEach(csearcharray, id: \.statid) {item in
                
                Button(action: {
                    
                    searchBtnAct(snsid: logininfo.snsid, appid: logininfo.appid, dist: "add", group: 3, name: item.name, lat: 0.0, lng: 0.0, rsid: item.statid)
                    
                    print("C클릭")
                    
                }){
                    
                    SearchBtnView(group: 3, icon: "flag", qtxt: qtxt, name: item.name, addr: item.addr)
                    
                }
                .foregroundColor(Color.black)
                
            }
            .padding(.vertical, 10)
            
            Divider()
                .padding(.vertical, 10)
        }

        
    }
    
    struct SearchBtnView : View {
        
        var group: Int
        var icon: String
        var qtxt: String
        var name: String
        var addr : String

        var body: some View {
            
            VStack{
                
                HStack{
                    
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .font(.system(size:17, weight: .semibold))
                    
                    let qttxt = qtxt.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    hilightedText(str: name, searched: qttxt)
                                .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                }
                
                if group != 2 {
                    
                    HStack{
                        
                        Image(systemName: icon)
                            .foregroundColor(.clear)
                            .font(.system(size:17, weight: .semibold))
                        
                        Text(addr)
                            .foregroundColor(.gray)
                            .font(.system(size:15, weight: .light))
                        
                        Spacer()
                        
                    }
                    
                }
                
            }
            .padding(.leading, 20)
            
            
        }
        
        func hilightedText(str: String, searched: String) -> Text {
            
                guard !str.isEmpty && !searched.isEmpty else { return Text(str) }

                var result: Text!
                let parts = str.components(separatedBy: searched)
            
                for i in parts.indices {
                    
                    result = (result == nil ? Text(parts[i]) : result + Text(parts[i]))
                    
                    if i != parts.count - 1 {
                        result = result + Text(searched).bold().foregroundColor(.blue)
                        
                    }
                    
                }
            
                return result ?? Text(str)
        }
        
    }
    
    func searchBtnAct(snsid: String, appid: String, dist: String, group: Int, name: String, lat: Double, lng: Double, rsid: String) {
        
        qtxt = ""
        
        //맵뷰에서 지도로 보여주기 위한 변수들
        lsearchinfo.group = group
        lsearchinfo.lat = lat
        lsearchinfo.lng = lng
        
        if group == 3 {
    
            stationid = rsid
            scompletion = false
            stationshow = true
            stationgetdata = true
            
        } else {
            
            searchmapshow = true
            searchshow = false
    
        }
        
        let endPoint = "https://jvexfu225b.execute-api.ap-northeast-2.amazonaws.com/getrsearch?snsid=\(snsid)&appid=\(appid)&dist=\(dist)&group=\(group)&name=\(name)&rsid=\(rsid)&lat=\(lat)&lng=\(lng)"
        
        print(endPoint)
        
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
                    
                    //add를 해준다음 새롭게 출력할 필요는 없음
                    print(item)

                }
                
            } catch {
                print("raw data error")
                
            }

        })
        task.resume()
        
    }
    
    
    //네이버 지역 검색(Naver Area Search)에 요청하는 함수
    func requestNAS() {
        
        print("============================> Search.swift request NAS")
        
        let clientID: String = "eMQlzNYcH6GoluyZiOvX"
        let clientKEY: String = "sr28VQpTX4"
        let qqtxt = qtxt.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (qqtxt.count >= 1) {
            
            let query: String  = "https://openapi.naver.com/v1/search/local.json?query=\(qqtxt)&display=3"
            let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let queryURL: URL = URL(string: encodedQuery)!
           
            var requestURL = URLRequest(url: queryURL)
            requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
            requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
            
            let session = URLSession.shared

            let task = session.dataTask(with: requestURL, completionHandler:
            {
                (data, response, error) -> Void in

                do {
                    
                    let ojson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                    
                    guard let jarray = ojson["items"] as? Array<Any> else {
                        print("data type error")
                        return
                    }
                    
                    asearcharray = []

                    for item in jarray{
                        
                        guard let addrdic = item as? Dictionary<AnyHashable, Any> else {
                            print("data type error")
                            return
                            
                        }

                        var temp = ASearchInfo()
                        
                        temp.name = (addrdic["title"] as! String).withoutHtmlTags
                        temp.addr = addrdic["address"] as! String
                        temp.lat = (addrdic["mapy"] as! NSString).doubleValue
                        temp.lng = (addrdic["mapx"] as! NSString).doubleValue
                        
                        print(temp.lat, temp.lng)
                        
                        DispatchQueue.main.async {
                            asearcharray.append(temp)
                        }
                        
                    }
               
                } catch {
                    print("raw data error")
                    
                }

            })
            task.resume()
            
        }

    }

    //아마존 람다(Amazon Lambda)를 통해 법정동(B)의 위경도를 가져오는 함수
    func requestALB() {
        
        print("============================> Search.swift request ALB")
        
        /*
        if qtxt.contains("도") || qtxt.contains("시") || qtxt.contains("군") || qtxt.contains("구") || qtxt.contains("동") || qtxt.contains("읍") || qtxt.contains("면") || qtxt.contains("리")  {
     */
        let qarray = qtxt.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
        
        if (qarray.count >= 1) {
            
            var t_first = ""
            var t_second = ""
            var t_third = ""
            var t_fourth = ""
            var t_fifth = ""
            
            switch qarray.count {
            
            case 1:
                t_first = qarray[0]

            case 2:
                t_first = qarray[0]
                t_second = qarray[1]
                
            case 3:
                t_first = qarray[0]
                t_second = qarray[1]
                t_third = qarray[2]
                
            case 4:
                t_first = qarray[0]
                t_second = qarray[1]
                t_third = qarray[2]
                t_fourth = qarray[3]
                
            case 5:
                t_first = qarray[0]
                t_second = qarray[1]
                t_third = qarray[2]
                t_fourth = qarray[3]
                t_fifth = qarray[4]
                
            default:
                print("")
            }
            
            let endPoint = "https://dx41q1hh0j.execute-api.ap-northeast-2.amazonaws.com/getsearchb?t_first=\(t_first)&t_second=\(t_second)&t_third=\(t_third)&t_fourth=\(t_fourth)&t_fifth=\(t_fifth)"
            
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
                    
                    bsearcharray = []
                    
                    for item in newValue{
                        
                        if let stdata = item as? [Any]{
                            
                            var temp = BSearchInfo()
                            
                            temp.bcode = stdata[0] as! String
                            temp.addr = stdata[1] as! String
                            temp.lat = stdata[2] as! Double
                            temp.lng = stdata[3] as! Double
                            
                            
                            DispatchQueue.main.async {
                                bsearcharray.append(temp)
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
    
    //아마존 람다(Amazon Lambda)를 통해 충전소(Station) 정보를 가져오는 함수
    func requestALS() {
        
        print("============================> Search.swift request ALS")
        
        let qqtxt = qtxt.trimmingCharacters(in: .whitespacesAndNewlines)
        if (qqtxt.count >= 1) {
            
            let realm = try! Realm()
            
            let crtlocation = realm.objects(locationCRT.self).first
            
            let latc = String(crtlocation!.latcrt)
            let lngc = String(crtlocation!.lngcrt)
            
            let endPoint = "https://o3y6a82aq9.execute-api.ap-northeast-2.amazonaws.com/getsearchc?txt=\(qqtxt)&latc=\(latc)&lngc=\(lngc)"
            
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
                    
                    csearcharray = []
                    
                    for item in newValue{
                        
                        if let stdata = item as? [Any]{
                            
                            var temp = CSearchInfo()
                                
                            temp.statid = stdata[0] as! String
                            temp.name = stdata[1] as! String
                            temp.addr = stdata[2] as! String
                            
                            DispatchQueue.main.async {
                                csearcharray.append(temp)
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
    
}


struct RSearch : View {
    
    @Binding var logininfo : LogInInfo
    
    @Binding var searchshow : Bool
    @Binding var searchmapshow : Bool
    @Binding var stationshow : Bool
    @Binding var stationgetdata : Bool
    @Binding var scompletion : Bool
    
    @Binding var rsearchinfo : RSearchInfo
    @Binding var rsearcharray : [RSearchInfo]
    @Binding var lsearchinfo : LSearchInfo
    @Binding var stationid : String
    
    @Binding var latori : Double
    @Binding var lngori : Double
    
    init(logininfo : Binding<LogInInfo>, searchshow : Binding<Bool>, searchmapshow : Binding<Bool>, stationshow : Binding<Bool>, stationgetdata : Binding<Bool>, scompletion : Binding<Bool>, rsearchinfo: Binding<RSearchInfo>, rsearcharray : Binding<[RSearchInfo]>, lsearchinfo : Binding<LSearchInfo>, stationid : Binding<String>, latori : Binding<Double>, lngori : Binding<Double>) {
        
        _logininfo = logininfo
    
        _searchshow = searchshow
        _searchmapshow = searchmapshow
        _stationshow = stationshow
        _stationgetdata = stationgetdata
        _scompletion = scompletion
        
        _rsearchinfo = rsearchinfo
        _rsearcharray = rsearcharray
        _lsearchinfo = lsearchinfo
        _stationid = stationid
        
        _latori = latori
        _lngori = lngori
        
        getrsearch(dist: "select", group: 0, name: "", rsid: "", lat: 0.0, lng: 0.0)

    }
    
    var body : some View {
         
        Text("최근검색")
            .padding(.top, 5)
            .modifier(SearchTitle())
                
        ForEach(rsearcharray, id: \.rsid) {item in
            
            HStack{
              
                Button(action: {
                    
                    if item.group == 3 {
                        
                        stationid = item.rsid
                        scompletion = false
                        stationshow = true
                        stationgetdata = true
                        hideKeyboard()
                        
                    } else {
                        
                        lsearchinfo.group = item.group
                        lsearchinfo.lat = item.lat
                        lsearchinfo.lng = item.lng

                        searchmapshow = true
                        searchshow = false
                        
                    }
                    
                }){
                    
                    HStack{
                        
                        if item.group == 1 {
                            
                            Image(systemName: "location")
                                .foregroundColor(.gray)
                                .font(.system(size:17, weight: .semibold))
                            
                        } else if item.group == 2 {
                            
                            Image(systemName: "aspectratio")
                                .foregroundColor(.gray)
                                .font(.system(size:17, weight: .semibold))
                            
                        } else if item.group == 3 {
                            
                            Image(systemName: "flag")
                                .foregroundColor(.gray)
                                .font(.system(size:17, weight: .semibold))
                            
                        }
                        
                            Text(item.name)
                                .font(.system(size:17, weight: .regular))
                        
                        Spacer()
                        
                    }
                    .padding(.leading, 20)
                    
                }
                .foregroundColor(Color.black)
                
                Button(action: {
                    
                    getrsearch(dist: "remove", group: item.group, name: item.name, rsid: item.rsid, lat: 0.0, lng: 0.0)
                    
                    print(item.rsid)
                    
                }){
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .font(.system(size:15, weight: .regular))
                    
                }
                .padding(.trailing, 20)
                
            }
            
        }
        .padding(.vertical, 10)
        
        Button(action: {
            
            getrsearch(dist: "removeall", group: 0, name: "", rsid: "", lat: 0.0, lng: 0.0)
            
        }) {
            
            Text("전체삭제")
                .padding(.top, 15)
                .foregroundColor(.gray_t3)
                .font(.system(size:14, weight: .regular))
            
        }

    }
    
    func getrsearch(dist: String, group: Int, name: String, rsid: String, lat: Double, lng: Double) {
        
        print("========================> Search.swift(R)의 getrsearch 실행됨")
        
        let snsid = logininfo.snsid
        let appid = logininfo.appid
        
        let endPoint = "https://jvexfu225b.execute-api.ap-northeast-2.amazonaws.com/getrsearch?snsid=\(snsid)&appid=\(appid)&dist=\(dist)&group=\(group)&name=\(name)&rsid=\(rsid)&lat=\(lat)&lng=\(lng)&"
        
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
                    print("no value from AWS or data type error")
                    return
                       
                }
                
                rsearcharray = []
                
                for item in newValue{
                    
                    if let stdata = item as? [Any]{
                        
                        var temp = RSearchInfo()
                            
                        temp.group = Int((stdata[0] as! NSString).intValue)
                        temp.name = stdata[1] as! String
                        temp.rsid = stdata[2] as! String
                        temp.lat = Double((stdata[3] as! NSString).doubleValue)
                        temp.lng = Double((stdata[4] as! NSString).doubleValue)
                        
                        DispatchQueue.main.async {
                            
                            rsearcharray.append(temp)
                            
                        }
                            
                    }

                }
 
                
            } catch {
                print("no value from AWS")
                
            }

        })
        task.resume()
        
    }

}
/*
class rsearchDB : Object {
    
    @objc dynamic var title = ""
    @objc dynamic var dist : Int = 0
 //   @objc dynamic var addr = ""
    @objc dynamic var lat : Double = 0.0
    @objc dynamic var lng : Double = 0.0
    @objc dynamic var statid = ""
    @objc dynamic var time : Date = Date()
    
}
*/

struct SearchTitle: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content
            .padding(.top, 15)
            .padding(.bottom, 5)
            .padding(.horizontal, 20)
            .font(.system(size:14, weight: .semibold))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
}
