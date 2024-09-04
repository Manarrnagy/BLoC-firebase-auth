import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_one_think/data/dummy_user_model.dart';

import '../../data/firestore_service.dart';

part 'dummy_user_event.dart';
part 'dummy_user_state.dart';

class DummyUserBloc extends Bloc<DummyUserEvent, DummyUserState> {
  final FirestoreService _firestoreService;
  DummyUserBloc(this._firestoreService) : super(DummyUserInitial()) {
    on<LoadUsers>((event, emit) async {
      try {
        emit(DummyUserLoading());
        final users = await _firestoreService.getUsers().first;
        emit(DummyUserLoaded(users));
      } catch (e) {
        print(e.toString());
        emit(DummyUserError('Failed to load todos.'));
      }
    });
  }
}
