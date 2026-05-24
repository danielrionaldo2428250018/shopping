import 'package:flutter/material.dart';

import '../services/in_app_notification_host.dart';

/// Overlay banner di bagian atas layar (di atas konten app).
class InAppNotificationOverlay extends StatelessWidget {
  const InAppNotificationOverlay({
    super.key,
    required this.child,
  });

  static const Color _purple = Color(0xFF7B42F6);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        ListenableBuilder(
          listenable: InAppNotificationHost.instance,
          builder: (context, _) {
            final banner = InAppNotificationHost.instance.banner;
            if (banner == null) return const SizedBox.shrink();

            final top = MediaQuery.paddingOf(context).top + 8;
            return Positioned(
              top: top,
              left: 12,
              right: 12,
              child: Material(
                elevation: 12,
                shadowColor: Colors.black38,
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: InAppNotificationHost.instance.dismiss,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _purple.withValues(alpha: 0.35)),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _purple.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: _purple,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              if (banner.body.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  banner.body,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.35,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: InAppNotificationHost.instance.dismiss,
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
