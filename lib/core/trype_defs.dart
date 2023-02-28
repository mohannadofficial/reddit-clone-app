import 'package:dartz/dartz.dart';
import 'package:reddit_app/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
