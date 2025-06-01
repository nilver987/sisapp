import 'package:dio/dio.dart';
import 'package:ventas_app/apis/marca_api.dart';
import 'package:ventas_app/modelo/MarcaModelo.dart';
import 'package:ventas_app/util/TokenUtil.dart';

class MarcaRepository {
  MarcaApi? marcaApi;

  MarcaRepository() {
    Dio _dio = Dio();
    _dio.options.headers["Content-Type"] = "application/json";
    marcaApi = MarcaApi(_dio);
  }

  Future<List<Marca>> getEntidad() async {
    return await marcaApi!.getMarca(TokenUtil.TOKEN).then((
        value) => value);
  }
}