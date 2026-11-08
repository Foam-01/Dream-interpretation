import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/error_log.dart';
import '../theme.dart';

/// Hidden developer view of [ErrorLog]: long-press the Home title. Lets a tester read, copy or clear
/// the errors recorded on this device (also on release builds). Nothing leaves the phone unless copied.
Future<void> showErrorLog(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  backgroundColor: C.surface,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  builder: (_) => const ErrorLogSheet(),
);

class ErrorLogSheet extends StatefulWidget {
  const ErrorLogSheet({super.key});

  @override
  State<ErrorLogSheet> createState() => _ErrorLogSheetState();
}

class _ErrorLogSheetState extends State<ErrorLogSheet> {
  @override
  Widget build(BuildContext context) {
    final records = ErrorLog.records.reversed.toList();
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text('บันทึกข้อผิดพลาด (${records.length})', style: serif(17, color: C.accent)),
                  ),
                  TextButton(
                    onPressed: records.isEmpty
                        ? null
                        : () async {
                            await Clipboard.setData(ClipboardData(text: ErrorLog.report()));
                            if (context.mounted) {
                              ScaffoldMessenger.maybeOf(context)
                                  ?.showSnackBar(const SnackBar(content: Text('คัดลอกแล้ว')));
                            }
                          },
                    child: Text('คัดลอก', style: sans(14, color: C.goldLight)),
                  ),
                  TextButton(
                    onPressed: records.isEmpty ? null : () => setState(ErrorLog.clear),
                    child: Text('ล้าง', style: sans(14, color: C.goldLight)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: records.isEmpty
                  ? Center(
                      child: Text('ยังไม่มีข้อผิดพลาด', style: sans(14, color: C.textSoft)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: records.length,
                      separatorBuilder: (_, _) => Divider(height: 16, color: C.caption.withValues(alpha: .2)),
                      itemBuilder: (_, i) {
                        final r = records[i];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${r.time.toLocal().toIso8601String().substring(0, 19)} · ${r.context}',
                              style: sans(12, color: C.caption),
                            ),
                            const SizedBox(height: 2),
                            SelectableText(r.error, style: sans(13, color: C.textBody, height: 1.5)),
                          ],
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
