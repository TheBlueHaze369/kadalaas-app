import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/feature_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Widget _reveal({required int index, required Widget child}) {
    final start = (index * 0.10).clamp(0.0, 0.55);
    final end = (start + 0.42).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 22),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  void _onAddNote() {
    // TODO: new note flow
  }

  void _onCardTap(String label) {
    // TODO: Lazy Mode / To-Do List / Ideas
  }

  @override
  Widget build(BuildContext context) {
    final englishHeadline = GoogleFonts.moderustic(
      fontSize: 26,
      height: 1.28,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
    final malayalamHeadline = GoogleFonts.notoSansMalayalam(
      fontSize: 26,
      height: 1.28,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
    final muted = GoogleFonts.moderustic(
      fontSize: 13,
      color: const Color(0xFFBDBDBD),
      height: 1.35,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 48 - 16) / 2;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _reveal(
                      index: 0,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'കടലാസ്', style: malayalamHeadline),
                            TextSpan(
                              text: ' is yours.\nWhat do you wanna scribble today?',
                              style: englishHeadline,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _reveal(
                      index: 1,
                      child: Center(
                        child: _AddNoteButton(onTap: _onAddNote),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _reveal(
                      index: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _FeatureCard(
                              icon: const SittingPersonIcon(size: 30),
                              title: 'Lazy Mode',
                              subtitle: 'Record simple voice journals, no stress.',
                              onTap: () => _onCardTap('Lazy Mode'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _FeatureCard(
                              icon: const ChecklistIcon(size: 30),
                              title: 'To-Do List',
                              subtitle: 'Catch up with your tasks. Never miss any!',
                              onTap: () => _onCardTap('To-Do List'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _reveal(
                      index: 3,
                      child: Center(
                        child: SizedBox(
                          width: cardWidth,
                          child: _FeatureCard(
                            icon: const IdeaHeadIcon(size: 30),
                            title: 'Ideas',
                            subtitle: 'New idea popped up? Drop it here!',
                            onTap: () => _onCardTap('Ideas'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    _reveal(
                      index: 4,
                      child: Center(
                        child: Text(
                          'Wondering why kadalaas looks dead?\nGet those things done first gang!',
                          textAlign: TextAlign.center,
                          style: muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AddNoteButton extends StatefulWidget {
  const _AddNoteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_AddNoteButton> createState() => _AddNoteButtonState();
}

class _AddNoteButtonState extends State<_AddNoteButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _pressed ? 0.04 : 0.12),
                blurRadius: _pressed ? 6 : 16,
                offset: Offset(0, _pressed ? 2 : 8),
              ),
            ],
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

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _pressed ? 0.05 : 0.08),
                blurRadius: _pressed ? 10 : 22,
                offset: Offset(0, _pressed ? 4 : 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.icon,
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: GoogleFonts.moderustic(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.subtitle,
                style: GoogleFonts.moderustic(
                  fontSize: 12,
                  height: 1.35,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
