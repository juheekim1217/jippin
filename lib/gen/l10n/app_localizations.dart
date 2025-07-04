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
  /// **'Search for a Province/State or City'**
  String get search_location;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'Province/State'**
  String get state;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @zip.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get zip;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

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

  /// No description provided for @rental_type.
  ///
  /// In en, this message translates to:
  /// **'Rental Type'**
  String get rental_type;

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

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_and_conditions;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

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
  /// **'Landlord'**
  String get submit_review_landlord_label;

  /// No description provided for @submit_review_landlord_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter the landlord name'**
  String get submit_review_landlord_error;

  /// No description provided for @submit_review_realtor_label.
  ///
  /// In en, this message translates to:
  /// **'Realtor / Rental Platform'**
  String get submit_review_realtor_label;

  /// No description provided for @submit_review_realtor_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter the realtor'**
  String get submit_review_realtor_error;

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

  /// No description provided for @invalid_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get invalid_number;

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
  /// **'Search landlord or realtor...'**
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
  /// **'About Jippin'**
  String get about_title;

  /// No description provided for @about_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Helping Renters Make Smarter Choices — and Avoid Rental Scams!'**
  String get about_subtitle;

  /// No description provided for @about_personal_story.
  ///
  /// In en, this message translates to:
  /// **'I created Jippin after watching a heartbreaking news story about young people in South Korea who took their lives after falling victim to rental scams.\n\nNo one should suffer alone or in silence. By sharing our stories, we can protect each other.\n\nAnyone can contribute — and together, we can prevent this crisis. I’m committed to expanding Jippin and adding more countries so renters everywhere can benefit from shared knowledge and support.'**
  String get about_personal_story;

  /// No description provided for @about_section_what_you_can_share.
  ///
  /// In en, this message translates to:
  /// **'What You Can Share'**
  String get about_section_what_you_can_share;

  /// No description provided for @about_what_rental_title.
  ///
  /// In en, this message translates to:
  /// **'🏡 Rental Property Details (If unknown, just write “unknown”)'**
  String get about_what_rental_title;

  /// No description provided for @about_what_rental_body.
  ///
  /// In en, this message translates to:
  /// **'• Country, Province/State, and City\n• Street Address and Postal Code\n• Rental Type: Short-term, Long-term, Lump-sum Lease, Daily Rental, Vacation Rental, or Other\n• Rent and Deposit'**
  String get about_what_rental_body;

  /// No description provided for @about_what_who_title.
  ///
  /// In en, this message translates to:
  /// **'👤 Who You Dealt With (If unknown, just write “unknown”)'**
  String get about_what_who_title;

  /// No description provided for @about_what_who_body.
  ///
  /// In en, this message translates to:
  /// **'• Landlord Name\n• Realtor or Rental Platform'**
  String get about_what_who_body;

  /// No description provided for @about_section_ratings.
  ///
  /// In en, this message translates to:
  /// **'Condition & Experience Ratings'**
  String get about_section_ratings;

  /// No description provided for @about_rating_trust_title.
  ///
  /// In en, this message translates to:
  /// **'Trustworthiness'**
  String get about_rating_trust_title;

  /// No description provided for @about_rating_trust_description.
  ///
  /// In en, this message translates to:
  /// **'Did the landlord or agent follow through on promises and act with integrity?'**
  String get about_rating_trust_description;

  /// No description provided for @about_rating_price_title.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get about_rating_price_title;

  /// No description provided for @about_rating_price_description.
  ///
  /// In en, this message translates to:
  /// **'Was the cost fair for what was offered?'**
  String get about_rating_price_description;

  /// No description provided for @about_rating_location_title.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get about_rating_location_title;

  /// No description provided for @about_rating_location_description.
  ///
  /// In en, this message translates to:
  /// **'Was the area convenient, safe, and accessible?'**
  String get about_rating_location_description;

  /// No description provided for @about_rating_condition_title.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get about_rating_condition_title;

  /// No description provided for @about_rating_condition_description.
  ///
  /// In en, this message translates to:
  /// **'Was the property clean, safe, and well-maintained?'**
  String get about_rating_condition_description;

  /// No description provided for @about_section_why_it_matters.
  ///
  /// In en, this message translates to:
  /// **'Why It Matters'**
  String get about_section_why_it_matters;

  /// No description provided for @about_why_it_matters.
  ///
  /// In en, this message translates to:
  /// **'Every review helps build a safer, more transparent rental market:\n\n• Exposes dishonest or discriminatory practices\n• Highlights trustworthy and respectful landlords and agents\n• Helps protect newcomers, students, and vulnerable renters\n• Fights fraud and rental scams through shared knowledge'**
  String get about_why_it_matters;

  /// No description provided for @about_contribution_message.
  ///
  /// In en, this message translates to:
  /// **'All reviews are anonymous. Your voice matters — by sharing your experience, you’re helping others avoid bad rentals and find better housing.'**
  String get about_contribution_message;

  /// No description provided for @about_contact_label.
  ///
  /// In en, this message translates to:
  /// **'Developer Contact:'**
  String get about_contact_label;

  /// No description provided for @terms_title.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_title;

  /// No description provided for @terms_effective_date.
  ///
  /// In en, this message translates to:
  /// **'Effective Date: 2025-06-24'**
  String get terms_effective_date;

  /// No description provided for @terms_intro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to JIPPIN. These Terms & Conditions govern your use of our website and mobile application (the “Platform”). By accessing or using JIPPIN, you agree to be legally bound by the following terms.'**
  String get terms_intro;

  /// No description provided for @terms_section1_title.
  ///
  /// In en, this message translates to:
  /// **'1. Purpose of the Platform'**
  String get terms_section1_title;

  /// No description provided for @terms_section1_body.
  ///
  /// In en, this message translates to:
  /// **'JIPPIN is a community-based platform designed to help renters share and discover information about landlords, rental experiences, and housing conditions. It exists to promote transparency and reduce rental fraud through user-generated reviews.'**
  String get terms_section1_body;

  /// No description provided for @terms_section2_title.
  ///
  /// In en, this message translates to:
  /// **'2. Your Agreement'**
  String get terms_section2_title;

  /// No description provided for @terms_section2_body.
  ///
  /// In en, this message translates to:
  /// **'By accessing or using JIPPIN, you confirm that you are at least 18 years old (or have legal parental consent) and that you agree to these Terms and all applicable laws. If you do not agree, do not use the Platform.'**
  String get terms_section2_body;

  /// No description provided for @terms_section3_title.
  ///
  /// In en, this message translates to:
  /// **'3. User Content'**
  String get terms_section3_title;

  /// No description provided for @terms_section3_body.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for any content (e.g., reviews, comments, ratings) you submit.\nBy submitting content, you grant JIPPIN a worldwide, royalty-free license to use, display, store, and share your content for the purpose of operating and promoting the Platform.\n\nYou must not submit content that is:\n• False or misleading\n• Harassing, discriminatory, or offensive\n• In violation of any laws or third-party rights\n\nWe reserve the right to remove any content that violates these terms or harms the integrity of the platform.'**
  String get terms_section3_body;

  /// No description provided for @terms_section4_title.
  ///
  /// In en, this message translates to:
  /// **'4. Privacy'**
  String get terms_section4_title;

  /// No description provided for @terms_section4_body.
  ///
  /// In en, this message translates to:
  /// **'We take your privacy seriously. Reviews are published anonymously, and personal data is handled in accordance with our Privacy Policy.'**
  String get terms_section4_body;

  /// No description provided for @terms_section5_title.
  ///
  /// In en, this message translates to:
  /// **'5. Platform Availability'**
  String get terms_section5_title;

  /// No description provided for @terms_section5_body.
  ///
  /// In en, this message translates to:
  /// **'JIPPIN is provided “as is.” We do not guarantee uninterrupted or error-free access. We may update, modify, or discontinue parts of the platform at any time without notice.'**
  String get terms_section5_body;

  /// No description provided for @terms_section6_title.
  ///
  /// In en, this message translates to:
  /// **'6. Limitation of Liability'**
  String get terms_section6_title;

  /// No description provided for @terms_section6_body.
  ///
  /// In en, this message translates to:
  /// **'To the fullest extent permitted by law, JIPPIN and its creators are not liable for any direct, indirect, or incidental damages related to your use (or inability to use) the platform or the accuracy of its content.'**
  String get terms_section6_body;

  /// No description provided for @terms_section7_title.
  ///
  /// In en, this message translates to:
  /// **'7. External Links'**
  String get terms_section7_title;

  /// No description provided for @terms_section7_body.
  ///
  /// In en, this message translates to:
  /// **'JIPPIN may contain links to third-party websites or services. We are not responsible for the content, policies, or actions of those external sites.'**
  String get terms_section7_body;

  /// No description provided for @terms_section8_title.
  ///
  /// In en, this message translates to:
  /// **'8. Changes to Terms'**
  String get terms_section8_title;

  /// No description provided for @terms_section8_body.
  ///
  /// In en, this message translates to:
  /// **'We may update these Terms at any time. Continued use of JIPPIN after updates means you accept the revised terms. Please check this page periodically for changes.'**
  String get terms_section8_body;

  /// No description provided for @terms_section9_title.
  ///
  /// In en, this message translates to:
  /// **'9. Contact Us'**
  String get terms_section9_title;

  /// No description provided for @terms_section9_body.
  ///
  /// In en, this message translates to:
  /// **'For any questions or concerns, please contact:\n📧 icecreambears1@gmail.com'**
  String get terms_section9_body;

  /// No description provided for @terms_section10_title.
  ///
  /// In en, this message translates to:
  /// **'10. Governing Law'**
  String get terms_section10_title;

  /// No description provided for @terms_section10_body.
  ///
  /// In en, this message translates to:
  /// **'These Terms shall be governed by the laws of the jurisdiction in which JIPPIN is operated. For Canadian users, this includes PIPEDA. For South Korean users, this includes PIPA. Legal disputes shall be resolved in the courts of the applicable jurisdiction.'**
  String get terms_section10_body;

  /// No description provided for @terms_section11_title.
  ///
  /// In en, this message translates to:
  /// **'11. Content Moderation'**
  String get terms_section11_title;

  /// No description provided for @terms_section11_body.
  ///
  /// In en, this message translates to:
  /// **'User-generated content may be reviewed and moderated. We reserve the right to remove any content that violates applicable laws, our community guidelines, or the integrity of the platform.'**
  String get terms_section11_body;

  /// No description provided for @privacy_privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy for JIPPIN'**
  String get privacy_privacyTitle;

  /// No description provided for @privacy_privacyDescription.
  ///
  /// In en, this message translates to:
  /// **'Effective Date: 2025-06-24\n\nAt JIPPIN, we are committed to protecting your privacy. This Privacy Policy explains how we handle information on our website and mobile application (collectively, the \"Platform\").'**
  String get privacy_privacyDescription;

  /// No description provided for @privacy_informationCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get privacy_informationCollectionTitle;

  /// No description provided for @privacy_informationCollectionDescription.
  ///
  /// In en, this message translates to:
  /// **'We do not collect any personal information from users who browse or use the Platform.'**
  String get privacy_informationCollectionDescription;

  /// No description provided for @privacy_cookiesTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Cookies and Tracking'**
  String get privacy_cookiesTitle;

  /// No description provided for @privacy_cookiesDescription.
  ///
  /// In en, this message translates to:
  /// **'JIPPIN does not use cookies or tracking technologies for user profiling. However, essential technologies may be used for:\n• Analytics (e.g., traffic statistics)\n• Security (e.g., spam protection)\n• Advertising (e.g., display ads)'**
  String get privacy_cookiesDescription;

  /// No description provided for @privacy_informationSharingTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Information Sharing'**
  String get privacy_informationSharingTitle;

  /// No description provided for @privacy_informationSharingDescription.
  ///
  /// In en, this message translates to:
  /// **'Since we do not collect personal data, we also do not share any personal information with third parties.'**
  String get privacy_informationSharingDescription;

  /// No description provided for @privacy_dataSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Data Security'**
  String get privacy_dataSecurityTitle;

  /// No description provided for @privacy_dataSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'While JIPPIN does not store user identities, we implement strong security measures to protect the platform from unauthorized access and maintain its reliability and integrity.'**
  String get privacy_dataSecurityDescription;

  /// No description provided for @privacy_childrenTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Children\'s Privacy'**
  String get privacy_childrenTitle;

  /// No description provided for @privacy_childrenDescription.
  ///
  /// In en, this message translates to:
  /// **'JIPPIN is not intended for children under 13 years of age, and we do not knowingly collect any data from children.'**
  String get privacy_childrenDescription;

  /// No description provided for @privacy_botDetectionTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Bot Detection'**
  String get privacy_botDetectionTitle;

  /// No description provided for @privacy_botDetectionDescription.
  ///
  /// In en, this message translates to:
  /// **'We use Google reCAPTCHA to detect and prevent automated activity such as spam, fake reviews, or bot traffic. This may involve Google collecting device and interaction data in accordance with their privacy policy.'**
  String get privacy_botDetectionDescription;

  /// No description provided for @privacy_advertisingTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Advertising'**
  String get privacy_advertisingTitle;

  /// No description provided for @privacy_advertisingDescription.
  ///
  /// In en, this message translates to:
  /// **'JIPPIN uses Google Ads to display relevant advertisements. Google may collect usage data to personalize ads. For more details, refer to Google’s Ad Policy.'**
  String get privacy_advertisingDescription;

  /// No description provided for @privacy_thirdPartyCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'8. Third-Party Data Collection'**
  String get privacy_thirdPartyCollectionTitle;

  /// No description provided for @privacy_thirdPartyCollectionDescription.
  ///
  /// In en, this message translates to:
  /// **'While JIPPIN does not directly collect or store personal information, we use third-party services (such as Google Ads and reCAPTCHA) that may collect user data such as IP addresses or browser metadata. By using our platform, you consent to the data practices of these services. Please review their privacy policies for more details.'**
  String get privacy_thirdPartyCollectionDescription;

  /// No description provided for @privacy_gdprTitle.
  ///
  /// In en, this message translates to:
  /// **'9. GDPR Compliance'**
  String get privacy_gdprTitle;

  /// No description provided for @privacy_gdprDescription.
  ///
  /// In en, this message translates to:
  /// **'JIPPIN supports data protection principles under the General Data Protection Regulation (GDPR). All user-generated content is anonymous and reviewed to ensure compliance with applicable privacy standards.'**
  String get privacy_gdprDescription;

  /// No description provided for @privacy_dsaTitle.
  ///
  /// In en, this message translates to:
  /// **'10. DSA Compliance'**
  String get privacy_dsaTitle;

  /// No description provided for @privacy_dsaDescription.
  ///
  /// In en, this message translates to:
  /// **'Under the EU Digital Services Act (DSA), JIPPIN ensures that landlord reviews are:\n• Clearly marked as user-generated\n• Subject to moderation based on our community guidelines\n\nWe do not endorse or guarantee the accuracy of user reviews.'**
  String get privacy_dsaDescription;

  /// No description provided for @privacy_policyChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'11. Changes to This Privacy Policy'**
  String get privacy_policyChangesTitle;

  /// No description provided for @privacy_policyChangesDescription.
  ///
  /// In en, this message translates to:
  /// **'We may update this policy at any time. Changes take effect immediately once published on this page. We recommend reviewing it regularly.'**
  String get privacy_policyChangesDescription;

  /// No description provided for @privacy_contactTitle.
  ///
  /// In en, this message translates to:
  /// **'12. Contact Us'**
  String get privacy_contactTitle;

  /// No description provided for @privacy_contactDescription.
  ///
  /// In en, this message translates to:
  /// **'If you have questions or concerns about this Privacy Policy, please contact:\n📧 icecreambears1@gmail.com'**
  String get privacy_contactDescription;

  /// No description provided for @submitted_review_success_title.
  ///
  /// In en, this message translates to:
  /// **'Your review has been successfully submitted!'**
  String get submitted_review_success_title;

  /// No description provided for @submitted_review_success_description.
  ///
  /// In en, this message translates to:
  /// **'Thank you for helping others by sharing your experience.'**
  String get submitted_review_success_description;

  /// No description provided for @back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get back_to_home;
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
