Rails.application.config.after_initialize do
  # Federation localisation and display
  repository_factory = Display::RepositoryFactory.new(FEDERATION_TRANSLATOR)
  IDP_DISPLAY_REPOSITORY = repository_factory.create_idp_repository(CONFIG.idp_display_locales)
  RP_DISPLAY_REPOSITORY = repository_factory.create_rp_repository(CONFIG.rp_display_locales)
  CYCLE_THREE_DISPLAY_REPOSITORY = repository_factory.create_cycle_three_repository(CONFIG.cycle_3_display_locales)

  IDENTITY_PROVIDER_DISPLAY_DECORATOR = Display::IdentityProviderDisplayDecorator.new(
    IDP_DISPLAY_REPOSITORY,
    CONFIG.logo_directory,
    CONFIG.white_logo_directory
  )

  RP_CONFIG = YAML.load_file(CONFIG.rp_config)
  IDP_CONFIG = YAML.load_file(CONFIG.idp_config)
  FURTHER_INFORMATION_SERVICE = FurtherInformationService.new(SESSION_PROXY, CYCLE_THREE_DISPLAY_REPOSITORY)

  # IDP Eligibility
  loaded_profile_filters = IdpEligibility::ProfilesLoader.new(CONFIG.rules_directory).load
  DOCUMENTS_ELIGIBILITY_CHECKER = IdpEligibility::Checker.new(loaded_profile_filters.document_profiles)
  IDP_ELIGIBILITY_CHECKER = IdpEligibility::Checker.new(loaded_profile_filters.all_profiles)
  IDP_RECOMMENDATION_GROUPER = IdpEligibility::RecommendationGrouper.new(
    loaded_profile_filters.recommended_profiles,
    loaded_profile_filters.non_recommended_profiles,
    loaded_profile_filters.demo_profiles,
    RP_CONFIG.fetch('demo_period_blacklist')
  )
  IDP_HINTS_CHECKER = IdpEligibility::IdpHintsChecker.new(loaded_profile_filters.idps_with_hints)
  IDP_LANGUAGE_HINT_CHECKER = IdpEligibility::IdpHintsChecker.new(loaded_profile_filters.idps_with_language_hint)

  # Per-IDP Config
  UNAVAILABLE_IDPS = IDP_CONFIG.fetch('show_unavailable', [])

  # Per-RP Config
  CONTINUE_ON_FAILED_REGISTRATION_RPS = RP_CONFIG.fetch('allow_continue_on_failed_registration', [])
end
