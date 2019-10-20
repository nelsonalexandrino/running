const GOOGLE_API_KEY = 'AIzaSyDvgjMQe2UBsLCVfiwFcOGMmAvOjJbx_HA';

class LocationHelper {
  static String generateLocationPreviewImage(
      double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,' +
        '$longitude&zoom=13&size=300x150&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
}
