import 'dart:async';

import 'package:bitcoin_news/models/news_model.dart';
import 'package:bloc/bloc.dart';

import '../services/http_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<NewsModel> userList = [];
  int currentPage = 1;

  HomeBloc() : super(HomeInitialState()) {
    on<LoadNewsListEvent>(_onLoadNewsListEvent);
  }

  Future<void> _onLoadNewsListEvent(
    LoadNewsListEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());

    var response = await Network.getRequest(Network.API_NEWS_LIST, Network.paramsNewsList(currentPage));
    if (response != null) {
      var users = Network.parseNewsList(response).articles;
      userList.addAll(users);
      currentPage++;
      emit(HomeLoadedNewsListState(userList));
    } else {
      emit(HomeErrorState("Fetch Users Error"));
    }
  }
}
