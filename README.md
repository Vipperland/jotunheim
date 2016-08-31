#Sirius Framework
======
#####*A flexible coded framework to do simple and complex dreams come to reality with less headache and stress*

- [X] Work with JavaScript
- [X] Work with HaXe
- [X] Work with JQuery
- [X] Work with GSAP
- [X] Its FREE


Javascript sample:

```
Sirius.all('input').each(function(o){
	input.events.focusIn(function(e){ e.target.css('active'); });
	input.events.focusOut(function(e){ e.target.css('/active'); });
});

Sirius.one('#form-send-bt').events.click(function(e){
   var data = {};
   Sirius.all('input[name]').each(function(o){
   		data[o.attribute(name)] = o.hasFile() ? o.file() : o.value();
   });
   Sirius.request('form.php', data, function(result){
   		if(result.success)
   			alert(result.data);
   		else
   			alert(result.error);
   });
});
```
