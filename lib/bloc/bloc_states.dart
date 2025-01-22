// FOR POST APIs

abstract class BlocStates {}

class Initial extends BlocStates {}

class ValidationCheck extends BlocStates {
  final String? value;

  ValidationCheck(this.value);
}

class Loading extends BlocStates {}

class Loaded extends BlocStates {}

class NextScreen extends BlocStates {}

class Error extends BlocStates {
  final String? error;

  Error(this.error);
}
