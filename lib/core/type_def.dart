import 'package:fpdart/fpdart.dart';
import 'package:my_flutter_app/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FuturVoid = FutureEither<void>;
