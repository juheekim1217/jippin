import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'JIPPIN'**
  String get appTitle;

  /// No description provided for @appMission.
  ///
  /// In en, this message translates to:
  /// **'All reviews are anonymous. Share your experience with confidence and help create a fair, fraud-free rental market together.'**
  String get appMission;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReview;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @supportUs.
  ///
  /// In en, this message translates to:
  /// **'Support Us'**
  String get supportUs;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @popup_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get popup_about;

  /// No description provided for @popup_help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get popup_help;

  /// No description provided for @popup_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get popup_settings;

  /// No description provided for @popup_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get popup_logout;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @search_here.
  ///
  /// In en, this message translates to:
  /// **'Search here'**
  String get search_here;

  /// No description provided for @search_country.
  ///
  /// In en, this message translates to:
  /// **'Find a Country'**
  String get search_country;

  /// No description provided for @search_location.
  ///
  /// In en, this message translates to:
  /// **'City, Neighbourhood, Address or Postal Code'**
  String get search_location;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sort_most_recent.
  ///
  /// In en, this message translates to:
  /// **'Most recent'**
  String get sort_most_recent;

  /// No description provided for @sort_highest_rating.
  ///
  /// In en, this message translates to:
  /// **'Highest rating'**
  String get sort_highest_rating;

  /// No description provided for @sort_lowest_rating.
  ///
  /// In en, this message translates to:
  /// **'Lowest rating'**
  String get sort_lowest_rating;

  /// No description provided for @overallrating.
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get overallrating;

  /// No description provided for @trustworthiness.
  ///
  /// In en, this message translates to:
  /// **'Trustworthiness'**
  String get trustworthiness;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @safety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safety;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @occupiedYear.
  ///
  /// In en, this message translates to:
  /// **'Occupied Year'**
  String get occupiedYear;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @otherFees.
  ///
  /// In en, this message translates to:
  /// **'Other Fees'**
  String get otherFees;

  /// No description provided for @landlord.
  ///
  /// In en, this message translates to:
  /// **'Landlord'**
  String get landlord;

  /// No description provided for @property.
  ///
  /// In en, this message translates to:
  /// **'Property Name'**
  String get property;

  /// No description provided for @landlord_fraud.
  ///
  /// In en, this message translates to:
  /// **'This landlord has been reported for fraud or deception by the reviewer.'**
  String get landlord_fraud;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @realtor.
  ///
  /// In en, this message translates to:
  /// **'Realtor'**
  String get realtor;

  /// No description provided for @empty_reviews_no_reviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get empty_reviews_no_reviews;

  /// No description provided for @empty_reviews_be_first.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your experience!'**
  String get empty_reviews_be_first;

  /// No description provided for @empty_reviews_write_review.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get empty_reviews_write_review;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @created_at.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get created_at;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @unknown_country.
  ///
  /// In en, this message translates to:
  /// **'Unknown Country'**
  String get unknown_country;

  /// No description provided for @unknown_city.
  ///
  /// In en, this message translates to:
  /// **'Unknown City'**
  String get unknown_city;

  /// No description provided for @unknown_landlord.
  ///
  /// In en, this message translates to:
  /// **'Unknown Landlord'**
  String get unknown_landlord;

  /// No description provided for @unknown_property.
  ///
  /// In en, this message translates to:
  /// **'🏠 Unknown Property'**
  String get unknown_property;

  /// No description provided for @no_review_available.
  ///
  /// In en, this message translates to:
  /// **'No review available'**
  String get no_review_available;

  /// No description provided for @submit_review_title.
  ///
  /// In en, this message translates to:
  /// **'Submit a Review'**
  String get submit_review_title;

  /// No description provided for @submit_review_review_title_label.
  ///
  /// In en, this message translates to:
  /// **'Review Title'**
  String get submit_review_review_title_label;

  /// No description provided for @submit_review_review_title_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get submit_review_review_title_error;

  /// No description provided for @submit_review_review_content_label.
  ///
  /// In en, this message translates to:
  /// **'Review Content'**
  String get submit_review_review_content_label;

  /// No description provided for @submit_review_review_content_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter some content for your review'**
  String get submit_review_review_content_error;

  /// No description provided for @submit_review_landlord_label.
  ///
  /// In en, this message translates to:
  /// **'Landlord or Building Name'**
  String get submit_review_landlord_label;

  /// No description provided for @submit_review_landlord_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter the landlord or building name'**
  String get submit_review_landlord_error;

  /// No description provided for @submit_review_address_label.
  ///
  /// In en, this message translates to:
  /// **'Address or Location'**
  String get submit_review_address_label;

  /// No description provided for @submit_review_address_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter the address or location'**
  String get submit_review_address_error;

  /// No description provided for @submit_review_trustworthiness.
  ///
  /// In en, this message translates to:
  /// **'Trustworthiness'**
  String get submit_review_trustworthiness;

  /// No description provided for @submit_review_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get submit_review_price;

  /// No description provided for @submit_review_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get submit_review_location;

  /// No description provided for @submit_review_condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get submit_review_condition;

  /// No description provided for @submit_review_safety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get submit_review_safety;

  /// No description provided for @submit_review_submit_button.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submit_review_submit_button;

  /// No description provided for @submit_review_success.
  ///
  /// In en, this message translates to:
  /// **'Review Submitted'**
  String get submit_review_success;

  /// No description provided for @submit_review_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get submit_review_error;

  /// No description provided for @home_intro1_title.
  ///
  /// In en, this message translates to:
  /// **'Hello, Renter!'**
  String get home_intro1_title;

  /// No description provided for @home_intro1_desc.
  ///
  /// In en, this message translates to:
  /// **'JIPPIN helps you find the best rental experiences by connecting you with reliable landlord reviews and resources.'**
  String get home_intro1_desc;

  /// No description provided for @home_intro2_title.
  ///
  /// In en, this message translates to:
  /// **'Get Started:'**
  String get home_intro2_title;

  /// No description provided for @home_intro2_desc1.
  ///
  /// In en, this message translates to:
  /// **'Browse Reviews'**
  String get home_intro2_desc1;

  /// No description provided for @home_intro2_desc2.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get home_intro2_desc2;

  /// No description provided for @home_intro2_desc3.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get home_intro2_desc3;

  /// No description provided for @home_intro3_title.
  ///
  /// In en, this message translates to:
  /// **'Why Choose JIPPIN?'**
  String get home_intro3_title;

  /// No description provided for @home_intro3_desc1_title.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get home_intro3_desc1_title;

  /// No description provided for @home_intro3_desc2_title.
  ///
  /// In en, this message translates to:
  /// **'Submit Your Story'**
  String get home_intro3_desc2_title;

  /// No description provided for @home_intro3_desc3_title.
  ///
  /// In en, this message translates to:
  /// **'Contribute to a Better Rental Market'**
  String get home_intro3_desc3_title;

  /// No description provided for @home_intro3_desc4_title.
  ///
  /// In en, this message translates to:
  /// **'Community Support'**
  String get home_intro3_desc4_title;

  /// No description provided for @home_intro3_desc1.
  ///
  /// In en, this message translates to:
  /// **'Read honest reviews from real tenants about their experiences.'**
  String get home_intro3_desc1;

  /// No description provided for @home_intro3_desc2.
  ///
  /// In en, this message translates to:
  /// **'Share your renting journey and help others make informed decisions.'**
  String get home_intro3_desc2;

  /// No description provided for @home_intro3_desc3.
  ///
  /// In en, this message translates to:
  /// **'Contribute to creating a transparent rental market.'**
  String get home_intro3_desc3;

  /// No description provided for @home_intro3_desc4.
  ///
  /// In en, this message translates to:
  /// **'Connect with renters like you to find trusted advice and support.'**
  String get home_intro3_desc4;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Rental Review Platform'**
  String get home_title;

  /// No description provided for @home_heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the truth about your landlord and your future home!'**
  String get home_heroTitle;

  /// No description provided for @home_heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rental fraud, lease scam, 🔊 noisy neighbors, 😡 ruthless landlords, and real estate agents who deceive tenants 🤯... Tired of it all? Read honest reviews from real tenants and protect yourself from abuse! 🤝 Share your experience to help not only tenants in your city but also renters around the world.'**
  String get home_heroSubtitle;

  /// No description provided for @home_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search landlord, property or realtor...'**
  String get home_searchHint;

  /// No description provided for @home_readReviews.
  ///
  /// In en, this message translates to:
  /// **'Read Reviews'**
  String get home_readReviews;

  /// No description provided for @home_writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get home_writeReview;

  /// No description provided for @home_recentReviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get home_recentReviews;

  /// No description provided for @home_seeMoreReviews.
  ///
  /// In en, this message translates to:
  /// **'See More Reviews →'**
  String get home_seeMoreReviews;

  /// No description provided for @home_howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get home_howItWorks;

  /// No description provided for @home_step1Title.
  ///
  /// In en, this message translates to:
  /// **'Search Landlords/Properties'**
  String get home_step1Title;

  /// No description provided for @home_step1Desc.
  ///
  /// In en, this message translates to:
  /// **'Look up rental properties and landlords to read real reviews.'**
  String get home_step1Desc;

  /// No description provided for @home_step2Title.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get home_step2Title;

  /// No description provided for @home_step2Desc.
  ///
  /// In en, this message translates to:
  /// **'Share your experience to help future tenants make better choices.'**
  String get home_step2Desc;

  /// No description provided for @home_step3Title.
  ///
  /// In en, this message translates to:
  /// **'Protect Yourself'**
  String get home_step3Title;

  /// No description provided for @home_step3Desc.
  ///
  /// In en, this message translates to:
  /// **'Use community-driven insights to avoid rental scams.'**
  String get home_step3Desc;

  /// No description provided for @home_anonymousReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'All Reviews Are Anonymous'**
  String get home_anonymousReviewsTitle;

  /// No description provided for @home_anonymousReviewsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your identity is protected. Share your experience freely and help others stay safe!'**
  String get home_anonymousReviewsDesc;

  /// No description provided for @home_findLandlordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Landlords/Properties'**
  String get home_findLandlordsTitle;

  /// No description provided for @home_findLandlordsDesc.
  ///
  /// In en, this message translates to:
  /// **'Search for properties and see real reviews.'**
  String get home_findLandlordsDesc;

  /// No description provided for @home_writeReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get home_writeReviewTitle;

  /// No description provided for @home_writeReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Help others by sharing your rental experience.'**
  String get home_writeReviewDesc;

  /// No description provided for @about_title.
  ///
  /// In en, this message translates to:
  /// **'Who we are?'**
  String get about_title;

  /// No description provided for @about_description.
  ///
  /// In en, this message translates to:
  /// **'The Jippin Rent Review app helps tenants share their experiences with landlords and real estate agents, providing transparency and helping future renters make informed decisions.'**
  String get about_description;

  /// No description provided for @about_review_fields_title.
  ///
  /// In en, this message translates to:
  /// **'Review Fields and Rating Technique'**
  String get about_review_fields_title;

  /// No description provided for @about_trustworthiness_title.
  ///
  /// In en, this message translates to:
  /// **'1. Trustworthiness Rating'**
  String get about_trustworthiness_title;

  /// No description provided for @about_trustworthiness_description.
  ///
  /// In en, this message translates to:
  /// **'The Trustworthiness Rating reflects how reliable and honest the landlord or real estate agent is in their dealings. Rate the landlord/agent based on transparency, ethical practices, and whether promises are kept.'**
  String get about_trustworthiness_description;

  /// No description provided for @about_trustworthiness_1_star.
  ///
  /// In en, this message translates to:
  /// **'1 Star: Very untrustworthy – Major issues with dishonesty or failure to follow through on promises.'**
  String get about_trustworthiness_1_star;

  /// No description provided for @about_trustworthiness_2_star.
  ///
  /// In en, this message translates to:
  /// **'2 Stars: Untrustworthy – Some issues with transparency or reliability.'**
  String get about_trustworthiness_2_star;

  /// No description provided for @about_trustworthiness_3_star.
  ///
  /// In en, this message translates to:
  /// **'3 Stars: Neutral – No major issues, but not particularly reliable.'**
  String get about_trustworthiness_3_star;

  /// No description provided for @about_trustworthiness_4_star.
  ///
  /// In en, this message translates to:
  /// **'4 Stars: Trustworthy – Generally reliable, with few issues.'**
  String get about_trustworthiness_4_star;

  /// No description provided for @about_trustworthiness_5_star.
  ///
  /// In en, this message translates to:
  /// **'5 Stars: Very trustworthy – Completely transparent and dependable in all dealings.'**
  String get about_trustworthiness_5_star;

  /// No description provided for @about_respect_title.
  ///
  /// In en, this message translates to:
  /// **'2. Respect Rating'**
  String get about_respect_title;

  /// No description provided for @about_respect_description.
  ///
  /// In en, this message translates to:
  /// **'The Respect Rating reflects how the landlord or real estate agent treats you. This includes politeness, attentiveness to concerns, and overall professionalism.'**
  String get about_respect_description;

  /// No description provided for @about_respect_1_star.
  ///
  /// In en, this message translates to:
  /// **'1 Star: Very disrespectful – Rude or dismissive communication.'**
  String get about_respect_1_star;

  /// No description provided for @about_respect_2_star.
  ///
  /// In en, this message translates to:
  /// **'2 Stars: Disrespectful – Occasional unprofessional behavior or lack of courtesy.'**
  String get about_respect_2_star;

  /// No description provided for @about_respect_3_star.
  ///
  /// In en, this message translates to:
  /// **'3 Stars: Neutral – Adequate but not particularly respectful or disrespectful.'**
  String get about_respect_3_star;

  /// No description provided for @about_respect_4_star.
  ///
  /// In en, this message translates to:
  /// **'4 Stars: Respectful – Generally polite and attentive, with minor issues.'**
  String get about_respect_4_star;

  /// No description provided for @about_respect_5_star.
  ///
  /// In en, this message translates to:
  /// **'5 Stars: Very respectful – Always considerate, courteous, and professional.'**
  String get about_respect_5_star;

  /// No description provided for @about_additional_details_title.
  ///
  /// In en, this message translates to:
  /// **'Additional Review Details'**
  String get about_additional_details_title;

  /// No description provided for @about_additional_details_description.
  ///
  /// In en, this message translates to:
  /// **'In addition to the Trustworthiness and Respect Ratings, users can leave comments to provide more context on their experiences. They can also answer the following optional questions:'**
  String get about_additional_details_description;

  /// No description provided for @about_question_contract_dispute.
  ///
  /// In en, this message translates to:
  /// **'• Was there a contract dispute? – Indicate if you encountered any issues with the lease agreement.'**
  String get about_question_contract_dispute;

  /// No description provided for @about_question_accurate_info.
  ///
  /// In en, this message translates to:
  /// **'• Did the landlord/agent provide accurate information? – Rate whether the information given was truthful and clear.'**
  String get about_question_accurate_info;

  /// No description provided for @about_question_discriminatory_behavior.
  ///
  /// In en, this message translates to:
  /// **'• Did you experience any discriminatory behavior? – Optional, to assess how inclusive the landlord/agent was.'**
  String get about_question_discriminatory_behavior;

  /// No description provided for @about_contribute_message.
  ///
  /// In en, this message translates to:
  /// **'By contributing to Rent Review, you’re helping other renters find reliable and respectful landlords and agents, creating a more transparent rental market for everyone.'**
  String get about_contribute_message;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
