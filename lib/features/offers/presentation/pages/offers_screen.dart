import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/offer_entity.dart';
import '../bloc/offers_bloc.dart';
import '../bloc/offers_event.dart';
import '../bloc/offers_state.dart';
import '../sections/offers_loaded_section.dart';
import '../widgets/offers_empty_view.dart';
import '../widgets/offers_error_view.dart';
import '../widgets/offers_loading_view.dart';

class OffersScreen extends StatefulWidget {
  final ValueChanged<OfferEntity> onOfferPressed;

  const OffersScreen({
    super.key,
    required this.onOfferPressed,
  });

  @override
  State<OffersScreen> createState() {
    return _OffersScreenState();
  }
}

class _OffersScreenState extends State<OffersScreen> {
  String get _languageCode {
    return Localizations.localeOf(
      context,
    ).languageCode;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!mounted) {
          return;
        }

        _loadOffers();
      },
    );
  }

  void _loadOffers() {
    context.read<OffersBloc>().add(
      LoadOffersRequested(
        languageCode: _languageCode,
      ),
    );
  }

  Future<void> _refreshOffers() async {
    final bloc = context.read<OffersBloc>();

    bloc.add(
      LoadOffersRequested(
        languageCode: _languageCode,
      ),
    );

    await bloc.stream.firstWhere(
          (state) {
        return state.offersStatus !=
            OffersStatus.loading;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.offersTitle,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<OffersBloc, OffersState>(
        buildWhen: (previous, current) {
          return previous.offersStatus !=
              current.offersStatus ||
              previous.offers != current.offers ||
              previous.isFromCache !=
                  current.isFromCache ||
              previous.offersErrorMessage !=
                  current.offersErrorMessage;
        },
        builder: (context, state) {
          switch (state.offersStatus) {
            case OffersStatus.initial:
            case OffersStatus.loading:
              return const OffersLoadingView();

            case OffersStatus.failure:
              return OffersErrorView(
                message: state.offersErrorMessage,
                onRetry: _loadOffers,
              );

            case OffersStatus.success:
              if (state.offers.isEmpty) {
                return OffersEmptyView(
                  onRefresh: _loadOffers,
                );
              }

              return OffersLoadedSection(
                offers: state.offers,
                isFromCache: state.isFromCache,
                onRefresh: _refreshOffers,
                onOfferPressed:
                widget.onOfferPressed,
              );
          }
        },
      ),
    );
  }
}