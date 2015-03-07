# rails_appcache

This is a simple set of helpers for using the appcache from a Rails application


## Why?

First, if you don't know what the appcache is, or you don't have (at least) a high-level understanding of how it works, read [A high-level overview of the appcache](https://github.com/meagar/rails_appcache/wiki/A-high-level-overview-of-the-appcache).


## How does rail_appcache help?

This gem serves appcache manifests from `app/views/rails_appcache/manifests/<name>.appcache.erb`. You are (mostly) responsible for maintainig these files, but there is a generator for building them, and helpers for including things from the asset pipeline.

This gem provides the following:

- Automatically serve manifest files with the corret `text/appcache` mime type
- Generators for building new manifests, with helpers for versioning (expiring) them
- A mountable engine for serving manifests
- Helper methods for exploding asset paths in development:
  - `javascript_cache_path`
  - `stylesheet_cache_path`
  - `asset_cache_path`


## Installation

Install the gem with `gem install rails_appcache`

### or

1. Add the gem to your gemfile:

  ```ruby
  gem 'rails_appcache'
  ```

2. Bundle:

  ```bash
  $ bundle
  ```

3. Restart your server.

## Usage

1. Mount the engine in `config/routes.rb`:

  ```ruby
  mount RailsAppcache::Engine => '/'
  ```

2. Add the views directory (TODO: make this configurable)

  ```bash
  $ mkdir app/views/rails_appcache/manifests
  ```

3. Generate a new manifest called "application":

  ```bash
  $ rails g appcache_manifest application
    create  app/views/rails_appcache/manifests/application.appcache.erb
  ```

  This will produce a file containing the following:

  ```erb
  CACHE MANIFEST

  # auto-expire appcache in dev
  # <%= appcache_version_string %>

  CACHE:
  # by default, only the root path is cached
  /

  # Cache additional paths by using path helpers:
  # <%= posts_path %>

  # Cache our JS/CSS bundles
  <%= stylesheet_cache_path 'application' %>
  <%= javascript_cache_path 'application' %>

  # Cache additional assets by using the asset_cache_path, or any of the Rails built-in asset pipeline helpers
  # <%= asset_cache_path 'logo.png' %>
  # or
  # <%= asset_path 'logo.png' %>

  # Make everything else accessible
  # WITHOUT THIS LINE, your browser will 404 for anything not explicitly listed under CACHE:
  NETWORK:
  *
  ```

4. Add any additional resources to cache to the manifest, and you're done

## `javascript_cache_path` and `stylesheet_cache_path`

These are helpers for making asset-path-served resources work inside appcache manifests.

During development, the asset pipeline "explodes" your manifests into many included JavaScript files, while during production the asset pipeline finger prints them.

Basically, given this JavaScript manifest:

```javascript
// app/assets/application.js
//= require jquery
//= require underscore
//= require posts
```

in development (with `config.assets.debug = true` in config/environments/development.rb), adding this file...

```erb
<%= javascript_include_tag 'application' %>
```

... will actually add *four* javascript tags:

```html
<script src="/assets/application.js?body=1"></script>
<script src="/assets/jquery.js?body=1"></script>
<script src="/assets/underscore.js?body=1"></script>
<script src="/posts.js?body=1"></script>
```

while in production it will be a single tag:

```html
<script src="/assets/application-1ef0203b2aab72467dc6261a2216e326.js""></script>
```

The obvious problem here is that, when working with the appcache, you need to list **all** of your resources, or they're going to 404 once your page is cached.

To help, you can use `javascript_cache_path` and `stylesheet_cache_path` in your appcache manifests, as direct analogs for `javascript_include_tag` and `stylesheet_link_tag` respectively:

```text.erb
CACHE MANIFEST

CACHE:
<%= javascript_cache_path 'application' %>
```

In development, this file will be served with the paths exploded:

```
CACHE MANIFEST

CACHE:
/assets/application.js?body=1
/assets/jquery.js?body=1
/assets/underscore.js?body=1
/posts.js?body=1
```

In production, you'll get the correctly fingerprinted URL.

## `appcache_version_string`

One common technique for expiring your appcache is to add a simple version string in a comment below the `CACHE MANIFEST` line. This helper outputs a continually changing string in development (the unix timestamp) and the current revision in production, meaning that each time you deploy your app (assuming you're using Capistrano) you will get a new appcache manifest and your clients will re-download your app.

### Doesn't this cause all of your assets to be expired on every single deploy?

Yes, but that's how the appcache works. You cannot expire individual things in the cache; if the manifest changes, **every single file** cached by that manifest is re-downloaded, so it really doesn't matter if we get much more clever in expiring the manifest. Typically, if your app is heavy on JavaScript, you'll *probably* need ot fully expire the appcache on each deploy.

