import Flutter
import QMapKit
import CoreFoundation

class TencentMapFactory: NSObject, FlutterPlatformViewFactory {
    let registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }

    func create(withFrame _: CGRect, viewIdentifier _: Int64, arguments _: Any?) -> FlutterPlatformView {
        MapView(registrar)
    }
}

class MapView: NSObject, FlutterPlatformView, QMapViewDelegate {
    let mapView: QMapView
    let api: _TencentMapApi
    
    static let id:String = "pointAnnotation"

    init(_ registrar: FlutterPluginRegistrar) {
        mapView = QMapView()
        api = _TencentMapApi(mapView)
        TencentMapApiSetup(registrar.messenger(), api)
        super.init()
        mapView.delegate = self
    }

    func view() -> UIView {
        mapView
    }
    func mapView(_ mapView: QMapView!, viewFor annotation: QAnnotation!) -> QAnnotationView? {
        if annotation is QPointAnnotation{
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: MapView.id) as? QPinAnnotationView
            if let pinView = pinView{
                return pinView
            }
            pinView = QPinAnnotationView(annotation: annotation, reuseIdentifier: MapView.id)
            pinView?.canShowCallout = false
            return pinView
        }
        return Optional.none
    }
}
