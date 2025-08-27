import '../../shared/commons/result.dart';

abstract class UseCase<ReturnType, Param> {
  Future<Result<ReturnType>> call(Param param);
}

abstract class StreamUseCase<ReturnType, Param> {
  Stream<ReturnType> call(Param param);
}
