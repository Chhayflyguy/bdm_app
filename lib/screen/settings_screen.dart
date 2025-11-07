import 'package:flutter/material.dart';
import '../widget/color.dart';
import '../widget/responsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getPadding(context),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getConstrainedWidth(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: isTablet ? 40 : 30),
              
              // Profile Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 18,
                            tablet: 20,
                            desktop: 22,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: isTablet ? 35 : 30,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              size: isTablet ? 35 : 30,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: isTablet ? 20 : 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'John Doe',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      mobile: 16,
                                      tablet: 18,
                                      desktop: 18,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'john.doe@example.com',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      mobile: 14,
                                      tablet: 16,
                                      desktop: 16,
                                    ),
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: AppColors.primary,
                              size: ResponsiveHelper.getIconSize(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: isTablet ? 24 : 20),
              
              // Preferences Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 18,
                            tablet: 20,
                            desktop: 22,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      
                      // Notifications
                      ListTile(
                        leading: Icon(
                          Icons.notifications,
                          color: AppColors.primary,
                          size: ResponsiveHelper.getIconSize(context),
                        ),
                        title: Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 18,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Receive booking updates',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 16,
                            ),
                          ),
                        ),
                        trailing: Switch(
                          value: notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              notificationsEnabled = value;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      const Divider(),
                      
                      // Dark Mode
                      ListTile(
                        leading: Icon(
                          Icons.dark_mode,
                          color: AppColors.primary,
                          size: ResponsiveHelper.getIconSize(context),
                        ),
                        title: Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 18,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Switch to dark theme',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 16,
                            ),
                          ),
                        ),
                        trailing: Switch(
                          value: darkModeEnabled,
                          onChanged: (value) {
                            setState(() {
                              darkModeEnabled = value;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      const Divider(),
                      
                      // Language
                      ListTile(
                        leading: Icon(
                          Icons.language,
                          color: AppColors.primary,
                          size: ResponsiveHelper.getIconSize(context),
                        ),
                        title: Text(
                          'Language',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 18,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          selectedLanguage,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 16,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: isTablet ? 18 : 16,
                        ),
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          _showLanguageDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: isTablet ? 24 : 20),
              
              // Support Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Support',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 18,
                            tablet: 20,
                            desktop: 22,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      
                      _buildSettingsItem(
                        context,
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        onTap: () {},
                      ),
                      
                      const Divider(),
                      
                      _buildSettingsItem(
                        context,
                        icon: Icons.contact_support,
                        title: 'Contact Us',
                        onTap: () {},
                      ),
                      
                      const Divider(),
                      
                      _buildSettingsItem(
                        context,
                        icon: Icons.info_outline,
                        title: 'About',
                        onTap: () {},
                      ),
                      
                      const Divider(),
                      
                      _buildSettingsItem(
                        context,
                        icon: Icons.logout,
                        title: 'Sign Out',
                        onTap: () {
                          _showSignOutDialog();
                        },
                        textColor: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 30 : 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    final isTablet = ResponsiveHelper.isTablet(context);
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppColors.primary,
        size: ResponsiveHelper.getIconSize(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimary,
          fontSize: ResponsiveHelper.getFontSize(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 18,
          ),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: isTablet ? 18 : 16,
      ),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('Spanish'),
                value: 'Spanish',
                groupValue: selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('French'),
                value: 'French',
                groupValue: selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle sign out logic here
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
