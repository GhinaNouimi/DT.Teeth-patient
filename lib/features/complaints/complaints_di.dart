import 'data/repositories/complaints_repository_impl.dart';
import 'data/sources/complaints_mock_data_source.dart';
import 'domain/usecases/get_complaint_details_use_case.dart';
import 'domain/usecases/get_complaints_use_case.dart';
import 'domain/usecases/submit_complaint_use_case.dart';

abstract final class ComplaintsDi {
  static final _mockDataSource = ComplaintsMockDataSource();
  static final _repository = ComplaintsRepositoryImpl(_mockDataSource);

  static final getComplaintsUseCase = GetComplaintsUseCase(_repository);
  static final getComplaintDetailsUseCase =
  GetComplaintDetailsUseCase(_repository);
  static final submitComplaintUseCase = SubmitComplaintUseCase(_repository);
}