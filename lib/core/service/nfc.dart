import 'dart:developer';
import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  Future<void> readNfcData({
    required Function(Map<String, dynamic> data) onTagDiscovered,
    required Function(String error) onError,
    required Function() onTimeout,
  }) async {
    bool tagDetected = false;

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          tagDetected = true;
          final ndef = Ndef.from(tag);
          if (ndef == null) {
            log('This tag does not contain NDEF data. Showing raw data...');
            onTagDiscovered({
              'message': 'This tag does not contain NDEF data.',
              'rawData': tag.data,
            });
          } else {
            final cachedMessage = ndef.cachedMessage;
            log('NDEF data found.');
            onTagDiscovered({
              'message': 'NDEF data found.',
              'ndefData': cachedMessage?.toString() ?? 'No NDEF records.',
            });
          }
          await stopNfcSession();
        },
        onError: (error) async {
          log('Error: $error');
          onError('Error: $error');
          await stopNfcSession();
        },
      );

      await Future.delayed(const Duration(seconds: 15), () async {
        if (!tagDetected) {
          log('NFC Read Timeout');
          onTimeout();
          await stopNfcSession();
        }
      });
    } catch (e) {
      log('Error starting NFC session: $e');
      onError('Error starting NFC session: $e');
    }
  }

  Future<void> writeNfcData({
    required String dataToWrite,
    required Function(String successMessage) onWriteSuccess,
    required Function(String errorMessage) onError,
    required Function() onTimeout,
  }) async {
    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var ndef = Ndef.from(tag);
          if (ndef == null || !ndef.isWritable) {
            log('Tag is not writable');
            onError('Tag is not writable');
            await stopNfcSession();
            return;
          }

          NdefMessage message =
              NdefMessage([NdefRecord.createText(dataToWrite)]);
          try {
            await ndef.write(message);
            log("Successfully wrote to NFC tag");
            onWriteSuccess('Successfully wrote data to NFC tag.');
          } catch (e) {
            log("Write failed: $e");
            onError('Failed to write data: $e');
          }
          await stopNfcSession();
        },
        onError: (error) async {
          log('Error: $error');
          onError('Error: $error');
          await stopNfcSession();
        },
      );
      Future.delayed(const Duration(seconds: 15), () async {
        onTimeout();
        await stopNfcSession();
      });
    } catch (e) {
      log('Error starting NFC session: $e');
      onError('Error starting NFC session: $e');
    }
  }

  Future<void> stopNfcSession() async {
    await NfcManager.instance.stopSession();
  }
}
