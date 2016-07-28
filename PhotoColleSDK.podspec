# coding: utf-8
#
#  Be sure to run `pod spec lint photocolle-iOSSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "PhotoColleSDK"
  s.version      = "1.1.1"
  s.summary      = "フォトコレ iOS SDK"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                   NTT docomo フォトコレクションのAPIを利用するためのSDKです。
                   DESC

  s.homepage     = "https://www.kii.com"
  s.documentation_url = "http://docs.kii.com/ja/guides/photocolle/"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Kii Corporation" => "support@kii.com" }
  s.social_media_url   = "https://twitter.com/KiiCloudJP"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios

  #  When using multiple platforms
  s.ios.deployment_target = "8.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/KiiPlatform/photocolle-iOSSDK.git", :tag => "v#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.subspec 'GTMOAuth2' do |sp|
    sp.source_files = "photocolle-sdk/photocolle-sdk/ext/gtm/**/*.{h,m}"
    sp.requires_arc =
    [
      "photocolle-sdk/photocolle-sdk/ext/gtm/SessionFetcher/GTMGatherInputStream.m",
      "photocolle-sdk/photocolle-sdk/ext/gtm/SessionFetcher/GTMMIMEDocument.m",
      "photocolle-sdk/photocolle-sdk/ext/gtm/SessionFetcher/GTMReadMonitorInputStream.m",
      "photocolle-sdk/photocolle-sdk/ext/gtm/SessionFetcher/GTMSessionFetcher.m",
      "photocolle-sdk/photocolle-sdk/ext/gtm/SessionFetcher/GTMSessionFetcherLogging.m",
      "photocolle-sdk/photocolle-sdk/ext/gtm/SessionFetcher/GTMSessionFetcherLogViewController.m",
      "photocolle-sdk/photocolle-sdk/ext/gtm/SessionFetcher/GTMSessionFetcherService.m",
      "photocolle-sdk/photocolle-sdk/ext/gtm/SessionFetcher/GTMSessionUploadFetcher.m"
    ]
  end
  s.subspec 'SBJSON' do |sp|
    sp.requires_arc = false
    sp.source_files = "photocolle-sdk/photocolle-sdk/ext/json/**/*.{h,m}"
  end

  s.source_files  = "photocolle-sdk/photocolle-sdk/**/*.{h,m,c}"
  s.exclude_files = "photocolle-sdk/photocolle-sdk/ext/gtm/**/*.{h,m}",
                     "photocolle-sdk/photocolle-sdk/ext/json/**/*.{h,m}"
  s.public_header_files = "photocolle-sdk/photocolle-sdk/include/*.h"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  s.frameworks = "UIKit", "Security", "SystemConfiguration"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
