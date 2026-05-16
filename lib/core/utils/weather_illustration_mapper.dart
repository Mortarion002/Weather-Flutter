class WeatherIllustrationMapper {
  WeatherIllustrationMapper._();

  static String assetFor(int conditionId, {bool isDay = true}) {
    if (conditionId == 800) {
      return isDay
          ? 'assets/illustrations/sunny.svg'
          : 'assets/illustrations/night.svg';
    }
    if (conditionId >= 801 && conditionId <= 804) {
      return 'assets/illustrations/cloudy.svg';
    }
    if (conditionId >= 200 && conditionId <= 399) {
      return 'assets/illustrations/rain.svg';
    }
    if (conditionId >= 500 && conditionId <= 599) {
      return 'assets/illustrations/rain.svg';
    }
    if (conditionId >= 600 && conditionId <= 699) {
      return 'assets/illustrations/snow.svg';
    }
    if (conditionId >= 700 && conditionId <= 799) {
      return 'assets/illustrations/fog.svg';
    }
    return 'assets/illustrations/default.svg';
  }
}
