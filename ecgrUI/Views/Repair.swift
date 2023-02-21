import SwiftUI

struct Repair : View {
    
    @Binding var repairshow : Bool
    @Binding var repairsendshow : Bool
    @Binding var repaircompletion : Bool
    @Binding var repairfail : Bool
    @Binding var stationinfo : StationInfo
    @Binding var logininfo : LogInInfo
    //@Binding var uiimgarray : [UIImage]
    
    @State private var repairtxt = ""
    @State private var repairalert = false
    
    @State private var showingImagePicker = false
    @State private var inputImage : UIImage?
    @State private var uiimgarray : [UIImage] = []
    @State private var imgnamearray : [String] = []
    
    @State private var filesizealert : Bool = false
    @State private var sendemailalert : Bool = false
    
    /*
    init(repairshow: Binding<Bool>, stationinfo: Binding<StationInfo>, logininfo: Binding<LogInInfo>, uiimgarray: Binding<[UIImage]>){
        
        _repairshow = repairshow
        _stationinfo = stationinfo
        _logininfo = logininfo
        _uiimgarray = uiimgarray
         
    }
     */
    
    var body : some View {
        
        VStack(spacing: 0){
            
            HStack (spacing: 0){
                
                Button(action: {
                    
                    repairshow = false
                    inputImage = nil
                    uiimgarray = []
                    imgnamearray = []
                    
                    repairtxt = ""
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
                
                Text("충전소 고장 신고")
                    .font(.system(size:20, weight: .regular))
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                
                
                HStack{
                    
                    VStack(alignment: .leading){
                        
                        Text("충전소 ID : " + stationinfo.statId)
                        Text("충전소 이름 : " + stationinfo.statNm)
                        Text("사용자 이메일 : " + logininfo.email)
                       
                        
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 20)
                .foregroundColor(.gray)
                .font(.system(size:15, weight: .regular))
                
                HStack{
                    
                    TextView(text: $repairtxt)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .background(Color.white)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray_t2, lineWidth: 1)
                        )
                        .onReceive(repairtxt.publisher.collect()) {
                            self.repairtxt = String($0.prefix(500))
                            }
                    
                    
                }
                .frame(height: 250)
                .padding(.horizontal, 20)
                
                HStack{
                    
                    Text("\(repairtxt.count)/500")
                        .font(.system(size:13, weight: .regular))
                        .foregroundColor(.gray_t3)
                    
                    
                    
                    //Alert을 위한 비어있는 HStack
                    HStack {}
                    .alert(isPresented: $repaircompletion) {
                        Alert(title: Text("성공적으로 접수 되었습니다."),
                              message: Text("사용자 이메일을 확인하시길 바랍니다."),
                              dismissButton: .default(
                                Text("확인"), action: {
                                    repairshow = false
                                    repairsendshow = false

                                }
                              )
                        )
                        
                    }
                    
                    //Alert을 위한 비어있는 HStack
                    HStack {}
                    .alert(isPresented: $repairfail) {
                        Alert(title: Text("접수에 실패하였습니다."),
                              message: Text("다시 시도하시길 바랍니다."),
                              dismissButton: .default(
                                Text("확인"), action: {
                                    
                                    repairsendshow = false

                                }
                              )
                        )
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        sendemailalert = true
                        repairtxt = ""
                        hideKeyboard()
                        
                    }) {
                        
                        Text("보내기")
                            .font(.system(size:14, weight: .regular))
                            .foregroundColor((repairtxt.count < 1) ? .gray_t2 : .blue)
                        
                    }
                    .disabled(repairtxt.count < 1)
                    .alert(isPresented: $sendemailalert) {
                        Alert(title: Text("고장 신고를 접수 하시겠습니까?"),
                              message: Text(""),
                              dismissButton: .default(
                                Text("확인"), action: {
                                    
                                    repairsendshow = true
                                    sendEmail(emailto: logininfo.email, stid: stationinfo.statId, stnm: stationinfo.statNm, maintxt: repairtxt, dist: String(imgnamearray.count))
                                
                                }
                              )
                        )
                    }
                    
                }
                .padding(.horizontal, 25)
                .padding(.top, 5)
                
                HStack{
                    
                    ForEach(Array(uiimgarray.enumerated()), id: \.offset) {idx, item in
                        
                        VStack{
                            
                            Image(uiImage: item)
                                .resizable().frame(width: 50, height: 50)
                            
                            Button(action: {
                                
                                print("삭제클릭됨")
                                uiimgarray.remove(at: idx)
                                imgnamearray.remove(at: idx)
                                //deleteImage(imgname: imgnamearray[idx], delidx: idx)
                                //AWS상 삭제는 매일 전달까지 이미지를 삭제하면됨
                                
                            }) {
                                
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                                    .font(.system(size:12, weight: .light))
                                
                            }
                            .padding(.top, 5)
                            
                        }
                        
                        
                    }
                    
                    Button(action: {
                        
                        hideKeyboard()
                        self.showingImagePicker = true
                        
                    }) {
                        
                        Image(systemName: "plus.square")
                            .foregroundColor(uiimgarray.count > 2 ? .white : .gray_t1)
                            .font(.system(size:35, weight: .light))
                        
                    }
                    .disabled(uiimgarray.count > 2)
                    .padding(.bottom, 30)
                    .padding(.horizontal, 5)
                    .alert(isPresented: $filesizealert) {
                        Alert(title: Text("이미지 기준 용량(5MB)을 초과 하였습니다."),
                              message: Text(""),
                              dismissButton: .default(Text("확인"))
                        )
                    }
                    
                    Spacer()
                    
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                    ImagePicker(image: self.$inputImage)
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                HStack{}
                .padding(.vertical, 30)
                
            }
           // .keyboardAware()
            .simultaneousGesture(
                DragGesture()
                    .onChanged { gesture in hideKeyboard()})
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
    func loadImage() {
        
        guard let inputImage = inputImage else { return }
        
        //메모리 로드를 줄여주기 위해 jpeg파일을 Data화여 축소함
        if let imageData = inputImage.jpegData(compressionQuality: 0.0) {
            
            if imageData.count > 5000000 {
                
                print("이미지 기준 용량(5MB)을 초과 하였습니다.")
                filesizealert = true
                
            } else {

                //let img64 = imageData.base64EncodedString(options: .lineLength64Characters)
                //img64array.append(img64)
                
                print(imageData.count)
                
                uploadImage(imagedata: imageData)
                
            }
            
        }
    
    }
    
    func uploadImage(imagedata: Data) {
        
        let url = URL(string: "https://1ihmfad041.execute-api.ap-northeast-2.amazonaws.com/uploadimg")
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        data.append(imagedata)

        session.uploadTask(with: urlRequest, from: data, completionHandler: {responseData, response, error in
            
            if error == nil {
                
                let jsonResult = try? JSONSerialization.jsonObject(with: responseData!, options: [JSONSerialization.ReadingOptions.mutableContainers])
                
                guard let newValue = jsonResult as? [Any] else {
                    print("data type error")
                    return
                       
                }
                
                print(newValue)
                
                //값이 있을때만 생성함 AWS S3에 잘 첨부되었을때
                if newValue[0] as? String != nil {
                    
                    //축수한 data를 다시 UIImage형태로 변환
                    guard let temp = UIImage(data: imagedata, scale: 1.0) else { return }
                    uiimgarray.append(temp)
                    imgnamearray.append(newValue[0] as! String)
                    
                }
                
                
            }
            
        }).resume()
    }

    /*
    func deleteImage(imgname: String, delidx: Int){
        
        let endPoint = "https://bixxycpc4m.execute-api.ap-northeast-2.amazonaws.com/deleteimg?imgname=\(imgname)"
        
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
                
                print(newValue[0])
                
                if newValue[0] as! String == "ok" {
                    
                    uiimgarray.remove(at: delidx)
                    imgnamearray.remove(at: delidx)

                } else {
                    
  
                    
                }
                
                
            } catch {
                print("raw data error")

                
            }

        })
        task.resume()
         
    }
*/
    
    func sendEmail(emailto: String, stid: String, stnm: String, maintxt: String, dist: String) {
        
        print(dist)
        
        var first = ""
        var second = ""
        var third = ""
        
        switch dist {
        
        case "1":
            first = imgnamearray[0]
            second = ""
            third = ""
            
        case "2":
            first = imgnamearray[0]
            second = imgnamearray[1]
            third = ""
            
        case "3":
            first = imgnamearray[0]
            second = imgnamearray[1]
            third = imgnamearray[2]
            
        default:
            
            print("")
            
        }
 
        
        let endPoint = "https://bhuxa9n31a.execute-api.ap-northeast-2.amazonaws.com/sendemail?emailto=\(emailto)&stid=\(stid)&stnm=\(stnm)&maintxt=\(maintxt)&dist=\(dist)&first=\(first)&second=\(second)&third=\(third)"
        
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
                    repairfail = true
                   return
                       
                }
                
                print(newValue[0])
                
                if newValue[0] as! String == "ok" {
                    
                    print("작성완료")
                    repairtxt = ""
                    inputImage = nil
                    uiimgarray = []
                    imgnamearray = []
                    repaircompletion = true
                    
                } else {
                    
                    repairfail = true
                    
                }
                
                
            } catch {
                print("raw data error")
                repairfail = true
                
                
            }
            
            print("실행되나요??")

        })
        task.resume()
        
        
    }
    

}

struct RepairSend : View {
    
    @Binding var repairshow : Bool
    @Binding var repairsendshow : Bool
    @Binding var repaircompletion : Bool
    @Binding var repairfail : Bool
    
    var body : some View {
        
        VStack{
            
            if repairsendshow == true {
                
                if #available(iOS 14.0, *) {
                    
                    ProgressView()
                    
                } else {
                    
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                    
                }
                
            }

        }

    }
    
}
