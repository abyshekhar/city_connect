class Routes {
  final int id;
  final String displayText;
  final String from;
  final String to;
  final List<String> timings;
  final List<String> holidayTimings;
  final bool isHolidayApplicable;
 const Routes(this.id,this.displayText,this.from, this.to, this.timings,this.holidayTimings,this.isHolidayApplicable);

}