import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/service/nfc.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/error_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/nfc_action_button.dart';
import '../riverpod/nfc_write_provider.dart';

class NfcWriteScreen extends ConsumerStatefulWidget {
  const NfcWriteScreen({super.key});

  @override
  ConsumerState<NfcWriteScreen> createState() => _NfcWriteScreenState();
}

class _NfcWriteScreenState extends ConsumerState<NfcWriteScreen> {
  late FocusNode _focusNode;
  late NfcService _nfcService;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _nfcService = NfcService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final nfcState = ref.watch(nfcWriteStateProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'NFC Writing',
        icon: Icons.edit_note_rounded,
      ),
      body: ListView(
        children: [
          LoadingIndicator(state: nfcState.isScanning),
          SizedBox(height: 40.h),
          _buildNfcWritingCard(nfcState),
          SizedBox(height: 20.h),
          _buildTextField(ref),
          if (nfcState.errorMessage != null)
            ErrorCard(errorMessage: nfcState.errorMessage!),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildNfcWritingCard(NfcWriteState nfcState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Text(
                "Will be written on tag: ${nfcState.dataToWrite}",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              FractionallySizedBox(
                widthFactor: 1.25,
                child: NfcActionButton(
                  isScanning: nfcState.isScanning,
                  onPressed: () => _startNfcWriting(ref, nfcState.dataToWrite),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Touch to write Text",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: TextField(
        focusNode: _focusNode,
        decoration: InputDecoration(
          fillColor: Colors.blue[50],
          filled: true,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: 'Text to write on Tag',
        ),
        onChanged: (value) =>
            ref.read(nfcWriteStateProvider.notifier).updateDataToWrite(value),
      ),
    );
  }

  Future<void> _startNfcWriting(WidgetRef ref, String dataToWrite) async {
    ref.read(nfcWriteStateProvider.notifier).startScanning();

    await _nfcService.writeNfcData(
      dataToWrite: dataToWrite,
      onWriteSuccess: (successMessage) {
        ref.read(nfcWriteStateProvider.notifier).updateWriteSuccess(true);
        ref.read(nfcWriteStateProvider.notifier).stopScanning();
      },
      onError: (errorMessage) {
        ref
            .read(nfcWriteStateProvider.notifier)
            .updateErrorMessage(errorMessage);
        ref.read(nfcWriteStateProvider.notifier).stopScanning();
      },
      onTimeout: () {
        if (ref.read(nfcWriteStateProvider).isWriteInitiated) {
          ref.read(nfcWriteStateProvider.notifier).updateErrorMessage(
              'Write operation timed out after 15 seconds.');
        }
        ref.read(nfcWriteStateProvider.notifier).stopScanning();
      },
    );
  }
}
