class ServerConstApis {
  static String baseAPI = 'http://192.168.192.5:3000/';

///// sign
  static String signUp = '${baseAPI}customers/signup';
  static String signIn = '${baseAPI}worker/login';
/////// events
  static String showUpComing = '${baseAPI}events/show-all';
  static String showEventInfo = '${baseAPI}events/show-event';

///////////////order

  static String makeOrder = '${baseAPI}orders/make-order';
  static String makeOrderByWorker = '${baseAPI}worker/makeOrderByWorker';

//////////// drinks

  static String showDrinks = '${baseAPI}drinks';

////////stock
  static String showAllDrinks = '${baseAPI}drinks';
  static String addDrink = '${baseAPI}drinks/add';
  static String updateDrink = '${baseAPI}drinks/update';
  static String deleteDrink = '${baseAPI}drinks/delete';

///////orders

  static String showOrders = '${baseAPI}orders/show-all-orders';
  static String approveOrder = '${baseAPI}worker/approveOrder';
  static String denyOrder = '${baseAPI}worker/deleteOrderByWorker';

///////////reservation
  static String makeReservation = '${baseAPI}reservations/make-reservation';
  static String setSection = '${baseAPI}reservations/setSection';

  /////////// door
  static String showReservation = '${baseAPI}worker/show-reservations';
  static String sendreservation = '${baseAPI}worker/confirmArrival';

/////////forImages
  static String loadImages = baseAPI;
}
