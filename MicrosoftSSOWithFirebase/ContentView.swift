import SwiftUI

struct ContentView: View {
     
    var authProvider = AuthProvider()
    
    var body: some View {
        Button(action: {
            self.authProvider.login()
        }) {
            Text("SSO Microsoft")
                .font(.title)
        }
    }
}
