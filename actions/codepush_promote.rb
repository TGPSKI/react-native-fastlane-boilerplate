# Codepush - Fastlane action
# Original implementation by Jeremy Kun (@j2kun)
# Updates by Tyler Pate (@TGPSKI)

module Fastlane
  module Actions
    module SharedValues
      CODEPUSH_PROMOTE_SOURCE = :CODEPUSH_PROMOTE_SOURCE
      CODEPUSH_PROMOTE_TARGET = :CODEPUSH_PROMOTE_TARGET
    end

    class CodepushPromoteAction < Action
      def self.run(params)
        require 'colored'

        rows = []
        rows << ["source_deployment", params[:source_deployment]]
        rows << ["target_deployment", params[:target_deployment]]
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

        # code-push promote <appName> <sourceDeploymentName> <destDeploymentName> [options]
        command = "code-push promote #{params[:app_name]} #{params[:source_deployment]} #{params[:target_deployment]} "\
                  "-r #{params[:rollout]} --des \"#{params[:description]}\" "
        if params[:mandatory]
           command += "-m "
        end

        if params[:dry_run]
          UI.message("Dry run!".red + " Would have run: " + command + "\n")
        else
          sh("cd #{ENV['PWD']} && #{command}")
        end

        Actions.lane_context[SharedValues::CODEPUSH_PROMOTE_SOURCE] = params[:source_deployment]
        Actions.lane_context[SharedValues::CODEPUSH_PROMOTE_TARGET] = params[:target_deployment]
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Promote a code push deployment using Microsoft CodePush"
      end

      def self.details
        "Promote one code push deployment to another"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :source_deployment,
            env_name: "CODEPUSH_PROMOTE_SOURCE",
            description: "The deployment name to promote from",
            verify_block: proc do |value|
              UI.user_error!("No CodePush source_deployment specified! Choose one using `code-push deployment ls APP_NAME` and pass it via deployment") unless (value and not value.empty?)
            end,
          ),

          FastlaneCore::ConfigItem.new(
            key: :target_deployment,
            env_name: "CODEPUSH_PROMOTE_TARGET",
            description: "The deployment name for the destination of the promotion",
            verify_block: proc do |value|
              UI.user_error!("No CodePush target_deployment specified! Choose one using `code-push deployment ls APP_NAME` and pass it via deployment") unless (value and not value.empty?)
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
          ['CODEPUSH_PROMOTE_SOURCE', 'The source deployment being promoted'],
          ['CODEPUSH_PROMOTE_TARGET', 'The target deployment of the promotion'],
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
