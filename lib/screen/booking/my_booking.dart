import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../widget/color.dart';
import '../../widget/responsive.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/products_controller.dart';
import '../../models/booking.dart';
import '../../models/employee.dart';
import 'booking_screen.dart';

class MyBookingPage extends StatefulWidget {
  final String? phoneNumber;

  const MyBookingPage({super.key, this.phoneNumber});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  final _phoneController = TextEditingController();
  final BookingController bookingController = Get.put(BookingController());
  final _formKey = GlobalKey<FormState>();
  static const String _telegramUrl = 'https://t.me/meng_chhay564';

  @override
  void initState() {
    super.initState();
    // If phone number is provided, set it and search automatically
    if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) {
      _phoneController.text = widget.phoneNumber!;
      // Wait for the widget to be built before searching
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchBookings(skipValidation: true);
      });
    }
    // Fetch employees for therapist selection
    bookingController.fetchEmployees();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _searchBookings({bool skipValidation = false}) async {
    if (!skipValidation && !_formKey.currentState!.validate()) {
      return;
    }

    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      return;
    }

    final success = await bookingController.fetchBookingsByPhone(phoneNumber);

    if (!success && bookingController.errorMessage.value.isNotEmpty) {
      Get.snackbar(
        'Error',
        bookingController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.secondary,
      );
    }
  }

  String _formatDisplayDate(DateTime dateTime) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[dateTime.weekday - 1]}, ${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  String _formatDisplayTime(DateTime dateTime) {
    final hour =
        dateTime.hour > 12
            ? dateTime.hour - 12
            : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Color _getStatusColor(String? status) {
    if (status == null) return AppColors.info;
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 0,
        actions: [
          Obx(
            () => IconButton(
              icon:
                  bookingController.isLoadingBookings.value
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.secondary,
                          ),
                        ),
                      )
                      : const Icon(Icons.refresh),
              onPressed:
                  bookingController.isLoadingBookings.value
                      ? null
                      : () async {
                        if (_phoneController.text.trim().isNotEmpty) {
                          await bookingController.fetchBookingsByPhone(
                            _phoneController.text.trim(),
                          );
                          if (bookingController.errorMessage.value.isNotEmpty) {
                            Get.snackbar(
                              'Error',
                              bookingController.errorMessage.value,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.error,
                              colorText: AppColors.secondary,
                            );
                          } else {
                            Get.snackbar(
                              'Refreshed',
                              'Bookings updated successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.success,
                              colorText: AppColors.secondary,
                              duration: const Duration(seconds: 1),
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Info',
                            'Please enter your phone number first',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.info,
                            colorText: AppColors.secondary,
                          );
                        }
                      },
              tooltip: 'Refresh Bookings',
            ),
          ),
          Obx(
            () => IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed:
                  bookingController.bookings.isEmpty
                      ? null
                      : () {
                        bookingController.bookings.clear();
                        bookingController.errorMessage.value = '';
                        Get.snackbar(
                          'Cleared',
                          'Bookings list cleared',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.info,
                          colorText: AppColors.secondary,
                          duration: const Duration(seconds: 1),
                        );
                      },
              tooltip: 'Clear Bookings',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Get.to(() => const BookingScreen());
            },
            tooltip: 'Book Appointment',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary.withOpacity(0.05), AppColors.background],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: isTablet ? 24 : 16,
            left: ResponsiveHelper.getPadding(context).left,
            right: ResponsiveHelper.getPadding(context).right,
            bottom: ResponsiveHelper.getPadding(context).bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getConstrainedWidth(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_view_day,
                          color: AppColors.secondary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Bookings',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(
                                  context,
                                  mobile: 22,
                                  tablet: 26,
                                  desktop: 28,
                                ),
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Search your bookings by phone number',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(
                                  context,
                                  mobile: 14,
                                  tablet: 16,
                                  desktop: 16,
                                ),
                                color: AppColors.secondary.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 32 : 24),

                // Search Section
                Container(
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.search,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Search Bookings',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(
                                    context,
                                    mobile: 18,
                                    tablet: 20,
                                    desktop: 22,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter your phone number',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: AppColors.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
                          ),
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 18,
                            ),
                            color: AppColors.textPrimary,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: isTablet ? 56 : 50,
                            child: ElevatedButton(
                              onPressed:
                                  bookingController.isLoadingBookings.value
                                      ? null
                                      : _searchBookings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child:
                                  bookingController.isLoadingBookings.value
                                      ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    AppColors.secondary,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Searching...',
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper.getFontSize(
                                                    context,
                                                    mobile: 16,
                                                    tablet: 18,
                                                    desktop: 18,
                                                  ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.search, size: 22),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Search',
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper.getFontSize(
                                                    context,
                                                    mobile: 16,
                                                    tablet: 18,
                                                    desktop: 18,
                                                  ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 32 : 24),

                // Bookings List
                Obx(() {
                  if (bookingController.isLoadingBookings.value) {
                    return const SizedBox.shrink();
                  }

                  if (bookingController.bookings.isEmpty) {
                    if (_phoneController.text.isNotEmpty) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(isTablet ? 32 : 24),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: isTablet ? 64 : 48,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: isTablet ? 16 : 12),
                              Text(
                                'No Bookings Found',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(
                                    context,
                                    mobile: 18,
                                    tablet: 20,
                                    desktop: 22,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isTablet ? 8 : 6),
                              Text(
                                'No bookings found for this phone number',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(
                                    context,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 16,
                                  ),
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Found ${bookingController.bookings.length} ${bookingController.bookings.length == 1 ? 'booking' : 'bookings'}',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      ...bookingController.bookings.map(
                        (booking) => _buildBookingCard(
                          context,
                          booking: booking,
                          isTablet: isTablet,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context, {
    required Booking booking,
    required bool isTablet,
  }) {
    final bookingDate = booking.bookingDate;
    final statusColor = _getStatusColor(booking.status);
    final bool isConfirmed =
        (booking.status ?? '').toLowerCase() == 'confirmed';
    final bool isCancelled =
        (booking.status ?? '').toLowerCase() == 'cancelled';

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.serviceName ?? 'Service #${booking.serviceId}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 18,
                          tablet: 20,
                          desktop: 22,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.customerName,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 16,
                        ),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (booking.status != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    booking.status!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Divider(color: AppColors.borderLight),
          SizedBox(height: isTablet ? 16 : 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  icon: Icons.access_time,
                  label: 'Date',
                  value: _formatDisplayDate(bookingDate),
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: _buildInfoItem(
                  context,
                  icon: Icons.schedule,
                  label: 'Time',
                  value: _formatDisplayTime(bookingDate),
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
          if (booking.employeeName != null &&
              booking.employeeName!.isNotEmpty) ...[
            SizedBox(height: isTablet ? 16 : 12),
            Divider(color: AppColors.borderLight),
            SizedBox(height: isTablet ? 16 : 12),
            Builder(
              builder: (context) {
                // Try to get full employee details from the employees list
                Employee? employee;
                if (booking.employeeId != null) {
                  try {
                    employee = bookingController.employees.firstWhere(
                      (e) => e.id == booking.employeeId,
                    );
                  } catch (_) {}
                }

                final displayName = employee?.name ?? booking.employeeName!;
                final displayPhone = employee?.phone ?? booking.employeePhone;
                final displayImage =
                    employee?.profileImageUrl ??
                    booking.employeeProfileImageUrl;

                // Responsive sizing
                final profileSize = ResponsiveHelper.getFontSize(
                  context,
                  mobile: 60.0,
                  tablet: 70.0,
                  desktop: 80.0,
                );
                final cardPadding = ResponsiveHelper.getFontSize(
                  context,
                  mobile: 12.0,
                  tablet: 16.0,
                  desktop: 20.0,
                );
                final spacing = ResponsiveHelper.getFontSize(
                  context,
                  mobile: 14.0,
                  tablet: 16.0,
                  desktop: 18.0,
                );

                return Container(
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.05),
                        AppColors.primary.withOpacity(0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: isTablet ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Profile Image
                      Container(
                        width: profileSize,
                        height: profileSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient:
                              displayImage == null || displayImage.isEmpty
                                  ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary.withOpacity(0.2),
                                      AppColors.primary.withOpacity(0.1),
                                    ],
                                  )
                                  : null,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: isTablet ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              blurRadius: isTablet ? 12 : 8,
                              offset: Offset(0, isTablet ? 3 : 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child:
                              displayImage != null && displayImage.isNotEmpty
                                  ? Image.network(
                                    displayImage,
                                    width: profileSize,
                                    height: profileSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: profileSize * 0.5,
                                          color: AppColors.primary,
                                        ),
                                      );
                                    },
                                  )
                                  : Icon(
                                    Icons.person,
                                    size: profileSize * 0.5,
                                    color: AppColors.primary,
                                  ),
                        ),
                      ),
                      SizedBox(width: spacing),
                      // Info Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.medical_services_rounded,
                                  size: ResponsiveHelper.getFontSize(
                                    context,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 18,
                                  ),
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: isTablet ? 6 : 4),
                                Text(
                                  'Your Therapist',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      mobile: 11,
                                      tablet: 13,
                                      desktop: 14,
                                    ),
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isTablet ? 6 : 4),
                            Text(
                              displayName,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 19,
                                  desktop: 22,
                                ),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (displayPhone != null &&
                                displayPhone.isNotEmpty) ...[
                              SizedBox(height: isTablet ? 8 : 6),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(isTablet ? 5 : 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                        isTablet ? 6 : 4,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.phone,
                                      size: ResponsiveHelper.getFontSize(
                                        context,
                                        mobile: 12,
                                        tablet: 14,
                                        desktop: 16,
                                      ),
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: isTablet ? 8 : 6),
                                  Expanded(
                                    child: Text(
                                      displayPhone,
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getFontSize(
                                          context,
                                          mobile: 13,
                                          tablet: 15,
                                          desktop: 17,
                                        ),
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                );
              },
            ),
          ],
          if (booking.notes != null && booking.notes!.isNotEmpty) ...[
            SizedBox(height: isTablet ? 16 : 12),
            Divider(color: AppColors.borderLight),
            SizedBox(height: isTablet ? 16 : 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.note_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.notes!,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        mobile: 14,
                        tablet: 15,
                        desktop: 15,
                      ),
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: isTablet ? 16 : 12),
          Divider(color: AppColors.borderLight),
          SizedBox(height: isTablet ? 12 : 10),
          if (!isCancelled)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed:
                      isConfirmed
                          ? null
                          : () => _showEditDialog(context, booking, isTablet),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16 : 12,
                      vertical: isTablet ? 10 : 8,
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 12 : 8),
                TextButton.icon(
                  onPressed:
                      isConfirmed
                          ? null
                          : () => _showDeleteConfirmation(context, booking),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(isConfirmed ? 'Cancel' : 'Cancel Booking'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16 : 12,
                      vertical: isTablet ? 10 : 8,
                    ),
                  ),
                ),
              ],
            ),
          if (isConfirmed) ...[
            SizedBox(height: isTablet ? 12 : 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 16 : 14),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08),
                border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This booking is confirmed. Updates and cancellations are not allowed here.',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 13,
                              tablet: 14,
                              desktop: 14,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 46 : 42,
                    child: OutlinedButton.icon(
                      onPressed: _launchTelegram,
                      icon: const Icon(Icons.telegram),
                      label: const Text('Contact admin on Telegram'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isCancelled) ...[
            SizedBox(height: isTablet ? 12 : 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 16 : 14),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                border: Border.all(color: AppColors.error.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This booking has been cancelled. If you need to make changes, please contact the admin.',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 13,
                              tablet: 14,
                              desktop: 14,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 46 : 42,
                    child: OutlinedButton.icon(
                      onPressed: _launchTelegram,
                      icon: const Icon(Icons.telegram),
                      label: const Text('Contact admin on Telegram'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    Booking booking,
    bool isTablet,
  ) async {
    final notesController = TextEditingController(text: booking.notes ?? '');
    DateTime? selectedDateTime = booking.bookingDate;
    Employee? selectedEmployee;

    if (booking.employeeId != null) {
      try {
        selectedEmployee = bookingController.employees.firstWhere(
          (e) => e.id == booking.employeeId,
        );
      } catch (_) {}
    }

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.edit, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text('Edit Booking'),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date & Time Selection
                      Text(
                        'Date & Time',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 16,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          DateTime? dateTime = await showOmniDateTimePicker(
                            context: context,
                            initialDate: selectedDateTime ?? DateTime.now(),
                            firstDate: DateTime(
                              1600,
                            ).subtract(const Duration(days: 3652)),
                            lastDate: DateTime.now().add(
                              const Duration(days: 3652),
                            ),
                            is24HourMode: false,
                            isShowSeconds: false,
                            minutesInterval: 1,
                            secondsInterval: 1,
                            isForce2Digits: false,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            constraints: const BoxConstraints(
                              maxWidth: 350,
                              maxHeight: 650,
                            ),
                            type: OmniDateTimePickerType.dateAndTime,
                            title: const Text('Select Date & Time'),
                          );

                          if (dateTime != null) {
                            setState(() {
                              selectedDateTime = dateTime;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  selectedDateTime != null
                                      ? AppColors.primary
                                      : AppColors.border,
                              width: selectedDateTime != null ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedDateTime != null
                                          ? _formatDisplayDate(
                                            selectedDateTime!,
                                          )
                                          : 'Choose date & time',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getFontSize(
                                          context,
                                          mobile: 14,
                                          tablet: 16,
                                          desktop: 16,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color:
                                            selectedDateTime != null
                                                ? AppColors.textPrimary
                                                : AppColors.textSecondary,
                                      ),
                                    ),
                                    if (selectedDateTime != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDisplayTime(selectedDateTime!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Therapist Selection
                      Text(
                        'Therapist (Optional)',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 16,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        if (bookingController.isLoadingEmployees.value) {
                          return Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          );
                        }

                        if (bookingController.employees.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: AppColors.textSecondary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'No therapists available',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        bookingController.refreshEmployees();
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Retry',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (bookingController
                                    .errorMessage
                                    .value
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      bookingController.errorMessage.value,
                                      style: TextStyle(
                                        color: AppColors.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: bookingController.employees.length,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                itemBuilder: (context, index) {
                                  final employee =
                                      bookingController.employees[index];
                                  final isSelected =
                                      selectedEmployee?.id == employee.id;
                                  final isLast =
                                      index ==
                                      bookingController.employees.length - 1;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedEmployee =
                                            isSelected ? null : employee;
                                      });
                                    },
                                    child: Container(
                                      width: 100,
                                      margin: EdgeInsets.only(
                                        right: isLast ? 0 : 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? AppColors.primary
                                                  : AppColors.border,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? AppColors.primary
                                                          .withOpacity(0.2)
                                                      : AppColors.borderLight,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? AppColors.primary
                                                        : AppColors.border,
                                                width: isSelected ? 1.5 : 1,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child:
                                                  employee.profileImageUrl !=
                                                              null &&
                                                          employee
                                                              .profileImageUrl!
                                                              .isNotEmpty
                                                      ? Image.network(
                                                        employee
                                                            .profileImageUrl!,
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Icon(
                                                            Icons.person,
                                                            size: 24,
                                                            color:
                                                                isSelected
                                                                    ? AppColors
                                                                        .primary
                                                                    : AppColors
                                                                        .textSecondary,
                                                          );
                                                        },
                                                      )
                                                      : Icon(
                                                        Icons.person,
                                                        size: 24,
                                                        color:
                                                            isSelected
                                                                ? AppColors
                                                                    .primary
                                                                : AppColors
                                                                    .textSecondary,
                                                      ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            child: Text(
                                              employee.name,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    isSelected
                                                        ? AppColors.primary
                                                        : AppColors.textPrimary,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (selectedEmployee != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '${selectedEmployee!.name} selected',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedEmployee = null;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Clear',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      }),
                      const SizedBox(height: 20),
                      // Notes Field
                      Text(
                        'Notes',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 16,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: notesController,
                        decoration: InputDecoration(
                          hintText: 'Any special requests or notes...',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 16,
                          ),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        bookingController.isLoading.value ||
                                selectedDateTime == null
                            ? null
                            : () async {
                              final bookingDatetime = _formatDateTime(
                                selectedDateTime!,
                              );
                              final success = await bookingController
                                  .updateBooking(
                                    bookingId: booking.id,
                                    phoneNumber: _phoneController.text.trim(),
                                    bookingDatetime: bookingDatetime,
                                    notes:
                                        notesController.text.trim().isEmpty
                                            ? null
                                            : notesController.text.trim(),
                                    employeeId: selectedEmployee?.id,
                                    employeeName: selectedEmployee?.name,
                                    employeePhone: selectedEmployee?.phone,
                                    employeeProfileImageUrl:
                                        selectedEmployee?.profileImageUrl,
                                    updateEmployee: true,
                                  );

                              if (success) {
                                Navigator.of(context).pop();
                                Get.snackbar(
                                  'Success',
                                  'Booking updated successfully!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.success,
                                  colorText: AppColors.secondary,
                                );
                                // Refresh the bookings list
                                await bookingController.fetchBookingsByPhone(
                                  _phoneController.text.trim(),
                                );
                              } else {
                                Get.snackbar(
                                  'Error',
                                  bookingController
                                          .errorMessage
                                          .value
                                          .isNotEmpty
                                      ? bookingController.errorMessage.value
                                      : 'Failed to update booking',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.error,
                                  colorText: AppColors.secondary,
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        bookingController.isLoading.value
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondary,
                                ),
                              ),
                            )
                            : const Text('Save'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    Booking booking,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error),
              const SizedBox(width: 8),
              const Text('Delete Booking'),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this booking? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            Obx(
              () => ElevatedButton(
                onPressed:
                    bookingController.isLoading.value
                        ? null
                        : () async {
                          final success = await bookingController.deleteBooking(
                            bookingId: booking.id,
                            phoneNumber: _phoneController.text.trim(),
                          );

                          if (success) {
                            Navigator.of(context).pop(true);

                            // Refresh products to restore stock availability
                            try {
                              final productsCtrl =
                                  Get.find<ProductsController>();
                              productsCtrl.fetchProducts();
                            } catch (e) {
                              // Products controller doesn't exist, that's okay
                            }

                            Get.snackbar(
                              'Success',
                              'Booking deleted successfully!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.success,
                              colorText: AppColors.secondary,
                            );
                            // Refresh the bookings list
                            await bookingController.fetchBookingsByPhone(
                              _phoneController.text.trim(),
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              bookingController.errorMessage.value.isNotEmpty
                                  ? bookingController.errorMessage.value
                                  : 'Failed to delete booking',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.error,
                              colorText: AppColors.secondary,
                            );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    bookingController.isLoading.value
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.secondary,
                            ),
                          ),
                        )
                        : const Text('Yes'),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Already handled in the dialog
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _launchTelegram() async {
    final uri = Uri.parse(_telegramUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open Telegram.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.secondary,
      );
    }
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 14,
                    tablet: 15,
                    desktop: 15,
                  ),
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
