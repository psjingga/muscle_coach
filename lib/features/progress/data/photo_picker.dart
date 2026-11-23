import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

/// Ambil foto dari kamera/galeri. Mengembalikan path berkas sementara, atau
/// `null` bila dibatalkan.
abstract interface class PhotoPicker {
  Future<String?> pick(PhotoSource source);
}

class ImagePickerPhotoPicker implements PhotoPicker {
  ImagePickerPhotoPicker([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> pick(PhotoSource source) async {
    final file = await _picker.pickImage(
      source: source == PhotoSource.camera ? ImageSource.camera : ImageSource.gallery,
      // Diperkecil & dikompres ulang: hemat ruang, metadata asli tidak dibawa.
      maxWidth: 1440,
      maxHeight: 1920,
      imageQuality: 85,
      requestFullMetadata: false,
    );
    return file?.path;
  }
}
