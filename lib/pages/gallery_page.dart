// lib/pages/gallery_page.dart
import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart'; // Import the bottom navigation bar

// Enum to represent media types for filtering
enum MediaType { all, photo, video }

// Enum to represent primary sorting options
enum SortCategory { time, size }

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  MediaType _selectedMediaType = MediaType.all;
  SortCategory? _selectedSortCategory; // Nullable, as no sort might be selected initially
  bool _isTimeAscending = false; // False means newest first (descending time)
  bool _isSizeAscending = false; // False means largest first (descending size)

  // Placeholder data for mixed media (images and videos)
  final List<Map<String, dynamic>> _mediaItems = List.generate(
    8, // 8 items as requested
    (index) {
      final bool isVideo = index % 3 == 0; // Every 3rd item is a video for demonstration
      return {
        'id': index,
        'type': isVideo ? MediaType.video : MediaType.photo,
        'thumbnailUrl': isVideo
            ? 'https://placehold.co/150x150/000000/FFFFFF?text=Video%20${index + 1}' // Darker for video placeholder
            : 'https://placehold.co/150x150/E0E0E0/000000?text=Photo%20${index + 1}',
        'title': isVideo ? 'Video ${index + 1}' : 'Photo ${index + 1}',
        'timestamp': DateTime.now().subtract(Duration(days: index * 5)), // Dummy time
        'size': (index + 1) * 1024 * 100, // Dummy size in bytes
      };
    },
  );

  // Method to sort the media items based on the selected option and direction
  List<Map<String, dynamic>> _sortMedia(List<Map<String, dynamic>> media) {
    if (_selectedSortCategory == null) {
      return media; // No sorting applied if no category is selected
    }

    media.sort((a, b) {
      if (_selectedSortCategory == SortCategory.time) {
        final int comparison = a['timestamp'].compareTo(b['timestamp']);
        return _isTimeAscending ? comparison : -comparison; // Toggle ascending/descending
      } else if (_selectedSortCategory == SortCategory.size) {
        final int comparison = a['size'].compareTo(b['size']);
        return _isSizeAscending ? comparison : -comparison; // Toggle ascending/descending
      }
      return 0; // Should not reach here
    });
    return media;
  }

  @override
  Widget build(BuildContext context) {
    // Filter media items based on selected type
    final List<Map<String, dynamic>> filteredMedia = _mediaItems.where((item) {
      if (_selectedMediaType == MediaType.all) {
        return true;
      } else {
        return item['type'] == _selectedMediaType;
      }
    }).toList();

    // Sort the filtered media items
    final List<Map<String, dynamic>> sortedAndFilteredMedia = _sortMedia(filteredMedia);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Time Sort Button
          _buildSortButton(
            context,
            label: 'Time',
            category: SortCategory.time,
            isAscending: _isTimeAscending,
            onTap: () {
              setState(() {
                if (_selectedSortCategory == SortCategory.time) {
                  _isTimeAscending = !_isTimeAscending; // Toggle direction
                } else {
                  _selectedSortCategory = SortCategory.time;
                  _isTimeAscending = false; // Default to newest first when selecting time
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sorted by Time (${_isTimeAscending ? 'Oldest First' : 'Newest First'})')),
              );
            },
          ),
          const SizedBox(width: 8),
          // Size Sort Button
          _buildSortButton(
            context,
            label: 'Size',
            category: SortCategory.size,
            isAscending: _isSizeAscending,
            onTap: () {
              setState(() {
                if (_selectedSortCategory == SortCategory.size) {
                  _isSizeAscending = !_isSizeAscending; // Toggle direction
                } else {
                  _selectedSortCategory = SortCategory.size;
                  _isSizeAscending = false; // Default to largest first when selecting size
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sorted by Size (${_isSizeAscending ? 'Smallest First' : 'Largest First'})')),
              );
            },
          ),
          const SizedBox(width: 16), // Add some spacing at the end
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Center(
              child: SegmentedButton<MediaType>(
                segments: const <ButtonSegment<MediaType>>[
                  ButtonSegment<MediaType>(
                    value: MediaType.all,
                    label: Text('All'),
                    icon: Icon(Icons.collections),
                  ),
                  ButtonSegment<MediaType>(
                    value: MediaType.photo,
                    label: Text('Photos'),
                    icon: Icon(Icons.photo),
                  ),
                  ButtonSegment<MediaType>(
                    value: MediaType.video,
                    label: Text('Videos'),
                    icon: Icon(Icons.video_collection),
                  ),
                ],
                selected: <MediaType>{_selectedMediaType},
                onSelectionChanged: (Set<MediaType> newSelection) {
                  setState(() {
                    _selectedMediaType = newSelection.first;
                    // Reset sort category when media type changes, or keep it if desired
                    // _selectedSortCategory = null;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  selectedForegroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.grey[700],
                  side: BorderSide(color: Colors.grey[400]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            child: sortedAndFilteredMedia.isEmpty
                ? const Center(
                    child: Text(
                      'No media found for this filter.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 items per row
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0, // Square items
                    ),
                    itemCount: sortedAndFilteredMedia.length,
                    itemBuilder: (context, index) {
                      final item = sortedAndFilteredMedia[index];
                      final bool isVideo = item['type'] == MediaType.video;

                      return GestureDetector(
                        onTap: () {
                          // TODO: Implement media view/detail for both photos and videos
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item['title']} pressed!')),
                          );
                        },
                        child: Card( // Use Card for a nice elevated look
                          clipBehavior: Clip.antiAlias, // Clip children to card shape
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Thumbnail image
                              Image.network(
                                item['thumbnailUrl'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                              ),
                              // Overlay for video icon
                              if (isVideo)
                                Container(
                                  color: Colors.black54, // Semi-transparent overlay
                                  child: const Center(
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              // Optional: Title/caption overlay at the bottom
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  color: Colors.black.withOpacity(0.6),
                                  child: Text(
                                    item['title'],
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3), // Pass the current index for Gallery
    );
  }

  // Helper method to build a cute sort button
  Widget _buildSortButton(
    BuildContext context, {
    required String label,
    required SortCategory category,
    required bool isAscending,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedSortCategory == category;
    final Color textColor = isSelected ? Theme.of(context).colorScheme.primary : Colors.black87;
    final Color iconColor = isSelected ? Theme.of(context).colorScheme.primary : Colors.black54;
    final Color backgroundColor = isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.white;
    final BorderSide borderSide = BorderSide(
      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[300]!,
      width: isSelected ? 1.5 : 1.0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20), // More rounded for a "cute" look
          border: Border.all(
            color: borderSide.color,
            width: borderSide.width,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            if (!isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 18,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
