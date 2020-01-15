import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {}

class Fetch extends PostEvent {
  @override
  String toString() => 'Fetch';
}

class PostRefresh extends PostEvent {
  @override
  String toString() => 'PostRefresh';
}
