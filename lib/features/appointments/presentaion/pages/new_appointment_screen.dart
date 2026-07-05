// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// import '../../../../core/routing/app_routes.dart';
// import '../../../../core/theme/theme_extensions.dart';
// import '../../../../core/widgets/feedback/booking_bottom_sheet.dart';
// import '../../../../core/widgets/navigation/app_top_bar.dart';
//
// import '../models/appointments_store.dart';
// import '../models/new_appointment_form_model.dart';
// import '../models/mock_appointments_data.dart';
//
// import '../widgets/appointment/appointment_time_chip.dart';
// import '../widgets/appointment_type_selector_widget.dart';
// import '../widgets/doctor_selector_widget.dart';
// import '../widgets/service_type_grid_widget.dart';
//
// class NewAppointmentScreen extends StatefulWidget {
//   const NewAppointmentScreen({super.key});
//
//   @override
//   State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
// }
//
// class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
//   int _currentStep = 0;
//
//   DateTime _focusedDay = DateTime.now();
//
//   NewAppointmentFormModel _form = const NewAppointmentFormModel();
//
//   final TextEditingController _notesController = TextEditingController();
//
//   @override
//   void dispose() {
//     _notesController.dispose();
//     super.dispose();
//   }
//
//   // List<String> get _availableTimes {
//   //   final doctor = _form.selectedDoctor;
//   //
//   //   if (doctor == null) {
//   //     return [];
//   //   }
//   //
//   //   return MockAppointmentsData.getAvailableTimesForDoctor(doctor.id);
//   // }
//   //
//   // List<int> get _availableDays {
//   //   final doctor = _form.selectedDoctor;
//   //
//   //   if (doctor == null) {
//   //     return [];
//   //   }
//   //
//   //   return MockAppointmentsData.getAvailableDaysForDoctor(doctor.id);
//   // }
//
//   // bool _isDateAvailable(DateTime date) {
//   //   final now = DateTime.now();
//   //
//   //   return _availableDays.contains(date.day) &&
//   //       date.isAfter(now.subtract(const Duration(days: 1))) &&
//   //       date.isBefore(now.add(const Duration(days: 30)));
//   // }
//
//   void _goNext() {
//     // تحويل مباشر لشاشة الطوارئ
//     if (_currentStep == 0 && _form.appointmentType?.isEmergency == true) {
//       context.push(AppRoutes.emergencyAppointment);
//
//       return;
//     }
//
//     if (_currentStep < 3) {
//       setState(() {
//         _currentStep++;
//       });
//     }
//   }
//
//   void _goBack() {
//     if (_currentStep == 0) {
//       context.pop();
//       return;
//     }
//
//     setState(() {
//       _currentStep--;
//     });
//   }
//
//   void _submitAppointment() {
//     final appointment = _form.copyWith(
//       patientNotes: _notesController.text.trim().isEmpty
//           ? null
//           : _notesController.text.trim(),
//     );
//
//     final builtAppointment = appointment.buildAppointment(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//
//       location: 'عيادة DT.Teeth - الطابق الثاني',
//     );
//     AppointmentsStore.instance.addAppointment(builtAppointment);
//     // showBookingBottomSheet(
//     //   context,
//     //
//     //   doctorName: builtAppointment.doctor.name,
//     //
//     //   date:
//     //       '${builtAppointment.appointmentDate.day}/${builtAppointment.appointmentDate.month}/${builtAppointment.appointmentDate.year}',
//     //
//     //   time: builtAppointment.appointmentTime,
//     //
//     //   buttonText: 'العودة للمواعيد',
//     //
//     //   onPressed: () {
//     //     context.go('${AppRoutes.home}?tab=2');
//     //   },
//     // );
//   }
//
//   bool _canContinueCurrentStep() {
//     switch (_currentStep) {
//       case 0:
//         return _form.isAppointmentTypeSelected;
//
//       case 1:
//         return _form.isServiceSelected;
//
//       case 2:
//         // return _form.isDoctorSelected;
//
//       default:
//         return false;
//     }
//   }
//
//   bool _canSubmit() {
//     return _form.isScheduleSelected;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//
//     return Scaffold(
//       backgroundColor: colors.background,
//
//       body: SafeArea(
//         bottom: false,
//
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//
//               child: AppTopBar(title: 'حجز موعد جديد', onBackTap: _goBack),
//             ),
//
//             Expanded(
//               child: ListView(
//                 physics: const BouncingScrollPhysics(),
//
//                 padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//
//                 children: [
//                   _StepIndicator(currentStep: _currentStep),
//
//                   const SizedBox(height: 20),
//
//                   if (_currentStep == 0)
//                     AppointmentTypeSelectorWidget(
//                       selectedType: _form.appointmentType,
//
//                       onTypeSelected: (type) {
//                         setState(() {
//                           _form = _form.copyWith(appointmentType: type);
//                         });
//                       },
//                     ),
//
//                   if (_currentStep == 1)
//                     ServiceTypeGridWidget(
//                       selectedService: _form.serviceType,
//
//                       onServiceSelected: (service) {
//                         setState(() {
//                           _form = _form.copyWith(
//                             serviceType: service,
//
//                             clearDoctor: true,
//
//                             clearSchedule: true,
//                           );
//                         });
//                       },
//                     ),
//
//                   // if (_currentStep == 2)
//                   //   DoctorSelectorWidget(
//                   //     doctors: _form.serviceType == null
//                   //         ? []
//                   //         : MockAppointmentsData.getDoctorsByService(
//                   //             _form.serviceType!,
//                   //           ),
//                   //
//                   //     selectedDoctor: _form.selectedDoctor,
//                   //
//                   //     onDoctorSelected: (doctor) {
//                   //       setState(() {
//                   //         _form = _form.copyWith(
//                   //           selectedDoctor: doctor,
//                   //
//                   //           clearSchedule: true,
//                   //         );
//                   //       });
//                   //     },
//                   //   ),
//
//                   if (_currentStep == 3)
//                     _ScheduleAndReviewStep(
//                       focusedDay: _focusedDay,
//
//                       selectedDate: _form.selectedDate,
//
//                       selectedTime: _form.selectedTime,
//
//                       availableTimes: _availableTimes,
//
//                       isDateAvailable: _isDateAvailable,
//
//                       notesController: _notesController,
//
//                       onDateSelected: (selectedDay, focusedDay) {
//                         setState(() {
//                           _focusedDay = focusedDay;
//
//                           _form = _form.copyWith(
//                             selectedDate: selectedDay,
//
//                             selectedTime: null,
//                           );
//                         });
//                       },
//
//                       onPageChanged: (focusedDay) {
//                         setState(() {
//                           _focusedDay = focusedDay;
//                         });
//                       },
//
//                       onTimeSelected: (time) {
//                         setState(() {
//                           _form = _form.copyWith(selectedTime: time);
//                         });
//                       },
//                     ),
//
//                   const SizedBox(height: 24),
//
//                   if (_currentStep < 3)
//                     SizedBox(
//                       width: double.infinity,
//
//                       child: ElevatedButton(
//                         onPressed: _canContinueCurrentStep() ? _goNext : null,
//
//                         child: const Text('المتابعة'),
//                       ),
//                     ),
//
//                   if (_currentStep == 3)
//                     SizedBox(
//                       width: double.infinity,
//
//                       child: ElevatedButton(
//                         onPressed: _canSubmit() ? _submitAppointment : null,
//
//                         child: const Text('تأكيد الموعد'),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _StepIndicator extends StatelessWidget {
//   final int currentStep;
//
//   const _StepIndicator({required this.currentStep});
//
//   static const List<String> _titles = [
//     'نوع الموعد',
//     'نوع الخدمة',
//     'اختيار الطبيب',
//     'الموعد والتأكيد',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = context.colors;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//
//       children: [
//         Text(
//           'الخطوة ${currentStep + 1} من 4',
//
//           style: theme.textTheme.bodyMedium?.copyWith(
//             color: colors.textSecondary,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//
//         const SizedBox(height: 6),
//
//         Text(
//           _titles[currentStep],
//
//           style: theme.textTheme.titleLarge?.copyWith(
//             color: colors.textPrimary,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//
//         const SizedBox(height: 14),
//
//         Row(
//           children: List.generate(4, (index) {
//             final isActive = index <= currentStep;
//
//             return Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(left: index == 3 ? 0 : 8),
//
//                 height: 6,
//
//                 decoration: BoxDecoration(
//                   color: isActive ? colors.buttonPrimary : colors.surfaceMuted,
//
//                   borderRadius: BorderRadius.circular(99),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }
//
// class _ScheduleAndReviewStep extends StatelessWidget {
//   final DateTime focusedDay;
//
//   final DateTime? selectedDate;
//
//   final String? selectedTime;
//
//   final List<String> availableTimes;
//
//   final bool Function(DateTime) isDateAvailable;
//
//   final TextEditingController notesController;
//
//   final void Function(DateTime, DateTime) onDateSelected;
//
//   final ValueChanged<DateTime> onPageChanged;
//
//   final ValueChanged<String> onTimeSelected;
//
//   const _ScheduleAndReviewStep({
//     required this.focusedDay,
//     required this.selectedDate,
//     required this.selectedTime,
//     required this.availableTimes,
//     required this.isDateAvailable,
//     required this.notesController,
//     required this.onDateSelected,
//     required this.onPageChanged,
//     required this.onTimeSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = context.colors;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//
//       children: [
//         Text(
//           'اختر الموعد المتاح',
//
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.w800,
//             color: colors.textPrimary,
//           ),
//         ),
//
//         const SizedBox(height: 12),
//
//         Container(
//           padding: const EdgeInsets.all(16),
//
//           decoration: BoxDecoration(
//             color: colors.surfacePrimary,
//
//             borderRadius: BorderRadius.circular(20),
//
//             border: Border.all(color: colors.borderSoft),
//           ),
//
//           child: TableCalendar(
//             firstDay: DateTime.now(),
//
//             lastDay: DateTime.now().add(const Duration(days: 30)),
//
//             focusedDay: focusedDay,
//
//             selectedDayPredicate: (day) => isSameDay(selectedDate, day),
//
//             onDaySelected: (selectedDay, focusedDay) {
//               if (isDateAvailable(selectedDay)) {
//                 onDateSelected(selectedDay, focusedDay);
//               }
//             },
//
//             onPageChanged: onPageChanged,
//
//             enabledDayPredicate: isDateAvailable,
//           ),
//         ),
//
//         const SizedBox(height: 20),
//
//         Text(
//           'الأوقات المتاحة',
//
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.w800,
//             color: colors.textPrimary,
//           ),
//         ),
//
//         const SizedBox(height: 12),
//
//         if (selectedDate == null)
//           Container(
//             padding: const EdgeInsets.all(16),
//
//             decoration: BoxDecoration(
//               color: colors.surfaceSecondary,
//
//               borderRadius: BorderRadius.circular(16),
//             ),
//
//             child: Text(
//               'اختر التاريخ أولًا لعرض الأوقات المتاحة.',
//
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: colors.textSecondary,
//               ),
//             ),
//           )
//         else
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//
//             children: availableTimes.map((time) {
//               return AppointmentTimeChip(
//                 label: time,
//
//                 selected: selectedTime == time,
//
//                 available: true,
//
//                 onTap: () => onTimeSelected(time),
//               );
//             }).toList(),
//           ),
//
//         const SizedBox(height: 20),
//
//         Text(
//           'ملاحظتك للطبيب',
//
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.w800,
//             color: colors.textPrimary,
//           ),
//         ),
//
//         const SizedBox(height: 12),
//
//         TextField(
//           controller: notesController,
//
//           maxLines: 4,
//
//           decoration: InputDecoration(
//             hintText: 'اكتب أي ملاحظة أو وصف مختصر للحالة',
//
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//           ),
//         ),
//       ],
//     );
//   }
// }
