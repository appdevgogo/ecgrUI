
/*
DispatchQueue.main.async {
    
}
 
*/
/*
Button(action: {
    
    logoutexe = true
    
}) {
    
    Text("로그아웃")
        .foregroundColor(.gray_t3)
        .font(.system(size:14, weight: .regular))
    
}
*/

/*
 ForEach(bsearcharray, id: \.id) {item in
     
     Button(action: {
 
         searchBtnAct(title: item.addr, dist: 2, lat: item.lat, lng: item.lng, statid: "")
         print("B클릭")
                        
     }){
                
         SearchBtnView(icon: "aspectratio", qtxt: qtxt, name: item.addr)
         
     }
     .foregroundColor(Color.black)
     
 }
 .padding(.vertical, 10)
 
 
//그리드뷰
ForEach(0..<bfilterarray.count/2) { row in

  HStack {
      
          ForEach(0..<2) { column in
              // create 3 columns
              
              HStack{
                  
                  Image(systemName: "checkmark.square")
                      .foregroundColor(bfilterarray[row * 2 + column].on == 0 ? Color("gray_t1") : Color.green)
                      .font(.system(size:22))
                  
                  Text(bfilterarray[row * 2 + column].stnm)
                  
              }.frame(width: (UIScreen.main.bounds.width * 0.9)/2)
              
          }
      
      }

  }
 
*/





/* realm파일을 제거해주는 문구(이니셜에 넣어주면됨)
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

/* realm파일네 오브젝트(=db) 삭제
let realm = try! Realm()

try! realm.write {
    realm.deleteAll()
}
*/


/*

let realm = try! Realm()
let theDog = realm.objects(Dog.self).filter("age == 1").first
try! realm.write {
  theDog!.age = 3
}

*/


/* realm에서 필터를 통해 데이터 추출하는 문구
 for item in realm.objects(data.self).filter("id == 2 AND user_id == 4") {
    print(item)
 }
 */

/* realm에서 데이터 쓰기를 시행 문구
let realm = try! Realm()
 
try! realm.write {
       realm.add(initLtn, update: .modified)
 }
*/

/*

let realm = try! Realm()
if let userObject = realm.objects(userInfos.self).filter("id == 0").first {
 print("User is existed, it's being deleted.")
 try! realm.write {
      realm.delete(userObject)
 }
 print("Deleted.")
}
else{
 print("User is not found.")
}
 
let realm = try! Realm()
let toDel = realm.objects(ecgrDB.self)

try! realm.write {
  realm.delete(toDel)
}
 
 
 
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
 
default:
 Text("")
}
 

 if false || false{
     print("실행 되지 않습니다")
 }
 
 
 // Swift // // Extend the code sample from 6a. Add Facebook Login to Your Code // Add to your viewDidLoad method: loginButton.permissions = ["public_profile", "email"]


 <string>fbapi</string>
 <string>fbapi20130214</string>
 <string>fbapi20130410</string>
 <string>fbapi20130702</string>
 <string>fbapi20131010</string>
 <string>fbapi20131219</string>
 <string>fbapi20140410</string>
 <string>fbapi20140116</string>
 <string>fbapi20150313</string>
 <string>fbapi20150629</string>
 <string>fbapi20160328</string>
 <string>fbauth</string>
 <string>fb-messenger-share-api</string>
 <string>fbauth2</string>
 <string>fbshareextension</string>
 
 
*/



