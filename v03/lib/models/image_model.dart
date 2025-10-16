import 'package:v03/interfaces/i_image_model.dart';

class ImageModel implements IImageModel {
  @override
  final String? url;

  const ImageModel({this.url});

  factory ImageModel.fromMap(Map<String, dynamic> map) =>
      ImageModel(url: map['url']?.toString());

  @override
  Map<String, dynamic> toMap() => {if (url != null) 'url': url};
}
