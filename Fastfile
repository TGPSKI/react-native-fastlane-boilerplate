import './Common'

update_fastlane

# dir variable set to react native root directory
dir = File.expand_path('..', Dir.pwd)

# used for debugging options with jenkins
print_options = true

#################
##### SETUP #####
#################

before_all do
  yarn(
    command: 'install',
    package_path: './package.json'
  )
end

desc 'Test lane'
lane :fastlane_test do |options|
  debug_options(options, print_options)
end

#####################
##### iOS LANES #####
#####################

platform :ios do
  lane :dev do |options|
    yarn(
      command: 'pre-build ios dev',
      package_path: './package.json'
    )

    debug_options(options, print_options)
  end
end

#########################
##### ANDROID LANES #####
#########################

platform :android do
  lane :dev do |options|
    yarn(
      command: 'pre-build android dev',
      package_path: './package.json'
    )

    debug_options(options, print_options)
  end
end

##########################
##### CODEPUSH LANES #####
##########################

desc 'Codepush development build'
lane :codepush_dev do |options|
  yarn(
    command: 'pre-build codepush dev',
    package_path: './package.json'
  )

  debug_options(options, print_options)
end
