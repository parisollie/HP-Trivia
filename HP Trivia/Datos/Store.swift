//
//  Store.swift
//  HP Trivia
//
//  Created by Paul F on 24/10/24.
//

//V-105,Paso 200, creamos el archivo store
import Foundation
import StoreKit

//Paso 283, le ponemos codable
enum BookStatus: Codable{
    //V-96,paso 74,estado de los libros
    case active
    case inactive
    case locked
}

//Paso 201,Queremos esta clase corra
@MainActor
class Store: ObservableObject {
    //Paso 75,ponemos los 7 libros de HP
    @Published var books: [BookStatus] = [.active,.active,.inactive,.locked,.locked,.locked,.locked]
    //Paso 209
    @Published var products: [Product] = []
    //Paso 213
    @Published var purchasedIDs = Set<String>()
    //Paso 210
    private var productIDs = ["hp4","hp5","hp6","hp7"]
    private var updates: Task<Void, Never>? = nil

    //Paso 217, init
    init(){
        updates = watchForUpdates()
    }
    
    //V-114,paso 280
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedBookStatus")
    
    //Paso 211
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            products.sort {        $0.displayName < $1.displayName}
        }catch{
            print("Couldn't load  fetch those products: \(error)")
        }
    }
    
    //V-107,Paso 212
    func purchase(_ product: Product) async {
        do{
            //Que producto que queremos traer
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
    
    //Paso 214, ver esto ,porque es complicado ,es para la compra en la tienda.
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
    //Paso 215
    private func watchForUpdates() ->Task<Void, Never> {
        Task(priority: .background){
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
    
    
    //Paso 281
    func saveStatus(){
        do{
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath)
        }catch{
            print("Unable to save data.")
            
        }
    }
    //Paso 284
    func loadStatus(){
        do{
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([BookStatus].self, from: data)
            
        }catch{
            print("Couldn't load book statuses.")
        }
    }
    
    
}
