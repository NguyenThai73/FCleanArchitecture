# Design System

## Overview
Hệ thống thiết kế tập trung để quản lý colors, text styles, và dimensions cho toàn bộ ứng dụng.

## Files

### 1. app_colors.dart
Quản lý tất cả màu sắc trong ứng dụng:

- **Primary Colors**: primary, primaryLight, primaryDark
- **Secondary Colors**: secondary, secondaryLight, secondaryDark
- **Accent Colors**: accent, accentLight, accentDark
- **Text Colors**: textPrimary, textSecondary, textHint, textDisabled, textWhite
- **Background Colors**: background, backgroundLight, backgroundDark
- **Surface Colors**: surface, surfaceLight, surfaceDark
- **Border Colors**: border, borderLight, borderDark
- **Status Colors**: success, warning, error, info
- **Grey Scale**: grey50 to grey900
- **Gradients**: primaryGradient, secondaryGradient, accentGradient

**Dark Theme**: Sử dụng class `AppColorsDark` cho dark mode.

**Sử dụng**:
```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)

// Với opacity
Container(
  color: AppColors.primaryWithOpacity(0.5),
)
```

### 2. app_text_styles.dart
Quản lý tất cả text styles theo Material Design 3:

- **Display Styles**: displayLarge, displayMedium, displaySmall
- **Headline Styles**: headlineLarge, headlineMedium, headlineSmall
- **Title Styles**: titleLarge, titleMedium, titleSmall
- **Body Styles**: bodyLarge, bodyMedium, bodySmall
- **Label Styles**: labelLarge, labelMedium, labelSmall
- **Custom Styles**: button, buttonSmall, caption, overline, hint, error
- **Input Styles**: inputLabel, inputText, inputHint
- **Link Style**: link
- **Price Styles**: priceLarge, priceMedium, priceSmall

**Dark Theme**: Sử dụng class `AppTextStylesDark` cho dark mode.

**Sử dụng**:
```dart
Text(
  'Tiêu đề',
  style: AppTextStyles.headlineLarge,
)

Text(
  'Nội dung',
  style: AppTextStyles.bodyMedium,
)

// Kết hợp với màu khác
Text(
  'Custom',
  style: AppTextStyles.bodyLarge.copyWith(
    color: AppColors.primary,
  ),
)
```

### 3. app_dimensions.dart
Quản lý tất cả kích thước và spacing:

- **Spacing**: spacing4, spacing8, spacing12, spacing16, spacing20, spacing24, spacing32, spacing40, spacing48, spacing56, spacing64
- **Padding**: paddingXs, paddingSm, paddingMd, paddingLg, paddingXl
- **Margin**: marginXs, marginSm, marginMd, marginLg, marginXl
- **Border Radius**: radiusXs, radiusSm, radiusMd, radiusLg, radiusXl, radiusCircle
- **Icon Sizes**: iconXs, iconSm, iconMd, iconLg, iconXl, iconXxl
- **Button Heights**: buttonHeightSm, buttonHeightMd, buttonHeightLg
- **Input Heights**: inputHeightSm, inputHeightMd, inputHeightLg
- **Avatar Sizes**: avatarXs, avatarSm, avatarMd, avatarLg, avatarXl, avatarXxl
- **Image Sizes**: imageXs, imageSm, imageMd, imageLg, imageXl
- **Breakpoints**: mobileWidth, tabletWidth, desktopWidth

**Sử dụng**:
```dart
Container(
  padding: EdgeInsets.all(AppDimensions.paddingMd),
  margin: EdgeInsets.symmetric(vertical: AppDimensions.marginLg),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
  ),
  child: Icon(
    Icons.home,
    size: AppDimensions.iconMd,
  ),
)
```

### 4. app_theme.dart
Kết hợp tất cả colors, text styles, và dimensions để tạo theme hoàn chỉnh.

**Sử dụng**:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
)
```

## Best Practices

1. **Luôn sử dụng constants từ design system** thay vì hard-code values
2. **Không tạo màu mới** mà không thêm vào app_colors.dart
3. **Sử dụng text styles có sẵn** trước khi tạo custom styles
4. **Spacing nhất quán** bằng cách dùng AppDimensions
5. **Dark mode support** bằng cách sử dụng AppColorsDark và AppTextStylesDark

## Examples

### Tạo một Card đơn giản
```dart
Card(
  color: AppColors.surface,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
  ),
  child: Padding(
    padding: EdgeInsets.all(AppDimensions.paddingMd),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: AppTextStyles.titleLarge,
        ),
        SizedBox(height: AppDimensions.spacing8),
        Text(
          'Description text here',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    ),
  ),
)
```

### Tạo một Button với gradient
```dart
Container(
  height: AppDimensions.buttonHeightMd,
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
  ),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    child: Text(
      'Gradient Button',
      style: AppTextStyles.button,
    ),
  ),
)
```
