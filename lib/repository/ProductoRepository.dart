import 'package:dio/dio.dart';
import 'package:ventas_app/apis/producto_api.dart';
import 'package:ventas_app/modelo/MessageModelo.dart';
import 'package:ventas_app/modelo/ProductoModelo.dart';
import 'package:ventas_app/util/TokenUtil.dart';

class ProductoRepository{
  ProductoApi? productoApi;

  ProductoRepository(){
    Dio _dio=Dio();
    _dio.options.headers["Content-Type"]="application/json";
    productoApi=ProductoApi(_dio);
  }

  Future<List<ProductoResp>> getEntidad() async{
    return await productoApi!.getProducto(TokenUtil.TOKEN).then((value)=>value);
  }

  Future<Message> deleteEntidad(int id) async{
    return await productoApi!.deleteProducto(TokenUtil.TOKEN, id);
  }

  Future<ProductoResp> updateEntidad(int id, ProductoDto producto) async{
    return await productoApi!.updateProducto(TokenUtil.TOKEN, id, producto);
  }

  Future<Message> createEntidad(ProductoDto producto) async{
    return await productoApi!.crearProducto(TokenUtil.TOKEN, producto);
  }

}