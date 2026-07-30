import '../../../../core/cache/cached_result.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../../../core/network/network_error_messages.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/invoice/invoice_summary_entity.dart';
import '../../domain/entities/invoice/treatment_invoice_entity.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/local/invoice_local_data_source.dart';
import '../datasources/remote/invoice_remote_data_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;
  final InvoiceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const InvoiceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CachedResult<InvoiceSummaryEntity>> getInvoiceSummary({
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final summary = await remoteDataSource.getInvoiceSummary();

        await localDataSource.cacheInvoiceSummary(summary);

        return CachedResult.remote(summary);
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    final cachedSummary =
    await localDataSource.getCachedInvoiceSummary();

    if (cachedSummary == null) {
      throw Exception(
        NetworkErrorMessages.noCachedData(languageCode),
      );
    }

    return CachedResult.cache(cachedSummary);
  }

  @override
  Future<CachedResult<TreatmentInvoiceEntity>>
  getInvoiceForTreatment({
    required int treatmentId,
    required String languageCode,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final invoice =
        await remoteDataSource.getInvoiceForTreatment(
          treatmentId,
        );

        await localDataSource.cacheTreatmentInvoice(invoice);

        return CachedResult.remote(invoice);
      } catch (error) {
        throw Exception(
          ApiErrorHandler.handle(
            error,
            languageCode: languageCode,
          ),
        );
      }
    }

    final cachedInvoice =
    await localDataSource.getCachedTreatmentInvoice(
      treatmentId,
    );

    if (cachedInvoice == null) {
      throw Exception(
        NetworkErrorMessages.noCachedData(languageCode),
      );
    }

    return CachedResult.cache(cachedInvoice);
  }
}