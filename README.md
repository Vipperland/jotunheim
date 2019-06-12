#Jotun Framework
======
#####*A flexible framework to do simple and complex dreams come to reality with less headache and stress*

- [X] Work with JavaScript
- [X] Work with Haxe
- [X] Work with PHP
- [X] Compatible with JQuery
- [X] Modules and Plugins
- [X] Modular CSS Generator
- [ ] Api Samples **WIP**
- [ ] Api Docs **WIP**
- [X] Its FREE


Javascript sample:

```
// Focus events for input
Jotun.all('input').each(function(o){
	o.events.focusIn(function(e){ e.target.css('active'); });
	o.events.focusOut(function(e){ e.target.css('/active'); });
});

// Control event for send button
Jotun.one('#form-send-bt').events.click(function(e){
   var data = {};
   Jotun.all('input[name]').each(function(o){
   	data[o.attribute(name)] = o.hasFile() ? o.file() : o.value();
   });
   Jotun.request('form.php', data, function(result){
   	if(result.success)
		trace(result.object()); //display json object in console
	else
		trace(result.error); //display error object in console
   }, 'POST');
});
```

PHP sample (form.php):

```
// Path and max size for images
Uploader->set('upload/images','upload/documents',1920,1080);

// Object for uploaded files info and received parameters (test)
$data = new \stdClass();
$data->files = Uploader->save();
$data->properties = Sirius->domain->params;

// Print data as json string
print json_encode($data);

```
