import 'package:bitcoin_news/models/news_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class HomeState extends Equatable{

}

class HomeInitialState extends HomeState{
  @override
  List<Object?> get props => [];
}

class HomeLoadingState extends HomeState{
  @override
  List<Object?> get props => [];
}

class HomeErrorState extends HomeState{
  final String errorMessage;
  HomeErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class HomeLoadedNewsListState extends HomeState{

  final List<NewsModel> userList ;
  HomeLoadedNewsListState(this.userList);

  @override
  List<NewsModel> get props => [];
}