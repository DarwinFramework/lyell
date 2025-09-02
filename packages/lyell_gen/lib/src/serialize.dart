import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:duffer/duffer.dart';
import 'package:lyell_gen/lyell_gen.dart';

String serializeType(DartType type) {
  var buffer = Unpooled.buffer();
  _serializeType(type, buffer);
  return buffer.base64;
}

Future<DartType> deserializeType(String string, BuildStep step) =>
    _deserializeType(string.parseBase64(), step);

void _serializeType(DartType type, ByteBuf buffer) {
  var import = type.import;
  if (import == null) {
    buffer.writeByte(0x00);
  } else {
    buffer.writeByte(0x01);
    buffer.writeLPString(import);
  }
  var fallbackName = type.getDisplayString(withNullability: false);
  buffer.writeLPString(type.element3?.displayName ?? fallbackName);
  if (type is ParameterizedType && type.typeArguments.isNotEmpty) {
    buffer.writeByte(type.typeArguments.length);
    for (var value in type.typeArguments) {
      _serializeType(value, buffer);
    }
  } else {
    buffer.writeByte(0x00);
  }
}

Future<DartType> _deserializeType(ByteBuf buffer, BuildStep step) async {
  String? import;
  if (buffer.readByte() == 0x01) {
    import = buffer.readLPString();
  }

  LibraryElement2 library;
  if (import != null) {
    library = await getLibrary(import, step);
  } else {
    library = coreLibraryReader.element;
  }

  var name = buffer.readLPString();
  var paramCount = buffer.readByte();
  if (name == "dynamic" && import == null) {
    return library.typeProvider.dynamicType;
  }
  if (name == "void" && import == null) {
    return library.typeProvider.voidType;
  }
  InterfaceElement2? type = library.getClass2(name);
  if (type == null) throw Exception("Type $name not found in library $import");
  if (paramCount == 0) return type.thisType;
  var params = <DartType>[];
  for (var i = 0; i < paramCount; i++) {
    params.add(await _deserializeType(buffer, step));
  }
  return type.instantiate(
      typeArguments: params, nullabilitySuffix: NullabilitySuffix.none);
}
