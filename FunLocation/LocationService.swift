import CoreLocation
import CoreMotion

final class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionActivityManager()
    
    override init() {
        super.init()
        configurate()
    }
    
    private func configurate() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func start() {
        setActiveMode(true)
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        motionManager.startActivityUpdates(to: .main, withHandler: { [weak self] activity in
            self?.setActiveMode(activity?.cycling ?? false)
        })
    }
    
    private func setActiveMode(_ value: Bool) {
        if value {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 10
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.distanceFilter = CLLocationDistanceMax
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userDefaults = UserDefaults.standard
        let key = "location"
        let count = userDefaults.integer(forKey: key) + 1
        userDefaults.set(count, forKey: key)
        userDefaults.synchronize()
        print("didUpdateLocations #\(count)")
    }
}
