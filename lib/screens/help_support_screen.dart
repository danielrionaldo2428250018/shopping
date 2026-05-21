import 'package:flutter/material.dart';

import '../utils/l10n_helpers.dart';

class HelpSupportScreen
    extends StatelessWidget {

  const HelpSupportScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;

    final menus = [
      {
        'icon': Icons.help_outline,
        'title': loc.helpSupport,
      },
      {
        'icon': Icons.chat_bubble_outline,
        'title': loc.liveChat,
      },
      {
        'icon': Icons.email_outlined,
        'title': loc.contactEmail,
      },
      {
        'icon': Icons.report_problem_outlined,
        'title': loc.reportProblem,
      },
    ];

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(

        backgroundColor:
            Colors.white,

        elevation: 0,

        centerTitle: true,

        iconTheme:
            const IconThemeData(
          color: Colors.black,
        ),

        title: Text(
          loc.helpSupport,

          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(
                24,
              ),

              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [

                    Color(0xFF7F3DFF),

                    Color(0xFFE5D9FF),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(
                  30,
                ),
              ),

              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    color: Colors.white,
                    size: 70,
                  ),
                  SizedBox(height: 20),
                  Text(
                    loc.helpTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    loc.helpSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(

                itemCount:
                    menus.length,

                itemBuilder:
                    (context, index) {

                  final menu =
                      menus[index];

                  return Container(

                    margin:
                        const EdgeInsets.only(
                      bottom: 16,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),
                    ),

                    child: ListTile(

                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),

                      leading: Container(
                        padding:
                            const EdgeInsets
                                .all(14),

                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFF7F3DFF,
                          ).withOpacity(
                            0.1,
                          ),

                          shape:
                              BoxShape.circle,
                        ),

                        child: Icon(
                          menu['icon']
                              as IconData,

                          color:
                              const Color(
                            0xFF7F3DFF,
                          ),
                        ),
                      ),

                      title: Text(
                        menu['title']
                            as String,

                        style:
                            const TextStyle(
                          fontSize: 18,

                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      trailing:
                          const Icon(
                        Icons
                            .chevron_right,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}