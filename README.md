# Vertebra

Micro Coffeescript framework for use instead of Backbone.View to avoid requiring
underscore and the whole backbone framework.

Supported Backbone.View features :

- DOM Events delegation (with prototype.events property)
- Class-level events API (listenTo / stopListening / on / off / trigger)
- Automatic element assignation (this.$el) and scoped finders (this.$(selector))

## Installation

Add to your Gemfile and bundle :

```ruby
gem 'vertebra'
```

Require the framework :

```javascript
//= require vertebra
```

## Usage

Here's a simple example API usage covering most of the Vertebra supported
features.

```coffeescript
class MyPanel extends Vertebra.View
  events:
    'click .trigger-button': 'buttonClicked'

  # Like for Backbone, use the `#initialize` method isteand of `#constructor`
  # to hook into class instanciation
  #
  initialize: ->
    @form = new MyForm(el: @$('form'))
    # Class-level events API
    @listenTo(@form, 'submit', @onFormSubmit)

  buttonClicked: ->
    # Button clicked here

  onFormSubmit: ->
    # Form submitted here


class MyButton extends Vertebra.View
  events:
    'submit': 'onSubmit'

  onSubmit: ->
    @trigger('submit')
```

# Licence

This project rocks and uses MIT-LICENSE.
