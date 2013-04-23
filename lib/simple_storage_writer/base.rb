require 'abstract_controller/asset_paths'
require 'abstract_controller/helpers'
require 'abstract_controller/layouts'
require 'abstract_controller/logger'
require 'abstract_controller/rendering'
require 'abstract_controller/translation'
require 'aws-sdk'

module SimpleStorageWriter
  class Base < AbstractController::Base
    abstract!

    include AbstractController::AssetPaths
    include AbstractController::Helpers
    include AbstractController::Layouts
    include AbstractController::Logger
    include AbstractController::Rendering
    include AbstractController::Translation
    
    self.view_paths = 'app/views'

    helper_method :page_url

    class << self
     def bucket
       AWS::S3.new.buckets[@bucket_name]
     end

     attr_writer :bucket_name
     def bucket_name(bucket_name)
       self.bucket_name = bucket_name
     end

     def respond_to?(method, include_private = false) #:nodoc:
       super || action_methods.include?(method.to_s)
     end

     protected

     def method_missing(method, *args) #:nodoc:
       return super unless respond_to?(method)
       new(method, *args)
     end
    end

    def initialize(method_name=nil, *args)
     process(method_name, *args) if method_name
    end

    def filename
     filename = @filename.dup
     filename << '/index.html' if filename[-5..-1] != '.html'
     filename
    end

    def page_url
     "http://#{bucket.name}/#{@filename}"
    end

    def delete
      bucket.objects[filename].delete
    end

    def write
     html = render(template: template_name)
     
     if @compress
       content = ActiveSupport::Gzip.compress(html)
       bucket.objects[filename].write(content, acl: :public_read, content_encoding: 'gzip', content_type: 'text/html')
     else
       bucket.objects[filename].write(html, acl: :public_read)
     end
    end

    protected

    def upload(filename, options={})
      @compress = options[:compress] || false
      @filename = filename
    end

    private

    def bucket
     self.class.bucket
    end

    def template_name
     "#{controller_path}/#{action_name}"
    end

  end
end