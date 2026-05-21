import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/seller_application.dart';
import '../providers/auth_provider.dart';
import '../providers/seller_applications_provider.dart';
import '../utils/l10n_helpers.dart';

Future<bool> runApproveSellerFlow(
  BuildContext context,
  SellerApplication a,
)
async {
  final loc = context.l10n;

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(loc.approveApplicationQ),
      content: Text(
        loc.approveApplicationBody(a.storeName, a.email),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(loc.yesApprove),
        ),
      ],
    ),
  );

  if (ok != true || !context.mounted) return false;

  final auth = Provider.of<AuthProvider>(context, listen: false);
  final apps = Provider.of<SellerApplicationsProvider>(context, listen: false);

  try {
    await apps.approve(a.id, auth);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.approveFailed(e.toString()))),
      );
    }
    return false;
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.applicationApproved)),
    );
  }

  return true;

}

Future<bool> runRejectSellerFlow(
  BuildContext context,

  SellerApplication a,

) async {
  final loc = context.l10n;
  final ctrl = TextEditingController();

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(loc.rejectApplicationQ),
      content: TextField(
        controller: ctrl,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: loc.rejectReasonHint,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(loc.delete),
        ),
      ],
    ),
  );

  if (ok != true || !context.mounted) {

    ctrl.dispose();

    return false;

  }

  final apps = Provider.of<SellerApplicationsProvider>(context, listen: false);

  try {
    await apps.reject(a.id, reason: ctrl.text);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.rejectFailed(e.toString()))),
      );
    }
    ctrl.dispose();
    return false;
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.applicationRejected)),
    );
  }

  ctrl.dispose();

  return true;

}

/// Panel admin — melihat pengajuan calon seller, setujui / tolak.
class AdminSellerApplicationsScreen extends StatelessWidget {

  const AdminSellerApplicationsScreen({
    super.key,
  });

  static const Color _purple = Color(0xFF7B42F6);

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: _purple,

          foregroundColor: Colors.white,
          elevation: 0,

          title: Text(
            loc.adminSellerApps,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          bottom: TabBar(
            indicatorColor:
                Colors.white,
            labelColor:
                Colors.white,
            unselectedLabelColor:

                Colors.white70,
            tabs: [
              Tab(text: loc.tabPending),
              Tab(text: loc.tabApproved),
              Tab(text: loc.tabRejected),
            ],

          ),

        ),


        body: Consumer<SellerApplicationsProvider>(
          builder: (context, pool, _) {
            return Column(
              children: [
                if (pool.loadError != null)
                  Material(
                    color: Colors.orange.shade50,
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange.shade800,
                      ),
                      title: Text(
                        pool.loadError!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ),
                if (!pool.usesFirestore)
                  Material(
                    color: Colors.blue.shade50,
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade800,
                      ),
                      title: Text(
                        loc.localModeHint,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _list(
                        context,
                        pool.pending,
                        showActions: true,
                      ),
                      _list(
                        context,
                        pool.approved,
                        showActions: false,
                      ),
                      _list(
                        context,
                        pool.rejected,
                        showActions: false,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _list(
    BuildContext context,

    List<SellerApplication> list, {

    required bool showActions,
  }) {

    if (list.isEmpty) {
      final loc = context.l10n;
      return Center(
        child: Text(
          loc.noDataYet,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final loc = context.l10n;
        final a = list[i];

        return Material(
          borderRadius:
              BorderRadius.circular(16),
          color:
              Colors.white,
          elevation: 1,

          child: InkWell(
            borderRadius:
                BorderRadius.circular(16),
            onTap: () =>
                Navigator.pushNamed(
              context,

              AdminSellerDetailScreen.route,

              arguments: a.id,

            ),

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            _purple.withValues(
                          alpha:
                              0.12,
                        ),

                        child: const Icon(
                          Icons.storefront,
                          color: _purple,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.storeName,

                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize:
                                    16,
                              ),
                            ),

                            const SizedBox(
                              height:
                                  4,
                            ),

                            Text(
                              a.email,

                              style: TextStyle(
                                color:
                                    Colors.grey.shade600,
                                fontSize:
                                    13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _pill(
                        a.status,

                        label: sellerStatusLabel(a.status, loc),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        14,
                  ),

                  Text(
                    _submitted(context, a),

                    style: TextStyle(
                      fontSize:
                          12,

                      color:
                          Colors.grey.shade600,
                    ),
                  ),

                  if (showActions &&
                      a.status ==
                          SellerApplicationStatus
                              .pending) ...[
                    const Divider(
                      height:
                          24,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child:
                              OutlinedButton(
                            onPressed: () async {
                              await runApproveSellerFlow(context, a);
                            },

                            style:
                                OutlinedButton.styleFrom(
                              foregroundColor:
                                  Colors.green,
                              side:
                                  const BorderSide(
                                color:
                                    Colors.green,
                              ),
                            ),

                            child: Text(loc.approveShort),
                          ),
                        ),

                        const SizedBox(
                          width:
                              12,
                        ),

                        Expanded(
                          child:
                              OutlinedButton(
                            onPressed: () async {
                              await runRejectSellerFlow(context, a);
                            },

                            style:
                                OutlinedButton.styleFrom(
                              foregroundColor:
                                  Colors.red,
                              side:
                                  const BorderSide(
                                color:
                                    Colors.red,
                              ),
                            ),

                            child: Text(loc.rejectShort),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _pill(
    SellerApplicationStatus status, {

    required String label,
  }) {

    Color bg;
    Color fg;

    switch (status) {

      case SellerApplicationStatus.pending:
        bg = Colors.amber.shade100;
        fg = Colors.amber.shade900;

        break;

      case SellerApplicationStatus.approved:

        bg = Colors.green.shade100;
        fg = Colors.green.shade800;

        break;

      case SellerApplicationStatus.rejected:

        bg = Colors.red.shade100;
        fg = Colors.red.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child:
          Text(
        label,

        style: TextStyle(
          color: fg,

          fontSize: 11,

          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _submitted(
    BuildContext context,
    SellerApplication a,
  ) {
    final d = a.submittedAt;
    final day = '${d.year}-${d.month.toString().padLeft(
      2,
      '0',
    )}-${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(
      2,
      '0',
    )}:${d.minute.toString().padLeft(2, '0')}';

    return context.l10n.sentOn(day);
  }

}

/// Halaman detail isi formulir satu calon seller.
class AdminSellerDetailScreen extends StatelessWidget {

  const AdminSellerDetailScreen({
    super.key,
    required this.applicationId,

  });

  static const route = '/admin-seller-detail';

  final String applicationId;

  @override

  Widget build(BuildContext context) {
    final loc = context.l10n;
    final pool = Provider.of<SellerApplicationsProvider>(context);
    final a = pool.findById(applicationId);

    if (a == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.notFound),
        ),
        body: Center(
          child: Text(loc.applicationNotFound),
        ),
      );
    }

    return Scaffold(
      appBar:
          AppBar(
        title:
            Text(
          a.storeName,

          overflow:
              TextOverflow.ellipsis,
        ),

        elevation:
            0,
      ),

      body:

          ListView(
        padding:

            const EdgeInsets.all(
          16,
        ),

        children: [
          if (a.logoPath !=
                  null &&
              !kIsWeb)
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
              child:

                  Image.file(
                File(a.logoPath!),


                height: 180,

                width: double.infinity,

                fit: BoxFit.cover,
              ),

            ),

          if (a.logoPath !=
                  null &&
              !kIsWeb)

            const SizedBox(
              height:

                  14,
                ),

          _detailCard(
            loc.storeInfo,
            [
              _row(loc.nameLabel, a.storeName),
              _row(loc.description, a.storeDescription),
            ],
          ),

          const SizedBox(
            height:

                14,
          ),

          _detailCard(
            loc.contactInformation,
            [
              _row(loc.email, a.email),
              _row(loc.phoneLabel, a.phone),
            ],
          ),

          const SizedBox(
            height:

                14,
          ),

          _detailCard(
            loc.storeAddress,
            [
              _row(loc.streetLabel, a.streetAddress),
              _row(loc.cityLabel, a.city),
            ],
          ),

          const SizedBox(
            height:
                14,
          ),

          _detailCard(
            loc.administration,
            [
              _row(loc.statusLabel, sellerStatusLabel(a.status, loc)),
              _row(
                loc.agreeTermsLabel,
                a.agreedToTerms ? loc.yes : loc.no,
              ),
              if (a.reviewedAt != null)
                _row(loc.reviewedLabel, '${a.reviewedAt}'),
              if (a.rejectReason != null && a.rejectReason!.isNotEmpty)
                _row(loc.rejectReason, a.rejectReason!),
            ],
          ),

          const SizedBox(
            height:

                24,

          ),

          if (a.status ==
              SellerApplicationStatus.pending) ...[
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),

                    onPressed: () async {
                      final ok =
                          await runApproveSellerFlow(
                              context,

                              a,);

                      if (ok &&
                          context.mounted) {

                        Navigator.pop(
                          context,

                        );

                      }

                    },

                    child: Text(loc.approveBtn),

                  ),
                ),

                const SizedBox(
                  width:

                      12,
                ),

                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () async {

                      final ok =
                          await runRejectSellerFlow(
                              context,

                              a,);

                      if (ok &&
                          context.mounted) {

                        Navigator.pop(
                          context,
                        );

                      }

                    },

                    child: Text(loc.rejectShort),

                  ),
                ),

              ],

            ),
          ],


        ],

      ),

    );

  }

  Widget _detailCard(
    String title,
    List<
        Widget> rows,
  ) {

    return Container(
      width:

          double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
              14,
            ),
        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Column(
        crossAxisAlignment:

            CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontWeight: FontWeight.bold,

              fontSize: 15,
            ),

          ),

          const Divider(
              height:

                  22),

          ...rows,

        ],

      ),

    );

  }

  Widget _row(
    String label,
    String value,
  ) {

    return Padding(
      padding:

          const EdgeInsets.only(
              bottom:

                  8),
      child: Row(
        crossAxisAlignment:

            CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,

              style: TextStyle(
                color:

                    Colors.grey.shade600,

                fontWeight: FontWeight.w500,
              ),

            ),

          ),

          Expanded(
            child: Text(
              value,

              style: const TextStyle(
                height: 1.35,
              ),

            ),

          ),

        ],

      ),

    );

  }

}
