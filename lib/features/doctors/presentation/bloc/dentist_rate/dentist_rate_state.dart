abstract class DentistRateState {
  const DentistRateState();
}

class DentistRateInitial extends DentistRateState {
  const DentistRateInitial();
}

class DentistRateLoading extends DentistRateState {
  const DentistRateLoading();
}

class DentistRateLoaded extends DentistRateState {
  final int rating;

  const DentistRateLoaded({
    required this.rating,
  });
}

class DentistRateSubmitting extends DentistRateState {
  final int currentRating;

  const DentistRateSubmitting({
    required this.currentRating,
  });
}

class DentistRateSubmitted extends DentistRateState {
  final int averageRating;

  const DentistRateSubmitted({
    required this.averageRating,
  });
}

class DentistRateFailure extends DentistRateState {
  final String message;

  const DentistRateFailure({
    required this.message,
  });
}