# GetX Navigation Guide

## How to Add New Pages and Routes

### 1. Create a New Page
Create your new page file in `lib/screen/` directory:
```dart
// lib/screen/new_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Page')),
      body: const Center(
        child: Text('This is a new page!'),
      ),
    );
  }
}
```

### 2. Add Route to app_routes.dart
```dart
// lib/routes/app_routes.dart
import '../screen/new_page.dart';

class AppRoutes {
  static const String newPage = '/new-page';
  
  static List<GetPage> routes = [
    // ... existing routes
    GetPage(
      name: newPage,
      page: () => const NewPage(),
    ),
  ];
}
```

### 3. Navigation Methods

#### Basic Navigation
```dart
// Navigate to a new page (push)
Get.toNamed('/new-page');

// Navigate with route constant
Get.toNamed(AppRoutes.newPage);
```

#### Navigation with Arguments
```dart
// Pass data to the new page
Get.toNamed('/new-page', arguments: {
  'userId': 123,
  'userName': 'John Doe',
});

// In the new page, receive arguments
final args = Get.arguments;
final userId = args['userId'];
final userName = args['userName'];
```

#### Different Navigation Types
```dart
// 1. Push (add to stack)
Get.toNamed('/new-page');

// 2. Replace current page
Get.offNamed('/new-page');

// 3. Replace all pages and go to new page
Get.offAllNamed('/new-page');

// 4. Go back
Get.back();

// 5. Go back with result
Get.back(result: 'some data');

// 6. Navigate and clear all previous routes
Get.offAllNamed('/new-page');
```

#### Navigation with Transitions
```dart
Get.toNamed(
  '/new-page',
  transition: Transition.fadeIn,
  duration: const Duration(milliseconds: 300),
);

// Available transitions:
// Transition.fadeIn
// Transition.fadeOut
// Transition.leftToRight
// Transition.rightToLeft
// Transition.upToDown
// Transition.downToUp
// Transition.scale
// Transition.rotate
// Transition.size
// Transition.rightToLeftWithFade
// Transition.leftToRightWithFade
```

#### Navigation with Middleware
```dart
GetPage(
  name: '/protected-page',
  page: () => const ProtectedPage(),
  middlewares: [AuthMiddleware()],
),
```

### 4. Complete Example

#### Step 1: Create the page
```dart
// lib/screen/settings_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Center(
        child: Text('Settings Page'),
      ),
    );
  }
}
```

#### Step 2: Add to routes
```dart
// lib/routes/app_routes.dart
import '../screen/settings_page.dart';

class AppRoutes {
  static const String settings = '/settings';
  
  static List<GetPage> routes = [
    // ... existing routes
    GetPage(
      name: settings,
      page: () => const SettingsPage(),
    ),
  ];
}
```

#### Step 3: Navigate to it
```dart
// From any widget
ElevatedButton(
  onPressed: () => Get.toNamed(AppRoutes.settings),
  child: const Text('Go to Settings'),
),
```

### 5. Advanced Features

#### Named Routes with Parameters
```dart
// Define route with parameter
GetPage(
  name: '/user/:id',
  page: () => const UserProfilePage(),
),

// Navigate with parameter
Get.toNamed('/user/123');

// Get parameter in the page
final userId = Get.parameters['id'];
```

#### Nested Routes
```dart
GetPage(
  name: '/dashboard',
  page: () => const DashboardPage(),
  children: [
    GetPage(
      name: '/profile',
      page: () => const ProfilePage(),
    ),
    GetPage(
      name: '/settings',
      page: () => const SettingsPage(),
    ),
  ],
),
```

This guide covers all the essential navigation patterns you'll need for your GetX project!
