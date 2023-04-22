//
//  ViewController.swift
//  Milistone projects 10-12
//
//  Created by Артем Чжен on 22/04/23.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pictures = [Picture]()
    var imageDis: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Added Foto or pictures"
      
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load pictures")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let photo = pictures[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        
        cell.textLabel?.text = photo.caption
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = pictures[indexPath.row]
        let path = getDocumentsDirectory().appendingPathExtension(photo.image)
        let ac = UIAlertController(title: "Add", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            [weak self, weak ac] _ in
            guard let caption = ac?.textFields?[0].text else { return }
            photo.caption = caption
            self?.save()
            self?.tableView.reloadData()
        }))
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = photo
            vc.path = path
            navigationController?.pushViewController(vc, animated: true)
        }
//        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(vc, animated: true)
    }
    
    @objc func addPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let picture = info[.editedImage] as? UIImage else { return }
        let pictureName = UUID().uuidString
        let picturePath = getDocumentsDirectory().appendingPathComponent(pictureName)
        
        if let jpegData = picture.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: picturePath)
        }
        let photo = Picture(image: pictureName, caption: "")
        pictures.append(photo)
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures")
        }
    }
    
}

