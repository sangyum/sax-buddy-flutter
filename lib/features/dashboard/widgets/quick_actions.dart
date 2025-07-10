import 'package:flutter/material.dart';
import 'action_card.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                ActionCard(
                  icon: Icons.music_note,
                  title: 'Start Practice',
                  subtitle: 'Begin assessment',
                  onTap: () {},
                ),
                ActionCard(
                  icon: Icons.history,
                  title: 'View History',
                  subtitle: 'Past sessions',
                  onTap: () {},
                ),
                ActionCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'App preferences',
                  onTap: () {},
                ),
                ActionCard(
                  icon: Icons.help,
                  title: 'Help',
                  subtitle: 'Support & FAQ',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}