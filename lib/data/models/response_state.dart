sealed class ResponseState {}

class Initial extends ResponseState {
  Initial();
}

class Loading extends ResponseState {
  Loading();
}

class Success<T> extends ResponseState {
  final T data;
  Success(this.data);
}

class Error extends ResponseState {
  final String message;
  Error(this.message);
}
