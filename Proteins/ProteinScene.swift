//
//  ProteinScene.swift
//  Proteins
//
//  Created by lrussu on 6/30/17.
//  Copyright © 2017 lrussu. All rights reserved.
//

import UIKit
import SceneKit

class ProteinScene: SCNScene {
    static var atom: [SCNSphere] = []
    static var z = 0.0
    
    static var xMax = SCNVector3(x: 0, y: 0, z: 0)
    static var yMax = SCNVector3(x: 0, y: 0, z: 0)
    static var zxMax = SCNVector3(x: 0, y: 0, z: 0)
    static var zyMax = SCNVector3(x: 0, y: 0, z: 0)
    
    static var minX: Float = 0.0
    static var minY: Float = 0.0
    static var minZ: Float = 0.0
    
    static var maxX: Float = 0.0
    static var maxY: Float = 0.0
    static var maxZ: Float = 0.0
    
    static var v = SCNVector3(x: (maxX - minX) / 2.0, y: (maxY - minY) / 2.0, z: (maxZ - minZ) / 2.0)
    
    static var radius: Double = 0.2
    
    override init() {
        super.init()
//        let secondSphereGeometry = SCNSphere(radius: 0.5)
//        let secondSphereNode = SCNNode(geometry: secondSphereGeometry)
//        secondSphereNode.position = SCNVector3(x: 3.0, y: 0.0, z: 0.0)
//        self.rootNode.addChildNode(secondSphereNode)
    }
    
    
    func setZ(x: Double, y: Double, z: Double, xTan: Double, yTan: Double) {

        
        let xZ = sqrt(pow((abs(x) / xTan), 2) - pow(y, 2))
        let yZ = sqrt(pow((abs(y) / yTan), 2) - pow(x, 2))
        
        let m = (xZ > yZ ? xZ : yZ)
        print(m)
        let tmp = z + m
        if tmp > ProteinScene.z {
            ProteinScene.z = tmp
        }
        print("tan = \(xTan) \(yTan)")
        print("p = \(x) \(y) \(z)")
        print("tmp = \(tmp) \(xZ) \(yZ)")
        
    }
    
    
    func setMax(x: Float, y: Float, z: Float) {
        var max = abs(x)
        if max > ProteinScene.xMax.x {
            ProteinScene.xMax = SCNVector3(x: max, y: y, z: z)
        }
        
        max = abs(y)
        if max > ProteinScene.yMax.y {
            ProteinScene.yMax = SCNVector3(x: x, y: max, z: z)
        }
        
        max = abs(z)
        if max > ProteinScene.zxMax.z {
            ProteinScene.zxMax = SCNVector3(x: x, y: y, z: max)
            ProteinScene.zyMax = SCNVector3(x: x, y: y, z: max)
        }
//        else if (max == ProteinScene.zxMax.z ) {
//            max = abs(x)
//            if (max > ProteinScene.zxMax.x) {
//                ProteinScene.zxMax.x = max
//            }
//            max = abs(y)
//            if (max > ProteinScene.zyMax.y) {
//                ProteinScene.zyMax.y = max
//            }
//            
//        }

    }
    
    func setMinMax(x: Float, y: Float, z: Float) {
        if x < ProteinScene.minX {
            ProteinScene.minX = x
        }
        if y < ProteinScene.minY {
            ProteinScene.minY = y
        }
        if z < ProteinScene.minZ {
            ProteinScene.minZ = z
        }
        if x > ProteinScene.maxX {
            ProteinScene.maxX = x
        }
        if y > ProteinScene.maxY {
            ProteinScene.maxY = y
        }
        if z > ProteinScene.maxZ {
            ProteinScene.maxZ = z
        }

    }
    
    func translate(x: Float, y: Float, z: Float) -> SCNVector3 {
        
        return SCNVector3(x: Float(x), y: Float(y), z: Float(z))
    }
    
    public func addAtom(a: [Any], xtan: Double, ytan: Double) {
        
        let x = (a[0] as! Float)
        let y = (a[1] as! Float)
        let z = (a[2] as! Float)
        
    //    print("a = \(a)")
    //    setZ(x: x, y: y, z: z, xTan: xtan, yTan: ytan)
        setMax(x: Float(x), y: Float(y), z: Float(z))
        
        let sphere = SCNSphere(radius: CGFloat(ProteinScene.radius))
        sphere.materials.first?.diffuse.contents = UIColor.byAtom(atom: a[3] as! String)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: Float(x), y: Float(y), z: Float(z))
        sphereNode.name = a[3] as! String
        print("sphereNode.position = \(sphereNode.position)")
        self.rootNode.addChildNode(sphereNode)

    }
    
    public func addLink(a1: [Any], a2: [Any], n: Int) {
//        print("a1 = \(a1), a2 = \(a2)")
//        let dx = Float(a1[0])! - Float(a2[0])!
//        let dy = Float(a1[1])! - Float(a2[1])!
//        let dz = Float(a1[2])! - Float(a2[2])!
//        let hh = dx * dx + dy * dy + dz * dz
//        let cylinder = SCNCylinder(radius: 0.05, height: sqrt(CGFloat(hh)))
//        let cylinder = SCNCylinder()
//        cylinder.materials.first?.diffuse.contents = UIColor.byAtom(atom: a1[3])
//        let cylinderNode = SCNNode(geometry: cylinder)
//        cylinderNode.position = SCNVector3(x: (Float(a1[0])! + Float(a2[0])!) / 2.0, y: (Float(a1[1])! + Float(a2[1])!) / 2.0, z: (Float(a1[2])! + Float(a2[2])!) / 2.0)
        
//        let oldRot: SCNQuaternion = cylinderNode.rotation
//        var rot: GLKQuaternion = GLKQuaternionMakeWithAngleAndAxis(oldRot.w, oldRot.x, oldRot.y, oldRot.z)
//        let rotX: GLKQuaternion = GLKQuaternionMakeWithAngleAndAxis(Float(M_PI_4), 0, 1, 0)
//        let rotY: GLKQuaternion = GLKQuaternionMakeWithAngleAndAxis(Float(M_PI_4), 1, 0, 0)
//        let netRot: GLKQuaternion = GLKQuaternionMultiply(rotX, rotY)
//        rot = GLKQuaternionMultiply(rot, netRot)
//        
//        let axis: GLKVector3 = GLKQuaternionAxis(rot)
//        let angle: Float = GLKQuaternionAngle(rot)
//        cylinderNode.rotation = SCNVector4Make(axis.x, axis.y, axis.z, angle)
        


        
//        cylinderNode.position = position
//        let randomX = Double(arc4random_uniform(10) + 1)
//        let randomY = Double(arc4random_uniform(20) + 1)
//        let force = SCNVector3(x: Float(randomX), y: Float(randomY) , z: 0)
////        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
//        cylinderNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        
//        let randomY = random(min: 10, max: 18)
//        
//        let force = SCNVector3(x: randomX, y: randomY , z: 0)
//        
//        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
//        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)

        
//        let initial_object_orientation = rotateNode.orientation;
//        new_orientation = GLKQuaternionMultiply(rotation_quaternion, initial_object_orientation)
//        Assign the new orientation
//        rotatNode.orientation = new_orientation
//        Hope it helps.
//        
//        let test = GLKQuaternionMakeWithAngleAndAxis(Float(M_PI_2), 1, 0, 0)
//        let initialOrientation = cylinderNode.orientation
//        print("ORIENTATION \(initialOrientation)")
//        let newOrientation = GLKQuaternionMultiply(test, (initialOrientation as? GLKQuaternion)!)
//        cylinderNode.orientation = (newOrientation as? SCNQuaternion)!
        
  
        if (n < 2) {
            let startPosition = SCNVector3(x: (a1[0] as! Float), y: (a1[1] as! Float), z: (a1[2] as! Float))
            let endPosition = SCNVector3(x: (a2[0] as! Float), y: (a2[1] as! Float), z: (a2[2] as! Float))

            let cylNode = SCNNode().makeCylinder(positionStart: startPosition, positionEnd: endPosition, radius: 0.05 , color: UIColor.red, transparency: 0)
            self.rootNode.addChildNode(cylNode)
        } else {
            let d: Float = 0.06
            let startPosition1 = SCNVector3(x: (a1[0] as! Float), y: (a1[1] as! Float) + d, z: (a1[2] as! Float))
            let endPosition1 = SCNVector3(x: (a2[0] as! Float), y: (a2[1] as! Float) + d, z: (a2[2] as! Float))

            let cylNode1 = SCNNode().makeCylinder(positionStart: startPosition1, positionEnd: endPosition1, radius: 0.03 , color: UIColor.red, transparency: 0)
            
            let startPosition2 = SCNVector3(x: (a1[0] as! Float), y: (a1[1] as! Float) - d, z: (a1[2] as! Float))
            let endPosition2 = SCNVector3(x: (a2[0] as! Float), y: (a2[1] as! Float) - d, z: (a2[2] as! Float))
            
       
            let cylNode2 = SCNNode().makeCylinder(positionStart: startPosition2, positionEnd: endPosition2, radius: 0.03 , color: UIColor.red, transparency: 0)
        
            self.rootNode.addChildNode(cylNode1)
            self.rootNode.addChildNode(cylNode2)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    static func byAtom(atom: String) -> UIColor {
        switch atom {
        case "H": return .white
        case "O": return .red
        case "C": return .black
        case "N": return UIColor(name: "darkblue")!
        case "Br": return UIColor(name: "darkred")!
        case "I": return UIColor(name: "darkviolet")!
        case "B": return UIColor(name: "salmon")!
        case "F", "Cl": return .green
        case "He", "Ne", "Ar", "Xe", "Kr": return .cyan
        case "Li", "Na", "K", "Rb", "Cs", "Fr": return UIColor(name: "violet")!
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra": return UIColor(name: "darkgreen")!
        case "P": return .orange
        case "S": return .yellow
        case "Ti": return .gray
        case "Fe": return UIColor(name: "darkorange")!
        default: return UIColor(name: "pink")!
        }
    }
    
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    public convenience init?(name: String) {
        let allColors = [
            "aliceblue": "#F0F8FFFF",
            "antiquewhite": "#FAEBD7FF",
            "aqua": "#00FFFFFF",
            "aquamarine": "#7FFFD4FF",
            "azure": "#F0FFFFFF",
            "beige": "#F5F5DCFF",
            "bisque": "#FFE4C4FF",
            "black": "#000000FF",
            "blanchedalmond": "#FFEBCDFF",
            "blue": "#0000FFFF",
            "blueviolet": "#8A2BE2FF",
            "brown": "#A52A2AFF",
            "burlywood": "#DEB887FF",
            "cadetblue": "#5F9EA0FF",
            "chartreuse": "#7FFF00FF",
            "chocolate": "#D2691EFF",
            "coral": "#FF7F50FF",
            "cornflowerblue": "#6495EDFF",
            "cornsilk": "#FFF8DCFF",
            "crimson": "#DC143CFF",
            "cyan": "#00FFFFFF",
            "darkblue": "#00008BFF",
            "darkcyan": "#008B8BFF",
            "darkgoldenrod": "#B8860BFF",
            "darkgray": "#A9A9A9FF",
            "darkgrey": "#A9A9A9FF",
            "darkgreen": "#006400FF",
            "darkkhaki": "#BDB76BFF",
            "darkmagenta": "#8B008BFF",
            "darkolivegreen": "#556B2FFF",
            "darkorange": "#FF8C00FF",
            "darkorchid": "#9932CCFF",
            "darkred": "#8B0000FF",
            "darkdeepgreen": "#043F06FF",
            "darksalmon": "#E9967AFF",
            "darkseagreen": "#8FBC8FFF",
            "darkslateblue": "#483D8BFF",
            "darkslategray": "#2F4F4FFF",
            "darkslategrey": "#2F4F4FFF",
            "darkturquoise": "#00CED1FF",
            "darkviolet": "#9400D3FF",
            "deeppink": "#FF1493FF",
            "deepskyblue": "#00BFFFFF",
            "dimgray": "#696969FF",
            "dimgrey": "#696969FF",
            "dodgerblue": "#1E90FFFF",
            "firebrick": "#B22222FF",
            "floralwhite": "#FFFAF0FF",
            "forestgreen": "#228B22FF",
            "fuchsia": "#FF00FFFF",
            "gainsboro": "#DCDCDCFF",
            "ghostwhite": "#F8F8FFFF",
            "gold": "#FFD700FF",
            "goldenrod": "#DAA520FF",
            "gray": "#808080FF",
            "grey": "#808080FF",
            "green": "#008000FF",
            "greenyellow": "#ADFF2FFF",
            "honeydew": "#F0FFF0FF",
            "hotpink": "#FF69B4FF",
            "indianred": "#CD5C5CFF",
            "indigo": "#4B0082FF",
            "ivory": "#FFFFF0FF",
            "khaki": "#F0E68CFF",
            "lavender": "#E6E6FAFF",
            "lavenderblush": "#FFF0F5FF",
            "lawngreen": "#7CFC00FF",
            "lemonchiffon": "#FFFACDFF",
            "lightblue": "#ADD8E6FF",
            "lightcoral": "#F08080FF",
            "lightcyan": "#E0FFFFFF",
            "lightgoldenrodyellow": "#FAFAD2FF",
            "lightgray": "#D3D3D3FF",
            "lightgrey": "#D3D3D3FF",
            "lightgreen": "#90EE90FF",
            "lightpink": "#FFB6C1FF",
            "lightsalmon": "#FFA07AFF",
            "lightseagreen": "#20B2AAFF",
            "lightskyblue": "#87CEFAFF",
            "lightslategray": "#778899FF",
            "lightslategrey": "#778899FF",
            "lightsteelblue": "#B0C4DEFF",
            "lightyellow": "#FFFFE0FF",
            "lime": "#00FF00FF",
            "limegreen": "#32CD32FF",
            "linen": "#FAF0E6FF",
            "magenta": "#FF00FFFF",
            "maroon": "#800000FF",
            "mediumaquamarine": "#66CDAAFF",
            "mediumblue": "#0000CDFF",
            "mediumorchid": "#BA55D3FF",
            "mediumpurple": "#9370D8FF",
            "mediumseagreen": "#3CB371FF",
            "mediumslateblue": "#7B68EEFF",
            "mediumspringgreen": "#00FA9AFF",
            "mediumturquoise": "#48D1CCFF",
            "mediumvioletred": "#C71585FF",
            "midnightblue": "#191970FF",
            "mintcream": "#F5FFFAFF",
            "mistyrose": "#FFE4E1FF",
            "moccasin": "#FFE4B5FF",
            "navajowhite": "#FFDEADFF",
            "navy": "#000080FF",
            "oldlace": "#FDF5E6FF",
            "olive": "#808000FF",
            "olivedrab": "#6B8E23FF",
            "orange": "#FFA500FF",
            "orangered": "#FF4500FF",
            "orchid": "#DA70D6FF",
            "palegoldenrod": "#EEE8AAFF",
            "palegreen": "#98FB98FF",
            "paleturquoise": "#AFEEEEFF",
            "palevioletred": "#D87093FF",
            "papayawhip": "#FFEFD5FF",
            "peachpuff": "#FFDAB9FF",
            "peru": "#CD853FFF",
            "pink": "#FFC0CBFF",
            "plum": "#DDA0DDFF",
            "powderblue": "#B0E0E6FF",
            "purple": "#800080FF",
            "rebeccapurple": "#663399FF",
            "red": "#FF0000FF",
            "rosybrown": "#BC8F8FFF",
            "royalblue": "#4169E1FF",
            "saddlebrown": "#8B4513FF",
            "salmon": "#FA8072FF",
            "sandybrown": "#F4A460FF",
            "seagreen": "#2E8B57FF",
            "seashell": "#FFF5EEFF",
            "sienna": "#A0522DFF",
            "silver": "#C0C0C0FF",
            "skyblue": "#87CEEBFF",
            "slateblue": "#6A5ACDFF",
            "slategray": "#708090FF",
            "slategrey": "#708090FF",
            "snow": "#FFFAFAFF",
            "springgreen": "#00FF7FFF",
            "steelblue": "#4682B4FF",
            "tan": "#D2B48CFF",
            "teal": "#008080FF",
            "thistle": "#D8BFD8FF",
            "tomato": "#FF6347FF",
            "turquoise": "#40E0D0FF",
            "violet": "#EE82EEFF",
            "wheat": "#F5DEB3FF",
            "white": "#FFFFFFFF",
            "whitesmoke": "#F5F5F5FF",
            "yellow": "#FFFF00FF",
            "yellowgreen": "#9ACD32FF"
        ]
        
        let cleanedName = name.replacingOccurrences(of: " ", with: "").lowercased()
        
        if let hexString = allColors[cleanedName] {
            self.init(hexString: hexString)
        } else {
            return nil
        }
    }
}

extension SCNNode
{
    func makeCylinder(positionStart: SCNVector3, positionEnd: SCNVector3, radius: CGFloat , color: UIColor, transparency: CGFloat) -> SCNNode
    {
        let height = CGFloat(GLKVector3Distance(SCNVector3ToGLKVector3(positionStart), SCNVector3ToGLKVector3(positionEnd)))
        let startNode = SCNNode()
        let endNode = SCNNode()
        
        startNode.position = positionStart
        endNode.position = positionEnd
        
        // additional node to align cylinder along the z axis
        let zAxisNode = SCNNode()
        zAxisNode.eulerAngles.x = Float(CGFloat(M_PI_2))
        
        let cylinderGeometry = SCNCylinder(radius: radius, height: height)
        cylinderGeometry.firstMaterial?.diffuse.contents = color
        let cylinder = SCNNode(geometry: cylinderGeometry)
        
        
        //correction of relative positions of the cylinder start/end
        if (positionStart.x > 0.0 && positionStart.y < 0.0 && positionStart.z < 0.0 && positionEnd.x > 0.0 && positionEnd.y < 0.0 && positionEnd.z > 0.0)
        {
            cylinder.position.y = -Float(height)/2
        }
        else if (positionStart.x < 0.0 && positionStart.y < 0.0 && positionStart.z < 0.0 && positionEnd.x < 0.0 && positionEnd.y < 0.0 && positionEnd.z > 0.0)
        {
            cylinder.position.y = -Float(height)/2
        }
        else  if (positionStart.x < 0.0 && positionStart.y > 0.0 && positionStart.z < 0.0 && positionEnd.x < 0.0 && positionEnd.y > 0.0 && positionEnd.z > 0.0)
        {
            cylinder.position.y = -Float(height)/2
        }
        else  if (positionStart.x > 0.0 && positionStart.y > 0.0 && positionStart.z < 0.0 && positionEnd.x > 0.0 && positionEnd.y > 0.0 && positionEnd.z > 0.0)
        {
            cylinder.position.y = -Float(height)/2
        }
        else
        {
            cylinder.position.y = -Float(height)/2
        }
        
        
        zAxisNode.addChildNode(cylinder)
        
        //additional node is at startNode
        startNode.addChildNode(zAxisNode)
        //constrain the startNode by endNode
        startNode.constraints = [ SCNLookAtConstraint(target: endNode) ]
        
        return startNode
    }
    
}
