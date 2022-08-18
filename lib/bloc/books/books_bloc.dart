part of 'books.dart';

class BooksBloc extends Cubit<BooksState> {
  final BuildContext context;
  BooksBloc({
    required this.context,
  }) : super(const BooksState());

  void reading() {
    emit(state.copyWith(reading: true));
  }

  void writing() {
    emit(state.copyWith(reading: false));
  }

 
}
