Pod::Spec.new do |s|
    s.name         = 'Foloosi-iOS-SDK'
    s.version      = '1.5.1'
    s.summary      = 'Foloosi iOS SDK'
    s.description  = <<-DESC
                    Foloosi iOS SDK Integration
                     DESC
    s.homepage     = 'https://www.foloosi.com'
    s.license      = { :type => "Apache License, Version 2.0", :text => <<-LICENSE
        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.
        LICENSE
      }
    s.author       = { "FoloosiTech" => "tech@foloosi.com" }
    s.source       = { :git => "https://github.com/FoloosiTech/Foloosi-iOS-SDK.git", :tag => s.version.to_s }
    s.vendored_frameworks = 'FoloosiSdk.xcframework'
    s.platform     = :ios, '11.0'
  end
  