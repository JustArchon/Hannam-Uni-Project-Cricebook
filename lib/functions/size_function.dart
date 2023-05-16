double widthSizeMax(int n, double screenWidth) {
  double wSize = 0.0;
  wSize = screenWidth * (n / 500);
  if (wSize > n) {
    wSize = n.toDouble();
  } else if (wSize <= 10) {
    wSize = 10.0;
  }
  return wSize;
}

double heightSizeMax(int n, double screenHeight) {
  double hSize = 0.0;
  hSize = screenHeight * (n / 800);
  if (hSize > n) {
    hSize = n.toDouble();
  } else if (hSize <= 10) {
    hSize = 10.0;
  }

  return hSize;
}

double bookListWidth(int n, double screenWidth) {
  double bWidth = 0.0;
  bWidth = screenWidth * (n / 500);
  return bWidth;
}
