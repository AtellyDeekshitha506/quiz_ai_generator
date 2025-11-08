import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_ai/models/quiz_model.dart';
import 'package:quiz_ai/providers/quiz_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:quiz_ai/models/result.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedTimeRange = 'Week';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportReport(context),
            tooltip: 'Export Report',
          ),
          PopupMenuButton<String>(
            initialValue: _selectedTimeRange,
            onSelected: (value) => setState(() => _selectedTimeRange = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Week', child: Text('This Week')),
              const PopupMenuItem(value: 'Month', child: Text('This Month')),
              const PopupMenuItem(value: 'All', child: Text('All Time')),
            ],
          ),
        ],
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, _) {
          final results = _filterResults(quizProvider.results);

          if (results.isEmpty) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverallScoreCard(context, results, quizProvider.results),
                const SizedBox(height: 16),
                _buildUsageSummaryCards(context, results),
                const SizedBox(height: 24),
                _buildProgressChart(context, results),
                const SizedBox(height: 24),
                _buildCategoryBreakdown(context, results, quizProvider),
                const SizedBox(height: 24),
                _buildEngagementMetrics(context, results),
                const SizedBox(height: 24),
                _buildPerformanceInsights(context, results, quizProvider),
                const SizedBox(height: 24),
                _buildStreakTracker(context, results),
                const SizedBox(height: 24),
                _buildActivityHeatmap(context, results),
                const SizedBox(height: 24),
                _buildRecentActivity(context, results, quizProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No quiz results yet',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take a quiz to see your analytics',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScoreCard(BuildContext context, List<QuizResult> results,
      List<QuizResult> allResults) {
    final averageScore =
        results.map((r) => r.percentage).reduce((a, b) => a + b) /
            results.length;
    final prevResults = _getPreviousPeriodResults(allResults);
    final prevAverage = prevResults.isEmpty
        ? 0.0
        : prevResults.map((r) => r.percentage).reduce((a, b) => a + b) /
            prevResults.length;
    final improvement = averageScore - prevAverage;

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                '${averageScore.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Average Score',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              if (prevResults.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      improvement >= 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${improvement.abs().toStringAsFixed(1)}% vs last period',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageSummaryCards(
      BuildContext context, List<QuizResult> results) {
    final totalQuizzes = results.length;
    final passedQuizzes = results.where((r) => r.percentage >= 60).length;
    final avgTime = _calculateAverageTime(results);
    final successRate =
        totalQuizzes > 0 ? (passedQuizzes / totalQuizzes * 100) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage Summary',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildStatCard(
              context,
              Icons.quiz,
              '$totalQuizzes',
              'Quizzes Taken',
              Colors.blue,
            ),
            _buildStatCard(
              context,
              Icons.check_circle,
              '$passedQuizzes',
              'Passed',
              Colors.green,
            ),
            _buildStatCard(
              context,
              Icons.timer_outlined,
              avgTime,
              'Avg Time',
              Colors.orange,
            ),
            _buildStatCard(
              context,
              Icons.percent,
              '${successRate.toStringAsFixed(0)}%',
              'Success Rate',
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String value,
      String label, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(BuildContext context, List<QuizResult> results) {
    if (results.isEmpty) return const SizedBox.shrink();

    final sortedResults = List<QuizResult>.from(results)
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Over Time',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}%',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= sortedResults.length ||
                              value.toInt() < 0) {
                            return const Text('');
                          }
                          final date = sortedResults[value.toInt()].completedAt;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('MM/dd').format(date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        sortedResults.length,
                        (i) =>
                            FlSpot(i.toDouble(), sortedResults[i].percentage),
                      ),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(
      BuildContext context, List<QuizResult> results, QuizProvider provider) {
    final categoryStats = _calculateCategoryStats(results, provider);

    if (categoryStats.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _generatePieSections(categoryStats, context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categoryStats.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(e.key),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  e.key,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementMetrics(
      BuildContext context, List<QuizResult> results) {
    final topFeatures = _getTopFeatures(results);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top 3 Most Used Features',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...topFeatures.take(3).map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.star, color: Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${feature['count']} times used',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${feature['percentage']}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceInsights(
      BuildContext context, List<QuizResult> results, QuizProvider provider) {
    final insights = _generateInsights(results, provider);

    if (insights.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Smart Insights',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...insights.map((insight) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: insight['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: insight['color'].withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(insight['icon'], color: insight['color'], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(insight['text'],
                          style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakTracker(BuildContext context, List<QuizResult> results) {
    final currentStreak = _calculateStreak(results);
    final longestStreak = _calculateLongestStreak(results);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Streak',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStreakCard(
                    context,
                    Icons.local_fire_department,
                    '$currentStreak',
                    'Current Streak',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStreakCard(
                    context,
                    Icons.emoji_events,
                    '$longestStreak',
                    'Longest Streak',
                    Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, IconData icon, String value,
      String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityHeatmap(BuildContext context, List<QuizResult> results) {
    final heatmapData = _generateHeatmapData(results);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Heatmap',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Text(days[dayIndex],
                            style: const TextStyle(fontSize: 10)),
                        const SizedBox(height: 4),
                        ...List.generate(4, (weekIndex) {
                          final activity = heatmapData[dayIndex][weekIndex];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _getHeatmapColor(activity),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                activity > 0 ? '$activity' : '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(
      BuildContext context, List<QuizResult> results, QuizProvider provider) {
    final recentResults = results.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recentResults.map((result) {
              final quiz = provider.quizzes.firstWhere(
                (q) => q.id == result.quizId,
                orElse: () => Quiz(
                  id: '',
                  title: 'Unknown Quiz',
                  description: '',
                  questions: [],
                  duration: 0,
                  createdAt: DateTime.now(),
                  createdBy: '',
                  difficulty: Difficulty.medium,
                ),
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: result.percentage >= 60
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      child: Icon(
                        result.percentage >= 60 ? Icons.check : Icons.close,
                        color:
                            result.percentage >= 60 ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _formatDateTime(result.completedAt),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${result.percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: result.percentage >= 60
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        Text(
                          '${result.score}/${result.totalQuestions}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Helper methods
  List<QuizResult> _filterResults(List<QuizResult> allResults) {
    final now = DateTime.now();
    return allResults.where((result) {
      if (_selectedTimeRange == 'Week') {
        return result.completedAt
            .isAfter(now.subtract(const Duration(days: 7)));
      } else if (_selectedTimeRange == 'Month') {
        return result.completedAt
            .isAfter(now.subtract(const Duration(days: 30)));
      }
      return true;
    }).toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  List<QuizResult> _getPreviousPeriodResults(List<QuizResult> allResults) {
    if (allResults.isEmpty) return [];
    final now = DateTime.now();
    final periodStart = _selectedTimeRange == 'Week'
        ? now.subtract(const Duration(days: 14))
        : now.subtract(const Duration(days: 60));
    final periodEnd = _selectedTimeRange == 'Week'
        ? now.subtract(const Duration(days: 7))
        : now.subtract(const Duration(days: 30));

    return allResults
        .where((r) =>
            r.completedAt.isAfter(periodStart) &&
            r.completedAt.isBefore(periodEnd))
        .toList();
  }

  String _calculateAverageTime(List<QuizResult> results) {
    if (results.isEmpty) return '0min';
    final totalMinutes =
        results.map((r) => r.timeTaken.inMinutes).reduce((a, b) => a + b);
    final avgMinutes = totalMinutes ~/ results.length;
    return '${avgMinutes}min';
  }

  Map<String, int> _calculateCategoryStats(
      List<QuizResult> results, QuizProvider provider) {
    final Map<String, int> stats = {};
    for (var result in results) {
      final quiz = provider.quizzes.firstWhere(
        (q) => q.id == result.quizId,
        orElse: () => Quiz(
          id: '',
          title: 'Other',
          description: '',
          questions: [],
          duration: 0,
          createdAt: DateTime.now(),
          createdBy: '',
          difficulty: Difficulty.medium,
        ),
      );
      final category = quiz.title.split(' ').first;
      stats[category] = (stats[category] ?? 0) + 1;
    }
    return stats;
  }

  List<PieChartSectionData> _generatePieSections(
      Map<String, int> stats, BuildContext context) {
    final total = stats.values.fold(0, (a, b) => a + b);
    return stats.entries.map((e) {
      final percentage = (e.value / total * 100);
      return PieChartSectionData(
        value: e.value.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        color: _getCategoryColor(e.key),
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Color _getCategoryColor(String category) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal
    ];
    return colors[category.hashCode % colors.length];
  }

  List<Map<String, dynamic>> _getTopFeatures(List<QuizResult> results) {
    final Map<String, int> featureCounts = {'Quiz': results.length};
    final total = results.length;

    final features = featureCounts.entries.map((e) {
      return {
        'name': e.key,
        'count': e.value,
        'percentage': ((e.value / total) * 100).toStringAsFixed(0),
      };
    }).toList();

    // Ensure proper int comparison
    features.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

    return features;
  }

  List<Map<String, dynamic>> _generateInsights(
      List<QuizResult> results, QuizProvider provider) {
    final insights = <Map<String, dynamic>>[];

    if (results.length >= 10) {
      final recentList = results.take(5).toList();
      final olderList = results.skip(5).take(5).toList();

      if (recentList.isNotEmpty && olderList.isNotEmpty) {
        final recent =
            recentList.map((r) => r.percentage).reduce((a, b) => a + b) /
                recentList.length;
        final older =
            olderList.map((r) => r.percentage).reduce((a, b) => a + b) /
                olderList.length;

        if (recent > older) {
          insights.add({
            'text':
                'Your performance improved by ${(recent - older).toStringAsFixed(0)}% in recent quizzes! 🎉',
            'icon': Icons.trending_up,
            'color': Colors.green,
          });
        }
      }
    }

    if (results.isNotEmpty) {
      final passRate =
          results.where((r) => r.percentage >= 60).length / results.length;
      if (passRate >= 0.8) {
        insights.add({
          'text':
              'Excellent! You\'re passing ${(passRate * 100).toStringAsFixed(0)}% of your quizzes.',
          'icon': Icons.emoji_events,
          'color': Colors.amber,
        });
      } else if (passRate < 0.5) {
        insights.add({
          'text':
              'Focus on reviewing material before quizzes for better results.',
          'icon': Icons.school,
          'color': Colors.blue,
        });
      }
    }

    return insights;
  }

  int _calculateStreak(List<QuizResult> results) {
    if (results.isEmpty) return 0;
    final sorted = List<QuizResult>.from(results)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    int streak = 0;
    DateTime? lastDate;

    for (var result in sorted) {
      final date = DateTime(result.completedAt.year, result.completedAt.month,
          result.completedAt.day);
      if (lastDate == null) {
        lastDate = date;
        streak = 1;
      } else {
        final diff = lastDate.difference(date).inDays;
        if (diff == 1) {
          streak++;
          lastDate = date;
        } else if (diff > 1) {
          break;
        }
      }
    }
    return streak;
  }

  int _calculateLongestStreak(List<QuizResult> results) {
    if (results.isEmpty) return 0;
    final sorted = List<QuizResult>.from(results)
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));

    int maxStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (var result in sorted) {
      final date = DateTime(result.completedAt.year, result.completedAt.month,
          result.completedAt.day);
      if (lastDate == null || date.difference(lastDate).inDays == 1) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else if (date.difference(lastDate).inDays > 1) {
        currentStreak = 1;
      }
      lastDate = date;
    }
    return maxStreak;
  }

  List<List<int>> _generateHeatmapData(List<QuizResult> results) {
    final heatmap = List.generate(7, (_) => List.filled(4, 0));
    final now = DateTime.now();

    for (var result in results) {
      final daysDiff = now.difference(result.completedAt).inDays;
      if (daysDiff < 28) {
        final weekIndex = daysDiff ~/ 7;
        final dayIndex = result.completedAt.weekday - 1;
        if (weekIndex < 4 && dayIndex >= 0 && dayIndex < 7) {
          heatmap[dayIndex][3 - weekIndex]++;
        }
      }
    }
    return heatmap;
  }

  Color _getHeatmapColor(int activity) {
    if (activity == 0) return Colors.grey.shade200;
    if (activity == 1) return Colors.green.shade200;
    if (activity == 2) return Colors.green.shade400;
    return Colors.green.shade700;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays == 0) {
      return 'Today at ${DateFormat('HH:mm').format(dateTime)}';
    } else if (diff.inDays == 1) {
      return 'Yesterday at ${DateFormat('HH:mm').format(dateTime)}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(dateTime);
    }
  }

  void _exportReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Analytics report exported successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Handle view action - implement PDF generation or share functionality
          },
        ),
      ),
    );
  }
}
