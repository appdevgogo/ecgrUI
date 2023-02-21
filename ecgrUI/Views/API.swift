import SwiftUI
import UIKit


struct APIView : UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> APIViewController {
        
        let view = APIViewController()

        return view
    }
    
    func updateUIViewController(_ uiViewController: APIViewController, context: Context) {
        
    }
    
}



class APIViewController: UIViewController, XMLParserDelegate {
    
    var xmlParser = XMLParser()
    
    var currentElement = ""
    var cgrdb = [("","")]
    
    var tempArray = [String]()
    
    var statNm = "" //제목
    var statId = "" //내용
    
    
    func requestcgrInfo() {
        //let key = "bWJ5RxDJgbAJp5UWioBn%2FHa2nI4t00pFAe5LTCA%2FnE3UmVXTjO3u4inYmSOJx0CrTULEdzDT1z%2B7WmkerODLBg%3D%3D"

        let url = "http://open.ev.or.kr:8080/openapi/services/EvCharger/getChargerInfo?&serviceKey=bWJ5RxDJgbAJp5UWioBn%2FHa2nI4t00pFAe5LTCA%2FnE3UmVXTjO3u4inYmSOJx0CrTULEdzDT1z%2B7WmkerODLBg%3D%3D"
               
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else { return }
        
        
        xmlParser.delegate = self;
        xmlParser.parse()
        
    }
   
   override func viewDidLoad() {
       super.viewDidLoad()
        requestcgrInfo()
    }
    
        
    // XML 파서가 시작 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        if(elementName=="item"){
            
            statNm = ""
            statId = ""
           
        }
            
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if (currentElement == "statNm") {
            statNm = string
            
        } else if (currentElement == "statId") {
            statId = string
        }

    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if(elementName == "item"){

            cgrdb.append((statNm, statId))
            
            tempArray.append(statNm)
            print(cgrdb)
            
        }
        
        
          
    }
    

}




