# Codepush - Fastlane action
# Original implementation by Jeremy Kun (@j2kun)
# Updates by Tyler Pate (@TGPSKI)

module Fastlane
  module Actions
    module SharedValues
      CODEPUSH_DEPLOYMENT = :CODEPUSH_DEPLOYMENT
    end

    class CodepushAction < Action
      def self.run(params)
        require 'colored'

        rows = []
        rows << ["deployment", params[:deployment]]
        rows << ["target_binary_version", params[:target_binary_version]]
        rows << ["platform", params[:platform]]
        rows << ["mandatory", params[:mandatory]]
        rows << ["rollout", params[:rollout]]
        rows << ["description", params[:description][0..30].gsub(/\s\w+\s*$/, '...')]
        table_params = {
          rows: rows,
          title: "Codepush".white
        }
        puts ""
        puts Terminal::Table.new(table_params)
        puts ""

        if params[:platform]
          platform = params[:platform]
        else
          platform = Actions.lane_context[Actions::SharedValues::PLATFORM_NAME]
        end

        if platform == 'android'
          FileUtils.mkdir_p "#{ENV['PWD']}/js_build/android"
          output_path = "js_build/android"
        elsif platform == 'ios'
          FileUtils.mkdir_p "#{ENV['PWD']}/js_build/ios"
          output_path = "js_build/ios"
        end

        # cf. code-push release-react --help
        command = "code-push release-react #{params[:app_name]} #{platform} -d #{params[:deployment]} -t #{params[:target_binary_version]} "\
                  "-r #{params[:rollout]} --des \"#{params[:description]}\" --outputDir #{output_path}"
        if params[:mandatory]
           command += " -m"
        end

        if params[:dry_run]
          UI.message("Dry run!".red + " Would have run: " + command + "\n")
        else
          sh("cd #{ENV['PWD']} && #{command}")
        end

        Actions.lane_context[SharedValues::CODEPUSH_DEPLOYMENT] = params[:deployment]
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Code push to Microsoft CodePush"
      end

      def self.details
        "Code push javascript updates to the specified codepush deployment"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :deployment,
            env_name: "CODEPUSH_DEPLOYMENT",
            description: "The deployment name to codepush to",
            verify_block: proc do |value|
              UI.user_error!("No CodePush deployment specified! Choose one using `code-push deployment ls APP_NAME` and pass it via deployment") unless (value and not value.empty?)
            end,
          ),

          FastlaneCore::ConfigItem.new(
            key: :mandatory,
            env_name: "CODEPUSH_MANDATORY",
            description: "Make this codepush mandatory",
            is_string: false,
            default_value: true
          ),

          FastlaneCore::ConfigItem.new(
            key: :platform,
            env_name: "CODEPUSH_PLATFORM",
            description: "ios/android",
            is_string: true,
            default_value: "ios"
          ),

          FastlaneCore::ConfigItem.new(
            key: :target_binary_version,
            env_name: "CODEPUSH_TARGET_BINARY_VERSION",
            description: "The binary version to target with this codepush",
            verify_block: proc do |value|
              current_version = Actions.lane_context[SharedValues::VERSION_NUMBER]
              UI.user_error!("Must provide target_binary_version! Current value is #{current_version}") unless (value and not value.empty?)
              split_value = value.split('.').map{|v| v.to_i}
              UI.user_error!("Invalid semantic versioning binary version! Current value is #{current_version}") unless (split_value.length == 3)
            end,
          ),

          FastlaneCore::ConfigItem.new(
            key: :rollout,
            env_name: "CODEPUSH_ROLLOUT",
            description: "The percentage of users to roll this codepush out to",
            is_string: false,
            default_value: 100,
            verify_block: proc do |value|
              UI.user_error!("Invalid rollout, must be an integer in (0, 100]") unless (0 < value.to_i and value.to_i <= 100)
            end,
          ),

          FastlaneCore::ConfigItem.new(
            key: :description,
            env_name: "CODEPUSH_DESCRIPTION",
            description: "The description to release with this codepush",
            verify_block: proc do |value|
              UI.user_error!("Description cannot be empty") unless (value and not value.empty?)
            end,
          ),

          FastlaneCore::ConfigItem.new(
            key: :dry_run,
            env_name: "CODEPUSH_DRY_RUN",
            description: "Print the command that would be run, and don't run it",
            is_string: false,
            default_value: false
          ),

          FastlaneCore::ConfigItem.new(
            key: :app_name,
            env_name: "CODEPUSH_APP_NAME",
            description: "The name of the app on Codepush",
            verify_block: proc do |value|
              UI.user_error!("No app_name specified! Choose one using `code-push app ls`") unless (value and not value.empty?)
            end,
          ),

        ]
      end

      def self.output
        [
          ['CODEPUSH_DEPLOYMENT', 'The chosen codepush deployment']
        ]
      end

      def self.return_value
        # No return value
      end

      def self.authors
        ["j2kun", "tgpski"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
