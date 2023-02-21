import SwiftUI
import NMapsMap
import Combine
import RealmSwift

//swiftUI기반 지도서비스구현(네어버지도 서비스는 swift지원)
//양 언어간 변수를 공유하려면 일종의 브릿지가 필요함
struct MapView : UIViewControllerRepresentable {
    
    @Binding var stationshow : Bool
    @Binding var stationmapshow : Bool //상세페이지 나올때 지도아이콘 클릭히 지도로 이동하는 핸들러
    @Binding var stationinfo : StationInfo  //관련된것 지워도 될듯함
    @Binding var stationarray : [StationInfo]
    @Binding var scompletion : Bool
    
    @Binding var searchmapshow : Bool //검색후 나오는 결과물 클릭시 지도로 이동하는 핸들러
    @Binding var lsearchinfo : LSearchInfo
    
    @Binding var stationgetdata : Bool
    @Binding var stationid : String
    
    @Binding var logininfo : LogInInfo
    
    @Binding var filtershow : Bool
    @Binding var afcompletion : Bool
    @Binding var bfcompletion : Bool
    @Binding var afilterarray : [Int]
    @Binding var bfilterarray : [BFilterInfo]
    
    @Binding var latori : Double
    @Binding var lngori : Double

    func makeUIViewController(context: Context) -> MapViewController {
        
        let mapview = MapViewController(stationshow: $stationshow, stationmapshow: $stationmapshow, stationinfo: $stationinfo, stationarray: $stationarray, scompletion: $scompletion, stationid: $stationid, logininfo: $logininfo, filtershow: $filtershow, afcompletion: $afcompletion, bfcompletion: $bfcompletion, afilterarray: $afilterarray, bfilterarray: $bfilterarray, latori: $latori, lngori: $lngori)

        return mapview
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        
        //상세페이지에서 지도이미지를 클릭시 위치를 보여주는 함수
        if stationmapshow {
            
            print("========================> MapView의 stationmapshow 함수 실행")
            
            uiViewController.camerUpdating(lat: stationarray[0].lat, lng: stationarray[0].lng)
            
            DispatchQueue.main.async {
                
                stationmapshow = false
                
            }
            
        }
        
        if searchmapshow {
            
            print("========================> MapView의 searchmapshow 함수 실행")
            
            if lsearchinfo.group == 1 {
    
                let tm128 = NMGTm128(x: lsearchinfo.lng, y: lsearchinfo.lat)
                let latlng = tm128.toLatLng()
                
                print(latlng)
                
                uiViewController.camerUpdating(lat: latlng.lat, lng: latlng.lng)
                
            } else {
                
                uiViewController.camerUpdating(lat: lsearchinfo.lat, lng: lsearchinfo.lng)
                
            }
            
            DispatchQueue.main.async {
                
                searchmapshow = false
                
            }

        }
        
        if stationgetdata {
            
            print("========================> MapView의 stationgetdata 함수 실행")
            
            uiViewController.getstationInfo(statId: stationid)
            
            DispatchQueue.main.async {
                
                stationgetdata = false
                
            }
            
        }
        
        //1.필터클릭 하자마자 바로 맵뷰에 적용되게 하기위함
        //2.필터on->off로 될때 맵뷰에 적용되게 하기위함
        //3.필터on인상태에서 타입을 모두지우기 했을때 적용되게 하기 위함
        //4.(공통)충전소상세보기시에는 적용되지 않음
        if (afilterarray[0] == 1 && (bfilterarray.filter{$0.on == 1}).count > 0) || (afilterarray[0] == 0 && filtershow == true) || ((bfilterarray.filter{$0.on == 1}).count == 0 && filtershow == true) && stationshow == false {
            
            print("========================> MapView의 필터관련 함수 실행")
            
            uiViewController.getdatafromlocaldb(afilterarray: afilterarray, bfilterarray: bfilterarray)

        }
    
    }
    
}



class MapViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    
    @Binding var stationshow : Bool
    @Binding var stationmapshow : Bool
    @Binding var stationinfo : StationInfo
    @Binding var stationarray : [StationInfo]
    @Binding var scompletion : Bool
    @Binding var stationid : String
    
    @Binding var logininfo : LogInInfo
    
    @Binding var filtershow : Bool
    @Binding var afcompletion : Bool
    @Binding var bfcompletion : Bool
    @Binding var afilterarray : [Int]
    @Binding var bfilterarray : [BFilterInfo]
    
    @Binding var latori : Double
    @Binding var lngori : Double
    
    init(stationshow: Binding<Bool>, stationmapshow: Binding<Bool>, stationinfo: Binding<StationInfo>, stationarray: Binding<[StationInfo]>, scompletion: Binding<Bool>, stationid: Binding<String>, logininfo: Binding<LogInInfo>, filtershow: Binding<Bool>, afcompletion: Binding<Bool>, bfcompletion: Binding<Bool>, afilterarray: Binding<[Int]>, bfilterarray: Binding<[BFilterInfo]>, latori: Binding<Double>, lngori: Binding<Double>) {
        
        _stationshow = stationshow
        _stationmapshow = stationmapshow
        _stationinfo = stationinfo
        _stationarray = stationarray
        _scompletion = scompletion
        _stationid = stationid
        
        _logininfo = logininfo
        
        _filtershow = filtershow
        _afcompletion = afcompletion
        _bfcompletion = bfcompletion
        _afilterarray = afilterarray
        _bfilterarray = bfilterarray
        
        _latori = latori
        _lngori = lngori
        
        super.init(nibName: nil, bundle: nil)
        
        //로컬db(Realm) 경로
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        print(realmURL)
         
    }
    
    //UIView와 UIViewControllor 동시사용시 필요(인터넷 검색필요)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //위치 관련 변수선언
    var locationManager : CLLocationManager!
    var initLoading : Bool = false
    var markers: [NMFMarker] = [] //마커배열
    var markersold : [NMFMarker] = [] //마커배열 old
    
    //초기맵뷰를 위한 설정
    let mapView = NMFMapView(frame : CGRect(x: 0, y: 35, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 35)) //네이버맵 위치설정
    let img = NMFOverlayImage(name: "marker_13")
    let imgsq = NMFOverlayImage(name: "marker_sq3")//마커디자인이미지 설정
    
    //데이터를 받기위한 준비
    let group = DispatchGroup() //코딩순서설정(동기+비동기)
    
    //맵 초기로딩
    override func viewDidLoad() {
        
        print("-------------> MapView의 vieDidLoad 실행")
        
        super.viewDidLoad()
        view.addSubview(mapView)
        
        //네이버 지도 기본 설정들(네이버지도 설명서 참고)
        mapView.addCameraDelegate(delegate: self)
        mapView.logoAlign = .rightBottom
        mapView.logoMargin = .init(top: 0, left: 0, bottom: 30, right: 0)
        mapView.isTiltGestureEnabled = false
        mapView.isRotateGestureEnabled = false
        mapView.minZoomLevel = 6.0
        mapView.maxZoomLevel = 19.0
            
        //초기 위치 설정
        initLoading = true
        initlocation()

        //지도위에 생성되는 버튼
        mapViewBtn(x: 15, y: 35, w: 40, h: 40, imgname: "smallcircle.fill.circle", dist: "center" )
        mapViewBtn(x: 15, y: 85, w: 40, h: 40, imgname: "goforward", dist: "refresh" )
        mapViewBtn(x: UIScreen.main.bounds.width - 55, y: 35, w: 40, h: 40, imgname: "slider.horizontal.3", dist: "filter" )
        
        let (cameraRtop, cameraRbottom, cameraRright, cameraRleft) = cameraRange()
        
        requestmarkersInfo(t: cameraRtop, b: cameraRbottom, r: cameraRright, l: cameraRleft)
        
        DispatchQueue.main.async {
            
            self.getafilterInfo(dist: "initload", snsid: self.logininfo.snsid, appid: self.logininfo.appid, aidx: 0)
            
            self.getbfilterInfo(dist: "initload", snsid: self.logininfo.snsid, appid: self.logininfo.appid, stid: "")
            
            self.getdatafromlocaldb(afilterarray: self.afilterarray, bfilterarray: self.bfilterarray)
            
        }
        
    }
    
    //카메라 이동 또는 축소확대 직후 마커 생성 삭제에 관한 함수
    func mapViewCameraIdle(_ mapView: NMFMapView) {
    
        //최신 카메라위치 정보(위경도)를 로컬db에 저장함
        let lastcmr = locationCMR()
        lastcmr.latcmr = mapView.cameraPosition.target.lat
        lastcmr.lngcmr = mapView.cameraPosition.target.lng
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(lastcmr)
        }
        
        //네이버지도에 보여진 마커 모두 삭제
        for marker in markers{
            marker.mapView = nil
        }

        //markers 배열에 있는 마커 모두 삭제
        markers.removeAll()
        
        let zoom = mapView.cameraPosition.zoom
        
        //카메라 이동후 변경된 카메라 범위정보(위경도)를 받아오는 함수
        let (cameraRtop, cameraRbottom, cameraRright, cameraRleft) = cameraRange()
        
        if zoom > 13.0 {
            
            //변경된 카메라 범위를 AWS에 재요청하여 범위내 충전소 정보(id,위경도,충전기상태)를 받아오는 함수
            requestmarkersInfo(t: cameraRtop, b: cameraRbottom, r: cameraRright, l: cameraRleft)
            
            //로컬db에 저장된 자료를 불러와 지도에 마커 등을 보여주는 함수
            getdatafromlocaldb(afilterarray: afilterarray, bfilterarray: bfilterarray)
            
        } else if zoom > 12.0 {
            
           // print("동표시")
            let level = 3
            requestareaInfo(t: cameraRtop, b: cameraRbottom, r: cameraRright, l: cameraRleft, level: level)
            
            getareafromlocaldb(level: level)
            
         //   subcapUpdate(level: level)
            
        } else if zoom > 10.0 {
            
          //  print("시군구표시")
            let level = 2
            requestareaInfo(t: cameraRtop, b: cameraRbottom, r: cameraRright, l: cameraRleft, level: level)
            
            getareafromlocaldb(level: level)
            
        } else {
            
           // print("특별시도표시")
            let level = 1
            requestareaInfo(t: cameraRtop, b: cameraRbottom, r: cameraRright, l: cameraRleft, level: level)
            
            getareafromlocaldb(level: level)
        }

    }
    
    //초기로딩시 위치 설정해주는 함수(현재 실제위치로 설정)
    func initlocation (){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }

    //사용자의 실제 현재위치(GPS연동)에 대한 정보를 가져오는 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        latori = locValue.latitude
        lngori = locValue.longitude
        
        //초기로딩일 경우 초기위치로 이동하는 함수
        if initLoading {
            camerUpdating(lat: latori, lng: lngori)
            initLoading = false
        }
        
        let lastcrt = locationCRT()
        lastcrt.latcrt = locValue.latitude
        lastcrt.lngcrt = locValue.longitude
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(lastcrt)
        }
        
    }
    
    //카메라 범위 가져오는 함수
    func cameraRange() -> (Double, Double, Double, Double) {
        
        //스크린원점(왼쪽상단)에서의 위경도
        let olat = mapView.projection.latlng(from: CGPoint(x: 0, y: 0)).lat
        let olng = mapView.projection.latlng(from: CGPoint(x: 0, y: 0)).lng
        
        //마커를 보여주기위한 위경도상 범위 설정 함수
        let cameraRlat = olat - mapView.cameraPosition.target.lat
        let cameraRlng = mapView.cameraPosition.target.lng - olng
        
        let cameraRtop = mapView.cameraPosition.target.lat + cameraRlat
        let cameraRbottom = mapView.cameraPosition.target.lat - cameraRlat
        let cameraRright = mapView.cameraPosition.target.lng + cameraRlng
        let cameraRleft = mapView.cameraPosition.target.lng - cameraRlng
        
        return (cameraRtop, cameraRbottom, cameraRright, cameraRleft)
        
    }
    
    //지도상 보여주는(=카메라) 위치 임의 변경해주는 함수
    func camerUpdating(lat : Double, lng : Double) {
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        mapView.moveCamera(cameraUpdate)

    }
    
    //지도상에 특정줌으로 변하면 법정동 구역의 위치로 임의 변경해주는 함수
    func camerUpdatingwithzoom(lat : Double, lng : Double, zto : Double){
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: zto)
        mapView.moveCamera(cameraUpdate)

        
    }
    
    //지도위 버튼 클릭시 실행되는 함수??
    @objc func buttonCenter() {
        
        //현재위치 오버레이 설정하는것(아이콘 별도 설정필요)
        let locationOverlay = mapView.locationOverlay
        locationOverlay.location = NMGLatLng(lat: latori, lng: lngori)
        locationOverlay.hidden = false

        //지도 보여주는 위치 변경
        camerUpdating(lat: latori, lng: lngori)
        
    }
    
    @objc func buttonRefresh() {
        
        print("refresh")

        
    }
    
    @objc func buttonFilter() {
        
        filtershow = true
        afcompletion = true
        bfcompletion = true
        
    }
    
    //버튼 추가 설정해주는 함수
    func mapViewBtn(x : CGFloat, y : CGFloat, w : CGFloat, h : CGFloat, imgname : String, dist : String) {
        
        //let btnImage = UIImage(named: "cha") //Assets 이미지에서 추출
        let btnImage = UIImage(systemName: imgname)?.withTintColor(.gray, renderingMode: .alwaysOriginal) //Assets 이미지에서 추출
        //let button = MyButton(frame: CGRect(x: x, y: y, width: w, height: h))
        let button = UIButton(frame: CGRect(x: x, y: y, width: w, height: h))
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.backgroundColor = .white
        button.setImage(btnImage, for: .normal)
        button.alpha = 0.9
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        
        switch dist {
        
        case "center":
            
            button.addTarget(self, action: #selector(self.buttonCenter), for: .touchDown)
            
        case "refresh":
            
            button.addTarget(self, action: #selector(self.buttonRefresh), for: .touchDown)
            
        case "filter":
            
            button.addTarget(self, action: #selector(self.buttonFilter), for: .touchDown)
            
        default:
            
            print("btn")
        }
        
        mapView.addSubview(button)
        
    }
    
    //AWS Lambda에 지도범위 위경도 파라미터를 요청하여 지도범위내 결과값(JSON Array)을 받아와 Local DB에 저장함
    func requestmarkersInfo(t : Double, b : Double, r : Double, l : Double) {

        let endPoint = "https://dd2wb8ft1i.execute-api.ap-northeast-2.amazonaws.com/getcoord?t_lat=\(t)&b_lat=\(b)&r_lng=\(r)&l_lng=\(l)"
        let url = NSURL(string: endPoint)
        let session = URLSession.shared
        
        let realm = try! Realm()
        
        let toDel = realm.objects(ecgrDB.self)
        
        try! realm.write {
             realm.delete(toDel)
        }
        
        group.enter()

        let task = session.dataTask(with: url! as URL, completionHandler:
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
                        
                        let ecgrdb = ecgrDB()
                        
                        ecgrdb.statId = stdata[0] as! String
                        ecgrdb.lat = stdata[1] as! Double
                        ecgrdb.lng = stdata[2] as! Double
                        ecgrdb.stat = stdata[3] as! Int8
                        ecgrdb.type = stdata[4] as! Int8
                        
                        let realm = try! Realm()
                        
                        try! realm.write {
                            realm.add(ecgrdb)
                        }
                        
                    }
                    
                }
                
            } catch {
                print("raw data error")
                
            }
            self.group.leave() //데이터 수집 종료시점

        })
        task.resume()
        
    }
    
    //AWS Lambda에 지도범위 위경도 파라미터를 요청하여 지도범위내 결과값(JSON Array)을 받아오는 함수
    func requestareaInfo(t : Double, b : Double, r : Double, l : Double, level : Int) {
              
        let endPoint = "https://f5p5nh6yje.execute-api.ap-northeast-2.amazonaws.com/getbcode?t_lat=\(t)&b_lat=\(b)&r_lng=\(r)&l_lng=\(l)&level=\(level)"
        let url = NSURL(string: endPoint)
        let session = URLSession.shared

        let realm = try! Realm()
        
        let toDel = realm.objects(areaDB.self)
        
        try! realm.write {
             realm.delete(toDel)
        }
        group.enter()
            
        let task = session.dataTask(with: url! as URL, completionHandler:
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
                        
                        let areadb = areaDB()
                        
                        areadb.code = stdata[0] as! String
                        areadb.name = stdata[1] as! String
                        areadb.lat = stdata[2] as! Double
                        areadb.lng = stdata[3] as! Double
                        areadb.num = stdata[4] as! Int
                        
                        let realm = try! Realm()
                        
                        try! realm.write {
                              realm.add(areadb)
                        }
                   
                    }

                }
                
            } catch {
                print("raw data error")
                
            }
            self.group.leave() //데이터 수집 종료시점
        })
        task.resume()
        
    }

    //지도범위 쿼리(=realm에서는 필터)를 통한 위경도 데이터 앱상으로 받아오기
    func getdatafromlocaldb(afilterarray : [Int], bfilterarray : [BFilterInfo]) {
        
        let realm = try! Realm()
        
        group.wait()
        
        realm.refresh()
        
        //아래 마커들 추가 삭제하는 이유는 필터on->off시 중복으로 생성되는것을 방지
        for marker in markers{
            marker.mapView = nil
        }

        markers.removeAll()
        
        var cMulti : String = "" //1개 충전소에 여러개 충전기가 있을때 중복 마커생성을 방지
        
        if afilterarray[0] == 1 && (bfilterarray.filter{$0.on == 1}).count > 0 {
            
            for item in realm.objects(ecgrDB.self).filter(getbfilterstring(bfilterarray: bfilterarray)){
                
                if !(cMulti == item.statId) {
                    
                    var numstring = ""
                    
                    if afilterarray[2] == 0 && afilterarray[3] == 0 && afilterarray[4] == 0 && afilterarray[5] == 0 {
                        
                        numstring = "0"
                        
                    } else {
                    
                        //로컬에 저장된 데이터중 충전가능 충전기숫자와 같이 나오는 것
                        let num = realm.objects(ecgrDB.self).filter("statId = '\(item.statId)' AND stat = 2\(getafilterstring(afilterarray: afilterarray))")
                        
                        numstring = String(num.count)
                        
                    }
                    
                    if afilterarray[1] == 1 && numstring == "0" {
                         
                    } else {
                        
                        markersShowing(item : item, num: numstring)
                        
                    }
                    
                }
                cMulti = item.statId
                
            }
            
        } else if afilterarray[0] == 1 && (bfilterarray.filter{$0.on == 1}).count == 0 {
            
            //필터는 켜져 있지만 공급업체는 하나도 선택되어 있지 않은 상태
            for marker in markers{
                marker.mapView = nil
            }

            markers.removeAll()

        } else {
            
            for item in realm.objects(ecgrDB.self){
                
                if !(cMulti == item.statId) {
                    
                    //로컬에 저장된 데이터중 충전가능 충전기숫자와 같이 나오는 것
                    let num = realm.objects(ecgrDB.self).filter("statId = '\(item.statId)' AND stat = 2")
                    
                    markersShowing(item : item, num: String(num.count))
                         
                }
                
                cMulti = item.statId
                
            }
            
        }
        
    }
    
    //Local DB에서 지도범위 쿼리(=realm에서는 필터)를 통한 위경도 데이터 앱상으로 받아오기
    func getareafromlocaldb(level : Int) {
        
        let realm = try! Realm()
        
        group.wait()
        
        realm.refresh()
        
        for item in realm.objects(areaDB.self){
            
            markersAreaShowing(item : item, level: level)
     
        }

    }
 
    //마커 보여주는 함수
    func markersShowing(item : ecgrDB, num : String) {
      
        let marker = NMFMarker()
        marker.userInfo = ["tag": item.statId]
        marker.position = NMGLatLng(lat: item.lat, lng: item.lng)
        marker.iconImage = img
        marker.captionText = num
        //marker.captionAligns = [NMFAlignType.center]
        marker.captionOffset = -42
        marker.captionTextSize = 20
        marker.captionColor = UIColor.white
        marker.captionHaloColor = UIColor.clear
        marker.mapView = mapView
        marker.touchHandler = { (overlay) -> Bool in
            
            print(self.stationid)

            self.stationmapshow = false
            self.scompletion = false
            self.stationshow = true
            
            self.getstationInfo(statId: marker.userInfo["tag"] as! String)
            self.stationid = marker.userInfo["tag"] as! String
            
            return false
        }
        markers.append(marker)
      
    }
    
    //법정동 마커 보여주는 함수
    func markersAreaShowing(item: areaDB, level: Int) {
    
        let marker = NMFMarker()
        
        marker.userInfo = ["tag": item.code]
        marker.position = NMGLatLng(lat: item.lat, lng: item.lng)
        marker.iconImage = imgsq
        marker.captionText = item.name
        marker.captionAligns = [NMFAlignType.center]
        marker.captionTextSize = 10
        marker.captionColor = UIColor.white
        marker.captionHaloColor = UIColor.clear
        marker.subCaptionText = String(item.num)
        marker.subCaptionTextSize = 15
        marker.subCaptionColor = UIColor.white
        marker.subCaptionHaloColor = UIColor.clear
        
        DispatchQueue.main.async{
            marker.mapView = self.mapView
            marker.touchHandler = { (overlay) -> Bool in
                
                var zto = 0.0
                
                if level == 3 {
                    
                    zto = 14.0
                    
                } else if level == 2 {
                    
                    zto = 12.5
                    
                } else if level == 1 {
                    
                    zto = 11.0
                }
                    
                self.camerUpdatingwithzoom(lat: marker.position.lat, lng: marker.position.lng, zto: zto)
                
                
                return false
            }
        }
        
        markers.append(marker)
        
    }
    
    //법정동 구역을 클릭하면 위치정보를 가져오는 함수
    func getstationInfo(statId : String){
        
        let endPoint = "https://dd2wb8ft1i.execute-api.ap-northeast-2.amazonaws.com/getstationinfo?id=\(statId)"
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
                
                var num = 0
                
                self.stationarray = []

                for item in newValue{
                    
                    if let stdata = item as? [Any]{
                        
                        var temp = StationInfo()
                        
                        temp.statNm = stdata[0] as! String
                        temp.statId = stdata[1] as! String
                        temp.chgerId = stdata[2] as! Int
                        temp.chgerType = stdata[3] as! Int
                        temp.addr = stdata[4] as! String
                        temp.addCd = stdata[5] as! String
                        temp.lat = stdata[6] as! Double
                        temp.lng = stdata[7] as! Double
                        temp.useTime = stdata[8] as! String
                        temp.busiId = stdata[9] as! String
                        temp.busiCall = stdata[10] as! String
                        temp.stat = stdata[11] as! Int
                        temp.statUpdDt = stdata[12] as! String
                        temp.powerType = stdata[13] as! String
                        
                        if temp.stat == 2 {
                            num = num + 1
                        }
                        
                        temp.num = String(num)
                        
                        DispatchQueue.main.async {
                            self.stationarray.append(temp)
                        }

                    }
                    
                }
                
            } catch {
                print("raw data error")
                
            }
            self.scompletion = true

        })
        task.resume()
        
    }
    
    //필터관련 필터on/off, 충전가능충전소, 충전기 타입정보 받아오는 함수
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
                
                let dataString = (newValue[0] as AnyObject).data(using: String.Encoding.utf8.rawValue)
                
                let newArray = try JSONSerialization.jsonObject(with: dataString!, options: []) as! Array<Any>
                
                self.afilterarray = [0, 0, 0, 0, 0, 0]
                
                for (idx, item) in newArray.enumerated(){
                    
                    DispatchQueue.main.async {
                    
                        self.afilterarray[idx] = item as! Int
                        
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
    
    //필터관련 충전기 공급업체 정보 받아오는 함수
    func getbfilterInfo(dist: String, snsid: String, appid: String, stid: String){
        
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
                self.bfilterarray = []

                for item in newValue{
                    
                    if let stdata = item as? [Any]{
                        
                        var temp = BFilterInfo()
                        
                        temp.stid = stdata[0] as! String
                        temp.stnm = stdata[1] as! String
                        temp.on = stdata[2] as! Int
                        
                        DispatchQueue.main.async {
                            self.bfilterarray.append(temp)
                        }

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
    
    //로컬db에서 필터링을 위한 쿼리 string 생성
    func getafilterstring(afilterarray : [Int]) -> String {
        
        var afilterstring : String = ""
        
        var temparray : [Int] = []
        let check : Bool = true
        
        for (idx, val) in afilterarray.enumerated() {
            
            switch check {

            case idx == 2 && val == 1:
                
                temparray.append(contentsOf: [4, 5])
                    
            case idx == 3 && val == 1:
                
                temparray.append(contentsOf: [1, 3, 5, 6])
                    
            case idx == 4 && val == 1:
                
                temparray.append(contentsOf: [2])

            case idx == 5 && val == 1:
                
                temparray.append(contentsOf: [3, 6, 7])

            default:
                
                temparray.append(contentsOf: [])
             
            }
            
        }
        
        let ftemparray = Array(Set(temparray))
        
        var tempstring = ""
        let fidx = ftemparray.endIndex - 1
        
        for (idx, val) in ftemparray.enumerated(){
            
            switch check {

            case idx == 0 && fidx != 0 :
                
                tempstring = " AND (type = \(val)"
                
            case idx == 0 && fidx == 0:
                
                tempstring = " AND type = \(val)"
                
            case idx != 0 && fidx != 0 && idx == fidx:
                
                tempstring = " OR type = \(val))"

            default:
                
                tempstring = " OR type = \(val)"
             
            }
            
            afilterstring += tempstring
            
        }
        
        return afilterstring
    }
    
    //로컬db에서 필터링을 위한 쿼리 string 생성
    func getbfilterstring(bfilterarray : [BFilterInfo]) -> String {
        
        var bfilterstring : String = ""
        
        for (idx, item) in bfilterarray.filter({$0.on == 1}).enumerated() {
            
            switch idx {

            case 0:
                
                bfilterstring = "statId contains '\(item.stid)'"
             
            default:
                
                let tempstring = " OR statId contains '\(item.stid)'"
                bfilterstring += tempstring
             
            }
            
        }
       
        return bfilterstring
        
    }
    
}

class locationCMR: Object {
    
    @objc dynamic var latcmr = 0.0
    @objc dynamic var lngcmr = 0.0

}

class locationCRT: Object {
    
    @objc dynamic var latcrt = 0.0
    @objc dynamic var lngcrt = 0.0

}

class ecgrDB: Object {
    
    @objc dynamic var statId = ""
    @objc dynamic var lat : Double = 0.0
    @objc dynamic var lng : Double = 0.0
    @objc dynamic var stat : Int8 = 0
    @objc dynamic var type : Int8 = 0
    
}

class areaDB: Object {
    
    @objc dynamic var code = ""
    @objc dynamic var name = ""
    @objc dynamic var lat : Double = 0.0
    @objc dynamic var lng : Double = 0.0
    @objc dynamic var num : Int = 0
    @objc dynamic var level : Int = 0
    
}

/*
class MyButton : UIButton {

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.gray : UIColor.white
        }
    }
}
 */

extension Array {

    mutating func remove(at indexs: [Int]) {
        guard !isEmpty else { return }
        let newIndexs = Set(indexs).sorted(by: >)
        newIndexs.forEach {
            guard $0 < count, $0 >= 0 else { return }
            remove(at: $0)
        }
    }

}

extension UIColor {

    static let markerb = UIColor(red: 0, green: 0.590, blue: 1, alpha: 1)

}
