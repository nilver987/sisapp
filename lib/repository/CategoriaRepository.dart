import 'package:dio/dio.dart';
import 'package:ventas_app/apis/categoria_api.dart';
import 'package:ventas_app/modelo/CategoriaModelo.dart';
import 'package:ventas_app/util/TokenUtil.dart';

class CategoriaRepository {
  CategoriaApi? categoriaApi;

  CategoriaRepository() {
    Dio _dio = Dio();
    _dio.options.headers["Content-Type"] = "application/json";
    categoriaApi = CategoriaApi(_dio);
  }

  Future<List<Categoria>> getEntidad() async {
    return await categoriaApi!.getCategoria(TokenUtil.TOKEN).then((
        value) => value);
  }
}