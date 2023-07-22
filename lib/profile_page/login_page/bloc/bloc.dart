import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState>{
  LoginPageBloc(this.repo) : super(LoginPageState()){}

  final ServerRepo repo;
}