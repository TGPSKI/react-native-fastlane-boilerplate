import './Common'

update_fastlane

# dir variable set to react native root directory
dir = File.expand_path('..', Dir.pwd)

# used for debugging options with jenkins
print_options = false

#################
#################
##### SETUP #####
#################
#################

before_all do
  yarn(
    command: 'install',
    package_path: './package.json'
  )
  yarn(
    command: 'checkmate',
    package_path: './package.json'
  )
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
    copyEnvForBuildType('dev')
  end

  desc 'iOS staging build'
  lane :staging do |options|
    debug_options(options, print_options)
    copyEnvForBuildType('staging')
  end

  desc 'iOS release build, upload to App Store'
  lane :release do |options|
    debug_options(options, print_options)
    copyEnvForBuildType('release')
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
    copyEnvForBuildType('dev')
  end

  desc 'Android staging build'
  lane :staging do |options|
    debug_options(options, print_options)
    copyEnvForBuildType('staging')
  end

  desc 'Android release build, upload to Play Store'
  lane :release do |options|
    debug_options(options, print_options)
    copyEnvForBuildType('release')
  end
end

##########################
##########################
##### CODEPUSH LANES #####
##########################
##########################

desc 'Codepush development'
lane :codepush_dev do |options|
  debug_options(options, print_options)
  copyEnvForBuildType('dev')
end

desc 'Codepush pre-release build'
lane :codepush_dev do |options|
  debug_options(options, print_options)
  copyEnvForBuildType('prod')
end

desc 'Codepush promotion pre-release -> release'
lane :codepush_promote do |options|
  debug_options(options, print_options)
end
