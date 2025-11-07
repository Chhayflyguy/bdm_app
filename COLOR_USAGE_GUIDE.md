# AppColors Usage Guide

## Your Custom Color Palette

### Primary Colors
- **Primary**: `Color.fromARGB(255, 31, 74, 193)` - Your main brand color
- **Primary Dark**: `Color.fromARGB(255, 20, 50, 130)` - Darker variant
- **Primary Light**: `Color.fromARGB(255, 60, 100, 220)` - Lighter variant

### Secondary Colors
- **Secondary**: `Colors.white` - Your secondary color
- **Secondary Dark**: `Color.fromARGB(255, 245, 245, 245)` - Off-white

## How to Use

### 1. Import the colors
```dart
import 'widget/color.dart';
```

### 2. Use in your widgets
```dart
// Text with primary color
Text(
  'Hello World',
  style: TextStyle(color: AppColors.primary),
)

// Background with secondary color
Container(
  color: AppColors.secondary,
  child: Text('Content'),
)

// AppBar with primary background
AppBar(
  backgroundColor: AppColors.primary,
  foregroundColor: AppColors.secondary,
)
```

### 3. Available Colors

#### Primary Colors
```dart
AppColors.primary        // Main brand color
AppColors.primaryDark   // Darker variant
AppColors.primaryLight  // Lighter variant
```

#### Secondary Colors
```dart
AppColors.secondary      // White
AppColors.secondaryDark  // Off-white
```

#### Accent Colors
```dart
AppColors.accent        // Amber
AppColors.accentDark    // Orange
```

#### Background Colors
```dart
AppColors.background    // White background
AppColors.surface       // Light gray surface
AppColors.cardBackground // Card background
```

#### Text Colors
```dart
AppColors.textPrimary   // Dark text
AppColors.textSecondary // Medium gray text
AppColors.textLight     // Light gray text
```

#### Status Colors
```dart
AppColors.success       // Green
AppColors.warning       // Yellow
AppColors.error         // Red
AppColors.info          // Blue
```

#### Border Colors
```dart
AppColors.border        // Medium gray border
AppColors.borderLight   // Light gray border
```

### 4. Gradients
```dart
// Primary gradient
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
)

// Background gradient
Container(
  decoration: BoxDecoration(
    gradient: AppColors.backgroundGradient,
  ),
)
```

### 5. Helper Methods
```dart
// Add opacity
AppColors.withOpacity(AppColors.primary, 0.5)

// Lighten color
AppColors.lighten(AppColors.primary, 0.2)

// Darken color
AppColors.darken(AppColors.primary, 0.2)
```

## Theme Integration

Your colors are already integrated into the app theme in `main.dart`:

- **Primary Color**: Used for AppBars, buttons, and accents
- **Secondary Color**: Used for text on primary backgrounds
- **Background**: Used for scaffold backgrounds
- **Cards**: Used for card backgrounds

## Examples

### Button
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Click Me'),
  // Uses AppColors.primary automatically from theme
)
```

### Card
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Card content'),
  ),
  // Uses AppColors.cardBackground automatically
)
```

### Custom Container
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppColors.surface,
    border: Border.all(color: AppColors.border),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    'Custom container',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

### Snackbar
```dart
Get.snackbar(
  'Title',
  'Message',
  backgroundColor: AppColors.primary,
  colorText: AppColors.secondary,
)
```

This color system ensures consistency across your entire Booking BDM app!
