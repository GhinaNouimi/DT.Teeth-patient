import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/invoice/get_invoice_for_treatment_use_case.dart';
import '../../../domain/usecases/invoice/get_invoice_summary_use_case.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GetInvoiceSummaryUseCase getInvoiceSummaryUseCase;
  final GetInvoiceForTreatmentUseCase getInvoiceForTreatmentUseCase;

  InvoiceBloc({
    required this.getInvoiceSummaryUseCase,
    required this.getInvoiceForTreatmentUseCase,
  }) : super(const InvoiceInitial()) {
    on<LoadInvoiceSummaryRequested>(
      _onLoadInvoiceSummaryRequested,
    );

    on<LoadTreatmentInvoiceRequested>(
      _onLoadTreatmentInvoiceRequested,
    );
  }

  Future<void> _onLoadInvoiceSummaryRequested(
      LoadInvoiceSummaryRequested event,
      Emitter<InvoiceState> emit,
      ) async {
    emit(const InvoiceLoading());

    try {
      final result = await getInvoiceSummaryUseCase(
        languageCode: event.languageCode,
      );

      emit(
        InvoiceSummaryLoaded(
          summary: result.data,
          isFromCache: result.isFromCache,
        ),
      );
    } catch (error) {
      emit(
        InvoiceFailure(
          message: error
              .toString()
              .replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoadTreatmentInvoiceRequested(
      LoadTreatmentInvoiceRequested event,
      Emitter<InvoiceState> emit,
      ) async {
    emit(const InvoiceLoading());

    try {
      final result = await getInvoiceForTreatmentUseCase(
        treatmentId: event.treatmentId,
        languageCode: event.languageCode,
      );

      emit(
        TreatmentInvoiceLoaded(
          invoice: result.data,
          isFromCache: result.isFromCache,
        ),
      );
    } catch (error) {
      emit(
        InvoiceFailure(
          message: error
              .toString()
              .replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}