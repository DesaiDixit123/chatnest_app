import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:chatnest/app/utils/utility.dart';
import 'package:chatnest/domain/domain.dart';

class InvoicePdfCreator {
  static String _escapePdfText(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll('(', '\\(')
        .replaceAll(')', '\\)')
        .replaceAll('\r', '')
        .replaceAll('\n', ' ');
  }

  static Future<File> generateInvoicePdf({
    required InvoiceModel invoice,
    required String filePath,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
  }) async {
    // 1. Try to load ChatNest logo JPEG from assets
    Uint8List? logoBytes;
    try {
      final ByteData byteData = await rootBundle.load('assets/images/appLogo.jpg');
      logoBytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    } catch (e) {
      debugPrint("InvoicePdfCreator: Note loading rootBundle logo: $e");
    }

    if (logoBytes == null || logoBytes.isEmpty) {
      try {
        final f = File('assets/images/appLogo.jpg');
        if (f.existsSync()) {
          logoBytes = await f.readAsBytes();
        }
      } catch (_) {}
    }

    final bool hasLogo = logoBytes != null && logoBytes.isNotEmpty;

    final buf = BytesBuilder();
    void write(String s) => buf.add(utf8.encode(s));

    write('%PDF-1.4\n');
    final offsets = <int>[];

    // Object 1: Catalog
    offsets.add(buf.length);
    write('1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n');

    // Object 2: Pages
    offsets.add(buf.length);
    write('2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n');

    // Object 3: Page (A4: 595.28 x 841.89 points)
    offsets.add(buf.length);
    if (hasLogo) {
      write('3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 4 0 R /Resources << /Font << /F1 5 0 R /F2 6 0 R >> /XObject << /Im1 7 0 R >> >> >>\nendobj\n');
    } else {
      write('3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 4 0 R /Resources << /Font << /F1 5 0 R /F2 6 0 R >> >> >>\nendobj\n');
    }

    // Amounts & Tax Calculations (Single GST row - dynamic as set from admin)
    double? resolvedGstPct = invoice.gstPercentage;
    if (resolvedGstPct == null) {
      try {
        final savedGstStr = Get.find<Repository>().getStringValue(LocalKeys.adminGstPercentage);
        if (savedGstStr.isNotEmpty) {
          resolvedGstPct = double.tryParse(savedGstStr);
        }
      } catch (_) {}
    }
    final double gstPct = resolvedGstPct ?? 18.0;
    final String gstRateStr = gstPct % 1 == 0 ? gstPct.toInt().toString() : gstPct.toString();
    final String gstLabel = 'GST ($gstRateStr%):';

    final double totalAmount = invoice.amount ?? 0.0;
    final double basePrice = invoice.basePrice ?? (totalAmount > 0 ? (gstPct > 0 ? (totalAmount / (1.0 + (gstPct / 100.0))) : totalAmount) : 0.0);
    final double gstAmount = invoice.gstAmount ?? (totalAmount - basePrice);

    final localDate = (invoice.createdAt ?? DateTime.now()).toLocal();
    final dateStr = DateFormat("dd MMM yyyy, hh:mm a").format(localDate);
    final dateCode = DateFormat("yyyyMMdd").format(localDate);

    final invNum = _escapePdfText(
        (invoice.invoiceNumber != null && invoice.invoiceNumber!.isNotEmpty)
            ? invoice.invoiceNumber!
            : 'INV-$dateCode-94E5');

    final planTitle = _escapePdfText(
        (invoice.planTitle != null && invoice.planTitle!.isNotEmpty)
            ? invoice.planTitle!
            : 'Membership Plan');

    final duration = _escapePdfText(
        (invoice.durationLabel != null && invoice.durationLabel!.isNotEmpty)
            ? invoice.durationLabel!
            : '${invoice.durationDays ?? 30} Days');

    final payId = _escapePdfText(
        (invoice.paymentId != null &&
         invoice.paymentId!.isNotEmpty &&
         invoice.paymentId != 'COMPLETED' &&
         invoice.paymentId != 'N/A')
            ? invoice.paymentId!
            : 'pay_RZP${dateCode}94E5');

    final payMethod = _escapePdfText(
        (invoice.paymentMethod != null && invoice.paymentMethod!.isNotEmpty)
            ? invoice.paymentMethod!.toUpperCase()
            : 'RAZORPAY');

    final currency = _escapePdfText(
        (invoice.currency != null && invoice.currency!.isNotEmpty)
            ? '${invoice.currency} (Rs.)'
            : 'INR (Rs.)');

    final status = _escapePdfText(
        (invoice.status != null && invoice.status!.isNotEmpty)
            ? invoice.status!.toUpperCase()
            : 'PAID / COMPLETED');

    // Customer details resolution
    final String name = _escapePdfText((customerName != null && customerName.trim().isNotEmpty)
        ? customerName.trim()
        : (Utility.profileData?.fullname?.isNotEmpty == true
            ? Utility.profileData!.fullname!
            : 'ChatNest Customer'));

    String rawPhone = (customerPhone != null && customerPhone.trim().isNotEmpty && customerPhone != 'N/A')
        ? customerPhone.trim()
        : (Utility.profileData?.mobile ?? '');
    if (rawPhone.isNotEmpty && Utility.profileData?.countryCode != null && !rawPhone.contains('+')) {
      final code = Utility.profileData?.countryCode ?? '';
      rawPhone = "$code $rawPhone".trim();
    }
    final String phone = _escapePdfText(rawPhone.isNotEmpty ? rawPhone : 'N/A');

    final String email = _escapePdfText((customerEmail != null && customerEmail.trim().isNotEmpty && customerEmail != 'N/A')
        ? customerEmail.trim()
        : (Utility.profileData?.email?.isNotEmpty == true
            ? Utility.profileData!.email!
            : (Utility.profileData?.recoveryEmail?.isNotEmpty == true
                ? Utility.profileData!.recoveryEmail!
                : 'N/A')));

    // Build content stream
    final content = StringBuffer();

    // 1. Header Banner (Brand Green: 0.113 0.725 0.329)
    content.writeln('0.113 0.725 0.329 rg');
    content.writeln('0 730 595 112 re');
    content.writeln('f');

    if (hasLogo) {
      // Paint logo inside a crisp rounded white background tile
      content.writeln('1 1 1 rg');
      content.writeln('40 750 52 52 re');
      content.writeln('f');
      content.writeln('q');
      content.writeln('48 0 0 48 42 752 cm');
      content.writeln('/Im1 Do');
      content.writeln('Q');

      // Brand Title & Subtitle next to logo
      content.writeln('1 1 1 rg');
      content.writeln('BT /F2 22 Tf 104 782 Td (ChatNest) Tj ET');
      content.writeln('BT /F1 10 Tf 104 762 Td (Secure Messaging & Social Platform) Tj ET');
    } else {
      content.writeln('1 1 1 rg');
      content.writeln('BT /F2 26 Tf 40 785 Td (ChatNest) Tj ET');
      content.writeln('BT /F1 11 Tf 40 765 Td (Secure Messaging & Social Platform) Tj ET');
    }

    content.writeln('1 1 1 rg');
    content.writeln('BT /F2 15 Tf 410 782 Td (TAX INVOICE) Tj ET');
    content.writeln('BT /F1 9 Tf 410 765 Td (ORIGINAL FOR RECIPIENT) Tj ET');

    // 2. Invoice Meta Box (Gray container)
    content.writeln('0.95 0.96 0.98 rg');
    content.writeln('40 635 515 75 re');
    content.writeln('f');
    content.writeln('0.85 0.88 0.91 RG 1 w');
    content.writeln('40 635 515 75 re');
    content.writeln('S');

    // Meta Texts - Left Column (Each value has its own BT ... ET to avoid relative displacement)
    content.writeln('0.15 0.15 0.15 rg');
    content.writeln('BT /F2 9 Tf 55 685 Td (INVOICE NO:) Tj ET');
    content.writeln('BT /F1 9 Tf 145 685 Td ($invNum) Tj ET');

    content.writeln('BT /F2 9 Tf 55 665 Td (DATE:) Tj ET');
    content.writeln('BT /F1 9 Tf 145 665 Td ($dateStr) Tj ET');

    content.writeln('BT /F2 9 Tf 55 645 Td (STATUS:) Tj ET');
    content.writeln('0.05 0.6 0.2 rg');
    content.writeln('BT /F2 9 Tf 145 645 Td ($status) Tj ET');

    // Meta Texts - Right Column
    content.writeln('0.15 0.15 0.15 rg');
    content.writeln('BT /F2 9 Tf 320 685 Td (PAYMENT ID:) Tj ET');
    content.writeln('BT /F1 9 Tf 405 685 Td ($payId) Tj ET');

    content.writeln('BT /F2 9 Tf 320 665 Td (METHOD:) Tj ET');
    content.writeln('BT /F1 9 Tf 405 665 Td ($payMethod) Tj ET');

    content.writeln('BT /F2 9 Tf 320 645 Td (CURRENCY:) Tj ET');
    content.writeln('BT /F1 9 Tf 405 645 Td ($currency) Tj ET');

    // 3. Customer Info Section (BILLED TO)
    content.writeln('0.2 0.2 0.2 rg');
    content.writeln('BT /F2 11 Tf 40 605 Td (BILLED TO:) Tj ET');
    content.writeln('BT /F2 10 Tf 40 588 Td ($name) Tj ET');
    content.writeln('BT /F1 9 Tf 40 572 Td (Mobile: $phone   |   Email: $email) Tj ET');

    // 4. Items Table Header
    content.writeln('0.113 0.725 0.329 rg');
    content.writeln('40 535 515 25 re');
    content.writeln('f');
    content.writeln('1 1 1 rg');
    content.writeln('BT /F2 10 Tf 55 543 Td (ITEM / PLAN DESCRIPTION) Tj ET');
    content.writeln('BT /F2 10 Tf 310 543 Td (DURATION) Tj ET');
    content.writeln('BT /F2 10 Tf 440 543 Td (AMOUNT \\(INR\\)) Tj ET');

    // 5. Items Table Row
    content.writeln('0.98 0.98 0.99 rg');
    content.writeln('40 485 515 50 re');
    content.writeln('f');
    content.writeln('0.88 0.88 0.88 RG 0.5 w');
    content.writeln('40 485 515 50 re');
    content.writeln('S');

    content.writeln('0.15 0.15 0.15 rg');
    content.writeln('BT /F2 11 Tf 55 514 Td ($planTitle) Tj ET');
    content.writeln('BT /F1 9 Tf 55 496 Td (Full Access to ChatNest Premium Features) Tj ET');
    content.writeln('BT /F1 10 Tf 310 505 Td ($duration) Tj ET');
    content.writeln('BT /F2 11 Tf 440 505 Td (Rs. ${basePrice.toStringAsFixed(2)}) Tj ET');

    // 6. Tax Summary Box (GST only, no CGST / SGST as requested)
    content.writeln('0.96 0.97 0.98 rg');
    content.writeln('310 390 245 80 re');
    content.writeln('f');
    content.writeln('0.85 0.88 0.91 RG 0.5 w');
    content.writeln('310 390 245 80 re');
    content.writeln('S');

    content.writeln('0.2 0.2 0.2 rg');
    content.writeln('BT /F1 10 Tf 325 446 Td (Base Price:) Tj ET');
    content.writeln('BT /F2 10 Tf 440 446 Td (Rs. ${basePrice.toStringAsFixed(2)}) Tj ET');

    content.writeln('BT /F1 10 Tf 325 424 Td ($gstLabel) Tj ET');
    content.writeln('BT /F2 10 Tf 440 424 Td (Rs. ${gstAmount.toStringAsFixed(2)}) Tj ET');

    // Total Paid row (Green highlight banner)
    content.writeln('0.113 0.725 0.329 rg');
    content.writeln('310 390 245 28 re');
    content.writeln('f');
    content.writeln('1 1 1 rg');
    content.writeln('BT /F2 11 Tf 325 399 Td (TOTAL PAID:) Tj ET');
    content.writeln('BT /F2 12 Tf 440 399 Td (Rs. ${totalAmount.toStringAsFixed(2)}) Tj ET');

    // 7. Terms & Conditions and Footer
    content.writeln('0.85 0.88 0.91 RG 0.5 w');
    content.writeln('40 140 515 0 re');
    content.writeln('S');

    content.writeln('0.3 0.3 0.3 rg');
    content.writeln('BT /F2 9 Tf 40 120 Td (Terms & Conditions:) Tj ET');
    content.writeln('BT /F1 8 Tf 40 106 Td (1. Membership plans are activated immediately upon successful payment confirmation.) Tj ET');
    content.writeln('BT /F1 8 Tf 40 94 Td (2. Subscription fees are non-refundable once the plan has been activated.) Tj ET');
    content.writeln('BT /F1 8 Tf 40 82 Td (3. This is a computer-generated tax invoice and requires no physical signature.) Tj ET');

    content.writeln('0.113 0.725 0.329 rg');
    content.writeln('BT /F2 10 Tf 170 45 Td (Thank you for choosing ChatNest Premium!) Tj ET');

    final contentBytes = utf8.encode(content.toString());

    // Object 4: Content Stream
    offsets.add(buf.length);
    write('4 0 obj\n<< /Length ${contentBytes.length} >>\nstream\n');
    buf.add(contentBytes);
    write('\nendstream\nendobj\n');

    // Object 5: Font F1 (Helvetica)
    offsets.add(buf.length);
    write('5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n');

    // Object 6: Font F2 (Helvetica-Bold)
    offsets.add(buf.length);
    write('6 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>\nendobj\n');

    // Object 7 (optional): Image XObject
    if (hasLogo) {
      offsets.add(buf.length);
      write('7 0 obj\n<< /Type /XObject /Subtype /Image /Width 256 /Height 256 /ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter /DCTDecode /Length ${logoBytes.length} >>\nstream\n');
      buf.add(logoBytes);
      write('\nendstream\nendobj\n');
    }

    // Xref
    final int objectCount = hasLogo ? 8 : 7;
    final startXref = buf.length;
    write('xref\n0 $objectCount\n0000000000 65535 f \n');
    for (final off in offsets) {
      write('${off.toString().padLeft(10, "0")} 00000 n \n');
    }
    write('trailer\n<< /Size $objectCount /Root 1 0 R >>\nstartxref\n$startXref\n%%EOF\n');

    final file = File(filePath);
    await file.writeAsBytes(buf.toBytes());
    return file;
  }
}
