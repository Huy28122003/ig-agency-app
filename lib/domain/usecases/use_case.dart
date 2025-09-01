abstract class UseCase<T, P> {
  Future<T> call(P param);
}

abstract class StreamUseCase<ReturnType, Param> {
  Stream<ReturnType> call(Param param);
}

class NoParam {
  const NoParam();
}
