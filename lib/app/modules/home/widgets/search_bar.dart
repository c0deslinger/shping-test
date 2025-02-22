import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(BuildContext context) {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      Provider.of<PhotoProvider>(context, listen: false)
          .searchPhotos(query, refresh: true);
      FocusScope.of(context).unfocus();
    }
  }

  void _clearSearch(BuildContext context) {
    _controller.clear();
    Provider.of<PhotoProvider>(context, listen: false).clearSearch();
    Provider.of<PhotoProvider>(context, listen: false)
        .fetchPhotos(refresh: true);
    setState(() {
      _isSearching = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(
                _isSearching ? Icons.search : Icons.search,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Search photos...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onSubmitted: (_) => _performSearch(context),
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
              ),
              if (_isSearching)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _clearSearch(context),
                  splashRadius: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
