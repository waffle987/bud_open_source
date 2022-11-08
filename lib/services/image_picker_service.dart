import 'package:image_picker/image_picker.dart';

class ImageSelector {
  /// Pick single image from gallery
  Future<XFile?> selectSingleImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  /// Pick multiple images from gallery
  Future<List<XFile>?> selectMultipleImages() async {
    return await ImagePicker().pickMultiImage();
  }
}
