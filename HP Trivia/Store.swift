//
//  Store.swift
//  HP Trivia
//
//  Created by Paul F on 24/10/24.
//

import Foundation
import StoreKit

//Vid 119

enum BookStatus: Codable{
    //Vid 110,estado de los libros
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    //Vid 110P,onemos los 7 libros de HP
    @Published var books: [BookStatus] = [.active,.active,.inactive,.locked,.locked,.locked,.locked]
    // 119
    @Published var products: [Product] = []
    //Vid 120
    @Published var purchasedIDs = Set<String>()
    
    private var productIDs = ["hp4","hp5","hp6","hp7"]
    //Vid 120
    private var updates: Task<Void, Never>? = nil

    //Vid 120
    init(){
        updates = watchForUpdates()
    }
    
    //Vid 128
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedBookStatus")
    
    //Vid 119
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            products.sort {        $0.displayName < $1.displayName}
        }catch{
            print("Couldn't load  fetch those products: \(error)")
        }
    }
    
    //Vid 120
    
    func purchase(_ product: Product) async {
        do{
            let result = try await product.purchase()
            switch result {
            //Purchase successfull, but now we have to verify reeipt
            case .success(let verificationResult):
                switch verificationResult {
                   case .unverified(let signedType, let verificationError):
                        print("Error on \(signedType): \(verificationError)")
                   case .verified(let signedType):
                        purchasedIDs.insert(signedType.productID)
                }
                
            //user cancelled or parent disapproved child's purchase request
            case .userCancelled:
                break
            
            //Waiting for approval
            case .pending:
                break
        
            @unknown default:
                break
            }
            
        } catch{
            print ("Couldn't purchase that product: \(error)")
        }
        
    }
    
    //Vid 120
    private func checkPurchased() async {
        for product in products {
            guard let state = await product.currentEntitlement else {return}
            
            switch state {
                case .unverified(let signedType, let verificationError):
                     print("Error on \(signedType): \(verificationError)")
                
                case . verified(let signedType):
                     if signedType.revocationDate == nil {
                          purchasedIDs.insert(signedType.productID)
                    }else{
                          purchasedIDs.remove(signedType.productID)
                    }
            }
        }
    }
    //Vid 120
    private func watchForUpdates() ->Task<Void, Never> {
        Task(priority: .background){
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
    
    
    //Vid 128
    
    func saveStatus(){
        do{
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath)
        }catch{
            print("Unable to save data.")
            
        }
    }
    
    func loadStatus(){
        do{
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([BookStatus].self, from: data)
            
        }catch{
            print("Couldn't load book statuses.")
        }
    }
    
    
}
