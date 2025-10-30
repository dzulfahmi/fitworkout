// --- Model untuk Tabel Workouts (Fitur 1) ---
const String tableWorkouts = 'workouts';

class WorkoutFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String youtubeLink = 'youtubeLink';
  static const String notes = 'notes';

  static final List<String> values = [
    id,
    name,
    description,
    youtubeLink,
    notes
  ];
}

class WorkoutModel {
  final int? id;
  final String name;
  final String? description;
  final String? youtubeLink;
  final String? notes;

  const WorkoutModel({
    this.id,
    required this.name,
    this.description,
    this.youtubeLink,
    this.notes,
  });

  WorkoutModel copy({
    int? id,
    String? name,
    String? description,
    String? youtubeLink,
    String? notes,
  }) =>
      WorkoutModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        youtubeLink: youtubeLink ?? this.youtubeLink,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toMap() => {
        WorkoutFields.id: id,
        WorkoutFields.name: name,
        WorkoutFields.description: description,
        WorkoutFields.youtubeLink: youtubeLink,
        WorkoutFields.notes: notes,
      };

  static WorkoutModel fromMap(Map<String, dynamic> map) => WorkoutModel(
        id: map[WorkoutFields.id] as int?,
        name: map[WorkoutFields.name] as String,
        description: map[WorkoutFields.description] as String?,
        youtubeLink: map[WorkoutFields.youtubeLink] as String?,
        notes: map[WorkoutFields.notes] as String?,
      );
}

// --- Model untuk Tabel WorkoutPlans (Fitur 2) ---
const String tableWorkoutPlans = 'workoutPlans';

class WorkoutPlanFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';

  static final List<String> values = [id, name, description];
}

class WorkoutPlan {
  final int? id;
  final String name;
  final String? description;

  const WorkoutPlan({
    this.id,
    required this.name,
    this.description,
  });

  WorkoutPlan copy({
    int? id,
    String? name,
    String? description,
  }) =>
      WorkoutPlan(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  Map<String, dynamic> toMap() => {
        WorkoutPlanFields.id: id,
        WorkoutPlanFields.name: name,
        WorkoutPlanFields.description: description,
      };

  static WorkoutPlan fromMap(Map<String, dynamic> map) => WorkoutPlan(
        id: map[WorkoutPlanFields.id] as int?,
        name: map[WorkoutPlanFields.name] as String,
        description: map[WorkoutPlanFields.description] as String?,
      );
}

// --- Model untuk Tabel PlanWorkouts (Fitur 3) ---
const String tablePlanWorkouts = 'planWorkouts';

class PlanWorkoutFields {
  static const String id = '_id';
  static const String planId = 'planId';
  static const String workoutId = 'workoutId';
  static const String targetSets = 'targetSets';
  static const String targetRepMin = 'targetRepMin';
  static const String targetRepMax = 'targetRepMax';

  static final List<String> values = [
    id,
    planId,
    workoutId,
    targetSets,
    targetRepMin,
    targetRepMax
  ];
}

class PlanWorkout {
  final int? id;
  final int planId;
  final int workoutId;
  final int targetSets;
  final int targetRepMin;
  final int targetRepMax;

  const PlanWorkout({
    this.id,
    required this.planId,
    required this.workoutId,
    required this.targetSets,
    required this.targetRepMin,
    required this.targetRepMax,
  });

   PlanWorkout copy({
    int? id,
    int? planId,
    int? workoutId,
    int? targetSets,
    int? targetRepMin,
    int? targetRepMax,
  }) =>
      PlanWorkout(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        workoutId: workoutId ?? this.workoutId,
        targetSets: targetSets ?? this.targetSets,
        targetRepMin: targetRepMin ?? this.targetRepMin,
        targetRepMax: targetRepMax ?? this.targetRepMax,
      );

  Map<String, dynamic> toMap() => {
        PlanWorkoutFields.id: id,
        PlanWorkoutFields.planId: planId,
        PlanWorkoutFields.workoutId: workoutId,
        PlanWorkoutFields.targetSets: targetSets,
        PlanWorkoutFields.targetRepMin: targetRepMin,
        PlanWorkoutFields.targetRepMax: targetRepMax,
      };

  static PlanWorkout fromMap(Map<String, dynamic> map) => PlanWorkout(
        id: map[PlanWorkoutFields.id] as int?,
        planId: map[PlanWorkoutFields.planId] as int,
        workoutId: map[PlanWorkoutFields.workoutId] as int,
        targetSets: map[PlanWorkoutFields.targetSets] as int,
        targetRepMin: map[PlanWorkoutFields.targetRepMin] as int,
        targetRepMax: map[PlanWorkoutFields.targetRepMax] as int,
      );
}

// --- Model untuk Tabel WorkoutSessions (Fitur 4) ---
const String tableWorkoutSessions = 'workoutSessions';

class WorkoutSessionFields {
  static const String id = '_id';
  static const String planId = 'planId';
  static const String date = 'date'; // Simpan sebagai ISO 8601 String
  static const String notes = 'notes';

  static final List<String> values = [id, planId, date, notes];
}

class WorkoutSession {
  final int? id;
  final int planId;
  final DateTime date;
  final String? notes;

  const WorkoutSession({
    this.id,
    required this.planId,
    required this.date,
    this.notes,
  });

  WorkoutSession copy({
    int? id,
    int? planId,
    DateTime? date,
    String? notes,
  }) =>
      WorkoutSession(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        date: date ?? this.date,
        notes: notes ?? this.notes,
      );


  Map<String, dynamic> toMap() => {
        WorkoutSessionFields.id: id,
        WorkoutSessionFields.planId: planId,
        WorkoutSessionFields.date: date.toIso8601String(),
        WorkoutSessionFields.notes: notes,
      };

  static WorkoutSession fromMap(Map<String, dynamic> map) => WorkoutSession(
        id: map[WorkoutSessionFields.id] as int?,
        planId: map[WorkoutSessionFields.planId] as int,
        date: DateTime.parse(map[WorkoutSessionFields.date] as String),
        notes: map[WorkoutSessionFields.notes] as String?,
      );
}

// --- Model untuk Tabel SessionLogs (Fitur 4) ---
const String tableSessionLogs = 'sessionLogs';

class SessionLogFields {
  static const String id = '_id';
  static const String sessionId = 'sessionId';
  static const String workoutId = 'workoutId';
  static const String setNumber = 'setNumber';
  static const String repsDone = 'repsDone';
  static const String weight = 'weight'; // Opsional
  static const String notes = 'notes'; // Opsional

  static final List<String> values = [
    id,
    sessionId,
    workoutId,
    setNumber,
    repsDone,
    weight,
    notes
  ];
}

class SessionLog {
  final int? id;
  final int sessionId;
  final int workoutId;
  final int setNumber;
  final int repsDone;
  final double? weight;
  final String? notes;

  const SessionLog({
    this.id,
    required this.sessionId,
    required this.workoutId,
    required this.setNumber,
    required this.repsDone,
    this.weight,
    this.notes,
  });

  SessionLog copy({
    int? id,
    int? sessionId,
    int? workoutId,
    int? setNumber,
    int? repsDone,
    double? weight,
    String? notes,
  }) =>
      SessionLog(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        workoutId: workoutId ?? this.workoutId,
        setNumber: setNumber ?? this.setNumber,
        repsDone: repsDone ?? this.repsDone,
        weight: weight ?? this.weight,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toMap() => {
        SessionLogFields.id: id,
        SessionLogFields.sessionId: sessionId,
        SessionLogFields.workoutId: workoutId,
        SessionLogFields.setNumber: setNumber,
        SessionLogFields.repsDone: repsDone,
        SessionLogFields.weight: weight,
        SessionLogFields.notes: notes,
      };

  static SessionLog fromMap(Map<String, dynamic> map) => SessionLog(
        id: map[SessionLogFields.id] as int?,
        sessionId: map[SessionLogFields.sessionId] as int,
        workoutId: map[SessionLogFields.workoutId] as int,
        setNumber: map[SessionLogFields.setNumber] as int,
        repsDone: map[SessionLogFields.repsDone] as int,
        weight: map[SessionLogFields.weight] as double?,
        notes: map[SessionLogFields.notes] as String?,
      );
}

// Model ini BUKAN tabel, tapi view-model untuk menampung
// data hasil JOIN query antara Session dan Plan
class SessionHistoryViewModel {
  final int sessionId;
  final int planId;
  final String planName;
  final DateTime sessionDate;

  SessionHistoryViewModel({
    required this.sessionId,
    required this.planId,
    required this.planName,
    required this.sessionDate,
  });

  factory SessionHistoryViewModel.fromMap(Map<String, dynamic> json) => SessionHistoryViewModel(
        sessionId: json['sessionId'] as int,
        planId: json['planId'] as int,
        planName: json['planName'] as String,
        sessionDate: DateTime.parse(json['sessionDate'] as String),
        // sessionDate: DateTime.parse(json[WorkoutSessionFields.date] as String),
      );
}

class PlanWorkoutViewModel {
  final int planWorkoutId; // ID dari tabel junction (PlanWorkout)
  final int workoutId;      // ID dari tabel Workout
  final String workoutName;
  final String? workoutDescription;
  final int sets;
  final int repMin;
  final int repMax;

  PlanWorkoutViewModel({
    required this.planWorkoutId,
    required this.workoutId,
    required this.workoutName,
    this.workoutDescription,
    required this.sets,
    required this.repMin,
    required this.repMax,
  });

  // Factory untuk membuat dari hasil query SQL JOIN
  factory PlanWorkoutViewModel.fromMap(Map<String, dynamic> json) => PlanWorkoutViewModel(
        // Nama alias HARUS SAMA PERSIS dengan di query SQL
        planWorkoutId: json['planWorkoutId'] as int,
        workoutId: json['workoutId'] as int,
        workoutName: json[WorkoutFields.name] as String,
        workoutDescription: json[WorkoutFields.description] as String?,
        sets: json[PlanWorkoutFields.targetSets] as int,
        repMin: json[PlanWorkoutFields.targetRepMin] as int,
        repMax: json[PlanWorkoutFields.targetRepMax] as int,
      );
}