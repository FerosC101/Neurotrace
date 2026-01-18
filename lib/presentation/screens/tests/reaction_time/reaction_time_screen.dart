import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../providers/reaction_time_provider.dart';

class ReactionTimeScreen extends StatelessWidget {
  const ReactionTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReactionTimeProvider(),
      child: const _ReactionTimeScreenContent(),
    );
  }
}

class _ReactionTimeScreenContent extends StatelessWidget {
  const _ReactionTimeScreenContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReactionTimeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reaction Time Test'),
        actions: [
          if (provider.state != ReactionTestState.instructions &&
              provider.state != ReactionTestState.completed)
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

  Widget _buildBody(BuildContext context, ReactionTimeProvider provider) {
    switch (provider.state) {
      case ReactionTestState.instructions:
        return const _InstructionsView();
      case ReactionTestState.ready:
        return const _ReadyView();
      case ReactionTestState.waiting:
      case ReactionTestState.tap:
      case ReactionTestState.result:
        return const _TestView();
      case ReactionTestState.completed:
        return const _ResultsView();
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
            Icons.touch_app,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'How It Works',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildInstructionStep(
            1,
            'Wait for the screen to turn green',
            'The screen will be red. Wait patiently for it to change.',
          ),
          const SizedBox(height: 16),
          _buildInstructionStep(
            2,
            'Tap as quickly as possible',
            'When you see green, tap anywhere on the screen immediately.',
          ),
          const SizedBox(height: 16),
          _buildInstructionStep(
            3,
            'Complete 5 rounds',
            'Your reaction time will be measured in milliseconds.',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Don\'t tap too early! False starts will be counted.',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              context.read<ReactionTimeProvider>().startTest();
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

// Ready Screen
class _ReadyView extends StatelessWidget {
  const _ReadyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Get Ready!',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 24),
          Text(
            'Tap the button below to begin',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<ReactionTimeProvider>().beginRound();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            ),
            child: const Text('Begin'),
          ),
        ],
      ),
    );
  }
}

// Test Screen
class _TestView extends StatelessWidget {
  const _TestView();

  Color _getBackgroundColor(ReactionTestState state) {
    switch (state) {
      case ReactionTestState.waiting:
        return Colors.red.shade400;
      case ReactionTestState.tap:
        return Colors.green.shade400;
      case ReactionTestState.result:
        return Colors.blue.shade400;
      default:
        return Colors.grey;
    }
  }

  String _getMessage(BuildContext context, ReactionTimeProvider provider) {
    switch (provider.state) {
      case ReactionTestState.waiting:
        return 'Wait for green...';
      case ReactionTestState.tap:
        return 'TAP NOW!';
      case ReactionTestState.result:
        if (provider.reactionTimes.isEmpty) {
          return 'False Start!\nYou tapped too early';
        }
        return '${provider.reactionTimes.last} ms';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReactionTimeProvider>();
    
    return GestureDetector(
      onTap: () => provider.onTap(),
      child: Container(
        color: _getBackgroundColor(provider.state),
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: provider.progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            // Round counter
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Round ${provider.currentRound + 1} of ${provider.totalRounds}',
                style: AppTextStyles.h4.copyWith(color: Colors.white),
              ),
            ),
            // Main message
            Expanded(
              child: Center(
                child: Text(
                  _getMessage(context, provider),
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

// Results Screen
class _ResultsView extends StatelessWidget {
  const _ResultsView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReactionTimeProvider>();
    final result = provider.finalResult;

    if (result == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.emoji_events,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Test Complete!',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Here are your results',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Average time - main metric
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
                  'Average Reaction Time',
                  style: AppTextStyles.h4.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  '${result.averageTime.toStringAsFixed(0)} ms',
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Other statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Fastest',
                  '${result.fastestTime} ms',
                  Icons.flash_on,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Slowest',
                  '${result.slowestTime} ms',
                  Icons.timer,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Consistency',
                  '±${result.standardDeviation.toStringAsFixed(0)} ms',
                  Icons.show_chart,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'False Starts',
                  '${result.falseStarts}',
                  Icons.warning,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // All attempts
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('All Attempts', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  ...result.reactionTimes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final time = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: min(time / result.slowestTime, 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '$time ms',
                                      style: AppTextStyles.body2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Action buttons
          ElevatedButton(
            onPressed: () {
              provider.reset();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Take Test Again'),
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
