//
//  ViewController.swift
//  Randog
//
//  Created by Gokhan Namal on 7.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        DogAPI.listAllBreeds(completionHandler: self.handleBreedList(breeds:error:))
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func handleBreedList(breeds: Breed?, error: Error?) {
        guard let breeds = breeds else {return}
        self.breeds = breeds.message.keys.map{$0}
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    func randomImageResponse(imageData: DogImage?, error: Error?) {
        guard let imageData = imageData else { return }
        guard let url = URL(string: imageData.message) else { return }
        DogAPI.requestImageFile(url: url, completionHandler: self.handleImageFileResponse(image:error:))
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: self.randomImageResponse(imageData:error:))
    }
}
