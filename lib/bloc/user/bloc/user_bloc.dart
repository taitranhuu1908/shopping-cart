import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopping_cart/services/auth_service.dart';
import 'package:shopping_cart/shared/UserShare.dart';

import '../../../model/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthService _authService = AuthService();
  UserBloc() : super(UserInitial(user: User(username: "", token: ""))) {
    on<UserLoginEvent>(_handleUserLogin);
    on<UserLogoutEvent>(_handleUserLogout);
  }

  void _handleUserLogin(UserLoginEvent event, Emitter<UserState> emit) async {
    User? user = await _authService.login(event.username, event.password);
    if (user != null) {
      UserShare.setTokenShare(user.token.toString());
      UserShare.setUsernameShare(user.username.toString());

      emit(UserInitial(user: user));
    }
  }

  void _handleUserLogout(UserLogoutEvent event, Emitter<UserState> emit) async {
    await UserShare.removeUsername();
    await UserShare.removeToken();
    emit(UserInitial(user: User(username: "")));
  }
}
