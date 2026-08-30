import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Home screen — shown right after the splash screen.
/// Greets the user, offers a primary "Add a new note" action,
/// and three entry points: Lazy Mode, To-Do List, Ideas.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Builds a staggered fade + slide-up animation for element [index].
  /// Each element starts slightly after the previous one, giving the
  /// screen a smooth, cascading entrance instead of popping in at once.
  Widget _staggered({required int index, required Widget child}) {
    final start = (index * 0.12).clamp(0.0, 1.0);
    final end = (start + 0.5).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - animation.value) * 16),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  void _onAddNote() {
    // TODO: wire up navigation to the "new note" flow.
  }

  void _onCardTap(String label) {
    // TODO: wire up navigation for Lazy Mode / To-Do List / Ideas.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),

              // Greeting — Malayalam app name stays on the system font
              // (Moderustic has no Malayalam glyphs); the English part
              // uses Moderustic.
              _staggered(
                index: 0,
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.moderustic(
                      fontSize: 22,
                      color: Colors.black,
                      height: 1.3,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      const TextSpan(
                        text: 'കടലാസ്',
                        style: TextStyle(
                          fontFamily:
                              null, // system font, keeps Malayalam glyphs
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      TextSpan(
                        text: ' is yours.\nWhat do you wanna scribble today?',
                        style: GoogleFonts.moderustic(
                          fontSize: 22,
                          color: Colors.black,
                          height: 1.3,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Add a new note button
              _staggered(
                index: 1,
                child: Center(child: _AddNoteButton(onTap: _onAddNote)),
              ),

              const SizedBox(height: 20),

              // Top row: Lazy Mode + To-Do List
              _staggered(
                index: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.self_improvement,
                        title: 'Lazy Mode',
                        subtitle: 'Record simple voice journals, no stress.',
                        onTap: () => _onCardTap('Lazy Mode'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.checklist_rounded,
                        title: 'To-Do List',
                        subtitle: 'Catch up with your tasks. Never miss any!',
                        onTap: () => _onCardTap('To-Do List'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Ideas card, centered, half width
              _staggered(
                index: 3,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 28,
                    child: _FeatureCard(
                      icon: Icons.emoji_objects_outlined,
                      title: 'Ideas',
                      subtitle: 'New idea popped up? Drop it here!',
                      onTap: () => _onCardTap('Ideas'),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Bottom hint text
              _staggered(
                index: 4,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Wondering why kadalaas looks dead?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.moderustic(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Get those things done first gang!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.moderustic(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Black pill-shaped "+ Add a new note" button with a gentle
/// press-down scale animation for tactile feedback.
class _AddNoteButton extends StatefulWidget {
  const _AddNoteButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_AddNoteButton> createState() => _AddNoteButtonState();
}

class _AddNoteButtonState extends State<_AddNoteButton> {
  double _scale = 1.0;

  void _setPressed(bool pressed) {
    setState(() => _scale = pressed ? 0.96 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'Add a new note',
                style: GoogleFonts.moderustic(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A rounded feature card (Lazy Mode / To-Do List / Ideas) with
/// icon, title, subtitle, and a subtle press animation + shadow.
class _FeatureCard extends StatefulWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  double _scale = 1.0;

  void _setPressed(bool pressed) {
    setState(() => _scale = pressed ? 0.97 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.icon, size: 22, color: Colors.black),
              const SizedBox(height: 14),
              Text(
                widget.title,
                style: GoogleFonts.moderustic(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.subtitle,
                style: GoogleFonts.moderustic(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
