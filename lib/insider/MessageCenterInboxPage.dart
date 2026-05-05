import 'package:flutter/material.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/src/app_cards_models.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCardsPage extends StatefulWidget {
  const AppCardsPage({Key? key}) : super(key: key);

  @override
  State<AppCardsPage> createState() => _AppCardsPageState();
}

class _AppCardsPageState extends State<AppCardsPage> {
  List<InsiderAppCard> appCards = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadAppCards();
  }

  Future<void> loadAppCards() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      print('[INSIDER][AppCards]: Loading campaigns...');

      final response = await FlutterInsider.Instance.appCards.getCampaigns();

      if (response != null && response.appCards.isNotEmpty) {
        print('[INSIDER][AppCards]: Received ${response.appCards.length} cards');
        setState(() {
          appCards = response.appCards;
          isLoading = false;
        });
      } else {
        print('[INSIDER][AppCards]: No cards found');
        setState(() {
          appCards = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('[INSIDER][AppCards]: Error loading cards: $e');
      setState(() {
        hasError = true;
        errorMessage = 'Error loading cards: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'App Cards',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.shade700,
                      Colors.deepPurple.shade900,
                    ],
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 60),
                    child: Text(
                      'Your cards and notifications',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (hasError) {
      return _buildErrorState();
    }

    if (appCards.isEmpty) {
      return _buildEmptyState();
    }

    return _buildCardsList();
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(48),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Warning', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: loadAppCards,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('No Cards', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text(
            'No cards yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'When you receive cards, they\'ll appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllCards() async {
    final allIds = appCards.map((c) => c.id).toList();

    if (allIds.isEmpty) return;

    try {
      print('[INSIDER][AppCards]: Deleting all ${allIds.length} cards');
      await FlutterInsider.Instance.appCards.delete(allIds);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All ${allIds.length} cards deleted'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      loadAppCards();
    } catch (e) {
      print('[INSIDER][AppCards]: Error deleting all cards: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting cards: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildCardsList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _deleteAllCards,
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              label: const Text('Remove All'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: appCards.length,
          itemBuilder: (context, index) {
            return _AppCardItem(
              appCard: appCards[index],
              onRefresh: loadAppCards,
            );
          },
        ),
      ],
    );
  }
}

class _AppCardItem extends StatefulWidget {
  final InsiderAppCard appCard;
  final VoidCallback onRefresh;

  const _AppCardItem({
    Key? key,
    required this.appCard,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<_AppCardItem> createState() => _AppCardItemState();
}

class _AppCardItemState extends State<_AppCardItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    // Track card view
    widget.appCard.view();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appCard = widget.appCard;
    final cardId = appCard.id;
    final isRead = appCard.isRead;
    final title = appCard.content?.title ?? '';
    final description = appCard.content?.description ?? '';
    final images = appCard.images ?? [];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _handleCardClick(),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title and Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (title.isNotEmpty && description.isNotEmpty)
                            const SizedBox(height: 4),
                          if (description.isNotEmpty)
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildStatusBadge(isRead),
                  ],
                ),

                // Images Carousel
                if (images.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildImageCarousel(images),
                  const SizedBox(height: 8),
                  _buildImageIndicators(images.length),
                ],

                // Card ID
                const SizedBox(height: 16),
                Text(
                  'ID: ${cardId.length > 16 ? cardId.substring(0, 16) + '...' : cardId}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black38,
                  ),
                ),

                // Divider
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => isRead ? _markAsUnread() : _markAsRead(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          side: BorderSide(
                            color: isRead ? Colors.grey.shade500 : Colors.deepPurple,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(isRead ? 'Mark Unread' : 'Mark Read'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _deleteCard(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showCardDetails(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                ),

                // Dynamic Buttons
                ..._buildDynamicButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isRead) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey.shade300 : Colors.deepPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isRead ? Colors.grey.shade600 : Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isRead ? 'Read' : 'Unread',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isRead ? Colors.grey.shade700 : Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<InsiderAppCardImage> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: images.length,
        onPageChanged: (index) {
          setState(() {
            _currentImageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final imageUrl = images[index].url;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageIndicators(int count) {
    if (count <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentImageIndex == index
                ? Colors.deepPurple
                : Colors.deepPurple.withOpacity(0.3),
          ),
        );
      }),
    );
  }

  List<Widget> _buildDynamicButtons() {
    final buttons = widget.appCard.buttons;

    if (buttons == null || buttons.isEmpty) {
      return [];
    }

    return [
      const SizedBox(height: 12),
      Text(
        'Card Actions:',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
      ...buttons.map((button) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleButtonClick(button),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(button.text),
            ),
          ),
        );
      }).toList(),
    ];
  }

  void _handleCardClick() {
    final appCard = widget.appCard;
    print('[INSIDER][AppCardItem]: Card clicked');
    print('  Card ID: ${appCard.id}');

    try {
      appCard.click();
      print('[INSIDER][AppCardItem]: Card click tracked in SDK');

      final action = appCard.action;
      if (action is InsiderAppCardDeeplinkAction && action.url.isEmpty) {
        final jsonData = action.json;
        final keyValueData = action.keysAndValues;
        if (jsonData != null && jsonData.isNotEmpty) {
          print('[INSIDER][AppCardItem]: Deep link JSON data: $jsonData');
        } else if (keyValueData != null && keyValueData.isNotEmpty) {
          print('[INSIDER][AppCardItem]: Deep link key-value data: $keyValueData');
        }
      }
    } catch (e) {
      print('[INSIDER][AppCardItem]: Error handling card click: $e');
    }
  }

  Future<void> _handleButtonClick(InsiderAppCardButton button) async {
    print('[INSIDER][AppCardItem]: Button clicked');
    print('  Button ID: ${button.id}');
    print('  Button Text: ${button.text}');
    print('  Card ID: ${widget.appCard.id}');

    try {
      button.click();
      print('[INSIDER][AppCardItem]: Button click tracked in SDK');

      final action = button.action;

      if (action != null && action is InsiderAppCardDeeplinkAction) {
        final deeplinkAction = action;
        final url = deeplinkAction.url;

        if (!url.isNotEmpty) {
          final jsonData = deeplinkAction.json;
          final keyValueData = deeplinkAction.keysAndValues;
          if (jsonData != null && jsonData.isNotEmpty) {
            print('[INSIDER][AppCardItem]: Deep link JSON data: $jsonData');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Deep link JSON: $jsonData'),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (keyValueData != null && keyValueData.isNotEmpty) {
            print('[INSIDER][AppCardItem]: Deep link key-value data: $keyValueData');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Deep link key-value: $keyValueData'),
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Deep link action triggered'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Button "${button.text}" clicked'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('[INSIDER][AppCardItem]: Error handling button click: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _markAsRead() async {
    try {
      print('[INSIDER][AppCardItem]: Marking card as read: ${widget.appCard.id}');
      await widget.appCard.markAsRead();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Card marked as read'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      widget.onRefresh();
    } catch (e) {
      print('[INSIDER][AppCardItem]: Error marking as read: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error marking card as read: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _markAsUnread() async {
    try {
      print('[INSIDER][AppCardItem]: Marking card as unread: ${widget.appCard.id}');
      await widget.appCard.markAsUnread();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Card marked as unread'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      widget.onRefresh();
    } catch (e) {
      print('[INSIDER][AppCardItem]: Error marking as unread: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error marking as unread: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteCard() async {
    try {
      print('[INSIDER][AppCardItem]: Deleting card: ${widget.appCard.id}');
      await widget.appCard.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Card deleted'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      widget.onRefresh();
    } catch (e) {
      print('[INSIDER][AppCardItem]: Error deleting card: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting card: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCardDetails() {
    final appCard = widget.appCard;
    final images = appCard.images ?? [];
    final buttons = appCard.buttons ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Card Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', appCard.id),
              _buildDetailRow('Type', appCard.type),
              _buildDetailRow('Status', appCard.isRead ? 'Read' : 'Unread'),
              if (appCard.content != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Content:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (appCard.content!.title.isNotEmpty)
                  _buildDetailRow('Title', appCard.content!.title),
                if (appCard.content!.description.isNotEmpty)
                  _buildDetailRow('Description', appCard.content!.description),
              ],
              if (images.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Images:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...images.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('${entry.key + 1}. ${entry.value.url}',
                        style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ],
              if (buttons.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Buttons:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...buttons.asMap().entries.map((entry) {
                  final btn = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${entry.key + 1}. ${btn.text}',
                            style: const TextStyle(fontSize: 12)),
                        Text('   ID: ${btn.id}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        if (btn.action != null)
                          Text('   Action: ${btn.action!.actionType}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  );
                }).toList(),
              ],
              if (appCard.action != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Action:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Type: ${appCard.action!.actionType}',
                    style: const TextStyle(fontSize: 12)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
