import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../../models/invoice/invoice_summary_model.dart';
import '../../models/invoice/treatment_invoice_model.dart';
import 'invoice_remote_data_source.dart';

class InvoiceRemoteDataSourceImpl
    implements InvoiceRemoteDataSource {
  final Dio dio;

  InvoiceRemoteDataSourceImpl({
    Dio? dio,
  }) : dio = dio ?? DioClient.dio;

  @override
  Future<InvoiceSummaryModel> getInvoiceSummary() async {
    final response = await dio.get(
      ApiConstants.showAllInvoices,
    );
    @override
    Future<InvoiceSummaryModel> getInvoiceSummary() async {
      final response = await dio.get(
        ApiConstants.showAllInvoices,
      );

      debugPrint(
        'SHOW ALL INVOICES URL: '
            '${ApiConstants.showAllInvoices}',
      );

      debugPrint(
        'SHOW ALL INVOICES RESPONSE: '
            '${response.data}',
      );

      return InvoiceSummaryModel.fromJson(
        response.data['data'],
      );
    }

    return InvoiceSummaryModel.fromJson(
      response.data['data'],
    );
  }

  @override
  Future<TreatmentInvoiceModel> getInvoiceForTreatment(
      int treatmentId,
      ) async {
    final response = await dio.get(
      ApiConstants.invoiceForTreatment(
        treatmentId,
      ),
    );

    return TreatmentInvoiceModel.fromJson(
      response.data['data'],
    );
  }
}