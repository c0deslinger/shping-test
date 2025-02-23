import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shping_test/features/home/providers/photo_provider.dart';

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
    final provider = Provider.of<PhotoProvider>(context, listen: false);
    provider.clearSearch();
    provider.fetchPhotos(refresh: true); // Kembali load list default
    setState(() {
      _isSearching = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoProvider>(
      builder: (context, provider, child) {
        // Sinkronkan text field dengan provider.currentQuery
        final currentQuery = provider.currentQuery;
        // Jika provider punya query, dan controller belum diset, sinkronkan
        if (currentQuery.isNotEmpty && _controller.text.isEmpty) {
          _controller.text = currentQuery;
          _isSearching = true;
        }
        // Jika provider kosong tapi textfield ada isinya, boleh diabaikan
        // atau jika diinginkan, reset ke kosong. Tergantung kebutuhan:
        else if (currentQuery.isEmpty && _controller.text.isNotEmpty) {
          // Bisa diabaikan atau disinkronkan (opsional):
          // _controller.clear();
          // _isSearching = false;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
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
      },
    );
  }
}
