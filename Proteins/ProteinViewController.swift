//
//  ProteinViewController.swift
//  Proteins
//
//  Created by lrussu on 6/28/17.
//  Copyright © 2017 lrussu. All rights reserved.
//

import UIKit
import SceneKit

class ProteinViewController: UIViewController {
    
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    
    @IBAction func changeField(_ sender: UITextField) {
        textLabel?.text = fieldText.text
        print("changeFieldtext")
    }
    
    
    @IBOutlet weak var fieldText: UITextField!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var atom: UILabel!
    
    var xTan: Double = 1.0
    var yTan: Double = 1.0
    
    var passedProteinId: String = ""
    var cameraNode: SCNNode!
    var share: UIBarButtonItem = UIBarButtonItem()
    
    var sphere1: SCNNode!
    var sphere2: SCNNode!
    
    var arrayTest = [[String]]()
    
    func match(for regex: String, in text: String) -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: nsString as String, options: [], range: NSRange(location: 0, length: nsString.length))
            return results.count > 0
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }

    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map{nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    func setupScene() {
    
        sceneView.scene = ProteinScene()
        sceneView.backgroundColor = UIColor.green
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.addSubview(textLabel!)
        sceneView.bringSubview(toFront: textLabel!)
        
    // sceneView.showsStatistics = true
    }

    func setupCamera() {
        self.cameraNode = SCNNode()
        self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 30)
        print("cameraNode.position = \(self.cameraNode.position)")
        self.cameraNode.camera = SCNCamera()
        
        //  self.cameraNode.transform = SCNMatrix4Rotate(self.cameraNode.transform, Float(-M_PI) / 7.0, 1, 0, 0)
        //  print("cameraNode.position = \(self.cameraNode.position)")
        //  self.cameraNode.camera?.fieldOfView
        //  print("xFov - yFov = \(self.cameraNode.camera?.xFov) - \(self.cameraNode.camera?.yFov)")
        
        self.cameraNode.camera?.zNear = 0.01
        self.cameraNode.camera?.zFar = 10000
        self.cameraNode.camera?.xFov = 53
        self.cameraNode.camera?.yFov = 53
        self.cameraNode.camera?.automaticallyAdjustsZRange = false
        self.cameraNode.camera?.usesOrthographicProjection = false
        self.xTan = tan((self.cameraNode.camera?.xFov)! * M_PI / 360)
        self.yTan = tan((self.cameraNode.camera?.yFov)! * M_PI / 360)
    }
    
    func sortCoords(a: [Any], b: [Any]) -> Bool {
        var ax = a[0] as! Float
        var ay = a[1] as! Float
        var az = a[2] as! Float
        let d1 = ax * ax + ay * ay + az * az
    
        
        ax = b[0] as! Float
        ay = b[1] as! Float
        az = b[2] as! Float
        
        let d2 = ax * ax + ay * ay + az * az

        
        return d1 > d2
    }
    
    func trans(a: [[Any]]) -> SCNVector3 {

        let x = a.reduce(0){l, t in l + (t[0] as! Float)}
        let y = a.reduce(0){l, t in l + (t[1] as! Float)}
        let z = a.reduce(0){l, t in l + (t[2] as! Float)}
        return SCNVector3(x: x / Float(a.count), y: y / Float(a.count), z: z / Float(a.count))
    }
    
    
    func transla(a: [Any], v: SCNVector3) -> [Any] {
        let x = (a[0] as! Float) - v.x
        let y = (a[1] as! Float) - v.y
        let z = (a[2] as! Float) - v.z
        return [x, y, z, a[3]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(name: "darkdeepgreen")
        indicator.hidesWhenStopped = true
         share = UIBarButtonItem.init(title: "Share", style: .plain, target: self, action: #selector(self.myShareButton(sender:)))
        self.navigationItem.rightBarButtonItem = share
        
        self.title = passedProteinId
        
        setupScene()
        setupCamera()
        
        sceneView.pointOfView = cameraNode
        ProteinScene.xMax = SCNVector3(x: 0, y: 0, z: 0)
        ProteinScene.yMax = SCNVector3(x: 0, y: 0, z: 0)
        ProteinScene.zxMax = SCNVector3(x: 0, y: 0, z: 0)


        // Create destination URL
   //     let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
  //      let destinationFileUrl = documentsUrl.appendingPathComponent("protein\(passedProteinId).sdf")
        
        //Create URL to the source file you want to download
//        http://ligand-expo.rcsb.org/reports/0/001/001_ideal.pdb
  //      http://ligand-expo.rcsb.org/reports/C/CPT/CPT_model.pdb
        //guard let fileURL = URL(string: "https://files.rcsb.org/ligands/view/\(passedProteinId)_ideal.sdf") else {
        guard let fileURL = URL(string: "https://files.rcsb.org/ligands/view/\(passedProteinId)_model.sdf") else {
           // print("fileURL = ...  https://files.rcsb.org/ligands/view/\(passedProteinId)_ideal.sdf")
            return
        }
        
      //  print("fileURL = \(fileURL)")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do {
                    
                    let urlTest = URL(string: "https://files.rcsb.org/ligands/view/\(self.passedProteinId)_ideal.sdf")
                    let dTest = NSData(contentsOf: urlTest!)
                    let str = NSString(data: dTest as! Data, encoding: String.Encoding.utf8.rawValue)
                    let lines = str?.components(separatedBy: .newlines)
                    let linesAtoms = lines?.filter({self.match(for: "^(\\s*(\\+|\\-)?\\d+(\\.\\d+)?\\s+){3}[A-Za-z]{1,2}", in: $0)})
                    let atoms1 = linesAtoms?.map({self.matches(for: "([\\+\\-]?\\d+(\\.\\d+)?){3}|[A-Za-z]", in: $0)})
                    let atomsCoords: [[Any]] = atoms1!.map({[Float($0[0])!, Float($0[1])!, Float($0[2])!, $0[3]]})
                    let atoms: [[Any]] = atomsCoords
                    
                    
                    print("atomsCoords = \(atomsCoords)")

                    DispatchQueue.main.async {
                        print("ATOMS = \(atoms)")
                        self.indicator.stopAnimating()
                        atoms.map({(self.sceneView.scene as! ProteinScene).addAtom(a: $0, xtan: self.xTan, ytan: self.yTan)})
                        let y = ProteinScene.yMax
                        let x = ProteinScene.xMax
                        let z = ProteinScene.zxMax.z
                        let zy = sqrt(pow(y.y / Float(self.yTan), 2) - pow(x.x, 2)) + x.z
                        let zx = sqrt(pow(x.x / Float(self.xTan), 2) - pow(y.y, 2)) + y.z
                        
                        
                        var zz = (zx > zy ? zx : zy)
                        zz = (zz > z ? zz : z)
                      //  self.cameraNode.position = SCNVector3(x: 0, y: 0, z: z)
                    }
                    
                    let linesLinks = lines?.filter({self.match(for: "^(.{3}){6}$", in: $0)})
                    let links = linesLinks?.map({self.matches(for: ".{3}", in: $0)})

                    for link in links! {
                        let test = link.map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
                        self.arrayTest.append(test)
                    }
                    let arrayT: [[String]] = (self.arrayTest.map({$0.filter({$0 != "0"})}))
                    print("arrayT = \(arrayT)")
                  //  print("Links = \(arrayT.count) +++ \(arrayT)")
                    DispatchQueue.main.async {
                        arrayT.map({(self.sceneView.scene as! ProteinScene).addLink(a1: (atoms[Int($0[0])! - 1]),
                                                                                    a2: (atoms[Int($0[1])! - 1]),
                                                                                    n: Int($0[2])!)})
                    }
                } catch {
                    print(error)
                }
                
//                do {
//                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
//                } catch (let writeError) {
//                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
//                }
                

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                self.sceneView.addGestureRecognizer(tapGesture)


                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        
        indicator.isHidden = false
        indicator.startAnimating()
        task.resume()
        
        
        if textLabel == nil {
            textLabel = UILabel(frame: sceneView.frame)
            textLabel?.font.withSize(30)
            textLabel?.font = UIFont()
            textLabel?.textColor = UIColor.black
            textLabel?.textAlignment = .center
        }

       // self.cameraNode.position = SCNVector3(x: (ProteinScene.maxX - ProteinScene.minX) / 2.0, y: (ProteinScene.maxY - ProteinScene.minY) / 2.0, z: (ProteinScene.maxY - ProteinScene.minY) / 2.0)
        

        // Do any additional setup after loading the view.
        
        // MARK: TEST
     

     

    }

    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = sceneView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView?.hitTest(p, options: [:])
        
        if let tappedNodeName = hitResults?.first?.node.name {
            atom.text = tappedNodeName
            // do something with the tapped node ...
        }
        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            // retrieved the first clicked object
//            let result: AnyObject = hitResults[0]
//            
        
                       // result.node is the node that the user tapped on
            // perform any actions you want on it
            
            
       // }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    internal func launchSDFRequest(ligandId: String) {
//        guard let request = (UIApplication.shared.delegate as! AppDelegate).createSDFRequest(ligandId: ligandId) else {
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) {
//            (data, response, error) in
//            
//            guard let httpURLResponse = response as? HTTPURLResponse,
//                httpURLResponse.statusCode == 200,
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            
//            DispatchQueue.main.async() { () -> Void in
//            }
//        }
//        task.resume()
//    }

//    if let path = Bundle.main.path(forResource: "TextFile", ofType: "txt") {
//        do {
//            let data = try String(contentsOfFile: path, encoding: .utf8)
//            let myStrings = data.components(separatedBy: .newlines)
//            TextView.text = myStrings.joined(separator: ", ")
//        } catch {
//            print(error)
//        }
//    }
       @IBAction func myShareButton(sender: UIBarButtonItem) {
        // Hide the keyboard
        //        myTextField.resignFirstResponder()
        //        // Check and see if the text field is empty
        //        if (myTextField.text == "") {
        //            // The text field is empty so display an Alert
        //            displayAlert("Warning", message: "Enter something in the text field!")
        //        } else {
        // We have contents so display the share sheet
        var image: UIImage?
    //    titleTxtField.isHidden = false
        
        
        
        
//        UIGraphicsBeginImageContext(newImageView.frame.size)
//        newImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let watermarkedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        
        UIGraphicsBeginImageContextWithOptions(sceneView.bounds.size, sceneView.isOpaque, 0.0)
        sceneView.drawHierarchy(in: sceneView.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if snapshotImageFromMyView == nil {
            displayAlert(title: "Warning", message: "Sorry, image wasn't created")
        }
        
        let toShare: [Any?] = [snapshotImageFromMyView, NSString(), nil]
        displayShareSheet(shareContent: toShare, sender: sender)
        
//        if #available(iOS 10.0, *) {
//            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
//            image = renderer.image { ctx in
//                self.sceneView.drawHierarchy(in: self.sceneView.bounds, afterScreenUpdates: true)
//            }
//            
//            if image == nil {
//                displayAlert(title: "Warning", message: "Sorry, image wasn't created")
//            }
//            
//            let toShare: [Any?] = [image, NSString(), nil]
//            displayShareSheet(shareContent: toShare, sender: sender)
//            
//        } else {
//            displayAlert(title: "Warning", message: "Sorry, I need iOS 10.0, version, update please")
//        }
        

        //}
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        return
    }
    
    func displayShareSheet(shareContent: [Any?], sender: UIBarButtonItem) {
        
 
               // let image = UIImage(named: "bgProfile")
        let activityViewController = UIActivityViewController(activityItems: shareContent, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.postToTwitter , UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender
        }
        present(activityViewController, animated: true, completion: nil)
                // set up activity view controller
        

    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let shareBar: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.action, target: self, action: #selector("myShareButton"))
//        self.navigationItem.rightBarButtonItem = shareBar
        
//        let btn1 = UIButton(type: .custom)
//        btn1.titleLabel?.text = "Share"
//        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btn1.addTarget(self, action: #selector("myShareButton"), for: .touchUpInside)
//        let item1 = UIBarButtonItem(customView: btn1)
        
        
  //      self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    func createARGBBitmapContext(inImage: CGImage) -> CGContext {
        var bitmapByteCount = 0
        var bitmapBytesPerRow = 0
        
        let pixelsWide = inImage.width
        let pixelsHigh = inImage.height
        
        bitmapBytesPerRow = Int(pixelsWide) * 4
        bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        return context!
    }
    
    func addText(img :UIImage, text :NSString) ->UIImage{
        
        var w = img.size.width;
        var h = img.size.height;
        var colorSpace = CGColorSpaceCreateDeviceRGB();
        
        var context = createARGBBitmapContext(inImage: img.cgImage!)
        
       
        context.draw(img.cgImage!, in: CGRect(x: 0.0,y: 0.0,width: w,height: h))
        context.setFillColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1);
        
        
        var path = CGMutablePath(); //1
        path.addRect(CGRect(x: w - 90, y: 1, width: 100, height: 20))
        var attString = NSAttributedString(string: text as String) //2
        
        var framesetter = CTFramesetterCreateWithAttributedString(attString); //3
        var frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString.length), path, nil);
        
        CTFrameDraw(frame, context); //4
        
        var imageMasked:CGImage = context.makeImage()! as CGImage
        
        return UIImage(cgImage: imageMasked);
    }
    
}

extension UIImage {
    
    func addText1(_ drawText: NSString, atPoint: CGPoint, textColor: UIColor?, textFont:  UIFont?) -> UIImage {
        
        // Setup the font specific variables
        var _textColor: UIColor
        if textColor == nil {
            _textColor = UIColor.red
        } else {
            _textColor = textColor!
        }
        
        var _textFont: UIFont
        if textFont == nil {
            _textFont = UIFont.systemFont(ofSize: 16)
        } else {
            _textFont = textFont!
        }
        
        // Setup the image context using the passed image
        UIGraphicsBeginImageContext(size)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: _textFont,
            NSForegroundColorAttributeName: _textColor,
            ] as [String : Any]
        
        // Put the image into a rectangle as large as the original image
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x: atPoint.x, y: atPoint.y, width: size.width, height: size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
        
    }
    
}
