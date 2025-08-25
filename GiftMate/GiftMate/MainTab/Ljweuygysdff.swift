import SwiftUI
import WebKit


class Ljweuygysdff: ObservableObject {
    func pageDidLoad() {
            yhdjbs = false
        }
    
    @Published var hjsabc: String = "evsdfbdfb"
    @Published var yhdjbs: Bool = true
    @Published var cgajbhc: Bool = false
    @Published var nvfgusd: Bool = false
    @Published var tyshv = UserDefaults.standard.bool(forKey: "eergdsgfg")
    @AppStorage("bfv") var bfv: URL!
    @AppStorage("bsbvsjvbv") var bsbvsjvbv: Bool = true
    @AppStorage("vwuhbvuwevb") var vwuhbvuwevb: String = "bsuhbvsdjvbjhsdv"
    @Published var vgshjbv: Bool = false
    @Published var yvuahbjv: URLRequest? = nil
    @Published var vyuhbjsdv: WKWebView? = nil

}

struct Phweygtufgsdhf: View {

     enum NavigationAction {
           case sergdffdg(WKNavigationAction,  (WKNavigationActionPolicy) -> Void)
           case husjkvdbfjhb(URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
           case jwhuisjknfbhdfjb(WKNavigation)
           case jiwhuhjkbjhdsbvn(WKNavigation)
           case ytuiihasguhjbvsdv(WKNavigation)
           case jbhaujksndvbh(WKNavigation)
           case jhugyfihajskbdv(WKNavigation,Error)
           case hbeugwvauhsjbdv(WKNavigation,Error)
       }
       
    @ObservedObject var bvygushbjvdsv: Ljweuygysdff
     
    private var actionDelegate: ((_ navigationAction: Phweygtufgsdhf.NavigationAction) -> Void)?
    let gvweuahjbsdvghsb: URLRequest
    var body: some View {
        
        ZStack{
          
            Oidshvb(hwgvfbdsfbvweghjb: bvygushbjvdsv,
                           action: actionDelegate,
                            request: gvweuahjbsdvghsb).zIndex(99)
            ZStack{
                VStack{
                    HStack{
                        Button(action: {
                            
                                       bvygushbjvdsv.nvfgusd = true
                                       bvygushbjvdsv.vyuhbjsdv?.removeFromSuperview()
                                       bvygushbjvdsv.vyuhbjsdv?.superview?.setNeedsLayout()
                                       bvygushbjvdsv.vyuhbjsdv?.superview?.layoutIfNeeded()
                                       bvygushbjvdsv.vyuhbjsdv = nil
                                       bvygushbjvdsv.vgshjbv = false
                        }) {
                            
                            Image(systemName: "chevron.backward.circle.fill").resizable().frame(width: 20, height: 20).foregroundColor(.white)
                            
                        }.padding(.leading, 20).padding(.top, 15)
                        Spacer()
                    }
                    Spacer()
                }
            }.ignoresSafeArea()
        }.statusBarHidden(true)

        .onAppear(){
            AppDelegate.orientationLock = UIInterfaceOrientationMask.all
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
       
    }

    init(uRLRequest: URLRequest, webViewStateModel: Ljweuygysdff) {
        self.gvweuahjbsdvghsb = uRLRequest
        self.bvygushbjvdsv = webViewStateModel
         
    }
    
    init(url: URL, webViewStateModel: Ljweuygysdff) {
        self.init(uRLRequest: URLRequest(url: url),
                  webViewStateModel: webViewStateModel)
    }
    
    
}


struct Oidshvb : UIViewRepresentable {
   
    @ObservedObject var vsgxjhvg: Ljweuygysdff
    private var hgsvxv: WKWebView?
    let action: ((_ navigationAction: Phweygtufgsdhf.NavigationAction) -> Void)?
    @State private var themeObservation: NSKeyValueObservation?
    @State var underPageBackgroundColor: UIColor!
    let request: URLRequest
  @State private var ytwjfhgsv: WKWebView?
    
    init(hwgvfbdsfbvweghjb: Ljweuygysdff,
    action: ((_ navigationAction: Phweygtufgsdhf.NavigationAction) -> Void)?,
    request: URLRequest) {
        self.action = action
        self.request = request
        self.vsgxjhvg = hwgvfbdsfbvweghjb
        self.ytwjfhgsv = WKWebView()
        self.ytwjfhgsv?.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
        self.ytwjfhgsv?.scrollView.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
        self.ytwjfhgsv = WKWebView()
        
        self.ytwjfhgsv?.isOpaque = false
        viewDidLoad()
        
    }
   
    func viewDidLoad() {
        

        self.ytwjfhgsv?.backgroundColor = UIColor.black
        if #available(iOS 15.0, *) {
            themeObservation = ytwjfhgsv?.observe(\.themeColor) {  webView, _ in
                self.ytwjfhgsv?.backgroundColor = webView.themeColor ?? .systemBackground
               
            }
        } else {
             
        }
     }
    func makeUIView(context: Context) -> WKWebView  {
        var view = WKWebView()
        let wkPreferences = WKPreferences()
        @ObservedObject var webViewStateModel: Ljweuygysdff
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true

        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences = wkPreferences
        configuration.applicationNameForUserAgent = "Version/17.2 Mobile/15E148 Safari/604.1"
        view = WKWebView(frame: .zero, configuration: configuration)
        view.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        view.navigationDelegate = context.coordinator
        view.uiDelegate = context.coordinator
        view.allowsBackForwardNavigationGestures = true
      

        view.load(request)
        
       

        return view
    }
   
     func updateUIView(_ uiView: WKWebView, context: Context) {


         self.ytwjfhgsv = WKWebView()

        if uiView.canGoBack, vsgxjhvg.nvfgusd {
            uiView.goBack()
            vsgxjhvg.nvfgusd = false

        }


    }
    var onThirdRedirecttt: ((_ url: URL) -> Void)?
    func makeCoordinator() -> Coordinator {
           return Coordinator(parent: self, action: nil, webViewStateModel: self.vsgxjhvg)
       }

    final class Coordinator: NSObject {
        var popupWebView: WKWebView?
        var parent: Oidshvb
        var redirectCounter = 0
        var redirectstring = ""
        
        
        var bheyewuhvviuehv: Ljweuygysdff
        let action: ((_ navigationAction: Phweygtufgsdhf.NavigationAction) -> Void)?
        
        init(parent: Oidshvb, action: ((_ navigationAction: Phweygtufgsdhf.NavigationAction) -> Void)?, webViewStateModel: Ljweuygysdff) {
            self.parent = parent
            self.action = action
            self.bheyewuhvviuehv = webViewStateModel
            super.init()
        }
    }

}

extension Oidshvb.Coordinator: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    
                
                let response = navigationResponse.response as? HTTPURLResponse
                if let headers = response?.allHeaderFields as? [String: Any] {
                    print("Response Headers: \(headers)")
                }
                decisionHandler(.allow)
            }
 
        
    func webView(_ uyhdsfuygf: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let jsCode = "var allLinks = document.getElementsByTagName('a');if (allLinks) { var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target');if (target && target == '_blank') {link.setAttribute('target','_self');} } }"
        uyhdsfuygf.evaluateJavaScript(jsCode, completionHandler: nil)
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            uyhdsfuygf.load(navigationAction.request)
           decisionHandler(.cancel)
           return
        }
        
        if action == nil {
            decisionHandler(.allow)
        } else {
            action?(.sergdffdg(navigationAction, decisionHandler))
           
        }
        
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        action?(.jwhuisjknfbhdfjb(navigation))
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        action?(.jiwhuhjkbjhdsbvn(navigation))
        if webView.url != nil {
                   
                }
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        bheyewuhvviuehv.yhdjbs = false
        bheyewuhvviuehv.cgajbhc = webView.canGoBack
        action?(.jhugyfihajskbdv(navigation, error))
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        action?(.ytuiihasguhjbvsdv(navigation))
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame != true {
            
            let popupWebView = WKWebView(frame: webView.bounds, configuration: configuration)
            
            popupWebView.navigationDelegate = self
            
            popupWebView.uiDelegate = self
             
            webView.addSubview(popupWebView)
            webView.setNeedsLayout()
            webView.layoutIfNeeded()
           
            bheyewuhvviuehv.vyuhbjsdv = popupWebView
            
            bheyewuhvviuehv.vgshjbv = true
            
            return popupWebView
        }
        return popupWebView
    }

    func webView(_ vgweubhdvhsdkv: WKWebView, didFinish navigation: WKNavigation!) {
        bheyewuhvviuehv.yhdjbs = false
         
        bheyewuhvviuehv.tyshv = true
        UserDefaults.standard.set(bheyewuhvviuehv.tyshv, forKey: "eergdsgfg")
        
        vgweubhdvhsdkv.allowsBackForwardNavigationGestures = true
        bheyewuhvviuehv.cgajbhc = vgweubhdvhsdkv.canGoBack
        if let title = vgweubhdvhsdkv.title {
            bheyewuhvviuehv.hjsabc = title
        }
        
        vgweubhdvhsdkv.configuration.mediaTypesRequiringUserActionForPlayback = .all
        vgweubhdvhsdkv.configuration.allowsInlineMediaPlayback = false
        vgweubhdvhsdkv.configuration.allowsAirPlayForMediaPlayback = false
        action?(.jbhaujksndvbh(navigation))
        
        guard let destinationUrl = vgweubhdvhsdkv.url?.absoluteURL.absoluteString else {
            
            return
        }
    
        var components = URLComponents(string: destinationUrl)!
        let cutUrl = components.url!.absoluteString
        
        if bheyewuhvviuehv.vwuhbvuwevb == "bsuhbvsdjvbjhsdv" && self.bheyewuhvviuehv.bsbvsjvbv{
                self.bheyewuhvviuehv.vwuhbvuwevb = components.url!.absoluteString
           
            
                self.bheyewuhvviuehv.bsbvsjvbv = false
                self.bheyewuhvviuehv.yhdjbs = false

           
        } else {
            
        }

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        bheyewuhvviuehv.yhdjbs = false
        action?(.hbeugwvauhsjbdv(navigation, error))
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if action == nil  {
            completionHandler(.performDefaultHandling, nil)
        } else {
            action?(.husjkvdbfjhb(challenge, completionHandler))
        }
        
    }
    
    
    func webViewDidClose(_ webView: WKWebView) {
        if webView == popupWebView {
            popupWebView?.removeFromSuperview()
            popupWebView = nil
        }
    }
    
}


