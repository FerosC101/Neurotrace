import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/motor_test_result.dart';
import '../../../providers/motor_test_provider.dart';

class MotorTestScreen extends StatelessWidget {
  const MotorTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MotorTestProvider(),
      child: const _MotorTestScreenContent(),
    );
  }
}

class _MotorTestScreenContent extends StatelessWidget {
  const _MotorTestScreenContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MotorTestProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motor Function Test'),
        actions: [
          if (provider.state != MotorTestState.instructions &&
              provider.state != MotorTestState.bothHandsComplete)
            TextButton.icon(
              onPressed: () => provider.reset(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MotorTestProvider provider) {
    switch (provider.state) {
      case MotorTestState.instructions:
        return const _InstructionsView();
      case MotorTestState.selectHand:
        return const _SelectHandView();
      case MotorTestState.countdown:
        return const _CountdownView();
      case MotorTestState.testing:
        return const _TestingView();
      case MotorTestState.results:
        return const _SingleResultView();
      case MotorTestState.bothHandsComplete:
        return const _BothResultsView();
    }
  }
}

// Instructions Screen
class _InstructionsView extends StatelessWidget {
  const _InstructionsView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.pan_tool,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Finger Tapping Test',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Measure your motor function and coordination',
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildInstructionStep(
            1,
            'Select your hand',
            'Choose which hand you want to test first.',
          ),
          const SizedBox(height: 16),
          _buildInstructionStep(
            2,
            'Tap as fast as possible',
            'When the test starts, tap the button repeatedly for 10 seconds.',
          ),
          const SizedBox(height: 16),
          _buildInstructionStep(
            3,
            'Maintain rhythm',
            'Try to tap at a consistent, steady pace for best results.',
          ),
          const SizedBox(height: 16),
          _buildInstructionStep(
            4,
            'Test both hands',
            'For accurate assessment, test both your left and right hands.',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Use your index finger or thumb for tapping.',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              context.read<MotorTestProvider>().startTest();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Start Test'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(int number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h4),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Select Hand Screen
class _SelectHandView extends StatelessWidget {
  const _SelectHandView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MotorTestProvider>();
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Text(
            'Select Hand to Test',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Which hand would you like to test?',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: _HandSelectionCard(
                  hand: 'left',
                  icon: Icons.pan_tool,
                  label: 'Left Hand',
                  tested: provider.hasLeftResult,
                  onTap: () => provider.selectHand('left'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _HandSelectionCard(
                  hand: 'right',
                  icon: Icons.back_hand,
                  label: 'Right Hand',
                  tested: provider.hasRightResult,
                  onTap: () => provider.selectHand('right'),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (provider.bothHandsComplete)
            ElevatedButton(
              onPressed: () => provider.viewBothResults(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('View Combined Results'),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _HandSelectionCard extends StatelessWidget {
  final String hand;
  final IconData icon;
  final String label;
  final bool tested;
  final VoidCallback onTap;

  const _HandSelectionCard({
    required this.hand,
    required this.icon,
    required this.label,
    required this.tested,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: tested ? Colors.green : AppColors.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: tested ? Colors.green : AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
            if (tested) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Tested',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Countdown Screen
class _CountdownView extends StatefulWidget {
  const _CountdownView();

  @override
  State<_CountdownView> createState() => _CountdownViewState();
}

class _CountdownViewState extends State<_CountdownView> {
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _countdown = 2);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() => _countdown = 1);
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                setState(() => _countdown = 0);
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange.shade100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _countdown > 0 ? '$_countdown' : 'GO!',
              style: AppTextStyles.h1.copyWith(
                fontSize: 120,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Get Ready...',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// Testing Screen
class _TestingView extends StatelessWidget {
  const _TestingView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MotorTestProvider>();
    
    return Column(
      children: [
        // Timer and stats bar
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.primary.withOpacity(0.1),
          child: Column(
            children: [
              Text(
                '${provider.remainingSeconds}',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'seconds remaining',
                style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '${provider.tapCount}',
                        style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                      ),
                      Text(
                        'taps',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        provider.currentTapsPerSecond.toStringAsFixed(1),
                        style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                      ),
                      Text(
                        'taps/sec',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Tap button
        Expanded(
          child: GestureDetector(
            onTap: () => provider.onTap(),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'TAP',
                          style: AppTextStyles.h1.copyWith(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Single Result Screen
class _SingleResultView extends StatelessWidget {
  const _SingleResultView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MotorTestProvider>();
    final result = provider.selectedHand == 'left' 
        ? provider.leftHandResult 
        : provider.rightHandResult;

    if (result == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final handIcon = result.hand == 'left' ? Icons.pan_tool : Icons.back_hand;
    final handLabel = result.hand == 'left' ? 'Left Hand' : 'Right Hand';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Icon(
            handIcon,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            '$handLabel Results',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Main metric
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Taps Per Second',
                  style: AppTextStyles.h4.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  result.tapsPerSecond.toStringAsFixed(2),
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 56,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Other stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Taps',
                  '${result.totalTaps}',
                  Icons.touch_app,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Consistency',
                  '${result.consistency.toStringAsFixed(0)} ms',
                  Icons.show_chart,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'Rhythm Stability',
            '${((1 - result.rhythm) * 100).clamp(0, 100).toStringAsFixed(0)}%',
            Icons.music_note,
            Colors.purple,
          ),
          const SizedBox(height: 32),
          // Action buttons
          if (!provider.bothHandsComplete) ...[
            ElevatedButton(
              onPressed: () => provider.testOtherHand(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Test ${result.hand == 'left' ? 'Right' : 'Left'} Hand'),
            ),
            const SizedBox(height: 12),
          ],
          if (provider.bothHandsComplete) ...[
            ElevatedButton(
              onPressed: () => provider.viewBothResults(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('View Both Hands Comparison'),
            ),
            const SizedBox(height: 12),
          ],
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Back to Home'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Both Results Comparison Screen
class _BothResultsView extends StatelessWidget {
  const _BothResultsView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MotorTestProvider>();
    final leftResult = provider.leftHandResult!;
    final rightResult = provider.rightHandResult!;

    final dominantHand = leftResult.tapsPerSecond > rightResult.tapsPerSecond 
        ? 'Left' 
        : 'Right';
    final ratio = (leftResult.tapsPerSecond / rightResult.tapsPerSecond * 100).toStringAsFixed(0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.compare_arrows,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Both Hands Comparison',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Comparison card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Dominant Hand',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 8),
                Text(
                  dominantHand,
                  style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  'L/R Ratio: $ratio%',
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Left hand
          _buildHandSummary('Left Hand', leftResult, Icons.pan_tool),
          const SizedBox(height: 16),
          // Right hand
          _buildHandSummary('Right Hand', rightResult, Icons.back_hand),
          const SizedBox(height: 32),
          // Action buttons
          ElevatedButton(
            onPressed: () => provider.reset(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Test Again'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Back to Home'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHandSummary(String title, MotorTestResult result, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 32),
                const SizedBox(width: 12),
                Text(title, style: AppTextStyles.h4),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat(
                  '${result.tapsPerSecond.toStringAsFixed(2)}',
                  'taps/sec',
                ),
                _buildMiniStat(
                  '${result.totalTaps}',
                  'total taps',
                ),
                _buildMiniStat(
                  '${result.consistency.toStringAsFixed(0)}',
                  'consistency',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
