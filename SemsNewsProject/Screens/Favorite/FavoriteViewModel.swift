//
//  FavoriteViewModel.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 19.03.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase

protocol FavoriteViewModelDelegate: AnyObject {
    func favoriteSuccess(firebaseModels: [FirebaseModel])
    func favoriteFail(message: String)
}

class FavoriteViewModel {
    
    // MARK: - Delegate
    weak var delegate : FavoriteViewModelDelegate?
    
    // MARK: - Properties
    private var firebaseModels: [FirebaseModel] = []
    
    func getData() {
        let fireStore = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email else { return }
        fireStore.collection("Favorite").document(email).collection(userId).getDocuments(completion: { snapShot, error in
        
            if let error = error {
                self.delegate?.favoriteFail(message: error.localizedDescription)
                return
            }

            guard let snapShot = snapShot else {
                self.delegate?.favoriteFail(message: "Your favorites are currently empty.")
                return
            }
            
            for document in snapShot.documents {
                if let model = try? FirestoreDecoder().decode(FirebaseModel.self, from: document.data()) {
                    self.firebaseModels.append(model)
                }
            }
            self.delegate?.favoriteSuccess(firebaseModels: self.firebaseModels)
        })
    }
}
