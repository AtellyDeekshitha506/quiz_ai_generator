// home_screen.dart - Enhanced Version
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_ai/models/user_model.dart';
import 'package:quiz_ai/providers/app_provider.dart';
import 'package:quiz_ai/screens/ai_generator_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  bool _isFabExpanded = false;
  int _unreadNotifications = 3; // Mock data

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
      if (_isFabExpanded) {
        _fabController.forward();
      } else {
        _fabController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context).currentUser;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          Positioned.fill(
            child: AnimatedGradientBackground(),
          ),

          // Main Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 0,
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Quiz AI',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  actions: [
                    // Animated Notification Bell
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {
                            setState(() => _unreadNotifications = 0);
                          },
                        ),
                        if (_unreadNotifications > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: AnimatedNotificationBadge(
                              count: _unreadNotifications,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Card with Gradient & Animation
                        _buildWelcomeCard(context, user),
                        const SizedBox(height: 24),

                        // Progress Tracker
                        _buildProgressTracker(context),
                        const SizedBox(height: 24),

                        // Today's Stats Dashboard
                        _buildTodayStats(context),
                        const SizedBox(height: 24),

                        // Daily Challenge Card
                        _buildDailyChallenge(context),
                        const SizedBox(height: 24),

                        // AI Tools Section
                        Text(
                          'AI Quiz Tools',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        _buildAIToolsSection(context),
                        const SizedBox(height: 24),

                        // Popular Topics
                        _buildPopularTopics(context),
                        const SizedBox(height: 24),

                        // Recent Quizzes
                        Text(
                          'Recent Quizzes',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        _buildRecentQuizzes(context),
                        const SizedBox(height: 24),

                        // Quick Actions
                        Text(
                          'Quick Actions',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        _buildQuickActions(context),
                        const SizedBox(height: 100), // Space for FAB
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Animated FAB
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildAnimatedFab(context),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, User? user) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Animated Avatar
                    Hero(
                      tag: 'user_avatar',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Text(
                            user?.name[0] ?? 'U',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            user?.name ?? 'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user?.role == UserRole.teacher
                                  ? '👨‍🏫 Teacher'
                                  : '👨‍🎓 Student',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '🚀 Ready to challenge your mind?',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressTracker(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level 3 Learner',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '60% to Level 4',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 0.6),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              builder: (context, value, _) {
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: value,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(value * 100).toInt()}% Complete',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '480 / 800 XP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Stats",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.quiz,
                label: 'Quizzes',
                value: '12',
                color: Colors.purple,
                delay: 0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.star,
                label: 'Avg Score',
                value: '78%',
                color: Colors.amber,
                delay: 100,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department,
                label: 'Streak',
                value: '4 Days',
                color: Colors.orange,
                delay: 200,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyChallenge(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade400, Colors.purple.shade600],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🎯 Daily Challenge',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Solve 5 random questions to earn 50 XP!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAIToolsSection(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _EnhancedAIToolCard(
            icon: Icons.auto_awesome,
            title: 'Generate Quiz',
            subtitle: 'Turn your notes into smart questions',
            gradient: [Colors.purple.shade400, Colors.purple.shade600],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AIQuizGeneratorScreen(),
                ),
              );
            },
          ),
          _EnhancedAIToolCard(
            icon: Icons.compare_arrows,
            title: 'Compare Tools',
            subtitle: 'OpenAI vs Gemini performance',
            gradient: [Colors.blue.shade400, Colors.blue.shade600],
            onTap: () {},
          ),
          _EnhancedAIToolCard(
            icon: Icons.bookmark_added,
            title: 'Saved Questions',
            subtitle: 'Your personal question vault',
            gradient: [Colors.orange.shade400, Colors.orange.shade600],
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPopularTopics(BuildContext context) {
    final topics = [
      '🤖 Artificial Intelligence',
      '🐍 Python Programming',
      '⚡ Electronics',
      '📡 Communication',
      '📊 Data Science',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Topics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(topics[index]),
                  onPressed: () {},
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  side: BorderSide.none,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentQuizzes(BuildContext context) {
    return Column(
      children: [
        _RecentQuizCard(
          title: 'Machine Learning Basics',
          score: 85,
          date: '2 hours ago',
          icon: Icons.computer,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _RecentQuizCard(
          title: 'Python Data Structures',
          score: 92,
          date: '1 day ago',
          icon: Icons.code,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _RecentQuizCard(
          title: 'Digital Electronics',
          score: 78,
          date: '3 days ago',
          icon: Icons.memory,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _AnimatedQuickActionCard(
          icon: Icons.file_upload,
          title: 'Import File',
          gradient: [Colors.teal.shade300, Colors.teal.shade500],
          onTap: () {},
          delay: 0,
        ),
        _AnimatedQuickActionCard(
          icon: Icons.link,
          title: 'From URL',
          gradient: [Colors.indigo.shade300, Colors.indigo.shade500],
          onTap: () {},
          delay: 100,
        ),
        _AnimatedQuickActionCard(
          icon: Icons.analytics,
          title: 'Analytics',
          gradient: [Colors.pink.shade300, Colors.pink.shade500],
          onTap: () {},
          delay: 200,
        ),
        _AnimatedQuickActionCard(
          icon: Icons.star,
          title: 'Favorites',
          gradient: [Colors.amber.shade300, Colors.amber.shade500],
          onTap: () {},
          delay: 300,
        ),
      ],
    );
  }

  Widget _buildAnimatedFab(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Sub FABs
        if (_isFabExpanded) ...[
          _SubFab(
            icon: Icons.edit_note,
            label: 'Create Quiz',
            onTap: () {
              _toggleFab();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AIQuizGeneratorScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _SubFab(
            icon: Icons.upload_file,
            label: 'Import Notes',
            onTap: () {
              _toggleFab();
            },
          ),
          const SizedBox(height: 12),
          _SubFab(
            icon: Icons.shuffle,
            label: 'Random Quiz',
            onTap: () {
              _toggleFab();
            },
          ),
          const SizedBox(height: 16),
        ],

        // Main FAB
        FloatingActionButton(
          onPressed: _toggleFab,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _fabController,
          ),
        ),
      ],
    );
  }
}

// ============================================
// ANIMATED WIDGETS
// ============================================

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({Key? key}) : super(key: key);

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(
                    0.1 + 0.1 * math.sin(_controller.value * math.pi)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedNotificationBadge extends StatefulWidget {
  final int count;

  const AnimatedNotificationBadge({Key? key, required this.count})
      : super(key: key);

  @override
  State<AnimatedNotificationBadge> createState() =>
      _AnimatedNotificationBadgeState();
}

class _AnimatedNotificationBadgeState extends State<AnimatedNotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (0.2 * _controller.value),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              widget.count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final int delay;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EnhancedAIToolCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _EnhancedAIToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_EnhancedAIToolCard> createState() => _EnhancedAIToolCardState();
}

class _EnhancedAIToolCardState extends State<_EnhancedAIToolCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) {
        setState(() => _isHovered = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.gradient.first.withOpacity(0.3),
              blurRadius: _isHovered ? 20 : 15,
              offset: Offset(0, _isHovered ? 12 : 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 32),
              ),
              const Spacer(),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentQuizCard extends StatelessWidget {
  final String title;
  final int score;
  final String date;
  final IconData icon;
  final Color color;

  const _RecentQuizCard({
    required this.title,
    required this.score,
    required this.date,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
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
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Score: $score%",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[400],
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ============================================
// SUB FAB WIDGET
// ============================================

class _SubFab extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SubFab({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            // Mini FAB icon
            FloatingActionButton.small(
              heroTag: label,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: onTap,
              child: Icon(icon, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
// ============================================
// ANIMATED QUICK ACTION CARD
// ============================================

class _AnimatedQuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Color> gradient;
  final VoidCallback onTap;
  final int delay;

  const _AnimatedQuickActionCard({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.last.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
