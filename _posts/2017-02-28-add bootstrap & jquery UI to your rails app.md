---
layout: post
title: add bootstrap & jquery UI to your rails app
date: 2017-02-23 17:19:22 +0800
categories: rails
---
> For lazy you, you can directly go through these steps. 

detail in wikis: [bootstrap](http://www.rubydoc.info/gems/bootstrap-sass/3.3.6) and [jquery UI](http://www.rubydoc.info/gems/jquery-ui-sass-rails/4.0.3.0#Credits)

### 1 add below to your Gemfile
```
# Sass format (SCSS syntax) for the Rails 3.1+ asset pipeline.
# bootstrap
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails' #is optional, but recommended.
It automatically adds the proper vendor prefixes to your CSS code when it is compiled.

# jquery ui
gem 'jquery-ui-sass-rails'
```

### 2 run bundle install to install gem

### 3 rename app/assets/stylesheets/application.css to app/assets/stylesheets/application.scss, since using scss syntax

### 4 add below to the bottom of app/assets/stylesheets/application.scss
```
@import "bootstrap-sprockets";
@import "bootstrap";
@import "jquery.ui.all";
```

### 5 modify app/assets/javascripts/application.js like below
```
...
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require jquery.ui.all
//= require_tree .
```

### 6 do a test if bootstrap&jquery UI are doing good.

`test_app> rails g controller welcome index`
`test_app> vi app/views/welcome/index.html.erb`

```
<style>
#draggable { width: 150px; height: 150px; }
</style>
<script>
$(function() {
    $( "#draggable" ).draggable();
});
</script>

<div id="draggable" class="panel panel-info">
    <div class="panel-heading">You can drag this panel</div>
</div>
```

`test_app>rails s`

### 7 access http://localhost:3000/welcome/index to see if you have draggable panel in blue.
