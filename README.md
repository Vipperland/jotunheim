#Sirius Framework
======
#####*A flexible framework to do simple and complex dreams come to reality with less headache and stress*

- [X] Work with JavaScript
- [X] Work with HaXe
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
Sirius.all('input').each(function(o){
	input.events.focusIn(function(e){ e.target.css('active'); });
	input.events.focusOut(function(e){ e.target.css('/active'); });
});

// Control event for send button
Sirius.one('#form-send-bt').events.click(function(e){
   var data = {};
   Sirius.all('input[name]').each(function(o){
   	data[o.attribute(name)] = o.hasFile() ? o.file() : o.value();
   });
   Sirius.request('form.php', data, function(result){
   	if(result.success)
		console.log(result.object()); //display json object in console
	else
		console.log(result.error); //display error object in console
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
