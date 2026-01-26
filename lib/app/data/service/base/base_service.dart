import 'package:blooket/app/config/network/api_client.dart';

abstract class BaseService {
  ApiClient apiClient;

  BaseService(this.apiClient);
}
