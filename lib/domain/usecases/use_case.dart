import '../../shared/commons/result.dart';

abstract class UseCase<ReturnType, Param> {
  Future<Result<ReturnType>> call(Param param);
}
