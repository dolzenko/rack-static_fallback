## About

NOTE: for maintained fork use https://github.com/6twenty/rack-static_fallback/

Bounces or redirects requests to missing static files.
Partially inspired by [http://menendez.com/blog/using-django-as-pass-through-image-proxy/](http://menendez.com/blog/using-django-as-pass-through-image-proxy/)

I.e. could be useful when you want to run the server with production database locally
and have user uploaded content fetched transparently from production site.

Options:
    :mode - [ :off,
              :bounce, # returns 404 to any request to static URL,
              :fallback ] # any request to static path is redirected to :fallback_static_url
    :static_path_regex - Regexp which matches the path to your static files.
                         Along the lines of the Capistrano conventions defaults to `%r{/system/(audios|photos|videos)}`
    :fallback_static_url - URL of the production site

To use with Rails install as a plugin:

    script/plugin install git://github.com/dolzenko/rack-static_fallback.git

then add the following to your `config/environments/development.rb`

    config.middleware.insert_after ::Rack::Lock,
                                   ::Rack::StaticFallback, :mode => :fallback,
                                                           :static_path_regex => %r{/system/uploads},
                                                           :fallback_static_url => "http://myproductionsite.com/"
## LICENSE

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.