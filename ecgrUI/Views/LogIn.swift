import SwiftUI
import Foundation
import UIKit
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKUser
import FBSDKLoginKit
import RealmSwift

struct LoginView : UIViewControllerRepresentable {
    
    @Binding var loginshow : Bool
    @Binding var logoutexe : Bool
    @Binding var logininfo : LogInInfo

    func makeUIViewController(context: Context) -> LoginViewController {
        
        let loginview = LoginViewController(loginshow: $loginshow, logoutexe: $logoutexe, logininfo: $logininfo)

        return loginview
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        
        print("========================> LoginView update 함수 실행")
        
        if(logoutexe) {
            
            uiViewController.allLogOut()
            print("----------> LogInView의 ALL 로그아웃 함수 실행")
            
        }
    
    }
    
}

class LoginViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate {
    
    @Binding var loginshow : Bool
    @Binding var logoutexe : Bool
    @Binding var logininfo : LogInInfo

    //네이버 로그인 인스텐스
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    //네이버 로그인 버튼
    private let nloginButton: UIButton = {
        
        let image = UIImage(named: "login_n")
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width - 280)/2, y: ((UIScreen.main.bounds.height - 200)/2) - 75, width: 280.0, height: 60.0))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(nLoginButton(_:)), for: .touchUpInside)
        
        return button
        
    }()
    
    //카카오 로그인 버튼
    private let kloginButton: UIButton = {
        
        let image = UIImage(named: "login_k")
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width - 280)/2, y: (UIScreen.main.bounds.height - 200)/2, width: 280.0, height: 60.0))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(kLoginButton(_:)), for: .touchUpInside)
        
        return button
        
    }()
    
    //페이스북 로그인 버튼
    private let floginButton: UIButton = {
        
        let image = UIImage(named: "login_f")
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width - 280)/2, y: ((UIScreen.main.bounds.height - 200)/2) + 75, width: 280.0, height: 60.0))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(fLoginButton(_:)), for: .touchUpInside)
        
        return button
        
    }()
/*
    //로그아웃 버튼(임시 테스트용)
    private let logoutButton: UIButton = {
        
        let image = UIImage(systemName: "person.badge.minus")
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width - 100)/2, y: 500.0, width: 100.0, height: 100.0))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(LogoutButton(_:)), for: .touchUpInside)
        
        return button
        
    }()
  */
    private let testButton: UIButton = {
        
        let image = UIImage(systemName: "trash")
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width - 100)/2, y: 500.0, width: 100.0, height: 100.0))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(TestButton(_:)), for: .touchUpInside)
        
        return button
        
    }()
    
    
    init(loginshow: Binding<Bool>, logoutexe: Binding<Bool>, logininfo: Binding<LogInInfo>) {
        
        _loginshow = loginshow
        _logoutexe = logoutexe
        _logininfo = logininfo
        
        super.init(nibName: nil, bundle: nil)
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        
        loginInstance?.delegate = self
        checkLocalLoginIdisEmpty()
        print("-------------> Login View의 viewDidLoad 실행됨 우선적으로 실행되는것임")

        view.addSubview(nloginButton)
        view.addSubview(kloginButton)
        view.addSubview(floginButton)
        //view.addSubview(logoutButton)
        view.addSubview(testButton)
        
    }
    
    @objc private func TestButton(_ sender: UIButton) {

        print("-------> ALL 로그아웃 버튼 실행됨")
        allLogOut()
        
    }
    
    //로컬 사용자 식별 id가 비어 있는지 확인(비어 있으면 로그인페이지 넘어감)
    func checkLocalLoginIdisEmpty() {
        
        let realm = try! Realm()
             
        let toCheck = realm.objects(loginDB.self)
    
        if toCheck.count == 0 {
            
            print("check 로컬로그인")
            
           // allLogOut() 이거 중요하다 여기에서 만약에 네이버나 다른데 접속해 있다면... 이런문구
            DispatchQueue.main.async {
                
                self.loginshow = true
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.logininfo.sns = toCheck[0].sns
                self.logininfo.snsid = toCheck[0].snsid
                self.logininfo.name = toCheck[0].name
                self.logininfo.nickname = toCheck[0].nickname
                self.logininfo.email = toCheck[0].email
                self.logininfo.appid = toCheck[0].appid
                
            }
            
        }
        //kakaoLogIn()
        //loginInstance?.requestThirdPartyLogin()
        
    }
    
    
    @objc private func LogoutButton(_ sender: UIButton) {

        print("-------> ALL 로그아웃 버튼 실행됨")
        allLogOut()
        
    }
    
 
    func allLogOut() {
        
        print("-------> ALL 로그아웃 함수 실행됨")
        loginInstance?.requestDeleteToken() //실행후에 아무것도 추가 출력이 안도니 오해 금지
        kakaoLogOut()
        facebookLogOut()
        
        let realm = try! Realm()

        let toDel = realm.objects(loginDB.self)
        
        if toDel.count > 0 {
            
            try! realm.write {
                 realm.delete(toDel)
            }
            
        }

        //이건 무조건 메인 쓰레드에서 실행해야함
        DispatchQueue.main.async {
            
            self.logoutexe = false
            self.loginshow = true
               
         }
        
    }
    
    //sns로그인이 정상적으로 되고 aws rds에 계정 정보를 등록(만약 기존에 아이디 존재시 업데이트)
    func getUserInfo(sns: String, snsid: String, email: String, name: String) {
        
        let endPoint = "https://qzevy0w12e.execute-api.ap-northeast-2.amazonaws.com/getuserinfo?sns=\(sns)&snsid=\(snsid)&email=\(email)&name=\(name)"
        
        let encodedQuery: String = endPoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
       
        let requestURL = URLRequest(url: queryURL)
        let session = URLSession.shared
            
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

                print("--------> sns로그인후에 AWS 접속")
                
                
                for item in newValue{
                    
                    if let stdata = item as? [Any]{
                        
                        let nickname = stdata[0] as! String
                        let appid = stdata[1] as! String
                        
                        let realm = try! Realm()
                        
                        realm.refresh()

                        let toDel = realm.objects(loginDB.self)
                        
                        print("----------------->>카운트", toDel.count)
                        
                        if toDel.count > 0 {
                            
                            print("지워지는것이 실행되는가?")
                            
                            try! realm.write {
                                 realm.delete(toDel)
                            }
                            
                        }
                        
                        let logindb = loginDB()
                        
                        logindb.sns = sns
                        logindb.snsid = snsid
                        logindb.name = name
                        logindb.nickname = nickname
                        logindb.email = email
                        logindb.appid = appid
                        
                        
                        try! realm.write {
                              realm.add(logindb)
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.logininfo.sns = sns
                            self.logininfo.nickname = nickname
                            self.logininfo.email = email
                            self.logininfo.appid = appid
                            
                        }

                        print("--------> 개인정보 Local DB등 저장 성공")

                    }

                }
                
            } catch {
                print("raw data error")
                
            }
            DispatchQueue.main.async {
            
                self.loginshow = false
            }

        })
        task.resume()
    
    }
    
    //---------- 네이버 로그인 ----------//
    
    //네이버 버튼 클릭
    @objc private func nLoginButton(_ sender: UIButton) {
        
        print("네이버 로그인 버튼 클릭됨")
        loginInstance?.requestThirdPartyLogin()

    }
    
    //로그인 성공시 실행되는 함수
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        
        print("네이버 로그인 시도성공, 자료 수집중")
        getNaverInfo()
        
    }
    
    
    //로그인후 이미 토큰이 발행되었을때 실행되는 함수
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
        print("네이버 로그인 된상태, 로그인재시도")
        getNaverInfo()
        
    }
    
    //로그아웃 하고 나면 실행되는 함수
    func oauth20ConnectionDidFinishDeleteToken() {
        
        print("네이버 로그아웃됨, 연동해제됨")
        
    }
    
    // 모든 Error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        
        print("네이버 로그인 인증 등 실행 실패 입니다.")
     // print("error = \(error.localizedDescription)")

    }

    // 네이버 로그인 정보 얻기
    func getNaverInfo() {
        
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }

        if !isValidAccessToken { return }

        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!

        let authorization = "\(tokenType) \(accessToken)"

        var requestURL = URLRequest(url: url)
        requestURL.addValue(authorization, forHTTPHeaderField: "Authorization")

        let session = URLSession.shared

        let task = session.dataTask(with: requestURL, completionHandler:
        {
            (data, response, error) -> Void in

            do {
                
                let ojson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                
                let sns = "naver"
                guard let object = ojson["response"] as? [String: Any] else { return }
                guard let snsid = object["id"] as? String else {return}
                guard let name = object["name"] as? String else { return }
                guard let email = object["email"] as? String else { return }
                
                print("네이버 유저 정보 API 성공")
                
                self.getUserInfo(sns: sns, snsid: snsid, email: email, name: name)
           
            } catch {
                print("raw data error")
                
            }

        })
        task.resume()

    }
    //--------------------------------//
    
    
    //---------- 카카오 로그인 ----------//
    
    //카카오 로그인 버튼
    @objc private func kLoginButton(_ sender: UIButton) {

       kakaoLogIn()
       print("카카오 로그인 버튼 클릭함")

    }
    
    //카카오 로그인 실행 함수
    func kakaoLogIn() {
        
        AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오 로그인 성공. 사용자 정보 얻기 실행")
                    self.kakaoGetInfo()
                    //do something
                    _ = oauthToken
                }
            }
        
    }
    
    //카카오 로그아웃 실행 함수
    func kakaoLogOut() {
        
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("카카오 로그아웃 성공")
            }
        }
        
    }
    
    //카카오 정보 얻기
    func kakaoGetInfo() {
        
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
                print("카카오 사용자 정보 획득 실패. 로그인이 필요")
             //   self.kneedlogin = true
                
            }
            else {

                let sns = "kakao"
                let snsid = String(user!.id)
                let name = user?.kakaoAccount?.profile?.nickname ?? ""
                let email = user?.kakaoAccount?.email ?? ""
                
                print("카카오 사용자 정보 API 성공")
                
                self.getUserInfo(sns: sns, snsid: snsid, email: email, name: name)

                //do something
                _ = user
            }
        }
        
    }
    //----------------------------------//
    
    
    //---------- 페이스북 로그인 ----------//
    
    //페이스북 로그인 및 데이터 저장
    @objc private func fLoginButton(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.publicProfile], viewController: self) { (LoginResult) in

            switch LoginResult {

            case .failed(let error):

                print(error)

            case .cancelled:

                print("페이스북 로그인 취소")

            case .success(granted: _, declined: _, token: _): // 로그인 성공

                print("페이스북 로그인 성공")
                
                if((AccessToken.current) != nil)
                
                {
                    
                    GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler:
                        { (connection, result, error) -> Void in
                            if (error == nil)
                            
                            {
                            
                                if let data = result as? NSDictionary
                                
                                {
                                    
                                    let sns = "facebook"
                                    let snsid = data.object(forKey: "id") as! String
                                    let name = data.object(forKey: "name") as! String
                                    let email = data.object(forKey: "email") as! String
                                    
                                    print("페이스북 사용자 정보 API 성공")
                                    
                                    self.getUserInfo(sns: sns, snsid: snsid, email: email, name: name)

                                }
                                
                            }
                            
                    })
                    
                }

             }

         }

    }
    
    func facebookLogOut() {
        
        print("페이스북 로그아웃 함수 실행")
        let loginmanager = LoginManager()
        loginmanager.logOut()
        
    }
    
    //------------------------------------//
    
}


class loginDB: Object {
    
    @objc dynamic var sns = ""
    @objc dynamic var snsid = ""
    @objc dynamic var name = ""
    @objc dynamic var nickname = ""
    @objc dynamic var email = ""
    @objc dynamic var appid = ""
    
}
