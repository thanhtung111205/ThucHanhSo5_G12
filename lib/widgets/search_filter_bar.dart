import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SearchFilterBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onMajorFilterChanged;
  final ValueChanged<String?> onGpaFilterChanged;
  final List<String> majors;

  const SearchFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.onMajorFilterChanged,
    required this.onGpaFilterChanged,
    this.majors = const [
      'Công Nghệ Thông Tin',
      'Kinh Tế',
      'Quản Lý',
      'Kỹ Thuật',
    ],
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  late TextEditingController _searchController;
  String? _selectedMajor;
  String? _selectedGpaRange;

  // GPA Range options
  final List<String> _gpaRanges = [
    'Tất cả',
    '0.0 - 2.0',
    '2.0 - 3.0',
    '3.0 - 3.5',
    '3.5 - 4.0',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm tên, mã sinh viên...',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 12),

          // Filter Dropdowns
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Major Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Chọn ngành'),
                      value: _selectedMajor,
                      items: widget.majors.map((String major) {
                        return DropdownMenuItem<String>(
                          value: major,
                          child: Text(major, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMajor = newValue;
                        });
                        widget.onMajorFilterChanged(newValue);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // GPA Range Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Khoảng GPA'),
                      value: _selectedGpaRange,
                      items: _gpaRanges.map((String range) {
                        return DropdownMenuItem<String>(
                          value: range,
                          child: Text(range, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGpaRange = newValue;
                        });
                        widget.onGpaFilterChanged(
                          newValue == 'Tất cả' ? null : newValue,
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Clear Filter Button
              if (_selectedMajor != null || _selectedGpaRange != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedMajor = null;
                        _selectedGpaRange = null;
                      });
                      widget.onMajorFilterChanged(null);
                      widget.onGpaFilterChanged(null);
                    },
                    child: const Icon(Icons.clear, color: AppColors.error),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
