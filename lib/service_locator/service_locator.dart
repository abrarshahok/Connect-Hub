import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/posts/presentation/bloc/posts_bloc.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';

class ServiceLocator {
  static final GetIt instance = GetIt.instance;
  static void setupLocators() {
    instance
      ..registerSingleton<AuthBloc>(AuthBloc())
      ..registerSingleton<HomeBloc>(HomeBloc())
      ..registerSingleton<PostsBloc>(PostsBloc())
      ..registerSingleton<ProfileBloc>(ProfileBloc());
  }
}
