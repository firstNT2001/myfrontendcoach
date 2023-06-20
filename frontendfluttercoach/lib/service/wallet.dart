import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/request/wallet_uid.dart';
import '../model/response/md_Result.dart';
import '../model/response/md_res_gbprime.dart';

part 'generated/wallet.g.dart';

@RestApi()
abstract class WalletService {
  factory WalletService(Dio dio, {String baseUrl}) = _WalletService;
  @POST("/wallet/{uid}")
  Future<HttpResponse<ModelResult>> insertWallet(
      @Path("uid") String uid, @Body() WalletUser walletUser);

  @POST("/gbcallback")
  Future<HttpResponse<ModelResult>> updateWallet(
      @Body() ResponseGbprime responseGbprime);
}
