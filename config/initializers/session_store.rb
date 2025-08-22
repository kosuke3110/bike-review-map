# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
                                       key: '_bike_review_map_session',
                                       secure: Rails.env.production?
