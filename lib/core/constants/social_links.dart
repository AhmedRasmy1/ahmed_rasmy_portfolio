/// Single source of truth for external profile / store URLs.
///
/// Fields stay nullable so a missing URL hides its affordance completely
/// (button, icon, and spacing) instead of rendering a dead link.
abstract final class SocialLinks {
  // ignore: unnecessary_nullable_for_final_variable_declarations
  static const String? linkedin =
      'https://www.linkedin.com/in/ahmed-rasmy-340680236';
  // ignore: unnecessary_nullable_for_final_variable_declarations
  static const String? github = 'https://github.com/AhmedRasmy1';
  // ignore: unnecessary_nullable_for_final_variable_declarations
  static const String? awwaabPlayStore =
      'https://play.google.com/store/apps/details?id=com.awwaab.muslim';
}
