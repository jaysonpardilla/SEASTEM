// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../widgets/bottom_nav.dart';
import 'explore_screen.dart';
import 'quiz_screen.dart';
import 'scan_screen.dart';
import 'shell_detail_screen.dart';
import 'advisory_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedExploreFilter = 'All';

  void _openExploreWithCategory(String category) {
    final normalized = category.trim();
    final mapped =
        {
          'Gastropods': 'Gastropod',
          'Bivalves': 'Bivalve',
          'Cephalopods': 'Cephalopod',
          'Scaphopods': 'Scaphopod',
          'Polyplacophora': 'Polyplacophora',
        }[normalized] ??
        normalized;

    setState(() {
      _selectedExploreFilter = mapped;
      _currentIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    const pageBg = Color(0xFFFAF8F2);

    final pages = [
      HomeContent(
        onCategoryTap: _openExploreWithCategory,
        onSeeAll: () => setState(() => _currentIndex = 3),
        onScanTap: () => setState(() => _currentIndex = 2),
        onQuizTap: () => setState(() => _currentIndex = 1),
      ),
      QuizScreen(
        onBackPressed: () {
          setState(() => _currentIndex = 0);
        },
      ),
      ScanScreen(
        onBackPressed: () {
          setState(() => _currentIndex = 0);
        },
      ),
      ExploreScreen(initialFilter: _selectedExploreFilter),
      AdvisoryScreen(
        onBackPressed: () {
          setState(() => _currentIndex = 0);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: pageBg,
      body: pages[_currentIndex],
      bottomNavigationBar:
          _currentIndex != 2
              ? BottomNav(
                currentIndex: _currentIndex,
                onTap: (i) {
                  setState(() => _currentIndex = i);
                },
              )
              : null,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.onCategoryTap,
    required this.onSeeAll,
    required this.onScanTap,
    required this.onQuizTap,
  });

  final void Function(String category) onCategoryTap;
  final VoidCallback onSeeAll;
  final VoidCallback onScanTap;
  final VoidCallback onQuizTap;

  @override
  Widget build(BuildContext context) {
    const primaryText = Color(0xFF1F2933);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        child: RefreshIndicator(
              onRefresh: () async {
                // Just a visual indicator, no functionality
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Hi, Explorer',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: primaryText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'What seashell will you discover today?',
                      style: TextStyle(fontSize: 15, color: const Color.fromARGB(208, 22, 62, 92)),
                    ),
                    const SizedBox(height: 22),
                  
                    // Categories row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: primaryText,
                          ),
                        ),
                        GestureDetector(
                          onTap: onSeeAll,
                          child: const Text(
                            'See All',
                            style: TextStyle(color: Color(0xFF0B2D4D), fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 86,
                      child: _AutoScrollCategories(
                        items: const [
                          {
                            'label': 'Gastropods',
                            'url':
                                'lib/assets/images/categories/gastropods.png',
                          },
                          {
                            'label': 'Bivalves',
                            'url': 'lib/assets/images/categories/Bivalves.png',
                          },
                          {
                            'label': 'Polyplacophora',
                            'url':
                                'lib/assets/images/categories/Polyplacophora.png',
                          },
                        ],
                        onCategoryTap: onCategoryTap,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: onScanTap,
                            child: Container(
                              height: 96,
                              decoration: BoxDecoration(
                                      color: const Color(0xFFF5EEDC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8D8B8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                      color: Color(0xFF0B2D4D),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Scan Shell',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            color: const Color(0xFF0B2D4D),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          'Tap to scan and identify seashells',
                                          style: TextStyle(
                                            color: const Color.fromARGB(204, 22, 62, 92),
                                            fontSize: 15,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Explore shells header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Explore shells',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: const Color(0xFF0B2D4D),
                          ),
                        ),
                        GestureDetector(
                          onTap: onSeeAll,
                          child: const Text(
                            'See All',
                            style: TextStyle(color: Color(0xFF0B2D4D), fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Explore grid (limited to a few items)
                    RandomShellsGrid(),

                    const SizedBox(height: 12),

                    // Quiz action
                    GestureDetector(
                      onTap: onQuizTap,
                      child: Container(
                        height: 96,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EEDC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8D8B8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.quiz, 
                                size: 30,
                                color: Color(0xFF0B2D4D),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Quiz Time',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17, 
                                      color: Color(0xFF0B2D4D),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Test your knowledge about seashells',
                                    style: TextStyle(
                                      color: Color.fromARGB(208, 22, 62, 92),
                                      fontSize: 15,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel({required this.images});

  final List<String> images;

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _controller = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_controller.hasClients) return;
      final nextPage = (_currentPage + 1) % widget.images.length;
      _currentPage = nextPage;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.images;

    return PageView.builder(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      padEnds: false,
      pageSnapping: true,
      onPageChanged: (index) => _currentPage = index,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final imagePath = items[index % items.length];
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image:
                  imagePath.startsWith('http')
                      ? NetworkImage(imagePath)
                      : AssetImage(imagePath) as ImageProvider,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.75,
            ),
          ),
        );
      },
    );
  }
}

class _AutoScrollCategories extends StatefulWidget {
  const _AutoScrollCategories({required this.items, this.onCategoryTap});

  final List<Map<String, String>> items;
  final void Function(String category)? onCategoryTap;

  @override
  State<_AutoScrollCategories> createState() => _AutoScrollCategoriesState();
}

class _AutoScrollCategoriesState extends State<_AutoScrollCategories> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  double? _loopStart;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  void _startAutoScroll() {
    _timer?.cancel();
    // Wait for layout, then initialize at the middle and scroll left->right (decrement offset)
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      if (!_scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 200), _startAutoScroll);
        return;
      }

      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll <= 0) {
        Future.delayed(const Duration(milliseconds: 300), _startAutoScroll);
        return;
      }

      if (!_initialized) {
        // Start in the middle so the duplicated list can loop smoothly.
        final half = maxScroll / 2;
        _loopStart = half;
        _scrollController.jumpTo(half.clamp(0.0, maxScroll));
        _initialized = true;
      }

      final loopStart = _loopStart ?? maxScroll / 2;

      _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
        if (!mounted || !_scrollController.hasClients) return;
        final max = _scrollController.position.maxScrollExtent;
        if (max <= 0) return;

        final next = _scrollController.offset - 0.6;
        if (next <= 0) {
          // wrap: move forward by half to continue seamlessly
          final resetTo = next + loopStart;
          _scrollController.jumpTo(resetTo.clamp(0.0, max));
        } else {
          _scrollController.jumpTo(next);
        }
      });
    });
  }

  void _pauseAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }

  void _resumeAutoScroll() {
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = List<Map<String, String>>.from(widget.items)
      ..addAll(widget.items);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification &&
            notification.dragDetails != null) {
          _pauseAutoScroll();
        } else if (notification is ScrollUpdateNotification &&
            notification.dragDetails != null) {
          _pauseAutoScroll();
        } else if (notification is UserScrollNotification &&
            notification.direction == ScrollDirection.idle) {
          _resumeAutoScroll();
        }
        return false;
      },
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.start,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          final label = item['label'] ?? 'All';

          return GestureDetector(
            onTap: () => widget.onCategoryTap?.call(label),
            child: Container(
              width: 92,
              decoration: BoxDecoration(
                color: const Color.fromARGB(132, 245, 238, 220),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromARGB(201, 232, 216, 184)),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image:
                            (item['url'] ?? '').startsWith('http')
                                ? NetworkImage(item['url']!) as ImageProvider
                                : AssetImage(item['url'] ?? '')
                                    as ImageProvider,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RandomShellsGrid extends StatefulWidget {
  const RandomShellsGrid({super.key});

  @override
  State<RandomShellsGrid> createState() => _RandomShellsGridState();
}

class _RandomShellsGridState extends State<RandomShellsGrid> {
  late Future<List<Map<String, dynamic>>> _randomShellsFuture;

  @override
  void initState() {
    super.initState();
    _randomShellsFuture = _loadRandomShells();
  }

  Future<List<Map<String, dynamic>>> _loadRandomShells() async {
    try {
      final jsonString = await rootBundle.loadString(
        'lib/assets/images/shell-json.json',
      );
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) return [];

      final shells =
          decoded
              .whereType<Map>()
              .map((shell) => Map<String, dynamic>.from(shell))
              .where((shell) => shell['basic_identification'] is Map)
              .where((shell) {
                final classification =
                    shell['basic_identification']['classification']?.toString();
                return classification != 'Cephalopod' &&
                    classification != 'Scaphopod';
              })
              .toList();

      // Shuffle and get first 9 shells
      shells.shuffle();
      return shells.take(9).toList();
    } catch (e) {
      debugPrint('Error loading shells: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _randomShellsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('Error loading shells')),
          );
        }

        final shells = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            mainAxisExtent: 140,
          ),
          itemCount: shells.length,
          itemBuilder: (context, index) {
            final shell = shells[index];
            final identification = shell['basic_identification'];
            final commonName =
                identification is Map
                    ? identification['common_name']?.toString() ?? 'Unknown'
                    : 'Unknown';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShellDetailScreen(shell: shell),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(130, 245, 238, 220),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color.fromARGB(138, 11, 45, 77)),
                ),
                padding: const EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            shell['image_path'] ?? 'lib/assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'lib/assets/images/logo.png',
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Text(
                      commonName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
