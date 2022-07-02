import Foundation
import Combine
import Firebase
import FirebaseDatabase
import CodableFirebase

class ViewModel: ObservableObject {
    
    var ref : DatabaseReference = Database.database().reference()
    
    @Published var userinfo : userstruct = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: ["1"], id: "1", key: "", name: "0", schedules: [[""]], uid: "")
    
    init(){
        print("VM init")
    }
}

extension ViewModel {
    func login( userEmail: String, userPassword: String, completion : @escaping (Int) -> ()){
        return Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in guard self != nil else { return }
            if authResult != nil {
                let flag = 1
                completion(flag)
            }
            else {
                let flag = 2
                completion(flag)
            }
            
        }
    }
    func Loaduser(completion: @escaping (userstruct) -> ()){
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid ?? "anyvalue").getData {
            (error, snapshot) in
            if let error = error {
                print("Error \(error)")
            }
            else {
                let value = snapshot?.value
                if let data = try? FirebaseDecoder().decode(userstruct.self, from: value){
                    self.userinfo = data
                    
                    completion(data)
                }
                else {
                    print("Error")
                }
            }
        }
    }
    func AddGroup(new: String, completion: @escaping (Int)->()){
        self.userinfo.groups.append(new)
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["groups": self.userinfo.groups])
        completion(1)
    }
    
    func sendFrequest(friendid : String, flag : String, completion: @escaping (Int) -> ()) {
        var frienduid : String = ""
        self.ref.child("users").queryOrdered(byChild: "id").queryEqual(toValue: friendid).observeSingleEvent(of: .value, with: {
            snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                frienduid = snap.key
                if flag == "GroupInvite" {
                    self.ref.child("users").child(frienduid).child("Grequest").getData {
                        (error,snapshot) in
                        if let error = error {
                            print("Error \(error)")
                        }
                        else{
                            guard let value = snapshot?.value else {return}
                            print(value)
                            if let data2 = try? FirebaseDecoder().decode([String].self, from: value){
                                var array: [String] = data2
                                if (!array.contains(self.userinfo.id)){
                                    array.append(self.userinfo.id)
                                    self.ref.child("users").child(frienduid).updateChildValues(["Grequest": array])
                                    completion(1)
                                   
                                }
                                else {
                                    completion(2)
                                }
                            }
                            else{
                                print("Error")
                            }
                        }
                    }
                }
                else{
                    self.ref.child("users").child(frienduid).child("Frequest").getData {
                        (error,snapshot) in
                        if let error = error {
                            print("Error \(error)")
                        }
                        else{
                            guard let value = snapshot?.value else {return}
                            if let data2 = try? FirebaseDecoder().decode([String].self, from: value){
                                var array: [String] = data2
                                if (!array.contains(self.userinfo.id)){
                                    array.append(self.userinfo.id)
                                    self.ref.child("users").child(frienduid).updateChildValues(["Frequest": array])
                                    completion(3)
                                }
                                else {
                                    completion(4)
                                }
                            }
                            else{
                                print("Error")
                            }
                        }
                    }
                }
            }
        })
    }
    
    func AcceptFriend(target: String, completion: @escaping (Int) -> ()) {
        var frienduid : String = ""
        self.ref.child("users").queryOrdered(byChild: "id").queryEqual(toValue: target).observeSingleEvent(of: .value, with: {
            snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                frienduid = snap.key
                self.ref.child("users").child(frienduid).child("friends").getData {
                    (error,snapshot) in
                    if let error = error {
                        print("Error \(error)")
                    }
                    else{
                        guard let value = snapshot?.value else {return}
                        if let data2 = try? FirebaseDecoder().decode([String].self, from: value){
                            var array: [String] = data2
                            if (!array.contains(self.userinfo.id)){
                                array.append(self.userinfo.id)
                                self.ref.child("users").child(frienduid).updateChildValues(["friends": array])
                                self.userinfo.friends.append(target)
                                self.userinfo.Frequest.remove(at: self.userinfo.Frequest.firstIndex(of: target)!)
                                self.ref.child("users").child(self.userinfo.uid).updateChildValues(["friends": self.userinfo.friends])
                                self.ref.child("users").child(self.userinfo.uid).updateChildValues(["Frequest": self.userinfo.Frequest])
                                completion(1)
                            }
                            else {
                                completion(2)
                            }
                        }
                        else{
                            print("Error")
                        }
                    }
                }
            }
        })
    }
    
    func DenyFriend(target: String){
        self.userinfo.Frequest.remove(at: self.userinfo.Frequest.firstIndex(of: target)!)
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["Frequest": self.userinfo.Frequest])
    }
    
    func AcceptGroup(target: String, completion: @escaping (Int) -> ()) {
            completion(1)
        
    }
    
    func DenyGroup(target: String){
        self.userinfo.Grequest.remove(at: self.userinfo.Grequest.firstIndex(of: target)!)
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["Grequest": self.userinfo.Grequest])
    }
    
    
}
