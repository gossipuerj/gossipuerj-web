import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";
import "glossip_components.dart";

class GlossipPullToRefresh extends StatefulWidget {
  const GlossipPullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.isRefreshing = false,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final bool isRefreshing;

  @override
  State<GlossipPullToRefresh> createState() => _GlossipPullToRefreshState();
}

class _GlossipPullToRefreshState extends State<GlossipPullToRefresh> {
  RefreshIndicatorStatus? _status;
  bool _isTopPullGesture = false;

  bool get _isVisible =>
      ((_status == RefreshIndicatorStatus.drag && _isTopPullGesture) ||
          _status == RefreshIndicatorStatus.armed ||
          _status == RefreshIndicatorStatus.snap ||
          _status == RefreshIndicatorStatus.refresh ||
          widget.isRefreshing);

  bool get _shouldShowReleaseHint =>
      _status == RefreshIndicatorStatus.armed ||
      _status == RefreshIndicatorStatus.snap;

  String get _label {
    if (widget.isRefreshing || _status == RefreshIndicatorStatus.refresh) {
      return "ATUALIZANDO FEED";
    }

    if (_shouldShowReleaseHint) {
      return "SOLTE PARA ATUALIZAR";
    }

    switch (_status) {
      case RefreshIndicatorStatus.drag:
        return "PUXE PARA ATUALIZAR";
      case RefreshIndicatorStatus.snap:
        return "PREPARANDO";
      case RefreshIndicatorStatus.refresh:
        return "ATUALIZANDO FEED";
      case null:
      case RefreshIndicatorStatus.armed:
      case RefreshIndicatorStatus.done:
      case RefreshIndicatorStatus.canceled:
        return "PUXE PARA ATUALIZAR";
    }
  }

  void _resetGestureState() => _isTopPullGesture = false;

  bool _handleScrollNotification(ScrollNotification notification) {
    final isAtTop = notification.metrics.extentBefore <= 0;

    if (notification is ScrollStartNotification) {
      if (_isTopPullGesture) {
        setState(_resetGestureState);
      }
      return false;
    }

    final dragDelta = switch (notification) {
      ScrollUpdateNotification(:final dragDetails?) => dragDetails.delta.dy,
      OverscrollNotification(:final dragDetails?) => dragDetails.delta.dy,
      _ => null,
    };

    if (dragDelta == null) {
      if (notification is ScrollEndNotification &&
          _isTopPullGesture &&
          mounted) {
        setState(_resetGestureState);
      }
      return false;
    }

    final isPullingDownFromTop = isAtTop && dragDelta > 0;
    if (!mounted) {
      return false;
    }

    if (isPullingDownFromTop) {
      if (!_isTopPullGesture) {
        setState(() {
          _isTopPullGesture = true;
        });
      }
      return false;
    }

    if (_isTopPullGesture) {
      setState(_resetGestureState);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width > 360 ? 320.0 : 280.0;
    final showSpinner =
        widget.isRefreshing || _status == RefreshIndicatorStatus.refresh;

    return Stack(
      children: [
        RefreshIndicator.noSpinner(
          onRefresh: widget.onRefresh,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          notificationPredicate: (notification) => notification.depth == 0,
          onStatusChange: (status) {
            if (!mounted) {
              return;
            }
            setState(() {
              _status = status;
              if (status == null ||
                  status == RefreshIndicatorStatus.canceled ||
                  status == RefreshIndicatorStatus.done) {
                _resetGestureState();
              }
            });
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: widget.child,
          ),
        ),
        IgnorePointer(
          child: SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                offset: _isVisible ? Offset.zero : const Offset(0, -1.4),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 140),
                  opacity: _isVisible ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: GlossipCard(
                        color: GlossipColors.accent,
                        shadowOffset: const Offset(6, 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (showSpinner)
                              const GlossipSpinnerProgressIndicator(radius: 18),
                            if (showSpinner) const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                _label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
