import Foundation

protocol SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

class APIClient {
    lazy var session: SessionProtocol = URLSession.shared
    
    func loginUser(withName username: String,
                   password: String,
                   completion: @escaping (Token?, Error?) -> Void) {
        
        let query = "username=\(username.percentEncoded)&password=\(password.percentEncoded)"
        guard let url = URL(string:"https://awesometodos.com/login?\(query)") else { fatalError() }
        
        session.dataTask(with: url) { (data, response, error) in
            
        }
    }
}

extension URLSession: SessionProtocol {}

extension String {
    var percentEncoded: String {
        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let encoded = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        return encoded
    }
}
