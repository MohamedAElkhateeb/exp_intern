import 'dart:convert';
import 'package:exp_intern/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/navigation_service.dart';
import '../utils/request_model.dart';

class RequestInspector extends StatefulWidget {
  const RequestInspector({super.key});

  @override
  State<RequestInspector> createState() => _RequestInspectorState();
}

class _RequestInspectorState extends State<RequestInspector> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ColorsManager.primaryTeal,
      onPressed: () {
        _showInspectorOverlay();
      },
      child: const Icon(Icons.account_tree_outlined, color: Colors.white),
    );
  }

  void _showInspectorOverlay() {
    final overlay = NavigationService.overlay;

    if (overlay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Overlay not available")),
      );
      return;
    }

    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _removeOverlay();
        },
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 1.sw,
                height: 0.8.sh,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  Widget _buildContent() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 12.h),
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: 16.h),

        Expanded(
          child: requestList.isEmpty
              ? Center(
            child: Text(
              "No Requests Found",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16.sp,
              ),
            ),
          )
              : ListView.builder(
            itemCount: requestList.length,
            itemBuilder: (context, index) {
              final req = requestList.reversed.toList()[index];
              return _buildRequestTile(req);
            },
          ),
        ),

        if (requestList.isNotEmpty)
          GestureDetector(
            onTap: () {
              setState(() {
                requestList.clear();
                _removeOverlay();
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                "DELETE ALL REQUESTS",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildRequestTile(Request e) {
    final isSuccess = e.status == "200";

    return GestureDetector(
      onTap: () {
        _removeOverlay();
        _showRequestDetails(e);
      },
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "STATUS CODE ${e.status ?? ''}",
              style: TextStyle(
                color: isSuccess ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              e.actionType?.toUpperCase() ?? 'UNKNOWN',
              style: TextStyle(
                color: isSuccess ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              e.url ?? '',
              style: TextStyle(
                fontSize: 22.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestDetails(Request e) {
    final context = NavigationService.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        contentPadding: EdgeInsets.all(16.w),
        // ✅ حط GestureDetector على الـ Content كله
        content: GestureDetector(
          onTap: () {
            _copyToClipboard(e);
            Navigator.pop(dialogContext);
            _showInspectorOverlay();
            NavigationService.showSnackBar("✅ Copied done");
          },
          child: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // STATUS CODE
                    Text(
                      "STATUS CODE => ${e.status ?? ''}",
                      style: TextStyle(
                        color: e.status == "200" ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // METHOD
                    Text(
                      e.actionType?.toUpperCase() ?? 'UNKNOWN',
                      style: TextStyle(
                        color: e.status == "200" ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // URL
                    Text(
                      "URL =>",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                    Text(
                      e.url ?? '',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Divider(thickness: 1, color: Colors.grey.shade300),

                    // HEADER
                    Text(
                      "Header =>",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                    Text(
                      _formatJson(e.header),
                      style: TextStyle(
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Divider(thickness: 1, color: Colors.grey.shade300),

                    // BODY (if exists)
                    if (e.body != null && e.body != 'null') ...[
                      Text(
                        "BODY =>",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                      ),
                      Text(
                        _formatJson(e.body),
                        style: TextStyle(
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Divider(thickness: 1, color: Colors.grey.shade300),
                    ],

                    // RESPONSE
                    Text(
                      "RESPONSE =>",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                    Text(
                      _formatJson(e.response),
                      style: TextStyle(
                        fontSize: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _copyToClipboard(e);
              Navigator.pop(dialogContext);
              _showInspectorOverlay();
            },
            child: const Text(
              "COPY ALL",
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showInspectorOverlay();
            },
            child: const Text(
              "CLOSE",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    ).then((_) {
      _showInspectorOverlay();
    });
  }

  String _formatJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return 'Empty';
    try {
      final decoded = json.decode(jsonString);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return jsonString;
    }
  }

  void _copyToClipboard(Request e) {
    String text =
        "STATUS CODE ${e.status}\n"
        "URL => ${e.url}\n"
        "Header => ${_formatJson(e.header)}\n"
        "BODY => ${_formatJson(e.body)}\n"
        "RESPONSE => ${_formatJson(e.response)}";

    Clipboard.setData(ClipboardData(text: text));
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }
}