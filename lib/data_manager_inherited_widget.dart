import 'package:flutter/material.dart';
import 'package:jmapp/api/api_repos.dart';
import 'package:jmapp/api/http_api.dart';

class _DataManagerInherited extends InheritedWidget {
  _DataManagerInherited({
    this.apiClient,
    this.apiRepos,
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final DataManagerInheritedWidgetState data;
  final HttpClient apiClient;
  final APIRepos apiRepos;

  @override
  bool updateShouldNotify(_DataManagerInherited oldWidget) {
    return true;
  }
}

class DataManagerInheritedWidget extends StatefulWidget {
  DataManagerInheritedWidget({
    Key key,
    this.child,
    this.apiClient,
    this.apiRepos,
  }) : super(key: key);

  final Widget child;
  final HttpClient apiClient;
  final APIRepos apiRepos;

  @override
  DataManagerInheritedWidgetState createState() =>
      new DataManagerInheritedWidgetState(this.apiClient, this.apiRepos);

  static DataManagerInheritedWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DataManagerInherited)
    as _DataManagerInherited)
        .data;
  }
}

class DataManagerInheritedWidgetState
    extends State<DataManagerInheritedWidget> {
  final HttpClient apiClient;
  final APIRepos apiRepos;

  DataManagerInheritedWidgetState(this.apiClient, this.apiRepos);

  @override
  Widget build(BuildContext context) {
    return new _DataManagerInherited(
      data: this,
      child: widget.child,
    );
  }
}

