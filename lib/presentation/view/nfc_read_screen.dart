import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/service/nfc.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/error_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/nfc_action_button.dart';
import '../riverpod/nfc_read_provider.dart';

class NfcReadScreen extends ConsumerWidget {
  const NfcReadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nfcState = ref.watch(nfcStateProvider);
    final nfcService = NfcService();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'NFC Reading',
        icon: Icons.document_scanner_rounded,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            LoadingIndicator(state: nfcState.isScanning),
            _buildTagDetailsSection(nfcState),
            NfcActionButton(
              isScanning: nfcState.isScanning,
              onPressed: () => _startNfcScanning(ref, nfcService),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagDetailsSection(NfcReadState nfcState) {
    return SizedBox(
      height: ScreenUtil().screenHeight * 0.4,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (nfcState.errorMessage != null)
              ErrorCard(errorMessage: nfcState.errorMessage!)
            else if (nfcState.scannedTag != null)
              _buildTagDetails(nfcState.scannedTag!)
            else
              const Center(
                child: Text('No data, tap on the NFC icon to start reading.'),
              ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTagDetails(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message: ${data['message']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Text(
            data['rawData'] != null
                ? 'Raw Data: ${data['rawData']}'
                : 'NDEF Data: ${data['ndefData']}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            )),
      ],
    );
  }

  Future<void> _startNfcScanning(WidgetRef ref, NfcService nfcService) async {
    ref.read(nfcStateProvider.notifier).startScanning();

    if (await nfcService.isNfcAvailable()) {
      await nfcService.readNfcData(
        onTagDiscovered: (data) {
          ref.read(nfcStateProvider.notifier).updateScannedTag(data);
          ref.read(nfcStateProvider.notifier).stopScanning();
        },
        onError: (error) {
          ref.read(nfcStateProvider.notifier).setError(error);
          ref.read(nfcStateProvider.notifier).stopScanning();
        },
        onTimeout: () {
          ref
              .read(nfcStateProvider.notifier)
              .setError('NFC read timed out after 15 seconds.');
          ref.read(nfcStateProvider.notifier).stopScanning();
        },
      );
    } else {
      ref
          .read(nfcStateProvider.notifier)
          .setError('NFC is not available on this device.');
      ref.read(nfcStateProvider.notifier).stopScanning();
    }
  }
}
