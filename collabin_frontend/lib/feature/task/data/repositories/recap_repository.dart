import 'package:collabin/core/common/api_exception.dart';
import 'package:collabin/feature/task/data/models/recap_model.dart';

abstract class RecapRepository {
  Future<RecapModel> fetchRecap(String filterWaktu);
}

class RecapRepositoryImpl implements RecapRepository {
  @override
  Future<RecapModel> fetchRecap(String filterWaktu) async {
    // Recap aktivitas yang dipakai aplikasi ada di feature/recap
    // (GET /api/v1/activity-logs/recap). Repository ini tidak terhubung ke
    // endpoint apa pun, jadi sengaja tidak mengembalikan angka palsu.
    throw ApiException('Recap berdasarkan filter belum tersedia.', 501);
  }
}
