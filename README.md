# ActiverecordActivityTracker
`activerecord_activity_tracker` provides simple yet powerful activity tracker for your Rails **ActiveRecord** models.

This gem will allows you to create the data model for social **news feed** used in many modern platform in no time.

`Note:` This is an abstract gem, thus there are no views or controllers provided.











### Features
- Track model's creation and/or updating activities. 
- Track any custom activity's event easily.
- Add optional data to any custom activity.
- Set owner once, and use it in all tracked models seamlessly.
  
  
  
  
  
  
  
  
  
  
  
  
  
## Usage

### Track a model
- Include `ActiverecordActivityTracker::ActsAsTrackable`
- For automatic tracking add `acts_as_trackable`
- For custom event use `create_ar_activity`

### Set default owner (user)
- Include `ActiverecordActivityTracker::Owner`
- To set the owner use `set_owner(current_user)`
- To get the owner use `get_owner`
- To clear owner use `clear_owner`

`Note:` setting the owner is required, as each activity must have an owner, see [set default owner example](#set-default-owner-to-devise-current_user).
 

### Access model's tracked activities
- Include `ActiverecordActivityTracker::ActsAsTrackable`
- Use `ar_activities`

### Examples

#### Track comment's creation
```ruby
# app/models/comment.rb
class Comment < ApplicationRecord
  include ActiverecordActivityTracker::ActsAsTrackable

  acts_as_trackable [:create]
end
 ```
 
#### Track comment's creation and modification
```ruby
# app/models/comment.rb
class Comment < ApplicationRecord
  include ActiverecordActivityTracker::ActsAsTrackable

  acts_as_trackable [:create, :update]
end
 ``` 

#### Track comment's custom event (title's change)

```ruby
# app/models/comment.rb
class Comment < ApplicationRecord
  include ActiverecordActivityTracker::ActsAsTrackable

  after_update :add_title_change_activity
    
  private
    
  def add_title_change_activity
    create_ar_activity(key: 'comment.title.change') if saved_change_to_title?
  end
    
end
 ``` 

#### Set default owner to devise current_user
`Note:` owner is a polymorphic relation, thus any model can be used, not just user.
 
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include ActiverecordActivityTracker::Owner

  protect_from_forgery with: :exception

  around_action :set_ar_activity_owner


  private

  def set_ar_activity_owner
    set_owner current_user
    yield
  ensure
    clear_owner
  end

end
```

### Access comment's activities

```html
<!-- app/views/comments/show.erb -->
  <% @comment.ar_activities.each do |activity| %>
      <%= activity.key %>
      <br>
  <% end %>
```














## Installation
Add this line to your application's Gemfile:

```ruby
gem 'activerecord_activity_tracker'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install activerecord_activity_tracker
```

### Setup
Execute this line in your application's directory:
```bash
$ rails generate activerecord_activity_tracker:install
``` 

And then execute:
```bash
$ rails db:migrate
```













## Documentation / API
#### ActiverecordActivityTracker::ActsAsTrackable
- `acts_as_trackable(tracked = [:create, :update]) => nil`
    Overview:
    Track model automatically.

    Parameters:
    tracked (array) (defaults to: [:create, :update]) -- instance options to set the tracked events.


- `create_ar_activity(options = {}) => nil`
    Overview:
    Create custom activity, prevent duplication.

    Options:
    - key (string) (defaults to: "#{model_name.param_key}.create"). 
    - owner (active_record_relation) (defaults to: get_owner).
    - data (string) (defaults to: nil).

    Parameters:
-- options (hash) (defaults to: {}) -- instance options to set custom params.


- `create_ar_activity!(options = {}) => nil`
    Overview:
    Similar to `create_ar_activity` but allows duplication.



- `has_many :ar_activities, as: :trackable, dependent: :destroy`
    Overview: 
    Handle activities' relations.    
    
#### ActiverecordActivityTracker::Owner
- `get_owner() => owner (active_record_model or nil)`
    Overview: Get the current owner.

- `set_owner(owner) => nil`
    Overview: Set the current owner.
    
    Parameters:
    owner (active_record_model) -- instance active record model to set current owner.
    
    
- `clear_owner => nil`
    Overview: Set the current owner to nil.   


#### ArActivityTracker 
- ##### Description
    Activity model, to handle trackable and owner relations.

- ##### Data structure
    `    t.string "trackable_type"
     t.integer "trackable_id"
     t.string "owner_type"
     t.integer "owner_id"
     t.string "key"
     t.string "data"
`
- ##### Key default format
    MODEL_NAME.ACTIVITY_TYPE

    **For example:**
Given a `tracked` comment model `Comment`, then the keys (by default) will be:
`comment.create` and `comment.update` for creation and modification activities respectively. 


For more details see:
[rubydoc](https://www.rubydoc.info/gems/activerecord_activity_tracker)







## Contributing

1. Fork it ( https://github.com/mudafar/activerecord_activity_tracker/fork ).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Test your changes to ensure they pass all tests (`bin/test`) .
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create a new Pull Request


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
