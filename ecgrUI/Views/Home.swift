import SwiftUI
import RealmSwift

struct Home : View {
    
    //검색관련된 변수들
    @State private var searchshow : Bool = false //검색페이지 보임or가림
    @State private var searchmapshow : Bool = false //검색결과 클릭시 지도를 보임or가림
    @State private var qtxt = ""
    @State private var asearchinfo = ASearchInfo()
    @State private var asearcharray : [ASearchInfo] = []
    @State private var bsearchinfo = BSearchInfo()
    @State private var bsearcharray : [BSearchInfo] = []
    @State private var csearchinfo = CSearchInfo()
    @State private var csearcharray : [CSearchInfo] = []
    @State private var rsearchinfo = RSearchInfo()
    @State private var rsearcharray : [RSearchInfo] = []
    @State private var lsearchinfo = LSearchInfo()
    
    //메뉴관련 변수들
    @State private var menushow : Bool = false //메뉴페이지 보임or가림
    @State private var menusubshow : Bool = false
    @State private var mscompletion : Bool = false
    @State private var menusubtitle : String = ""
    
    //북마크관련 변수들
    @State private var checkbookmark : Bool = false
    @State private var bookmarkinfo = BookMarkInfo()
    @State private var bookmarkarray : [BookMarkInfo] = []
    
    //충전소 상세페이지와 관련된 변수들
    @State private var stationshow : Bool = false //충전소 상세페이지 보임or가림
    @State private var stationmapshow : Bool = false //충전소 상세페이지에서 지도클릭시 가게 하는것
    @State private var stationgetdata : Bool = false //검색페이지에서 스테이션 인포데이터 가져오는 핸들러
    @State private var scompletion : Bool = false
    @State private var stationid : String = "" //검색페이지에서 스테이션 id를 받아와 전달
    @State private var stationinfo = StationInfo()
    @State private var stationarray : [StationInfo] = []
    
    //충전소 상세페이지의 리뷰와 관련된 변수들
    @State private var reviewshow : Bool = false
    @State private var rcompletion : Bool = false
    @State private var rfcompletion : Bool = false
    @State private var reviewupdateshow : Bool = false
    @State private var reviewfirstcount : Int = 0
    @State private var reviewid : String = ""
    @State private var reviewfirsttxt : String = ""
    @State private var reviewupdatetxt : String = ""
    @State private var reviewinfo = ReviewInfo()
    @State private var reviewarray : [ReviewInfo] = []
    
    @State private var reply : Bool = false
    @State private var replyshow : Bool = false
    @State private var replycompletion : Bool = false
    @State private var replyupdateshow : Bool = false
    @State private var replyid : String = ""
    @State private var replyupdatetxt : String = ""
    @State private var replyarray : [ReplyInfo] = []
    
    //로그인 관련 변수들
    @State private var loginshow : Bool = false
    @State private var logoutexe : Bool = false
    @State private var logininfo = LogInInfo()
    
    //고장접수
    @State private var repairshow : Bool = false
    @State private var repairsendshow : Bool = false
    @State private var repaircompletion : Bool = false
    @State private var repairfail : Bool = false
    @State private var uiimgarray : [UIImage] = []

    //필터
    @State private var filtershow : Bool = false
    @State private var afcompletion : Bool = false
    @State private var bfcompletion : Bool = false
    @State private var filteronlyable : Bool = false
    @State private var afilterarray : [Int] = [0, 0, 0, 0, 0, 0]
    @State private var bfilterarray : [BFilterInfo] = []
    
    //현재위치
    @State private var latori : Double = 0.0
    @State private var lngori : Double = 0.0
    
    init(){
        
        //테스트 용도로 ream local db 를 삭제하는 코딩
        /*
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        
        let realmURLs = [
          realmURL,
          realmURL.appendingPathExtension("lock"),
          realmURL.appendingPathExtension("note"),
          realmURL.appendingPathExtension("management")
        ]
        _ = FileManager.default
        for URL in realmURLs {
          do {
            try FileManager.default.removeItem(at: URL)
          } catch {
            
          }
        }
     */
        
    }
    
    var body : some View{
        
        ZStack{
            
            MapView(stationshow: $stationshow, stationmapshow: $stationmapshow, stationinfo: $stationinfo, stationarray: $stationarray, scompletion: $scompletion, searchmapshow: $searchmapshow, lsearchinfo: $lsearchinfo, stationgetdata: $stationgetdata, stationid: $stationid, logininfo: $logininfo, filtershow: $filtershow, afcompletion: $afcompletion, bfcompletion: $bfcompletion, afilterarray: $afilterarray, bfilterarray: $bfilterarray, latori: $latori, lngori: $lngori)
                .edgesIgnoringSafeArea(.bottom)
            
            VStack(spacing: 0){
                
                HStack{
                    
                    HStack{
                        
                        if !searchshow{
                            
                            Button(action: {
                                
                                menushow = true
                                
                            }) {
                                Image(systemName: "text.justify")
                                    .foregroundColor(.icon)
                                    .font(.system(size:25, weight: .regular))
                            }
                            .padding(.trailing, 6)
                            
                            Spacer()
                            
                            Text("위치나 장소를 검색하세요")
                                .foregroundColor(.icon)
                                .font(Font.system(size:19, weight: .regular))
                            
                            Spacer()
                            
                            Button(action: {
                                
                                searchshow = true
                                
                            }) {
                                Image(systemName: "magnifyingglass")
                                    //.background(Color.icon)
                                    .foregroundColor(Color.icon)
                                    .font(.system(size:25, weight: .regular))
                                    
                            }
                            .padding(.horizontal, 0)
                            
                        } else {
                            
                            Button(action: {
                                    qtxt = ""
                                    searchshow = false
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.gray)
                                    .font(.system(size:25, weight: .regular))
                            }
                            .padding(.trailing, 6)
                            
                        }
                            
                        if searchshow {
                            
                            TextField("검색어를 입력하세요", text: $qtxt)
                                .padding(.horizontal, 10)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
                            Button(action: {
                                    qtxt = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray_t1)
                                    .font(.system(size:25, weight: .regular))
                            }
                            .padding(.horizontal, 0)
                            
                        }
                        
                    }
                    .frame(height: 35)
                    .padding(.horizontal, 13)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .background(Color.header)
                    
                }
                .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 0)
                .background(Color.status_bar)
                
                Divider()
                    .background(Color.white)
                

                ZStack(){
                    
                    if searchshow {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            VStack(spacing: 0){
                                
                                if (qtxt.count >= 1) {
                                    
                                    Search(logininfo: $logininfo, qtxt: $qtxt, searchshow: $searchshow, searchmapshow: $searchmapshow, stationshow: $stationshow, stationgetdata: $stationgetdata, scompletion: $scompletion, asearchinfo: $asearchinfo, asearcharray: $asearcharray, bsearchinfo: $bsearchinfo, bsearcharray: $bsearcharray, csearchinfo: $csearchinfo, csearcharray: $csearcharray, rsearchinfo: $rsearchinfo, rsearcharray: $rsearcharray, lsearchinfo: $lsearchinfo, stationid: $stationid, latori: $latori, lngori: $lngori)
                                    
                                } else {
                                    
                                    RSearch(logininfo: $logininfo, searchshow: $searchshow, searchmapshow: $searchmapshow, stationshow: $stationshow, stationgetdata: $stationgetdata, scompletion: $scompletion, rsearchinfo: $rsearchinfo, rsearcharray: $rsearcharray, lsearchinfo: $lsearchinfo, stationid: $stationid, latori: $latori, lngori: $lngori)
                                    
                                }

                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 0)
                            .padding(.top, 0)
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
                .background(searchshow ? .white : Color(.clear))
                .edgesIgnoringSafeArea(.bottom)
                
            }
            .edgesIgnoringSafeArea(.top)
    
            if menushow || filtershow  {
                
                //메뉴뒤에 검은색 투명 화면을 클릭하면 초기화면으로 돌아가게 하는 기능
                Button(action: {
                    
                    menushow = false
                    filtershow = false
                    
                }) {
                    
                    Text("")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.black.opacity(menushow || filtershow ? 0.5 : 0)
                    .animation(.easeOut(duration: 0.2))
                )
                .edgesIgnoringSafeArea(.bottom)
                
            }
            
            GeometryReader{_ in
                
                Menu(menushow: $menushow, menusubshow: $menusubshow, menusubtitle: $menusubtitle, mscompletion: $mscompletion, logoutexe: $logoutexe, logininfo: $logininfo, bookmarkinfo: $bookmarkinfo, bookmarkarray: $bookmarkarray)
                    .offset(x: menushow ? 0 : -UIScreen.main.bounds.width)
                    //.animation(.easeOut(duration: 0.2))
                    
            }
            
            MenuSub(menushow: $menushow, menusubshow: $menusubshow, menusubtitle: $menusubtitle, mscompletion: $mscompletion, checkbookmark: $checkbookmark, bookmarkarray: $bookmarkarray, stationshow: $stationshow, stationgetdata: $stationgetdata, scompletion: $scompletion, stationid: $stationid, logininfo: $logininfo)
                .offset(x: menusubshow ? 0 : UIScreen.main.bounds.width)
                .animation(.easeOut(duration: 0.1))
                

            GeometryReader{_ in
                
                Filter(logininfo: $logininfo, filtershow: $filtershow, afcompletion: $afcompletion, bfcompletion: $bfcompletion, afilterarray: $afilterarray, bfilterarray: $bfilterarray)
                    .offset(x: filtershow ? UIScreen.main.bounds.width * 0.2 : UIScreen.main.bounds.width)
                    //.animation(.easeOut(duration: 0.0))
                
                FilterCover(filtershow: $filtershow, afilterarray: $afilterarray)
                    .offset(x: afilterarray[0] == 0 && filtershow ? UIScreen.main.bounds.width * 0.2 : UIScreen.main.bounds.width, y: 100)
            
            }

            //Group를 해주는 이유는 1개의 Stack은 최대 10개의 하위Stack만 가져올수 있음
            Group {
                
                Detail(searchshow: $searchshow, stationshow: $stationshow, stationmapshow: $stationmapshow, stationinfo: $stationinfo, stationarray: $stationarray, scompletion: $scompletion, stationid: $stationid, logininfo: $logininfo, checkbookmark: $checkbookmark, mscompletion: $mscompletion, bookmarkarray: $bookmarkarray, reviewshow: $reviewshow, rcompletion: $rcompletion, rfcompletion: $rfcompletion, reviewfirstcount: $reviewfirstcount, reviewfirsttxt: $reviewfirsttxt, reviewarray: $reviewarray, repairshow: $repairshow)
                    .offset(x: stationshow ? 0 : UIScreen.main.bounds.width)
                    .animation(.easeOut(duration: 0.1))
                    

                Review(reviewshow: $reviewshow, rcompletion: $rcompletion, reviewid: $reviewid, reviewinfo: $reviewinfo, reviewarray: $reviewarray, logininfo: $logininfo, stationid: $stationid, reviewupdateshow: $reviewupdateshow, reviewupdatetxt: $reviewupdatetxt, replyshow: $replyshow, replycompletion: $replycompletion, replyarray: $replyarray)
                    .offset(x: reviewshow ? 0 : UIScreen.main.bounds.width)
                    .animation(.easeOut(duration: 0.1))
                    
                
                Reply(reviewinfo: $reviewinfo, reviewarray: $reviewarray, replyshow: $replyshow, replycompletion: $replycompletion, replyid: $replyid, replyarray: $replyarray, logininfo: $logininfo, stationid: $stationid, reviewid: $reviewid, replyupdateshow: $replyupdateshow, replyupdatetxt: $replyupdatetxt)
                    .offset(x: replyshow ? 0 : UIScreen.main.bounds.width)
                    .animation(.easeOut(duration: 0.1))
            

                ReviewUpdate(reviewupdateshow: $reviewupdateshow, reviewupdatetxt: $reviewupdatetxt, reviewid: $reviewid, reviewarray: $reviewarray, logininfo: $logininfo, stationid: $stationid)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(x: reviewupdateshow ? 0 : -UIScreen.main.bounds.width)
                    .background(
                        Color.black.opacity(reviewupdateshow ? 0.5 : 0)
                        .animation(.easeOut(duration: 0.2))
                    )
                    .edgesIgnoringSafeArea(.bottom)
                    

                ReplyUpdate(replyupdateshow: $replyupdateshow, replyupdatetxt: $replyupdatetxt, replyid: $replyid, replyarray: $replyarray, logininfo: $logininfo, stationid: $stationid, reviewid: $reviewid)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(x: replyupdateshow ? 0 : -UIScreen.main.bounds.width)
                    .background(
                        Color.black.opacity(replyupdateshow ? 0.5 : 0)
                        .animation(.easeOut(duration: 0.2))
                    )
                    .edgesIgnoringSafeArea(.bottom)
                    

                Repair(repairshow: $repairshow, repairsendshow: $repairsendshow, repaircompletion: $repaircompletion, repairfail: $repairfail, stationinfo: $stationinfo, logininfo: $logininfo)
                    .offset(x: repairshow ? 0 : UIScreen.main.bounds.width)
                    .animation(.easeOut(duration: 0.1))

                
                RepairSend(repairshow: $repairshow, repairsendshow: $repairsendshow, repaircompletion: $repaircompletion, repairfail: $repairfail)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(x: repairsendshow ? 0 : -UIScreen.main.bounds.width)
                    .background(
                        Color.black.opacity(repairsendshow ? 0.5 : 0)
                        .animation(.easeOut(duration: 0.2))
                    )
                    .edgesIgnoringSafeArea(.bottom)

            }
        
            VStack() {
                
                LoginView(loginshow: $loginshow, logoutexe: $logoutexe, logininfo: $logininfo)
                
            }
            .background(Color(.white))
            .edgesIgnoringSafeArea(.vertical)
            .offset(y: loginshow ? 0 : -UIScreen.main.bounds.height)
            .animation(.easeOut(duration: 0.15))
            
        }
    }
    
}

