import 'package:flutter/material.dart';
import 'package:algo_rise/src/services/preferences_service.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';

class ExecutionSettingsDialog extends StatefulWidget {
  const ExecutionSettingsDialog({super.key});

  @override
  State<ExecutionSettingsDialog> createState() => _ExecutionSettingsDialogState();
}

class _ExecutionSettingsDialogState extends State<ExecutionSettingsDialog> {
  final _prefs = PreferencesService.instance;
  late String _selectedBackend;
  late TextEditingController _pistonUrlController;
  late TextEditingController _rapidApiKeyController;

  @override
  void initState() {
    super.initState();
    _selectedBackend = _prefs.executionBackend;
    _pistonUrlController = TextEditingController(text: _prefs.pistonUrl);
    _rapidApiKeyController = TextEditingController(text: _prefs.rapidApiKey);
  }

  @override
  void dispose() {
    _pistonUrlController.dispose();
    _rapidApiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    await _prefs.setExecutionBackend(_selectedBackend);
    await _prefs.setPistonUrl(_pistonUrlController.text.trim());
    await _prefs.setRapidApiKey(_rapidApiKeyController.text.trim());
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Execution settings updated successfully!'),
          backgroundColor: AppColors.primaryFixedDim,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117), // Match editor background color
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Execution Settings',
                      style: AppText.headlineMd.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white60),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              
              // Mode Selector
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  'COMPILER BACKEND',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              
              // Mock Backend Option
              RadioListTile<String>(
                value: 'mock',
                groupValue: _selectedBackend,
                activeColor: AppColors.primaryFixedDim,
                title: const Text('Offline Pattern Checker (Mock)', style: TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: const Text('Runs instantly offline; checks coding patterns using regex.', style: TextStyle(color: Colors.white38, fontSize: 11)),
                onChanged: (val) {
                  setState(() => _selectedBackend = val!);
                },
              ),
              
              // Piston Backend Option
              RadioListTile<String>(
                value: 'piston',
                groupValue: _selectedBackend,
                activeColor: AppColors.primaryFixedDim,
                title: const Text('Piston Compiler API', style: TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: const Text('Executes via custom Piston server. Self-host or use public URLs.', style: TextStyle(color: Colors.white38, fontSize: 11)),
                onChanged: (val) {
                  setState(() => _selectedBackend = val!);
                },
              ),
              
              // Judge0 Backend Option
              RadioListTile<String>(
                value: 'judge0',
                groupValue: _selectedBackend,
                activeColor: AppColors.primaryFixedDim,
                title: const Text('Judge0 CE API (RapidAPI)', style: TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: const Text('Runs code via sandbox compiler. Requires free RapidAPI key.', style: TextStyle(color: Colors.white38, fontSize: 11)),
                onChanged: (val) {
                  setState(() => _selectedBackend = val!);
                },
              ),

              const SizedBox(height: 12),

              // Dynamic Inputs
              if (_selectedBackend == 'piston') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Piston Host URL', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _pistonUrlController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'https://emkc.org',
                          hintStyle: const TextStyle(color: Colors.white24),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primaryFixedDim, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Leave empty to default to https://emkc.org (requires auth key). You can self-host using Docker.',
                        style: TextStyle(color: Colors.white30, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],

              if (_selectedBackend == 'judge0') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('RapidAPI Key', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _rapidApiKeyController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your X-RapidAPI-Key',
                          hintStyle: const TextStyle(color: Colors.white24),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primaryFixedDim, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Get your free key by subscribing to "Judge0 Extra CE" on RapidAPI.',
                        style: TextStyle(color: Colors.white30, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryFixedDim,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _saveSettings,
                      child: const Text('Save Settings'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
