# NeuroTrace AI - Architecture Documentation

##  Architecture Pattern

This project follows **Clean Architecture** principles with separation of concerns:

```
┌─────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER                   │
│  (UI, Screens, Widgets, State Management)           │
│  ├── Screens (Views)                                │
│  ├── Widgets (UI Components)                        │
│  └── Providers (State Management with Provider)     │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│                   DOMAIN LAYER                       │
│         (Business Logic, Use Cases, Entities)        │
│  ├── Entities (Core business objects)               │
│  └── Use Cases (Business operations)                │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│                    DATA LAYER                        │
│   (Models, Repositories, API, Local Storage)         │
│  ├── Models (Data transfer objects)                 │
│  ├── Repositories (Data access abstraction)         │
│  ├── Services (API, Storage)                        │
│  └── Data Sources (Remote & Local)                  │
└─────────────────────────────────────────────────────┘
```

---

##  Folder Structure Details

### `lib/core/`
**Purpose:** Shared utilities, constants, and configurations used across the app.

```
core/
├── constants/
│   ├── app_constants.dart      # Global constants (timeouts, URLs, etc.)
│   └── api_endpoints.dart      # API endpoint definitions
├── theme/
│   ├── app_colors.dart         # Color palette
│   ├── app_text_styles.dart    # Typography
│   └── app_theme.dart          # ThemeData configuration
├── utils/
│   ├── logger.dart             # Logging utility
│   └── validators.dart         # Form validation
└── routes/
    └── app_router.dart         # Navigation configuration
```

### `lib/data/`
**Purpose:** Data management, API communication, and persistence.

```
data/
├── models/                     # Data models (JSON serializable)
│   ├── user.dart              # User model
│   ├── test_result.dart       # Test result models
│   ├── risk_assessment.dart   # Risk assessment model
│   └── survey.dart            # Survey models
├── services/                   # Service layer
│   ├── api_service.dart       # HTTP client wrapper (Dio)
│   └── storage_service.dart   # Local storage (SharedPreferences)
├── repositories/               # Repository pattern implementation
│   ├── test_repository.dart   # Test data operations
│   ├── user_repository.dart   # User data operations
│   └── survey_repository.dart # Survey data operations
└── data_sources/               # Data source abstraction
    ├── remote/                # API data sources
    └── local/                 # Local database sources
```

### `lib/domain/`
**Purpose:** Business logic independent of frameworks.

```
domain/
├── entities/                   # Core business objects
│   ├── test_entity.dart       # Test entity
│   └── assessment_entity.dart # Assessment entity
└── use_cases/                  # Business operations
    ├── submit_test_use_case.dart
    ├── calculate_risk_use_case.dart
    └── get_results_use_case.dart
```

### `lib/presentation/`
**Purpose:** UI layer with screens, widgets, and state management.

```
presentation/
├── screens/                    # Full-screen views
│   ├── home/
│   │   └── home_screen.dart
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── tests/
│   │   ├── reaction_time/
│   │   │   ├── reaction_time_screen.dart
│   │   │   └── reaction_time_provider.dart
│   │   ├── cognitive/
│   │   ├── motor/
│   │   └── speech/
│   ├── survey/
│   ├── results/
│   └── profile/
├── widgets/                    # Reusable UI components
│   ├── common/
│   │   ├── custom_button.dart
│   │   ├── loading_indicator.dart
│   │   └── error_widget.dart
│   └── test_widgets/
│       ├── timer_widget.dart
│       └── score_card.dart
└── providers/                  # State management
    ├── auth_provider.dart
    ├── test_provider.dart
    └── results_provider.dart
```

---

## 🔄 Data Flow

### Example: Submitting a Reaction Time Test

1. **User Action (Presentation)**
   ```dart
   // reaction_time_screen.dart
   ElevatedButton(
     onPressed: () => provider.submitTest(result),
   )
   ```

2. **Provider Updates State (Presentation)**
   ```dart
   // reaction_time_provider.dart
   Future<void> submitTest(ReactionTimeResult result) async {
     setLoading(true);
     final useCase = SubmitTestUseCase(repository);
     final response = await useCase.execute(result);
     setLoading(false);
   }
   ```

3. **Use Case Executes Business Logic (Domain)**
   ```dart
   // submit_test_use_case.dart
   Future<Response> execute(TestResult result) async {
     // Validate result
     // Calculate metrics
     return await repository.submitTest(result);
   }
   ```

4. **Repository Manages Data (Data)**
   ```dart
   // test_repository.dart
   Future<Response> submitTest(TestResult result) async {
     // Try remote first
     try {
       return await remoteDataSource.submitTest(result);
     } catch (e) {
       // Fallback to local storage
       return await localDataSource.saveTest(result);
     }
   }
   ```

5. **Service Makes API Call (Data)**
   ```dart
   // api_service.dart
   Future<Response> post(endpoint, data: result.toJson());
   ```

---

##  State Management Strategy

### Provider Pattern
We use **Provider** for state management with the following structure:

```dart
class TestProvider extends ChangeNotifier {
  TestState _state = TestState.initial();
  
  TestState get state => _state;
  
  Future<void> performAction() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();
    
    // Perform operation
    final result = await repository.fetchData();
    
    _state = _state.copyWith(
      isLoading: false,
      data: result,
    );
    notifyListeners();
  }
}
```

### Provider Types
- **ChangeNotifierProvider** - For mutable state
- **Provider** - For dependency injection (services)
- **StreamProvider** - For real-time data streams
- **FutureProvider** - For async operations

---

##  Security Architecture

### Data Encryption
```dart
// Sensitive data stored securely
FlutterSecureStorage()
  .write(key: 'auth_token', value: token);

// Regular data in SharedPreferences
SharedPreferences.setString('user_id', id);
```

### API Security
```dart
// All API calls include:
- HTTPS/TLS encryption
- JWT token authentication
- Request/response validation
```

### Local Storage
```dart
// User data encrypted at rest
// Audio files stored with unique IDs
// Temporary data cleared on logout
```

---

##  Screen Flow

```
Splash Screen
     ↓
Onboarding (First Time) → Home Screen ← Login/Register
     ↓                         ↓
     └─────────────────────────┘
                ↓
         Home Dashboard
         ├── Reaction Time Test → Results
         ├── Cognitive Test → Results
         ├── Motor Test → Results
         ├── Speech Test → Results
         ├── Exposure Survey → Results
         └── View All Results
                ↓
         Risk Assessment
         ├── Risk Score Display
         ├── Category Breakdown
         ├── Recommendations
         └── Historical Trends
```

---

##  Test Types Implementation

### 1. Reaction Time Test
- **Purpose:** Measure response latency
- **Duration:** ~2 minutes
- **Metrics:** Average time, standard deviation, accuracy
- **UI:** Full-screen stimulus, tap to respond

### 2. Cognitive Test (N-back)
- **Purpose:** Assess working memory
- **Duration:** 3-5 minutes
- **Metrics:** Correct responses, reaction times
- **UI:** Sequence display, recall interface

### 3. Motor Control Test
- **Purpose:** Evaluate fine motor skills
- **Duration:** 1-2 minutes
- **Metrics:** Precision, speed, smoothness
- **UI:** Path tracing, tapping targets

### 4. Speech Analysis
- **Purpose:** Voice biomarker assessment
- **Duration:** 30 seconds
- **Metrics:** Pitch, jitter, shimmer, MFCCs
- **UI:** Recording interface, waveform display

---

##  API Integration

### Endpoint Structure
```
BASE_URL/v1/
├── /auth
│   ├── POST /login
│   ├── POST /register
│   └── POST /refresh
├── /tests
│   ├── POST /reaction-time
│   ├── POST /cognitive
│   ├── POST /motor
│   └── POST /speech
├── /survey
│   ├── GET /questions
│   └── POST /submit
└── /results
    ├── GET /risk-score
    ├── GET /history
    └── GET /analysis
```

### Request/Response Format
```json
// Request
{
  "user_id": "uuid",
  "test_type": "reaction_time",
  "data": {
    "reaction_times": [245, 312, 289],
    "timestamp": "2026-01-16T10:30:00Z"
  }
}

// Response
{
  "status": "success",
  "result": {
    "test_id": "uuid",
    "score": 87.5,
    "analysis": {...}
  }
}
```

---

##  Performance Optimization

### Lazy Loading
- Screens loaded on-demand
- Images cached with `cached_network_image`
- Audio files streamed when possible

### State Management
- Only rebuild affected widgets
- Use `const` constructors where possible
- Implement `shouldRebuild` for complex providers

### Network
- Request caching with Dio interceptors
- Batch API calls when possible
- Queue offline requests

---

##  Analytics & Logging

### Logger Levels
```dart
AppLogger.debug('Debug information');
AppLogger.info('General information');
AppLogger.warning('Warning message');
AppLogger.error('Error occurred', error);
```

### Analytics Events
- Test started/completed
- Survey submitted
- Results viewed
- App opened/closed

---

##  Offline Support

### Strategy
1. **Cache API responses** in local database
2. **Queue offline actions** for later sync
3. **Show cached data** when offline
4. **Sync automatically** when connection restored

---

##  Dependencies Justification

| Package | Purpose | Alternative Considered |
|---------|---------|----------------------|
| provider | State management | Bloc, Riverpod |
| go_router | Declarative routing | AutoRoute |
| dio | HTTP client | http package |
| shared_preferences | Simple storage | Hive |
| flutter_secure_storage | Sensitive data | encrypted_shared_preferences |
| record | Audio recording | audio_recorder |
| fl_chart | Data visualization | syncfusion_charts |
| logger | Logging | print statements |

---

##  Learning Resources

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

---

**Last Updated:** January 16, 2026
