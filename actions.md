Actions.yaml
---
Node					 | Cardinlity | Parent Object | Contains 						        | Required Child Objects
-------------------------|------------|---------------|-----------------------------------------|-------------------------------------
WEBSITES: 				 |1..*|&empty;    |**Array** containing 1 URL Hash, and 1 ACTIONS Hash  | Hash[URL], Hash[ACTIONS]
URL: 					 |1   |WEBSTIES:  |**String** valid url								    | &empty;
ACTIONS:				 |1..*|WEBSTIES:  |**Array** of Complex Actions	Type or Hash[manual]    | Hash[action], Hash[action_type] or Hash[manual]
Complex Action Type (CAT)|1   |ACTIONS:   |**Array** of 2..* Hashes, or a Manual Type		    | depends on the Hash[action_type]
action:                  |0..*|CAT        |&empty;                                              | &empty;
action_type:             |1   |CAT        |**String** click_element, print_element,  input_data, input_variable, done | &empty;
identifier:              |1   |CAT        |1 Selenium Finder Hash                               | Hash[Selenium Finder]
Selenium Finder Hash     |1   |identifier:|See [Selenium::WebDriver::SearchContext::FINDERS](http://selenium.googlecode.com/svn/trunk/docs/api/rb/Selenium/WebDriver/SearchContext.html#FINDERS-constant) | &empty;
variable:                |1   |CAT        |**String** any key in *sites.yaml* with same url     | &empty; 
manual:                  |0..*|ACTIONS:   |&empty;                                              | &empty;    


*note:*  

* &empty; symbolizes empty  
* cardinality is denoted for the scope in which an object appears (*action_type* has a cardinality of 1 because there can only be one *action_type* object in each *action* object, but because the *action* object can appear multiple times, there can be more than 1 *action_type* object in the entire Actions.yaml). 

---

####Complex Actions
**General Definition**  
   
action:  
action_type: < click_element | print_element | input_data | input_variable | done >    
*Proceeding objects are dependent on the action_type value*

**click_element**  
*description:* click on a DOM element  
*required:* action, action_type, identifier
```yaml
- action:
  action_type: click_element
  identifier:
    id: submit
```
**print_element**   
*description:* print a DOM element type, value, and location to the log   
*required:* action, action_type, identifier
```yaml
- action:   
  action_type: print_element   
  identifier:  
    id: siteTable
```
**input_data**    
*description:* input text into a DOM element    
*required:* action, action_type, identifier, data
```yaml
- action:   
  action_type: input_data   
  identifier:  
    id: start-date    
  data: "01/01/2014"   
```
**input_variable**   
*description:* input text from a variable defined in *sties.yaml* into a DOM element    
*required:* action, action_type, identifier, variable
```yaml
- action:   
  action_type: input_variable   
  identifier:  
    id: start-date
  variable: user_name   
```
**done**  
*description:* close the web browser and tell the driver to quit    
*required:* action, action_type
```yaml
- action:   
  action_type: done    
```
####Manual Action
**manual**   
*description:* execute the manual ruby commands specified by a ruby file that includes the Manual module and overrides the self.run method. By including the Manual module you will have access to the @@driver object and @@log object. Override the self.run method to preform manual actions.   
*required:* manual
```yaml
- manual:
```

