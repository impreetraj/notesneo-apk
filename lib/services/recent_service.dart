import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentService {
  static const String _key = 'recent_notes';
  static final ValueNotifier<List<Map<String, dynamic>>> recentNotesNotifier = 
      ValueNotifier<List<Map<String, dynamic>>>([]);

  // In-memory fallback when SharedPreferences is unavailable (platform errors)
  static List<Map<String, dynamic>> _memoryCache = [];

  static List<Map<String, dynamic>> get latestRecent => recentNotesNotifier.value;

  static Future<void> addRecent(Map<String, dynamic> note) async {
    print("RecentService: Adding note ${note['name']}");
    try {
      if (note['pdf'] == null || note['name'] == null) {
        print("RecentService: Invalid note data");
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      List<String> recentList = prefs.getStringList(_key) ?? [];

      // Remove if already exists to move it to the front
      recentList.removeWhere((item) {
        try {
          final decoded = json.decode(item);
          return decoded['pdf'] == note['pdf'];
        } catch (_) {
          return false;
        }
      });

      // Add to the front
      recentList.insert(0, json.encode(note));

      // Keep only the last 3
      if (recentList.length > 3) {
        recentList = recentList.sublist(0, 3);
      }

      await prefs.setStringList(_key, recentList);
      final list = recentList.map((item) => json.decode(item) as Map<String, dynamic>).toList();
      _memoryCache = list;
      recentNotesNotifier.value = list;
      print("RecentService: Successfully added. Total recent: ${list.length}");
    } catch (e) {
      print("Error in addRecent: $e");
      // Fallback: update in-memory cache and notifier so UI still reflects recent notes during session
      try {
        _memoryCache.removeWhere((existing) => existing['pdf'] == note['pdf']);
        _memoryCache.insert(0, note);
        if (_memoryCache.length > 3) _memoryCache = _memoryCache.sublist(0, 3);
        recentNotesNotifier.value = List<Map<String, dynamic>>.from(_memoryCache);
        print("RecentService: Fallback in-memory add, total: ${_memoryCache.length}");
      } catch (e2) {
        print("RecentService fallback failed: $e2");
      }
    }
  }

  static Future<List<Map<String, dynamic>>> getRecent() async {
    print("RecentService: Fetching recent notes");
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> recentList = prefs.getStringList(_key) ?? [];
      final list = recentList.map((item) => json.decode(item) as Map<String, dynamic>).toList();
      recentNotesNotifier.value = list;
      print("RecentService: Fetched ${list.length} notes");
      return list;
    } catch (e) {
      print("Error in getRecent: $e");
      // Return fallback in-memory cache if prefs unavailable
      recentNotesNotifier.value = List<Map<String, dynamic>>.from(_memoryCache);
      print("RecentService: Returning fallback memory cache (${_memoryCache.length})");
      return List<Map<String, dynamic>>.from(_memoryCache);
    }
  }
}
