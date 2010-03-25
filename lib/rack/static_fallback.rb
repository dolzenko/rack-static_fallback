module Rack
  # Bounces or redirects requests to missing static files.
  # Partially inspired by [http://menendez.com/blog/using-django-as-pass-through-image-proxy/](http://menendez.com/blog/using-django-as-pass-through-image-proxy/)
  #
  # I.e. could be useful when you want to run the server with production database locally
  # and have user uploaded content fetched transparently from production site.
  #
  # Options:
  #     :mode - [ :off,
  #               :bounce, # returns 404 to any request to static URL,
  #               :fallback ] # any request to static path is redirected to :fallback_static_url
  #     :static_path_regex - Regexp which matches the path to your static files.
  #                          Along the lines of the Capistrano conventions defaults to `%r{/system/(audios|photos|videos)}`
  #     :fallback_static_url - URL of the production site
  #
  # To use with Rails install as a plugin:
  #
  #     script/plugin install git://github.com/dolzenko/rack-static_fallback.git
  #
  # then add the following to your `config/environments/development.rb`
  #
  #     config.middleware.insert_after ::Rack::Lock,
  #                                    ::Rack::StaticFallback, :mode => :fallback,
  #                                                            :static_path_regex => %r{/system/uploads},
  #                                                            :fallback_static_url => "http://myproductionsite.com/"
  #

  class StaticFallback
    def initialize(app, options = {})
      @app = app
      @mode = options[:mode] || :off
      # along the lines of the Capistrano defaults
      @static_path_regex = options[:static_path_regex] || %r{/system/(audios|photos|videos)}
      @fallback_static_url = options[:fallback_static_url] 
    end

    def call(env)
      if env["PATH_INFO"] =~ @static_path_regex
        # If we get here that means that underlying web server wasn't able to serve the static file,
        # i.e. it wasn't found.
        case @mode
          when :off
            # pass the request to next middleware, ultimately Rails
            @app.call(env)

          when :bounce
            # don't pass the request so that it doesn't hit framework, which
            # speeds up things significantly
            not_found

          when :fallback
            if @fallback_static_url
              # redirect request to the production server
              [ 302, { "Location" => ::File.join(@fallback_static_url, env["PATH_INFO"]) }, [] ]
            else
              ActionController::Base.logger.debug "You're using StaticFallback middleware with StaticFallback.mode set to :fallback " <<
                      "however StaticFallback.fallback_static_url has not been set."
              not_found
            end
        end

      else
        @app.call(env)
      end
    end

    def not_found
      [ 404, { "Content-Type" => "text/html", "Content-Length" => "0" }, [] ]
    end
  end
end