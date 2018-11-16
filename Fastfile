import './Common'

# Support ENV variables as options or lane parameters
fastlane_require 'dotenv'

# dir variable set to react native root directory
dir = File.expand_path('..', Dir.pwd).freeze

# used for debugging options with Jenkins
print_options = false.freeze

#################
#################
##### SETUP #####
#################
#################

PROJECT_NAME = 'myCoolApp'.freeze

## iOS ##
USES_COCOAPODS = true.freeze
USES_MATCH = false.freeze

IOS_APP_SPECIFIER = 'com.tgpski.myCoolApp'.freeze
XCODE_PROJECT_PATH = "ios/#{PROJECT_NAME}.xcodeproj".freeze
XCODE_WORKSPACE_PATH = "ios/#{PROJECT_NAME}.xcworkspace".freeze

DEV_PRODUCT_NAME = "#{PROJECT_NAME}-debug.app".freeze
DEV_SCHEME_NAME = "#{PROJECT_NAME}".freeze
DEV_BUNDLE_ID_SUFFIX = '.dev'.freeze

STAGING_PRODUCT_NAME = "#{PROJECT_NAME}-staging.app".freeze
STAGING_SCHEME_NAME = "#{PROJECT_NAME}-staging".freeze
STAGING_BUNDLE_ID_SUFFIX = '.staging'.freeze

RELEASE_SCHEME_NAME = "#{PROJECT_NAME}-release".freeze

DEVELOPMENT_PROVISIONING_PROFILE_NAME = ''.freeze
DEVELOPMENT_CODESIGNING_IDENTITY = ''.freeze
RELEASE_PROVISIONING_PROFILE_NAME = ''.freeze
RELEASE_CODESIGNING_IDENTITY = ''.freeze

BUILT_PRODUCTS_PATH = "#{dir}/ios/Build/Products".freeze

## Android ##
AND_APP_SPECIFIER = 'com.tgpski.myCoolApp'.freeze
APP_BUILD_GRADLE_PATH = 'android/app/build.gradle'.freeze

AND_DEV_BUNDLE_ID_SUFFIX = 'dev'.freeze
AND_DEV_BUILT_PPRODUCTS_PATH = "#{dir}/android/app/build/outputs/apk/debug/app-debug.apk".freeze

AND_STAGING_BUNDLE_ID_SUFFIX = 'staging'.freeze
AND_STAGING_BUILT_PPRODUCTS_PATH = "#{dir}/android/app/build/outputs/apk/staging/app-staging-unsigned.apk".freeze

AND_RELEASE_BUILT_PPRODUCTS_PATH = "#{dir}/android/app/build/outputs/apk/release/app-release.apk".freeze

######################
######################
##### BEFORE ALL #####
######################
######################

before_all do |lane, options|

  parsed_options = {
    :skip_before => handle_env_and_options(
      ENV['SKIP_BEFORE'],
      options[:skip_before],
      false,
      false
    )
  }

  unless parsed_options[:skip_before]
    yarn(
      command: 'install',
      package_path: './package.json'
    )

    unless lane_context[SharedValues::PLATFORM_NAME].to_s.eql?('android')
      if USES_COCOAPODS
        cocoapods(
          podfile: 'ios/Podfile',
          use_bundle_exec: false
        )
      end
    end

    yarn(
      command: 'checkmate',
      package_path: './package.json'
    )

    ANDROID_VERSION_NAME = get_version_name(
      gradle_file_path: APP_BUILD_GRADLE_PATH
    ).freeze
    ANDROID_VERSION_CODE = get_version_code(
      gradle_file_path: APP_BUILD_GRADLE_PATH
    ).freeze

    IOS_VERSION_NUMBER = get_version_number(
      xcodeproj: XCODE_PROJECT_PATH,
      target: PROJECT_NAME
    ).freeze
    IOS_REVISION_NUMBER = get_build_number_from_plist(
      xcodeproj: XCODE_PROJECT_PATH,
      target: PROJECT_NAME
    ).freeze

    puts "Android: #{ANDROID_VERSION_NAME},#{ANDROID_VERSION_CODE} |" \
         " iOS: #{IOS_VERSION_NUMBER},#{IOS_REVISION_NUMBER}"
  end
end

desc 'Test lane'
lane :fastlane_test do |options|
  debug_options(options, print_options)
end

#####################
#####################
##### iOS LANES #####
#####################
#####################

platform :ios do
  desc 'iOS development build'
  lane :dev do |options|
    debug_options(options, print_options)
    copy_env_for_build_type('dev')

    parsed_options = {
      :badge => handle_env_and_options(
        ENV['BADGE'],
        options[:badge],
        false,
        false
      ),
      :simulator => handle_env_and_options(
        ENV['SIMULATOR'],
        options[:simulator],
        false,
        false
      ),
      :clean => handle_env_and_options(
        ENV['CLEAN'],
        options[:clean],
        false,
        true
      ),
      :install => handle_env_and_options(
        ENV['INSTALL'],
        options[:install],
        false,
        false
      ),
      :xcargs => handle_env_and_options(
        ENV['XCARGS'],
        options[:xcargs],
        true,
        ''
      )
    }

    if parsed_options[:badge]
      add_badge(
        shield: "#{IOS_VERSION_NUMBER}-#{IOS_REVISION_NUMBER}-orange",
        alpha: true,
        shield_scale: '0.75'
      )
    end


    # Enable match action after configuring Matchfile and Github support
    if USES_MATCH
      match(type: 'development', readonly: true)
    end

    xcodebuild(
      workspace: XCODE_WORKSPACE_PATH,
      scheme: DEV_SCHEME_NAME,
      codesigning_identity: DEVELOPMENT_CODESIGNING_IDENTITY,
      provisioning_profile: DEVELOPMENT_PROVISIONING_PROFILE_NAME,
      destination: (
        parsed_options[:simulator] ?
          'generic/platform=iOS Simulator' :
          'generic/platform=iOS'
      ),
      clean: parsed_options[:clean],
      build: true,
      xcargs: parsed_options[:xcargs],
    )

    if parsed_options[:install]
      sh("xcrun simctl uninstall booted '#{IOS_APP_SPECIFIER}#{DEV_BUNDLE_ID_SUFFIX}'")
      sh("xcrun simctl install booted #{BUILT_PRODUCTS_PATH}/Debug-iphonesimulator/#{DEV_PRODUCT_NAME}")
      sh("xcrun simctl launch booted '#{IOS_APP_SPECIFIER}#{DEV_BUNDLE_ID_SUFFIX}'")
    end
  end

  desc 'iOS staging build'
  lane :staging do |options|
    debug_options(options, print_options)
    copy_env_for_build_type('staging')

    parsed_options = {
      :badge => handle_env_and_options(
        ENV['BADGE'],
        options[:badge],
        false,
        false
      ),
      :simulator => handle_env_and_options(
        ENV['SIMULATOR'],
        options[:simulator],
        false,
        false
      ),
      :clean => handle_env_and_options(
        ENV['CLEAN'],
        options[:clean],
        false,
        true
      ),
      :install => handle_env_and_options(
        ENV['INSTALL'],
        options[:install],
        false,
        false
      ),
      :xcargs => handle_env_and_options(
        ENV['XCARGS'],
        options[:xcargs],
        true,
        ''
      )
    }

    if parsed_options[:badge]
      add_badge(
        shield: "#{IOS_VERSION_NUMBER}-#{IOS_REVISION_NUMBER}-orange",
        alpha: true,
        shield_scale: '0.75'
      )
    end

    if USES_MATCH
      match(type: 'development', readonly: true)
    end

    xcodebuild(
      workspace: XCODE_WORKSPACE_PATH,
      scheme: STAGING_SCHEME_NAME,
      codesigning_identity: DEVELOPMENT_CODESIGNING_IDENTITY,
      provisioning_profile: DEVELOPMENT_PROVISIONING_PROFILE_NAME,
      destination: (
        parsed_options[:simulator] ?
          'generic/platform=iOS Simulator' :
          'generic/platform=iOS'
      ),
      clean: parsed_options[:clean],
      build: true,
      xcargs: parsed_options[:xcargs]
    )

    if parsed_options[:install]
      sh("xcrun simctl uninstall booted '#{IOS_APP_SPECIFIER}#{STAGING_BUNDLE_ID_SUFFIX}'")
      sh("xcrun simctl install booted #{BUILT_PRODUCTS_PATH}/Staging-iphonesimulator/#{STAGING_PRODUCT_NAME}")
      sh("xcrun simctl launch booted '#{IOS_APP_SPECIFIER}#{STAGING_BUNDLE_ID_SUFFIX}'")
    end
  end

  desc 'iOS release build, upload to App Store'
  lane :release do |options|
    debug_options(options, print_options)
    copy_env_for_build_type('release')

    parsed_options = {
      :app_store => handle_env_and_options(
        ENV['APP_STORE'],
        options[:app_store],
        false,
        false
      ),
      :xcargs => handle_env_and_options(
        ENV['XCARGS'],
        options[:xcargs],
        true,
        ''
      )
    }

    if USES_MATCH
      match(type: 'appstore', readonly: true)
    end

    gym(
      scheme: RELEASE_SCHEME_NAME,
      codesigning_identity: RELEASE_CODESIGNING_IDENTITY,
      provisioning_profile: RELEASE_PROVISIONING_PROFILE_NAME,
      clean: true,
      xcargs: xcargs
    )

    if parsed_options[:app_store]
      deliver(
        submit_for_review: false
      )
    end
  end
end

#########################
#########################
##### ANDROID LANES #####
#########################
#########################

platform :android do
  desc 'Android development build'
  lane :dev do |options|
    debug_options(options, print_options)
    copy_env_for_build_type('dev')

    parsed_options = {
      :badge => handle_env_and_options(
        ENV['BADGE'],
        options[:badge],
        false,
        false
      ),
      :clean => handle_env_and_options(
        ENV['CLEAN'],
        options[:clean],
        false,
        true
      ),
      :install => handle_env_and_options(
        ENV['INSTALL'],
        options[:install],
        false,
        false
      )
    }

    if parsed_options[:badge]
      add_badge(
        shield: "#{ANDROID_VERSION_NAME}-#{ANDROID_VERSION_CODE}-orange",
        glob: '/android/app/src/main/res/mipmap-*/ic_launcher.png',
        alpha: true,
        shield_scale: "0.75"
      )
    end

    if parsed_options[:clean]
      gradle(
        task: 'clean',
        project_dir: './android/'
      )
    end

    gradle(
      task: 'assemble',
      build_type: 'debug',
      project_dir: './android/'
    )

    if parsed_options[:install]
      adb(
        command: "uninstall #{AND_APP_SPECIFIER}.#{AND_DEV_BUNDLE_ID_SUFFIX}"
      )
      adb(
        command: "install #{AND_DEV_BUILT_PPRODUCTS_PATH}"
      )
      adb(
        command: "shell monkey -p #{AND_APP_SPECIFIER}.#{AND_DEV_BUNDLE_ID_SUFFIX}
                  -c android.intent.category.LAUNCHER 1"
      )
    end
  end

  desc 'Android staging build'
  lane :staging do |options|
    debug_options(options, print_options)
    copy_env_for_build_type('staging')

    parsed_options = {
      :badge => handle_env_and_options(
        ENV['BADGE'],
        options[:badge],
        false,
        false
      ),
      :clean => handle_env_and_options(
        ENV['CLEAN'],
        options[:clean],
        false,
        true
      ),
      :install => handle_env_and_options(
        ENV['INSTALL'],
        options[:install],
        false,
        false
      )
    }

    if parsed_options[:badge]
      add_badge(
        shield: "#{ANDROID_VERSION_NAME}-#{ANDROID_VERSION_CODE}-orange",
        glob: '/android/app/src/main/res/mipmap-*/ic_launcher.png',
        alpha: true,
        shield_scale: "0.75"
      )
    end

    if parsed_options[:clean]
      gradle(
        task: 'clean',
        project_dir: './android/'
      )
    end

    gradle(
      task: 'assemble',
      build_type: 'staging',
      project_dir: './android/'
    )

    if parsed_options[:install]
      adb(
        command: "uninstall #{AND_APP_SPECIFIER}.#{AND_STAGING_BUNDLE_ID_SUFFIX}"
      )
      adb(
        command: "install #{AND_STAGING_BUILT_PPRODUCTS_PATH}"
      )
      adb(
        command: "shell monkey -p #{AND_APP_SPECIFIER}.#{AND_STAGING_BUNDLE_ID_SUFFIX}
                  -c android.intent.category.LAUNCHER 1"
      )
    end
  end

  desc 'Android release build, upload to Play Store'
  lane :release do |options|
    debug_options(options, print_options)
    copy_env_for_build_type('release')

    parsed_options = {
      :play_store => handle_env_and_options(
        ENV['PLAY_STORE'],
        options[:play_store],
        false,
        false
      )
    }

    gradle(task: 'clean', project_dir: "./android/")

    gradle(task: "assemble", build_type: "release", project_dir: "./android/")

    if parsed_options[:play_store]
      supply(track: "alpha", apk: AND_RELEASE_BUILT_PPRODUCTS_PATH)
    end

  end
end

##########################
##########################
##### CODEPUSH LANES #####
##########################
##########################

# desc 'Codepush development'
# lane :cp_dev do |options|
#   debug_options(options, print_options)
#   copy_env_for_build_type('dev')
# end

# desc 'Codepush pre-release'
# lane :cp_pre_release do |options|
#   debug_options(options, print_options)
#   copy_env_for_build_type('prod')
# end

# desc 'Codepush promotion pre-release -> release'
# lane :cp_release do |options|
#   debug_options(options, print_options)
# end
