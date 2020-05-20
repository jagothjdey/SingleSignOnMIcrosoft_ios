import Foundation
import Firebase
import FirebaseAuth

class AuthProvider{
    var microsoftProvider : OAuthProvider?
    let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
    
    init() {
        self.microsoftProvider = OAuthProvider(providerID: "microsoft.com")
    }
    
    func login(){
        self.microsoftProvider?.getCredentialWith(_: nil){credential, error in
            
            print("Credential \(credential)")
            if error != nil {
                print(error?.localizedDescription)
            }
            if let credential = credential {
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    
                    guard let authResult = authResult else {
                        print("Couldn't get graph authResult")
                        return
                    }
                    
                    // get credential and token when login successfully
                    let microCredential = authResult.credential as! OAuthCredential
                    let token = microCredential.accessToken!
                    
                    print("Token : \(token)")
                    
                    // use token to call Microsoft Graph API
                    self.getGraphContentWithToken(accessToken: token)
                }
            }
        }
    }
    
    func getGraphContentWithToken(accessToken: String) {
        
        // Specify the Graph API endpoint
        let url = URL(string: kGraphURI)
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Couldn't get graph result: \(error)")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                
                print("Couldn't deserialize result JSON")
                return
            }
            
            print("Result from Graph: \(result))")
            
        }.resume()
    }
    
}
