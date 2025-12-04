import 'package:flutter/material.dart';
import '../../widget/color.dart';
import '../../widget/responsive.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/services_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/products_controller.dart';
import '../../models/service.dart';
import '../../models/cart_item.dart';
import '../../models/employee.dart';
import '../product/product_screen.dart';
import 'my_booking.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? selectedDateTime;
  Service? selectedService;
  Employee? selectedEmployee;

  final BookingController bookingController = Get.put(BookingController());
  final CartController cartController = Get.put(CartController());
  late final ServicesController servicesController;
  ProductsController? productsController;

  @override
  void initState() {
    super.initState();
    // Try to find existing controller, if not found, create a new one
    try {
      servicesController = Get.find<ServicesController>();
      // If services list is empty, fetch services
      if (servicesController.services.isEmpty &&
          !servicesController.isLoading.value) {
        servicesController.fetchServices();
      }
    } catch (e) {
      servicesController = Get.put(ServicesController());
    }

    // Try to find existing products controller to refresh products after booking
    try {
      productsController = Get.find<ProductsController>();
    } catch (e) {
      // Products controller doesn't exist yet, that's okay
      productsController = null;
    }

    // Fetch employees
    bookingController.fetchEmployees();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Service? _getSelectedServiceFromList() {
    if (selectedService == null) return null;
    try {
      return servicesController.services.firstWhere(
        (service) => service.id == selectedService!.id,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.calendar_month),
        //     onPressed: () {
        //       Get.to(() => const MyBookingPage());
        //     },
        //     tooltip: 'My Bookings',
        //   ),
        // ],
      ),
      body: Obx(() {
        if (servicesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (servicesController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: ResponsiveHelper.getPadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    servicesController.errorMessage.value,
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 16,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => servicesController.fetchServices(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.05),
                AppColors.background,
              ],
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
              child: Form(
                key: _formKey,
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
                              Icons.calendar_today,
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
                                  'Book Your Appointment',
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
                                  'Fill in the details below',
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

                    // Customer Information Card
                    _buildSectionCard(
                      context,
                      isTablet: isTablet,
                      title: 'Customer Information',
                      icon: Icons.person_outline,
                      child: Column(
                        children: [
                          _buildTextFieldWithIcon(
                            context,
                            controller: _customerNameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            icon: Icons.person,
                            isTablet: isTablet,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          _buildTextFieldWithIcon(
                            context,
                            controller: _customerPhoneController,
                            label: 'Phone Number',
                            hint: 'Enter your phone number',
                            icon: Icons.phone,
                            isTablet: isTablet,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isTablet ? 24 : 20),

                    // Service Selection Card
                    _buildSectionCard(
                      context,
                      isTablet: isTablet,
                      title: 'Select Service',
                      icon: Icons.spa_outlined,
                      child: Obx(() {
                        if (servicesController.services.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(isTablet ? 20 : 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'No services available',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      mobile: 14,
                                      tablet: 16,
                                      desktop: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Container(
                          constraints: const BoxConstraints(minHeight: 70),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  selectedService != null
                                      ? AppColors.primary
                                      : AppColors.border,
                              width: selectedService != null ? 2 : 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Service>(
                              value: _getSelectedServiceFromList(),
                              isExpanded: true,
                              itemHeight: null,
                              menuMaxHeight: 320,
                              hint: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Choose a service',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: ResponsiveHelper.getFontSize(
                                          context,
                                          mobile: 16,
                                          tablet: 18,
                                          desktop: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return servicesController.services.map<Widget>((
                                  Service service,
                                ) {
                                  final isSelected =
                                      _getSelectedServiceFromList()?.id ==
                                      service.id;
                                  if (!isSelected) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                service.name,
                                                style: TextStyle(
                                                  fontSize:
                                                      ResponsiveHelper.getFontSize(
                                                        context,
                                                        mobile: 16,
                                                        tablet: 18,
                                                        desktop: 18,
                                                      ),
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.attach_money,
                                                    size: 12,
                                                    color: AppColors.primary,
                                                  ),
                                                  Text(
                                                    '${service.price}',
                                                    style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 12,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                  Text(
                                                    '${service.durationMinutes} min',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors
                                                              .textSecondary,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList();
                              },
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 18,
                                ),
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                              dropdownColor: AppColors.background,
                              items:
                                  servicesController.services.map((
                                    Service service,
                                  ) {
                                    return DropdownMenuItem<Service>(
                                      value: service,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          minHeight: 70,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                service.name,
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize:
                                                      ResponsiveHelper.getFontSize(
                                                        context,
                                                        mobile: 15,
                                                        tablet: 17,
                                                        desktop: 17,
                                                      ),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.attach_money,
                                                  size: 14,
                                                  color: AppColors.primary,
                                                ),
                                                Text(
                                                  '${service.price}',
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Icon(
                                                  Icons.access_time,
                                                  size: 14,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '${service.durationMinutes} min',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors
                                                              .textSecondary,
                                                      fontSize: 13,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (Service? newValue) {
                                setState(() {
                                  selectedService = newValue;
                                });
                              },
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: isTablet ? 24 : 20),

                    // Date & Time Selection Card
                    _buildSectionCard(
                      context,
                      isTablet: isTablet,
                      title: 'Appointment Date & Time',
                      icon: Icons.access_time,
                      child: InkWell(
                        onTap: _selectDateTime,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isTablet ? 20 : 16),
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
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: isTablet ? 16 : 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedDateTime != null
                                          ? '${_formatDisplayDate(selectedDateTime!)}'
                                          : 'Choose date & time',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getFontSize(
                                          context,
                                          mobile: 16,
                                          tablet: 18,
                                          desktop: 18,
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
                                          fontSize: 14,
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
                    ),

                    SizedBox(height: isTablet ? 24 : 20),

                    // Products Card (Optional)
                    Obx(
                      () => _buildSectionCard(
                        context,
                        isTablet: isTablet,
                        title: 'Products (Optional)',
                        icon: Icons.shopping_bag_outlined,
                        isOptional: true,
                        child:
                            cartController.cartItems.isEmpty
                                ? Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        isTablet ? 20 : 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            size: isTablet ? 48 : 40,
                                            color: AppColors.textSecondary,
                                          ),
                                          SizedBox(height: isTablet ? 12 : 10),
                                          Text(
                                            'No products in cart',
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper.getFontSize(
                                                    context,
                                                    mobile: 16,
                                                    tablet: 18,
                                                    desktop: 18,
                                                  ),
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(height: isTablet ? 8 : 6),
                                          Text(
                                            'Add products to your booking (optional)',
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper.getFontSize(
                                                    context,
                                                    mobile: 14,
                                                    tablet: 15,
                                                    desktop: 15,
                                                  ),
                                              color: AppColors.textSecondary,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 16 : 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          Get.to(() => const ProductScreen());
                                        },
                                        icon: const Icon(
                                          Icons.add_shopping_cart,
                                        ),
                                        label: const Text('Browse Products'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppColors.primary,
                                          side: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: isTablet ? 14 : 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...cartController.cartItems.map(
                                      (cartItem) => _buildCartItemPreview(
                                        context,
                                        cartItem: cartItem,
                                        isTablet: isTablet,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 12 : 10),
                                    Divider(color: AppColors.borderLight),
                                    SizedBox(height: isTablet ? 12 : 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Products',
                                          style: TextStyle(
                                            fontSize:
                                                ResponsiveHelper.getFontSize(
                                                  context,
                                                  mobile: 16,
                                                  tablet: 18,
                                                  desktop: 18,
                                                ),
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '\$${cartController.totalPrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize:
                                                ResponsiveHelper.getFontSize(
                                                  context,
                                                  mobile: 18,
                                                  tablet: 20,
                                                  desktop: 22,
                                                ),
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: isTablet ? 12 : 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          Get.to(() => const ProductScreen());
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                        ),
                                        label: const Text('Edit Products'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppColors.primary,
                                          side: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: isTablet ? 12 : 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 24 : 20),

                    SizedBox(height: isTablet ? 24 : 20),

                    // Employee Selection Card
                    _buildSectionCard(
                      context,
                      isTablet: isTablet,
                      title: 'Select Therapist (Optional)',
                      icon: Icons.person_search_outlined,
                      isOptional: true,
                      child: Obx(() {
                        if (bookingController.isLoadingEmployees.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (bookingController.employees.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(isTablet ? 20 : 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'No therapists available',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      mobile: 14,
                                      tablet: 16,
                                      desktop: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Horizontal Carousel Card Slider
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: isTablet ? 200 : 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: bookingController.employees.length,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
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
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: isTablet ? 180 : 160,
                                      margin: EdgeInsets.only(
                                        right: isLast ? 0 : 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? AppColors.primary
                                                  : AppColors.border,
                                          width: isSelected ? 2.5 : 1,
                                        ),
                                        boxShadow: [
                                          if (isSelected)
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Therapist Avatar
                                          Container(
                                            width: isTablet ? 80 : 70,
                                            height: isTablet ? 80 : 70,
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
                                                width: isSelected ? 2 : 1,
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
                                                        width:
                                                            isTablet ? 80 : 70,
                                                        height:
                                                            isTablet ? 80 : 70,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Icon(
                                                            Icons.person,
                                                            size:
                                                                isTablet
                                                                    ? 40
                                                                    : 35,
                                                            color:
                                                                isSelected
                                                                    ? AppColors
                                                                        .primary
                                                                    : AppColors
                                                                        .textSecondary,
                                                          );
                                                        },
                                                        loadingBuilder: (
                                                          context,
                                                          child,
                                                          loadingProgress,
                                                        ) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return Center(
                                                            child: CircularProgressIndicator(
                                                              value:
                                                                  loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          loadingProgress
                                                                              .expectedTotalBytes!
                                                                      : null,
                                                              strokeWidth: 2,
                                                              color:
                                                                  AppColors
                                                                      .primary,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                      : Icon(
                                                        Icons.person,
                                                        size:
                                                            isTablet ? 40 : 35,
                                                        color:
                                                            isSelected
                                                                ? AppColors
                                                                    .primary
                                                                : AppColors
                                                                    .textSecondary,
                                                      ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          // Therapist Name
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              employee.name,
                                              style: TextStyle(
                                                fontSize:
                                                    ResponsiveHelper.getFontSize(
                                                      context,
                                                      mobile: 14,
                                                      tablet: 16,
                                                      desktop: 16,
                                                    ),
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

                                          // Therapist Gender
                                          if (employee.gender.isNotEmpty) ...[
                                            const SizedBox(height: 3),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    isSelected
                                                        ? AppColors.primary
                                                            .withOpacity(0.1)
                                                        : AppColors.borderLight,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                employee.gender,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      isSelected
                                                          ? AppColors.primary
                                                          : AppColors
                                                              .textSecondary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],

                                          // Selected Indicator
                                          if (isSelected) ...[
                                            const SizedBox(height: 6),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                size: 16,
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Scroll indicator text
                            if (bookingController.employees.length > 2)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.swipe,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Swipe to see more therapists',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      }),
                    ),

                    SizedBox(height: isTablet ? 24 : 20),

                    // Notes Card
                    _buildSectionCard(
                      context,
                      isTablet: isTablet,
                      title: 'Additional Notes',
                      icon: Icons.note_outlined,
                      isOptional: true,
                      child: TextFormField(
                        controller: _notesController,
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
                          contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
                        ),
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 18,
                          ),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 32 : 24),

                    // Book Button
                    Obx(
                      () => Container(
                        width: double.infinity,
                        height: isTablet ? 60 : 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow:
                              _canBook() && !bookingController.isLoading.value
                                  ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                  : null,
                        ),
                        child: ElevatedButton(
                          onPressed:
                              bookingController.isLoading.value
                                  ? null
                                  : (_canBook() ? _bookAppointment : null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _canBook() && !bookingController.isLoading.value
                                    ? AppColors.primary
                                    : AppColors.border,
                            foregroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child:
                              bookingController.isLoading.value
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        'Booking...',
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Confirm Booking',
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
                    SizedBox(height: isTablet ? 30 : 24),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
    required bool isTablet,
    bool isOptional = false,
  }) {
    return Container(
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
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
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
              if (isOptional)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Optional',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          child,
        ],
      ),
    );
  }

  Widget _buildCartItemPreview(
    BuildContext context, {
    required CartItem cartItem,
    required bool isTablet,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 12 : 10),
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: isTablet ? 60 : 50,
            height: isTablet ? 60 : 50,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child:
                cartItem.product.imageUrl != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        cartItem.product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.shopping_bag,
                              size: isTablet ? 24 : 20,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    )
                    : Center(
                      child: Icon(
                        Icons.shopping_bag,
                        size: isTablet ? 24 : 20,
                        color: AppColors.textSecondary,
                      ),
                    ),
          ),
          SizedBox(width: isTablet ? 12 : 10),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 15,
                      tablet: 16,
                      desktop: 17,
                    ),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isTablet ? 6 : 4),
                Row(
                  children: [
                    Text(
                      'Qty: ${cartItem.quantity}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 13,
                          tablet: 14,
                          desktop: 14,
                        ),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: isTablet ? 12 : 8),
                    Text(
                      '×',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 13,
                          tablet: 14,
                          desktop: 14,
                        ),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: isTablet ? 12 : 8),
                    Text(
                      '\$${cartItem.product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 13,
                          tablet: 14,
                          desktop: 14,
                        ),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Total Price
          Text(
            '\$${cartItem.totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 18,
              ),
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isTablet,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(icon, color: AppColors.primary),
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
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
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
        ),
      ],
    );
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

  Future<void> _selectDateTime() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(const Duration(days: 3652)),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      isForce2Digits: false,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 650),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(Tween(begin: 0, end: 1)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierColor: const Color(0x80000000),
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
      type: OmniDateTimePickerType.dateAndTime,
      title: Text('Select Date & Time'),
      titleSeparator: Divider(),
      separator: SizedBox(height: 16),
      padding: EdgeInsets.all(16),
      insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      theme: ThemeData.light(),
    );

    if (dateTime != null && dateTime != selectedDateTime) {
      setState(() {
        selectedDateTime = dateTime;
      });
    }
  }

  bool _canBook() {
    return _customerNameController.text.isNotEmpty &&
        _customerPhoneController.text.isNotEmpty &&
        selectedService != null &&
        selectedDateTime != null;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_canBook()) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.secondary,
      );
      return;
    }

    final bookingDatetime = _formatDateTime(selectedDateTime!);

    // Prepare product information for booking
    final List<Map<String, dynamic>> products =
        cartController.cartItems.map((item) {
          return {'product_id': item.product.id, 'quantity': item.quantity};
        }).toList();

    final success = await bookingController.createBooking(
      customerName: _customerNameController.text.trim(),
      customerPhone: _customerPhoneController.text.trim(),
      serviceId: selectedService!.id,
      employeeId: selectedEmployee?.id,
      employeeName: selectedEmployee?.name,
      bookingDatetime: bookingDatetime,
      notes: _notesController.text.trim(),
      products: products.isNotEmpty ? products : null,
    );

    if (success) {
      final phoneNumber = _customerPhoneController.text.trim();
      final hadProducts = cartController.cartItems.isNotEmpty;

      // Clear cart after successful booking
      cartController.clearCart();

      // Refresh products to update stock availability
      if (hadProducts) {
        try {
          final productsCtrl = Get.find<ProductsController>();
          productsCtrl.fetchProducts();
        } catch (e) {
          // Products controller doesn't exist, that's okay
        }
      }

      Get.snackbar(
        'Success',
        'Appointment booked successfully!${hadProducts ? ' Products will be ready for pickup at the clinic.' : ''}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: AppColors.secondary,
        duration: const Duration(seconds: 3),
      );

      // Reset form
      setState(() {
        _customerNameController.clear();
        _customerPhoneController.clear();
        _notesController.clear();
        selectedService = null;
        selectedDateTime = null;
      });

      // Navigate to My Booking page with phone number
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.off(() => MyBookingPage(phoneNumber: phoneNumber));
      });
    } else {
      Get.snackbar(
        'Error',
        bookingController.errorMessage.value.isNotEmpty
            ? bookingController.errorMessage.value
            : 'Failed to book appointment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.secondary,
      );
    }
  }
}
