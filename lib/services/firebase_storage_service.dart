import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;

@injectable
class FirebaseStorageService {
  final LoggerService _logger;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseStorageService(this._logger);

  /// Upload audio file to Firebase Storage
  Future<String?> uploadAudioFile(String localFilePath, String exerciseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final file = File(localFilePath);
      if (!await file.exists()) {
        throw Exception('Audio file not found: $localFilePath');
      }

      // Generate a unique filename
      final fileName = _generateFileName(localFilePath, exerciseId);
      final storageRef = _storage.ref().child('audio_recordings/${user.uid}/$fileName');

      _logger.debug('Uploading audio file: $localFilePath to $fileName');

      // Upload file with metadata
      final metadata = SettableMetadata(
        contentType: 'audio/aac',
        customMetadata: {
          'exerciseId': exerciseId,
          'userId': user.uid,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      final uploadTask = storageRef.putFile(file, metadata);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        _logger.debug('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
      });

      // Wait for upload to complete
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      _logger.info('Audio file uploaded successfully: $downloadUrl');
      return downloadUrl;

    } catch (e) {
      _logger.error('Failed to upload audio file: $e');
      rethrow;
    }
  }

  /// Upload audio file in background (non-blocking)
  Future<void> uploadAudioFileInBackground(String localFilePath, String exerciseId) async {
    try {
      // Run upload in background without blocking the UI
      _uploadAudioFileWithRetry(localFilePath, exerciseId).unawaited;
    } catch (e) {
      _logger.error('Background upload failed: $e');
    }
  }

  /// Upload with retry logic
  Future<String?> _uploadAudioFileWithRetry(String localFilePath, String exerciseId, [int retryCount = 0]) async {
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 5);

    try {
      return await uploadAudioFile(localFilePath, exerciseId);
    } catch (e) {
      if (retryCount < maxRetries) {
        _logger.warning('Upload failed, retrying in ${retryDelay.inSeconds}s... (${retryCount + 1}/$maxRetries)');
        await Future.delayed(retryDelay);
        return _uploadAudioFileWithRetry(localFilePath, exerciseId, retryCount + 1);
      } else {
        _logger.error('Upload failed after $maxRetries attempts: $e');
        rethrow;
      }
    }
  }

  /// Delete audio file from Firebase Storage
  Future<bool> deleteAudioFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      _logger.info('Audio file deleted successfully: $downloadUrl');
      return true;
    } catch (e) {
      _logger.error('Failed to delete audio file: $e');
      return false;
    }
  }

  /// Get metadata for uploaded audio file
  Future<Map<String, dynamic>?> getAudioFileMetadata(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      final metadata = await ref.getMetadata();
      
      return {
        'name': metadata.name,
        'size': metadata.size,
        'contentType': metadata.contentType,
        'timeCreated': metadata.timeCreated?.toIso8601String(),
        'updated': metadata.updated?.toIso8601String(),
        'customMetadata': metadata.customMetadata,
      };
    } catch (e) {
      _logger.error('Failed to get audio file metadata: $e');
      return null;
    }
  }

  /// List all audio files for current user
  Future<List<Reference>> listUserAudioFiles() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final ref = _storage.ref().child('audio_recordings/${user.uid}');
      final result = await ref.listAll();
      
      return result.items;
    } catch (e) {
      _logger.error('Failed to list audio files: $e');
      return [];
    }
  }

  /// Get download URL for a storage reference
  Future<String> getDownloadUrl(Reference ref) async {
    try {
      return await ref.getDownloadURL();
    } catch (e) {
      _logger.error('Failed to get download URL: $e');
      rethrow;
    }
  }

  /// Generate unique filename for audio file
  String _generateFileName(String localFilePath, String exerciseId) {
    final originalName = path.basename(localFilePath);
    final extension = path.extension(originalName);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    return 'exercise_${exerciseId}_$timestamp$extension';
  }

  /// Check if file exists in storage
  Future<bool> fileExists(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get file size without downloading
  Future<int?> getFileSize(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      final metadata = await ref.getMetadata();
      return metadata.size;
    } catch (e) {
      _logger.error('Failed to get file size: $e');
      return null;
    }
  }

  /// Create a resumable upload task
  UploadTask createUploadTask(String localFilePath, String exerciseId) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final file = File(localFilePath);
    final fileName = _generateFileName(localFilePath, exerciseId);
    final storageRef = _storage.ref().child('audio_recordings/${user.uid}/$fileName');

    final metadata = SettableMetadata(
      contentType: 'audio/aac',
      customMetadata: {
        'exerciseId': exerciseId,
        'userId': user.uid,
        'uploadedAt': DateTime.now().toIso8601String(),
      },
    );

    return storageRef.putFile(file, metadata);
  }
}

/// Extension to handle unawaited futures
extension UnawaitedfFuture<T> on Future<T> {
  void get unawaited {}
}