import UIKit
import Flutter
import AuthenticationServices
import GoogleMaps

GMSServices.provideAPIKey("AIzaSyBANJJlDplrqmPbPM2CK6suomwcrRmI_sU")


@main
@objc class AppDelegate: FlutterAppDelegate ,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    var customChannel:FlutterMethodChannel?
    
  
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    GeneratedPluginRegistrant.register(with: self)
      initCustomInvoke()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    func initCustomInvoke(){
        let controller:FlutterViewController = self.window.rootViewController as! FlutterViewController
        customChannel = FlutterMethodChannel(name: "com.avispets.jeanne/custom", binaryMessenger: controller.binaryMessenger)
        customChannel?.setMethodCallHandler({ [weak self](call:FlutterMethodCall, result:FlutterResult) in
            guard let self = self else { return }
            if call.method == "iOSAppleLogin"{
                self.loginWithApple()
            }
        })
    }
    
    func loginWithApple(){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName,.email]
        
        let vc = ASAuthorizationController(authorizationRequests: [request])
        
        vc.delegate = self
        vc.performRequests()
    }
    
    func presentationAnchor(for: ASAuthorizationController) -> ASPresentationAnchor{
        return self.window
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        customChannel?.invokeMethod("iOSAppleLogin", arguments: ["status":"error","message":error.localizedDescription])
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credentials = authorization.credential as? ASAuthorizationAppleIDCredential{
            let appleId = credentials.user
            let firstName = credentials.fullName?.givenName
            let lastName = credentials.fullName?.familyName
            let email = credentials.email
            
            let arg = ["status":"success","appleId":appleId,"firstName":firstName ?? "","lastName":lastName ?? "","email":email ?? ""] as [String : Any]
                      
            customChannel?.invokeMethod("iOSAppleLogin", arguments: arg)
        }
    }
    
}

