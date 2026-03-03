import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/contact.dart';
import 'action_button.dart';

class ContactDetailsDialog extends StatelessWidget {
  final Contact contact;

  const ContactDetailsDialog({super.key, required this.contact});

  Future<void> _makeCall() async {
    final phone = contact.mobileNumber ?? contact.phone;
    if (phone == null || phone.isEmpty) return;
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendSMS() async {
    final phone = contact.mobileNumber ?? contact.phone;
    if (phone == null || phone.isEmpty) return;
    final url = Uri.parse('sms:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openWhatsApp() async {
    final phone = contact.mobileNumber ?? contact.phone;
    if (phone == null || phone.trim().isEmpty) return;

    // Remove all non-digit characters
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Fix Bangladesh number format
    // If starts with 0 -> replace with 880
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '88${cleanPhone.substring(1)}';
    }

    // If already 11 digits and no country code -> add 88
    if (cleanPhone.length == 11 && !cleanPhone.startsWith('88')) {
      cleanPhone = '88$cleanPhone';
    }

    final Uri url = Uri.parse('https://wa.me/$cleanPhone');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch WhatsApp");
    }
  }

  Future<void> _sendEmail() async {
    final email = contact.email;
    if (email == null || email.trim().isEmpty) return;

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint("Could not launch Email app");
    }
  }

  void _shareContact() {
    final phone = contact.mobileNumber ?? contact.phone ?? 'N/A';
    final shareText =
        '''
Police Contact:
Designation: ${contact.designation ?? 'N/A'}
Unit: ${contact.unit ?? 'N/A'}
Phone: $phone
Email: ${contact.email ?? 'N/A'}
''';
    Share.share(shareText);
  }

  String _getInitials() {
    final name = contact.designation ?? '';
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Color _getAvatarColor() {
    final colors = [
      const Color(0xFF5C6BC0),
      const Color(0xFF26A69A),
      const Color(0xFFEF5350),
      const Color(0xFFAB47BC),
      const Color(0xFF42A5F5),
      const Color(0xFFEC407A),
    ];
    final hash = (contact.designation ?? '').hashCode.abs();
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _getAvatarColor();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    avatarColor.withOpacity(0.15),
                    avatarColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: avatarColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: avatarColor.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name & designation
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.designation ?? 'Unknown Contact',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (contact.unit != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.business_outlined,
                                  size: 13, color: avatarColor),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  contact.unit!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: avatarColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(height: 1, color: Colors.grey.withOpacity(0.15)),
            // Contact info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _ContactTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: contact.mobileNumber,
                    accentColor: avatarColor,
                    onTap: contact.mobileNumber != null
                        ? () {
                            Clipboard.setData(
                                ClipboardData(text: contact.mobileNumber!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Phone number copied'),
                                  duration: Duration(seconds: 1)),
                            );
                          }
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _ContactTile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: contact.email,
                    accentColor: avatarColor,
                    onTap: contact.email != null
                        ? () {
                            Clipboard.setData(
                                ClipboardData(text: contact.email!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Email copied'),
                                  duration: Duration(seconds: 1)),
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButton(
                  icon: Icons.phone_rounded,
                  label: 'Call',
                  color: const Color(0xFF43A047),
                  onTap: _makeCall,
                ),
                ActionButton(
                  icon: Icons.sms_rounded,
                  label: 'SMS',
                  color: const Color(0xFF1E88E5),
                  onTap: _sendSMS,
                ),
                ActionButton(
                  icon: Icons.wechat_sharp,
                  label: 'WhatsApp',
                  color: const Color(0xFF00C853),
                  onTap: _openWhatsApp,
                ),
                ActionButton(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  color: const Color(0xFFE53935),
                  onTap: _sendEmail,
                ),
                ActionButton(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  color: const Color(0xFF8E24AA),
                  onTap: _shareContact,
                  isLast: true,
                ),
              ],
            ),
            Gap(8.h),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  if (contact.mobileNumber != null ||
                      contact.phone != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          _makeCall();
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: avatarColor,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.call, size: 18),
                        label: const Text('Call'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color accentColor;
  final VoidCallback? onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: hasValue
              ? accentColor.withOpacity(0.06)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasValue
                ? accentColor.withOpacity(0.2)
                : Colors.grey.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: hasValue
                    ? accentColor.withOpacity(0.12)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                size: 18,
                color: hasValue ? accentColor : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value ?? 'Not available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: hasValue ? null : Colors.grey,
                          fontWeight:
                              hasValue ? FontWeight.w500 : FontWeight.normal,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.copy_rounded, size: 16, color: accentColor),
          ],
        ),
      ),
    );
  }
}
