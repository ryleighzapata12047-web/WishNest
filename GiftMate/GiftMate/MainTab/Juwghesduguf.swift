
import Foundation
import SwiftUI

struct Juwghesduguf: View {
   
   @ObservedObject var iuwegfhdsb: Ljweuygysdff = Ljweuygysdff()
   @State var uysdhjfbn: Bool = true
   var body: some View {
       ZStack{
           Color.white
               .ignoresSafeArea()
               
           if let url = URL(string: UserDataManager.njwhbueihjskbdvshjbv.jhgb ?? "") {
             

               Nbvsdjhbv(gggsdhvc: $uysdhjfbn) {
                   Phweygtufgsdhf(url: url, webViewStateModel: iuwegfhdsb)
                       .background(Color.black.ignoresSafeArea())
                       .edgesIgnoringSafeArea(.bottom)
                       .onAppear{
                          
                           DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                               uysdhjfbn = false

                           }
                           
                       }
               }
                       } else {
                           
                           ZStack{
                               Nbvsdjhbv(gggsdhvc: $uysdhjfbn) {
                                   Phweygtufgsdhf(url:  URL(string: iuwegfhdsb.vwuhbvuwevb)!, webViewStateModel: iuwegfhdsb) .background(Color.black.ignoresSafeArea()).edgesIgnoringSafeArea(.bottom).onAppear{
                                       
                                   }
                               }
                               
                           }.onAppear{
                              
                               DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                                   uysdhjfbn = false
                               }
                           }
                                  
                              
                          
                       }
       }
   }
   
}

class UserDataManager {
   static let njwhbueihjskbdvshjbv = UserDataManager()
   
   var jhgb: String?
   var nbuhb: String?
   var bvygh: String?
}
