Streamline Selenium WebDriver Testing with Zander
---
There is a problem with fron-end testing. Websites are always changing. **Zander** audaciously 
attempts to provid a solution. Give zander two files `sites.yaml` and `actions.yaml`, and 
it will do all the work. `sites.yaml` will hold a list of URLs and any variables like user_name or password
that are assocaited to a URL. `actions.yaml` is a list of actions to take. 
actions contain attributes like action_type and identifier where you specify 
the action to preform and how to identifie the DOM element.
See Custom Input Example below.

Setup
---
#### Instilation
    $ gem install zander

Usage
---
#### irb example 
	$ irb
	irb(main):001:0> require 'zander'
	irb(main):002:0> Zander.run

#### rbenv example 
    $ rbenv exec zander
	
#### Custom ruby example
    require 'zander'
    Zander.run(sites: "sites.yaml", actions: "actions.yaml")
    
#### Ruby file with multiple examples
	$ gem environment | grep "INSTALLATION DIRECTORY" | cat \
	"$(cut -d ' ' -f 6)/gems/zander-$(gem list | grep zander | \
	cut -d '(' -f 2 | sed 's/)//g')/bin/zander"

Helpers
---
### Starter Files    
**Zander** is most powerful when build and customize your own *sites.yaml* and *actions.yaml* files. Here are some starter examples.    
 
sites.yaml

    WEBSITES:
      - url: https://www.google.com/
        user_name: "Replace this with your username"
        password: "Replace this with your password"


actions.yaml
	
    WEBSITES:
	  - URL: https://www.google.com/
	    ACTIONS:
	      - action:
	        action_type: click_element
	        identifier:
	          id: gb_70
	      - action:
	        action_type: print_element
	        identifier:
	          class: tagline
	      - action:
	        action_type: input_variable
	        identifier:
	          id: Email
	        variable: user_name
	      - action:
	        action_type: input_variable
	        identifier:
	          id: Passwd
	        variable: password
	      - action:
	        action_type: click_element
	        identifier:
	          id: signIn
	      - manual:
	      - action:
	        action_type: done

Notice: variable names and their values are defined by you in `sites.yaml`. 
variables can then be used in `actions.yaml`. i.e. You could change `user_name:` 
to `email:` or any other value that you prefer and as long as you also 
update `user_name` to 'email' in the `actions.yaml` it will still work.

Documentation
---
* `actions.yaml` documentation {file:actions.md docs}
* source documentation [http://bit.ly/zanderdoc](http://bit.ly/zanderdoc)