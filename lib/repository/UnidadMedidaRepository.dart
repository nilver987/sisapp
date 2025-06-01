import 'package:dio/dio.dart';
import 'package:ventas_app/apis/unidadmedida_api.dart';
import 'package:ventas_app/modelo/UnidadMedidaModelo.dart';
import 'package:ventas_app/util/TokenUtil.dart';

class UnidadMedidaRepository {
  UnidadmedidaApi? unidadmedidaApi;

  UnidadMedidaRepository() {
    Dio _dio = Dio();
    _dio.options.headers["Content-Type"] = "application/json";
    unidadmedidaApi = UnidadmedidaApi(_dio);
  }

  Future<List<UnidadMedida>> getEntidad() async {
    return await unidadmedidaApi!.getUnidadMedida(TokenUtil.TOKEN).then((
        value) => value);
  }
}