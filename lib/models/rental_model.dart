class RentalFormData {
  String? bicycleType;
  String? guestName;
  String? guestMobile;
  int? guestAge;
  String? guardianName;
  String? guardianContact;
  String? nicNumber;
  DateTime? startDateTime;
  DateTime? endDateTime;

  RentalFormData({
    this.bicycleType,
    this.guestName,
    this.guestMobile,
    this.guestAge,
    this.guardianName,
    this.guardianContact,
    this.nicNumber,
    this.startDateTime,
    this.endDateTime,
  });

  bool get isMinor => guestAge != null && guestAge! < 16;

  bool get isValid {
    if (guestName == null || guestName!.isEmpty) return false;
    if (guestMobile == null || guestMobile!.isEmpty) return false;
    if (guestAge == null) return false;
    if (nicNumber == null || nicNumber!.isEmpty) return false;
    if (startDateTime == null || endDateTime == null) return false;
    
    // If minor, guardian info is required
    if (isMinor) {
      if (guardianName == null || guardianName!.isEmpty) return false;
      if (guardianContact == null || guardianContact!.isEmpty) return false;
    }
    
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'bicycleType': bicycleType,
      'guestName': guestName,
      'guestMobile': guestMobile,
      'guestAge': guestAge,
      'guardianName': guardianName,
      'guardianContact': guardianContact,
      'nicNumber': nicNumber,
      'startDateTime': startDateTime?.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(),
    };
  }
}
