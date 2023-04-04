import 'dart:ffi';
import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:pdfium_bindings/pdfium_bindings.dart';

import '../exceptions/app_exceptions.dart';
import 'common.dart';
import 'file_utils.dart';

img.Image _getImageFromPdfFile(File pdfFile) {
  String lib = '';

  switch (Abi.current()) {
    case Abi.windowsX64:
      lib = 'pdfium_x64.dll';
      break;
    case Abi.linuxX64:
      lib = 'libpdfium_x64.so';
      break;
    default:
      throw ArchNotSupportedException(
        path: pdfFile.path,
        arch: Abi.current().toString(),
      );
  }

  final libPath = path.join(Directory.current.path, lib);
  var pdfWrap = PdfiumWrap(libraryPath: libPath)
      .loadDocumentFromBytes(pdfFile.readAsBytesSync())
      .loadPage(0);

  final width = (pdfWrap.getPageWidth()).round();
  final height = (pdfWrap.getPageHeight()).round();

  final image = img.Image.fromBytes(
    width: width,
    height: height,
    bytes: pdfWrap.renderPageAsBytes(width, height).buffer,
    order: img.ChannelOrder.bgra,
    numChannels: 4,
  );

  pdfWrap.closePage().closeDocument().dispose();
  return image;
}

img.Image _getImageFromImageFile(File imageFile) {
  img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

  if (image == null) throw ImageDecodingException(imageFile.path);

  return _addBackgroundColorToImage(image);
}

img.Image _fileToImage(File file) {
  if (isImageFileType(file.path)) {
    return _getImageFromImageFile(file);
  } else if (path.extension(file.path) == ".pdf") {
    return _getImageFromPdfFile(file);
  }
  throw FileNotValidException(file.path);
}

void resizeAndSaveFileAsJpg(
  File file, {
  required int width,
  required int height,
  required String toSavePath,
}) {
  String message = "";
  try {
    final image = img.copyResize(
      _fileToImage(file),
      width: width,
      height: height,
      interpolation: img.Interpolation.cubic,
    );

    File(toSavePath).writeAsBytesSync(img.encodeJpg(image));

    message = "Image saved in: $toSavePath";
  } catch (e) {
    message = e.toString();
  } finally {
    simplePrint(message);
  }
}

img.Image _addBackgroundColorToImage(
  img.Image image, {
  img.Color? imageColor,
}) {
  if (image.numChannels == 4) {
    final imageDst = img.Image(
      width: image.width,
      height: image.height,
    )..clear(
        imageColor ?? img.ColorRgb8(255, 255, 255),
      );
    return img.compositeImage(
      imageDst,
      image,
    );
  }
  return image;
}
