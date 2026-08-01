import 'package:flutter/material.dart';

import '../../domain/entities/offer_entity.dart';
import '../sections/offer_application_section.dart';
import '../sections/offer_information_section.dart';
import 'offer_details_header.dart';

class OfferDetailsContent extends StatelessWidget {
  final OfferEntity offer;

  const OfferDetailsContent({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(
        20,
        18,
        20,
        120,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OfferDetailsHeader(
            offer: offer,
          ),
          const SizedBox(height: 18),
          OfferInformationSection(
            offer: offer,
          ),
          const SizedBox(height: 18),
          OfferApplicationSection(
            offer: offer,
          ),
        ],
      ),
    );
  }
}