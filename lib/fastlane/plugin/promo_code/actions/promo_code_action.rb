require 'fastlane/action'
require_relative '../helper/promo_code_helper'
require 'spaceship'

module Fastlane
  module Actions
    class PromoCodeAction < Action

      def self.run(params)
        UI.message("The promo_code plugin is working!")
        app = get_app(params)
        app_version = params[:is_editing_version] == "true" ? app.edit_version : app.live_version
        if app_version.nil?
          UI.user_error!("Could not find your App Version")
        end
        Spaceship::Tunes.client.generate_app_version_promocodes!(
          app_id: app_version.application.apple_id,
          version_id: app_version.version_id,
          quantity: params[:quantity]
        )
        Spaceship::Tunes.client.app_promocodes_history(app_id: app_version.application.apple_id)[0]['codes']
      end

      def self.get_app(params)
        Spaceship::Tunes.login unless Spaceship::Tunes.client
        Spaceship::Tunes::Application.find params[:app_identifier]
      rescue => ex
        UI.error("#{ex.message}\n#{ex.backtrace.join('\n')}")
        UI.user_error!("Could not find your App Identifier")
      end

      def self.description
        "promo_code"
      end

      def self.authors
        ["marumemomo"]
      end

      def self.return_value
        ["PROMO_CODE", "PROMO_CODE"]
      end

      def self.details
        # Optional:
        "A Fastlane plugin that create and get ITC promo code"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :app_identifier,
            env_name: "APP_IDENTIFIER",
            description: "APP ID of the application",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :quantity,
            env_name: "PROMO_CODE_QUANTITY",
            description: "Quantity of creating promo code",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :is_editing_version,
            env_name: "PROMO_CODE_IS_LIVE_VERSION",
            description: "App version is editing?",
            optional: true,
            type: String
          ),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        [:ios].include?(platform)
        true
      end
    end
  end
end
