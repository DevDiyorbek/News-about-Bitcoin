import 'package:bitcoin_news/bloc/home_bloc.dart';
import 'package:bitcoin_news/bloc/home_event.dart';
import 'package:bitcoin_news/bloc/home_state.dart';
import 'package:bitcoin_news/models/news_model.dart';
import 'package:bitcoin_news/services/log_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    homeBloc.add(LoadNewsListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeErrorState) {
          LogService.i("Error occur");
        }
      },
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return viewOfNewsList(true, homeBloc.userList);
        }
        if (state is HomeLoadedNewsListState) {
          return viewOfNewsList(false, state.userList);
        } else {
          return viewOfNewsList(false, []);
        }
      },
    );
  }

  Widget viewOfNewsList(bool isLoading, List<NewsModel> articles) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News about Bitcoin"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: articles.length,
            itemBuilder: (ctx, index) {
              return itemForNews(articles[index], index);
            },
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget viewOfRandomUserList(List<NewsModel> article) {
    return Center(
      child: ListView.builder(
        controller: scrollController, // Add the controller here
        itemCount: article.length,
        itemBuilder: (ctx, index) {
          return itemForNews(article[index], index);
        },
      ),
    );
  }

  Widget itemForNews(NewsModel article, int index) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article.title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          // Author
          Text(
            article.author,
            style: const TextStyle(
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16.0),
          // Image and Content Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                article.urlToImage,
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16.0),
              // Content
              Expanded(
                child: Text(article.content),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            article.url,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
