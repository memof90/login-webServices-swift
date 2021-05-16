//
//  NewtworkServices.swift
//  Login
//
//  Created by Memo Figueredo on 11/5/21.
//

import Foundation


// MARK: Service Singlenton

class NetworkServices {
//    pass services to controller across of instance
    static let shared = NetworkServices()
    
    //    MARK:URL-SERVER
    //   root: basic '/'
    
    let URL_BASE = "https://develop.datacrm.la/datacrm/pruebatecnica/webservice.php?operation=getchallenge&username=prueba"
    
    //   root: login '/'
    let URL_LOGIN = "https://develop.datacrm.la/datacrm/pruebatecnica/webservice.php"
    
    
//    root: sessionName={{sessionName}} '/'
    
    let URL_LIST = "https://develop.datacrm.la/datacrm/pruebatecnica/webservice.php?operation=query"

    let session = URLSession(configuration: .default)
    
//    MARK: function to obtain token
    
    func getToken(onSucees: @escaping (Token) -> Void, onError: @escaping (String) -> Void) {
        let url = URL(string: "\(URL_BASE)")!

        let task = session.dataTask(with: url) { (data, response, error) in
            
//         obtain process response in background
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
    //            MARK: We have to handle 500 or 400 errors or 200 success
                do {
                    
                    if response.statusCode == 200 {
        //                parse successful result (token)
                        let tokens = try JSONDecoder().decode(Token.self, from: data)
    //                    handle success
                        onSucees(tokens)
                        
                    } else {
        //                show error to user
                        let err = try JSONDecoder().decode(APIError.self, from: data)
    //                    handle erorr
                        onError(err.message)
                    }
                    
                } catch {
                    onError(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

    //    MARK: function to login
    func singIn(token: String, onSuceess: @escaping (LogIn) -> Void, onError: @escaping (String) -> Void) {
//        Mark: URL Login
        let url = URL(string: "\(URL_LOGIN)")!
        var request = URLRequest(url: url)
        
//        MARK: accessKey key converitdo a md5 y convertido a string para un login satisfactorio
//        MARK: SI el accessKey no esta converitdo a string no pasa la session invalid user o passowrd
        
        let accessKey = String("\(token + "d0n9nzY6w66xuJtd")".md5())
        
//        MARK: HEADERS SOLICITUD Dicionarios
        let requestHeader: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        var requestBodyComponents = URLComponents()
        
        requestBodyComponents.queryItems = [URLQueryItem(name: "operation", value: "login"),
                                            URLQueryItem(name: "username", value: "prueba"),
                                            URLQueryItem(name: "accessKey", value: accessKey)]
        

//        metodo HTTP POST
        request.httpMethod = "POST"
//        Requets Headers
        request.allHTTPHeaderFields = requestHeader
//        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        do {
//            pass params to body to response 200 in server
            let body = requestBodyComponents.query?.data(using: .utf8)
            request.httpBody = body
//            pass data, reponse and posible errors in request
            let task = session.dataTask(with: request) { data, response, error in
                //  obtain process response in background
                DispatchQueue.main.async {
                 if let error = error {
                   onError(error.localizedDescription)
                 return}
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                do {
                    // MARK: We have to handle 500 or 400 errors or 200 success
                    if response.statusCode == 200 {
                        // parse successful result (session or log in)
                        let items = try JSONDecoder().decode(LogIn.self, from: data)
                        debugPrint(items)
                        // handle success
                        onSuceess(items)
                    } else {
                        // show error to user
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                } catch {
//                    handle erorr
                    onError(error.localizedDescription)
                }
            }
//            suscess request
            task.resume()
        }
        
//        MARK: Primera comprobacion satisfactoria me da el login saticfactorio codigo Refactorizado
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let response = response {
//                debugPrint(response)
//            }
//            if let data = data {
//               debugPrint(data)
//                print(String(data: data, encoding: .utf8))
//            }
//        }.resume()
//

    }
    
    //    MARK: FUNCTION TO OBTAIN LIST CONTACT
    
    func fetchAll(sessionName: String, onSucees: @escaping (Contacts) -> Void, onError: @escaping (String) -> Void) {
        
        var requestBodyComponents = URLComponents()
        requestBodyComponents.scheme = "https"
        requestBodyComponents.host = "develop.datacrm.la"
        requestBodyComponents.path = "/datacrm/pruebatecnica/webservice.php"



        requestBodyComponents.queryItems = [ URLQueryItem(name: "operation", value: "query"),
                                             URLQueryItem(name: "sessionName", value: sessionName),
                                             URLQueryItem(name: "query", value: "select * from Contacts;")                                                ]

        print(requestBodyComponents.string!)
        
        let url = URL(string: requestBodyComponents.string!)!
        
        let task = session.dataTask(with: url) { (data, response, error) in
                    
        //            Grand central Dispath es le sistema de enhebrado contruido por ios
        //            para hacer solictidus URLSession de manera asyncrona y cuyas tareas se ejecuten en segundo plano
                    DispatchQueue.main.async {
                        if let error = error {
                            onError(error.localizedDescription)
                            return
                        }
                        
                        guard let data = data, let response = response as? HTTPURLResponse else {
                            onError("Invalid data or response")
                            return
                        }
                        
            //            MARK: Tenemos que manejar los errores 500 or 400 o exito 200
                        do {
                            
                            if response.statusCode == 200 {
                //                parse successful result (todos)
                                let items = try JSONDecoder().decode(Contacts.self, from: data)
            //                    handle success
                                onSucees(items)
                                
                            } else {
                //                show error to user
                                let err = try JSONDecoder().decode(APIError.self, from: data)
            //                    handle erorr
                                onError(err.message)
                            }
                            
                        } catch {
                            onError(error.localizedDescription)
                        }
                    }
                }
                task.resume()
        
    }
    
    
//    MARK: FUNCTION TO OBTAIN LIST CONTACT
//    func fetchList(sessionName: String, completion: @escaping ([ListContact], Error?) -> ()) {
//        print("Fetching itunes from Service Layer")
//       
//        
//        var requestBodyComponents = URLComponents()
//        requestBodyComponents.scheme = "https"
//        requestBodyComponents.host = "develop.datacrm.la"
//        requestBodyComponents.path = "/datacrm/pruebatecnica/webservice.php"
//
//
//
//        requestBodyComponents.queryItems = [ URLQueryItem(name: "operation", value: "query"),
//                                             URLQueryItem(name: "sessionName", value: sessionName),
//                                             URLQueryItem(name: "query", value: "select * from Contacts;")                                                ]
//
//        print(requestBodyComponents.string!)
//        
//        let url = URL(string: requestBodyComponents.string!)!
//        
//      
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            //   ////        failaure
//                       if let error = error {
//                           print("Failed to fetch apps:", error)
//                           return
//                       }
////                    print(data)
//                print(String(data: data!, encoding: .utf8))
//            guard let data = data  else {return}
//            
//            do {
//                let searchResult = try JSONDecoder().decode(Contacts.self, from: data)
////                            print(searchResult)
//                completion(searchResult.result, nil)
//               
//
//            } catch let jsonErr {
//                debugPrint("Failed to decode json:", jsonErr)
//                completion([], jsonErr)
//            }
//            
//        }.resume()
//
//        
//     
//    }
    
}
