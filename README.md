
#Dancan

## Installation

Include 'dancan' in your Gemfile

``` ruby
gem 'dancan'
```

Include Dancan in your application controller:

``` ruby
class ApplicationController < ActionController::Base
  include Dancan
  protect_from_forgery

  def self.restrict_access(roles, options=nil)
    if options 
      before_filter(options) { restrict_access( :roles, roles) }
    else
      before_filter { restrict_access( :roles, roles) }
    end
  end

end
```
 
## Policies

In app/policies/role_policy.rb 

``` ruby
class RolePolicy < Struct.new(:current_admin, :roles)
  attr_reader :current_admin, :roles
  
  def initialize(current_admin, policy)
    @current_admin = current_admin
  end

  def role1
    @current_admin.has_any_role?(:role1)
  end

  def role2
    @current_admin.has_any_role?(:role2)
  end

  def role3
    @current_admin.has_any_role?(:role3)
  end

end
```

##Controller

In your controller, call restrict_access with an optional second parameter unless you want to restrict the entire controller

``` ruby
# restricts access only su action to role1 and role3
  restrict_access [:role1, :role3] , :only => [:su]

# restricts access everything except su action to role1 and role3 
  restrict_access [:role1, :role3] , :except => [:su] 
  
# restricts access entire controller to role1 and role3
  restrict_access [:role1, :role3] 
```

## Rescuing a denied Authorization in Rails

Dancan raises a `Dancan::NotAuthorizedError` you can
rescue_from in your `ApplicationController`. You can customize the `user_not_authorized`
method in every controller.

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery
  include Dancan

  rescue_from Dancan::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Access Denied."
    redirect_to(request.referrer || root_path)
  end
end
```

# License

Licensed under the MIT license, see the separate LICENSE.txt file.
