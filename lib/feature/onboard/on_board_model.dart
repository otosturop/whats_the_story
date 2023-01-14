class OnBoardModel {
  final String title;
  final String description;
  final String imageName;

  OnBoardModel(this.title, this.description, this.imageName);

  String get imageWithPath => 'assets/images/$imageName.png';
}

class OnBoardsModels {
  static final List<OnBoardModel> onBoardsItems = [
    OnBoardModel('Merhaba Hoşgeldin', 'Şimdi Buraya lorem impsun', 'ic_chef'),
    OnBoardModel('Burada uygulama tanıtım başlığı', 'Şimdi Buraya lorem impsun', 'ic_delivery'),
    OnBoardModel('Buraya uygulama kuralları vesaire', 'Şimdi Buraya lorem impsun', 'ic_order')
  ];
}
