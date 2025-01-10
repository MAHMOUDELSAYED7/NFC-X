import 'package:flutter_riverpod/flutter_riverpod.dart';

class NfcWriteState {
  final bool isScanning;
  final bool? writeSuccess;
  final bool? validationSuccess;
  final String dataToWrite;
  final String? errorMessage;
  final bool isWriteInitiated;

  NfcWriteState({
    required this.isScanning,
    this.writeSuccess,
    this.validationSuccess,
    required this.dataToWrite,
    this.errorMessage,
    required this.isWriteInitiated,
  });

  NfcWriteState.initial()
      : isScanning = false,
        writeSuccess = null,
        validationSuccess = false,
        dataToWrite = '',
        errorMessage = null,
        isWriteInitiated = false;

  NfcWriteState copyWith({
    bool? isScanning,
    bool? writeSuccess,
    bool? validationSuccess,
    String? dataToWrite,
    String? errorMessage,
    bool? isWriteInitiated,
  }) {
    return NfcWriteState(
      isScanning: isScanning ?? this.isScanning,
      writeSuccess: writeSuccess ?? this.writeSuccess,
      validationSuccess: validationSuccess ?? this.validationSuccess,
      dataToWrite: dataToWrite ?? this.dataToWrite,
      errorMessage: errorMessage ?? this.errorMessage,
      isWriteInitiated: isWriteInitiated ?? this.isWriteInitiated,
    );
  }
}

class NfcWriteStateNotifier extends StateNotifier<NfcWriteState> {
  NfcWriteStateNotifier() : super(NfcWriteState.initial());

  void startScanning() {
    clearState();
    state = state.copyWith(isScanning: true, isWriteInitiated: true);
  }

  void stopScanning() {
    state = state.copyWith(isScanning: false);
  }

  void updateWriteSuccess(bool success) {
    state = state.copyWith(writeSuccess: success, isWriteInitiated: false);
  }

  void updateDataToWrite(String data) {
    state = state.copyWith(dataToWrite: data);
  }

  void updateErrorMessage(String error) {
    state = state.copyWith(errorMessage: error, isWriteInitiated: false);
  }

  void clearState() {
    state = NfcWriteState.initial();
  }
}

final nfcWriteStateProvider =
    StateNotifierProvider<NfcWriteStateNotifier, NfcWriteState>(
  (ref) => NfcWriteStateNotifier(),
);
