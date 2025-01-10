import 'package:flutter_riverpod/flutter_riverpod.dart';

class NfcReadState {
  final bool isScanning;
  final Map<String, dynamic>? scannedTag;
  final String? errorMessage;

  NfcReadState({
    required this.isScanning,
    this.scannedTag,
    this.errorMessage,
  });

  NfcReadState.initial()
      : isScanning = false,
        scannedTag = null,
        errorMessage = null;

  NfcReadState copyWith({
    bool? isScanning,
    Map<String, dynamic>? scannedTag,
    String? errorMessage,
  }) {
    return NfcReadState(
      isScanning: isScanning ?? this.isScanning,
      scannedTag: scannedTag ?? this.scannedTag,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class NfcStateNotifier extends StateNotifier<NfcReadState> {
  NfcStateNotifier() : super(NfcReadState.initial());

  void startScanning() {
    clearState();
    state = state.copyWith(isScanning: true);
  }

  void stopScanning() {
    state = state.copyWith(isScanning: false);
  }

  void updateScannedTag(Map<String, dynamic> tag) {
    state = state.copyWith(scannedTag: tag);
  }

  void setError(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  void clearState() {
    state = NfcReadState.initial();
  }
}

final nfcStateProvider = StateNotifierProvider<NfcStateNotifier, NfcReadState>(
  (ref) => NfcStateNotifier(),
);
