import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'shell_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, this.initialFilter = 'All'});

  final String initialFilter;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filters = ['All'];
  String _selectedFilter = 'All';
  bool _isLoading = true;

  final List<Map<String, dynamic>> _shells = [];
  List<Map<String, dynamic>> _filteredShells = [];

  @override
  void initState() {
    super.initState();
    _selectedFilter = _normalizeFilter(widget.initialFilter);
    _searchController.addListener(_updateShellFilter);
    _loadShellData();
  }

  String _resolveAssetPath(String imagePath) {
    final value = imagePath.trim();
    if (value.isEmpty) return 'lib/assets/images/logo.png';
    if (value.startsWith('lib/assets/images/shells/')) return value;
    final fileName = value.split('/').last;
    return 'lib/assets/images/shells/$fileName';
  }

  Future<void> _loadShellData() async {
    try {
      final rawData = await rootBundle.loadString(
        'lib/assets/images/shell-json.json',
      );
      final decoded = jsonDecode(rawData) as List<dynamic>;

      final excludedCategories = {'Cephalopod', 'Scaphopod'};
      final shells = <Map<String, dynamic>>[];

      for (final entry in decoded) {
        final item = entry as Map<String, dynamic>;
        final basic = item['basic_identification'] as Map<String, dynamic>? ?? {};
        final commonName = (basic['common_name'] ?? 'Unknown shell').toString();
        final imagePath = _resolveAssetPath((item['image_path'] ?? '').toString());
        final classification =
            (basic['classification'] ?? 'Unknown').toString().trim();

        if (excludedCategories.contains(classification)) {
          continue;
        }

        shells.add({
          'name': commonName,
          'image': imagePath,
          'category': classification,
          'data': item,
        });
      }

      final uniqueCategories =
          shells.map((shell) => shell['category'] ?? 'Unknown').toSet().toList()
            ..sort();

      if (!mounted) return;

      setState(() {
        _shells.clear();
        _shells.addAll(shells);
        _filters = [
          'All',
          ...uniqueCategories,
          if (!uniqueCategories.contains('Polyplacophora')) 'Polyplacophora',
        ];
        if (!_filters.contains(_selectedFilter)) {
          _selectedFilter = 'All';
        }
        _isLoading = false;
      });
      _updateShellFilter();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _normalizeFilter(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'all') return 'All';

    final map = {
      'bivalves': 'Bivalve',
      'bivalve': 'Bivalve',
      'gastropods': 'Gastropod',
      'gastropod': 'Gastropod',
      'polyplacophoras': 'Polyplacophora',
      'polyplacophora': 'Polyplacophora',
    };

    return map[normalized.toLowerCase()] ?? normalized;
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateShellFilter);
    _searchController.dispose();
    super.dispose();
  }

  void _updateShellFilter() {
    final query = _searchController.text.toLowerCase();
    final selected = _normalizeFilter(_selectedFilter);

    setState(() {
      _filteredShells =
          _shells.where((shell) {
            final name = (shell['name'] ?? '').toString().toLowerCase();
            final matchesSearch = name.contains(query);
            final matchesFilter =
                selected == 'All' || (shell['category'] ?? '') == selected;
            return matchesSearch && matchesFilter;
          }).toList();
    });
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = _normalizeFilter(filter);
      _updateShellFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF8F2),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Explore Seashells',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0B2D4D),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search seashells',
                      hintStyle: const TextStyle(color: Color(0xFF163E5C)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF0B2D4D),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5EEDC),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        _filters.map((filter) {
                          final selected =
                              _normalizeFilter(filter) == _selectedFilter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              onTap: () => _selectFilter(filter),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected
                                          ? const Color(0xFF0B2D4D)
                                          : const Color(0xFFE8D8B8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  filter,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        selected
                                            ? const Color.fromARGB(255, 243, 242, 250)
                                            : const Color(0xFF0B2D4D),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child:
                      _filteredShells.isEmpty
                          ? Center(
                            child: const Text(
                              'No shells match your search.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF163E5C),
                              ),
                            ),
                          )
                          : GridView.builder(
                            itemCount: _filteredShells.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.75,
                                ),
                            itemBuilder: (context, index) {
                              final shell = _filteredShells[index];
                              final rawShell =
                                  (shell['data'] is Map)
                                      ? Map<String, dynamic>.from(
                                        shell['data'] as Map,
                                      )
                                      : <String, dynamic>{};
                              return GestureDetector(
                                onTap: () {
                                  final selectedShell =
                                      rawShell.isNotEmpty
                                          ? rawShell
                                          : Map<String, dynamic>.from(shell);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ShellDetailScreen(
                                            shell: selectedShell,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAF8F2),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color.fromARGB(183, 24, 11, 76),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(191, 11, 45, 77).withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                          child: Image.asset(
                                            (shell['image'] ?? '').toString(),
                                            fit: BoxFit.contain,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Image.asset(
                                                'lib/assets/images/logo.png',
                                                fit: BoxFit.contain,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          (shell['name'] ?? 'Unknown shell')
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
