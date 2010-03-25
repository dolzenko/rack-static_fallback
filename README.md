Bounces or redirects requests to missing static files.
Partially inspired by [http://menendez.com/blog/using-django-as-pass-through-image-proxy/](http://menendez.com/blog/using-django-as-pass-through-image-proxy/)

I.e. could be useful when you want to run the server with production database locally
and have user uploaded content fetched transparently from production site.

Options:
    :mode - [ :off,
              :bounce, # returns 404 to any request to static URL,
              :fallback ] # any request to static URL is redirected to options[:fallback_static_url]
    :static_path_regex - Regexp which matches the path to your static files.
                         Along the lines of the Capistrano conventions defaults to `%r{/system/(audios|photos|videos)}`
    :fallback_static_url - URL of the production site

To use with Rails add the following to your config/environments/development.rb:

    config.middleware.insert_after(::Rack::Lock,
                                   ::Rack::StaticFallback, :mode => :fallback,
                                                           :static_path_regex => %r{/public/uploads}
                                                           :fallback_static_url => "http://myproductionsite.com/")
