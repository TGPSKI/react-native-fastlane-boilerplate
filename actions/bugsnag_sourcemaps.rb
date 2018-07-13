# Bugsnag - Codepush sourcemap upload script
# By TGPSKI

module Fastlane
  module Actions
    class BugsnagSourcemapsAction < Action
      def self.run(params)
        require 'colored'

        rows = []
        rows << ["api_key", params[:api_key]]
        rows << ["app_version", params[:app_version]]
        rows << ["minified_file", params[:minified_file]]
        rows << ["source_map", params[:source_map]]
        rows << ["minified_url", params[:minified_url]]
        rows << ["upload_sources", params[:upload_sources]]
        rows << ["add_wildcard_prefix", params[:add_wildcard_prefix]]
        rows << ["overwrite", params[:overwrite]]
        rows << ["code_bundle_id", params[:code_bundle_id]]
        rows << ["dry_run", params[:dry_run]]
        table_params = {
          rows: rows,
          title: "Bugsnag Sourcemap Upload".white
        }

        puts ""
        puts Terminal::Table.new(table_params)
        puts ""

        # cf. bugsnag-sourcemaps --help
        command = "bugsnag-sourcemaps upload "\
                  "--api-key #{params[:api_key]} "\
                  "--minified-file #{params[:minified_file]} "\
                  "--minified-url #{params[:minified_url]} "\
                  "--source-map #{params[:source_map]} "

        if params[:app_version]
          command += " --app-version #{params[:app_version]}"
        elsif params[:code_bundle_id]
          command += " --code-bundle-id #{params[:code_bundle_id]}"
        end

        if params[:upload_sources]
          command += " --upload-sources"
        end

        if params[:add_wildcard_prefix]
          command += " --add-wildcard-prefix"
        end

        if params[:overwrite]
          command += " --overwrite"
        end

        if params[:dry_run]
          UI.message("Dry run!".red + " Would have run: " + command + "\n")
        else
          sh("cd #{ENV['PWD']} && #{command}")
        end

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload JS sourcemaps to Bugsnag"
      end

      def self.details
        "Upload JS sourcemaps to Bugsnag"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :api_key,
            env_name: "BUGSNAG_API_KEY",
            description: "Bugsnag api key",
            verify_block: proc do |value|
              UI.user_error!("No Bugsnag API key provided.") unless (value and not value.empty?)
            end,
          ),

          FastlaneCore::ConfigItem.new(
            key: :app_version,
            env_name: "APP_VERSION",
            description: "App binary version code",
            is_string: true,
            optional: true
          ),

          FastlaneCore::ConfigItem.new(
            key: :minified_file,
            env_name: "BUGSNAG_MINIFIED_FILE_PATH",
            description: "BUGSNAG MINIFIED FILE PATH",
            is_string: true,
            verify_block: proc do |value|
              UI.user_error!("No minifed file path provided.") unless (value and not value.empty?)
            end,
          ),

          FastlaneCore::ConfigItem.new(
            key: :source_map,
            env_name: "BUGSNAG_SOURCE_MAP_PATH",
            description: "BUGSNAG SOURCE MAP PATH",
            is_string: true,
            verify_block: proc do |value|
              UI.user_error!("No source map file path provided.") unless (value and not value.empty?)
            end,
          ),

          FastlaneCore::ConfigItem.new(
            key: :minified_url,
            env_name: "BUGSNAG_MINIFIED_URL",
            description: "BUGSNAG MINIFIED URL",
            is_string: true,
            verify_block: proc do |value|
              UI.user_error!("No minified url provided.") unless (value and not value.empty?)
            end,
          ),

          FastlaneCore::ConfigItem.new(
            key: :upload_sources,
            env_name: "BUGSNAG_UPLOAD_SOURCES",
            description: "BUGSNAG UPLOAD SOURCES",
            is_string: false,
            default_value: false
          ),

          FastlaneCore::ConfigItem.new(
            key: :add_wildcard_prefix,
            env_name: "BUGSNAG_WILDCARD_PREFIX",
            description: "BUGSNAG WILDCARD PREFIX",
            is_string: false,
            default_value: false
          ),

          FastlaneCore::ConfigItem.new(
            key: :overwrite,
            env_name: "BUGSNAG_OVERWRITE",
            description: "BUGSNAG OVERWRITE",
            is_string: false,
            default_value: false
          ),

          FastlaneCore::ConfigItem.new(
            key: :code_bundle_id,
            env_name: "BUGSNAG_CODE_BUNDLE_ID",
            description: "BUGSNAG CODE BUNDLE ID",
            is_string: true,
            optional: true
          ),

          FastlaneCore::ConfigItem.new(
            key: :dry_run,
            env_name: "BUGSNAG_DRY_RUN",
            description: "Print the command that would be run, and don't run it",
            is_string: false,
            default_value: false
          )
        ]
      end

      def self.output
        [
          ['BUGSNAG_MINIFIED_FILE_PATH', 'BUGSNAG MINIFIED FILE PATH']
        ]
      end

      def self.return_value
        # No return value
      end

      def self.authors
        ["tgpski"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
