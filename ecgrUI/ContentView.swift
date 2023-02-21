import SwiftUI
import Combine

struct ContentView: View {
       
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//상세페이지에서 사용해야하는 데이터만 받아오면됨
struct StationInfo {
    
    var statNm = ""
    var statId = ""
    var chgerId : Int = 0
    var chgerType : Int = 0
    var addr = ""
    var addCd = ""
    var lat : Double = 0.0
    var lng : Double = 0.0
    var useTime = ""
    var busiId = ""
    var busiCall = ""
    var stat : Int = 0
    var statUpdDt = ""
    var powerType = ""
    var num = ""
    
}


//검색관련한 코더블 하나 더 추가해야함
struct ASearchInfo {
    
    var id = UUID()
    var name = ""
    var addr = ""
    var lat : Double = 0.0
    var lng : Double = 0.0
}

struct BSearchInfo {
    
    //var id = UUID()
    var bcode = ""
    var addr = ""
    var lat : Double = 0.0
    var lng : Double = 0.0
    
}

struct CSearchInfo {
    
    var statid = ""
    var name = ""
    var addr = ""

}

struct RSearchInfo {
    
    var group : Int = 0
    var name = ""
    var addr = ""
    var lat : Double = 0.0
    var lng : Double = 0.0
    var rsid = ""

}

struct LSearchInfo {
    
    var group : Int = 0
    var lat : Double = 0.0
    var lng : Double = 0.0

}

struct LogInInfo {
    
    var sns = ""
    var snsid = ""
    var name = ""
    var nickname = ""
    var email = ""
    var appid = ""
    var appidshort = ""
    
}

struct BookMarkInfo {
    
    var statid = ""
    var name = ""
//    var addr = ""

}

struct ReviewInfo {
    
    var nickname = ""
    var stid = ""
    var reviewid = ""
    var review = ""
    var reviewlong : Int = 0
    var level = ""
    var time = ""
    var timediffer = ""
    var no : Int = 0
    var mine : Int = 0
    var replycount : Int = 0
    
}

struct ReplyInfo {
    
    var nickname = ""
    var stid = ""
    //var reviewid = ""
    var replyid = ""
    var reply = ""
    var level = ""
    var time = ""
    var timediffer = ""
    var no : Int = 0
    var mine : Int = 0
    
}

struct AFilterInfo {
    
    var id : String = ""
    var nm : String = ""
    var on : Int = 0
    
}

struct BFilterInfo {
    
    var stid : String = ""
    var stnm : String = ""
    var on : Int = 0
    
}

struct FilterInfo {
    
    var ac : Bool = false
    var ac3 : Bool = false
    var combo : Bool = false
    var cha : Bool = false
    
    //var 
    
    var able : Bool = false
    //var company = []
    
}

extension Color {
    
    static let gray_t0 = Color("gray_t0")
    static let gray_t1 = Color("gray_t1")
    static let gray_t2 = Color("gray_t2")
    static let gray_t3 = Color("gray_t3")
    static let status_bar = Color("status_bar")
    static let header = Color("header")
    static let icon = Color("icon")
    
}

//글자를 Index 범위로 추출하기위한 String 확장함수
extension String {
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

//문자열에 html 태그가 있을시 제거해주는 함수
extension String {
    
    var withoutHtmlTags: String {
        
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options:
    .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with:
    "", options:.regularExpression, range: nil)
        
    }
    
}
extension MutableCollection {
    mutating func mutateEach(_ body: (inout Element) throws -> Void) rethrows {
        for index in self.indices {
            try body(&self[index])
        }
    }
}


//진행중일때 로고 돌아가는것 보여주는 함수
struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
/*
struct ColoredToggleStyle: ToggleStyle {
    
    var label = ""
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
            Spacer()
            Button(action: { configuration.isOn.toggle() } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
        }
        .font(.title)
        .padding(.horizontal)
    }
}
*/


//크기가 변형되는 텍스트 필드(아래 struct과 세트)
fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont(name: "HelveticaNeue", size: 15) //글자크기 변경해야함
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        textField.autocorrectionType = .no //자동 수정 제거
        textField.autocapitalizationType = .none
        
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        /*
        if uiView.window != nil, !uiView.isFirstResponder {
            //uiView.becomeFirstResponder()
        }
        */
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }

}

//자동으로 사이즈가 증가하는 텍스트필드(리뷰,댓글)
struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false

    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, onDone: onCommit)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}

//고정된 사이즈의 텍스트 필드(고장신고)
struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = UIFont(name: "HelveticaNeue", size: 15)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.autocorrectionType = .no //자동 수정 제거
        myTextView.autocapitalizationType = .none
       // myTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)

        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            //print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
    }
}

//키보드 숨기게 하는것(Multi라인 텍스트 필드는 별도로 구현해야함)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//키보드가 위에 있을때 키보드 크기까지 Scroll이 되게 하는 기능
public class KeyboardInfo: ObservableObject {

    public static var shared = KeyboardInfo()

    @Published public var height: CGFloat = 0

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardChanged(notification: Notification) {
        if notification.name == UIApplication.keyboardWillHideNotification {
            self.height = 0
        } else {
            self.height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
        }
    }

}

struct KeyboardAware: ViewModifier {
    @ObservedObject private var keyboard = KeyboardInfo.shared

    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.keyboard.height)
            .edgesIgnoringSafeArea(self.keyboard.height > 0 ? .bottom : [])
            .animation(.easeOut(duration: 0.0))
    }
}

extension View {
    public func keyboardAware() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAware())
    }
}



func timeDiffer(time : String) -> String{
    
    let now = Date()

    let date_kr = DateFormatter()
    date_kr.locale = Locale(identifier: "ko_kr")
    date_kr.timeZone = TimeZone(abbreviation: "UTC")
    date_kr.dateFormat = "yyyy-MM-dd HH:mm:ss"

    let timenow = date_kr.string(from: now)
    let timereview = String(time.prefix(19))
    
    let diffsnow = date_kr.date(from: timenow)!
    let diffsreview = date_kr.date(from: timereview)!

    let diffs = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: diffsreview, to: diffsnow)
    
    var result = ""
    
    if diffs.year! > 0 {
        
        result = String(diffs.year!) + "년전"
    
    } else if diffs.month! > 0 {
        
        result = String(diffs.month!) + "개월전"
        
    } else if diffs.day! > 0 {
        
        result = String(diffs.day!) + "일전"
        
    } else if diffs.hour! > 0 {
        
        result = String(diffs.hour!) + "시간전"
        
    } else if diffs.minute! > 0 {
        
        result = String(diffs.minute!) + "분전"
        
    } else if diffs.second! >= 0 {
        
        result = "방금전"
    
    } else {
        
        result = ""
        
    }
    
    return result
        
}
