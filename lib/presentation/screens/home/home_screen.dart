import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/routes/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroTrace AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(AppRouter.profile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back!', style: AppTextStyles.headline2),
                    const SizedBox(height: 8),
                    Text(
                      'Complete tests to assess your neurological health',
                      style: AppTextStyles.body2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Test Categories
            Text('Available Tests', style: AppTextStyles.headline3),
            const SizedBox(height: 16),
            
            _TestCard(
              title: 'Reaction Time Test',
              description: 'Measure your response speed',
              icon: Icons.flash_on,
              color: AppColors.reactionTime,
              onTap: () => context.push(AppRouter.reactionTime),
            ),
            const SizedBox(height: 12),
            
            _TestCard(
              title: 'Cognitive Test',
              description: 'Assess memory and mental processing',
              icon: Icons.psychology,
              color: AppColors.cognitive,
              onTap: () => context.push(AppRouter.cognitive),
            ),
            const SizedBox(height: 12),
            
            _TestCard(
              title: 'Motor Control Test',
              description: 'Evaluate coordination and precision',
              icon: Icons.touch_app,
              color: AppColors.motor,
              onTap: () => context.push(AppRouter.motor),
            ),
            const SizedBox(height: 12),
            
            _TestCard(
              title: 'Speech Analysis',
              description: 'Voice pattern assessment',
              icon: Icons.mic,
              color: AppColors.speech,
              onTap: () => context.push(AppRouter.speech),
            ),
            const SizedBox(height: 24),
            
            // Survey & Results
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(AppRouter.survey),
                icon: const Icon(Icons.assignment),
                label: const Text('Microplastic Exposure Survey'),
              ),
            ),
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRouter.results),
                icon: const Icon(Icons.analytics),
                label: const Text('View Results'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TestCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.subtitle1),
                    const SizedBox(height: 4),
                    Text(description, style: AppTextStyles.body2),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: AppColors.textTertiary, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
