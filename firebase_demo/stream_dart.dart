import 'dart:async';

main(){
  myStreamFunction().listen((e) {print(e);});

  StreamController _streamController = StreamController();

  void functionForStreamController()async{
    for(int i=0;i<10;i++){
      await Future.delayed(Duration(seconds: 1));
      _streamController.sink.add(i);
    }
  }

  functionForStreamController();
  _streamController.stream.listen((event) {print(event);},
    onDone: () {print("Stream Listen içerisinde onDone fonksiyonu çalıştı.");},
    onError: (error){print(error);},
    cancelOnError: true,
  );

}


Stream<int> myStreamFunction() async*{
  for(int i=0;i<10;i++){
    await Future.delayed(Duration(seconds: 1));
    yield i+1;
  }
}