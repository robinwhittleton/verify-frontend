COOKIE_VALIDATOR = CookieValidator.new(Integer(CONFIG.session_cookie_duration))
CYCLE_THREE_FORMS = CycleThree::CycleThreeFormGenerator.new.form_classes_by_name(CONFIG.cycle_three_attributes_directory)
FINGERPRINT_CONFIG = '/assets2/fp.gif'.freeze
