package jotun.ai;
import jotun.dom.IDisplay;
import jotun.utils.ITable;

/**
 * ...
 * @author Rafael Moreira
 */
class Thinker {
	
	/*
	 * 
	 * [FONT]
	 * 		
	 * 		@Size = 18px
	 * 
	 * [COLORS]
	 * 	
	 * 		@BACKGROUND = #000000
	 * 		@TEXT = #FFFFFF
	 * 	
	 * [MENU]
	 * 
	 * 		@Home = /home
	 * 		@Cases = /cases
	 * 		@About = /about
	 * 		@Contact = /contact
	 * 
	 * [CONTENT]
	 * 	
	 * 		@BACKGROUND = /images/file.jpg
	 * 		@SIZE = 12
	 * 		
	 * 		@BLOCK
	 * 		Bla bla *bla* bla
	 * 		Bla bla _bla_ 
	 * 
	 * 		@HTML
	 * 
	 * [GALLERY]
	 * 		
	 * 		@SIZE = 4
	 * 	
	 * 		@IMG = /images/img1_big.jpg & /images/img1_thumb.jpg
	 * 		@IMG = /images/img2_big.jpg & /images/img2_thumb.jpg
	 * 		@IMG = /images/img3_big.jpg & /images/img3_thumb.jpg
	 * 		@IMG = /images/img4_big.jpg & /images/img4_thumb.jpg
	 * 		@IMG = /images/img5_big.jpg & /images/img5_thumb.jpg
	 * 		@VIDEO = /videos/video1.mp4 & /videos/video1_thumb.jpg
	 * 
	 * [CONTENT]
	 * 
	 * 		@Background = /images/file2.jpg
	 * 		@Size = 8
	 * 		
	 * 		@Block
	 * 		Bla bla bla bla
	 * 		Bla bla bla 
	 * 
	 * [FORM]
	 * 		
	 * 		@Background = #EFEFEF
	 * 		@Size = 6
	 * 		@Name = name
	 * 		@Email = me@domain.com
	 * 		@SendTo > /contact.php
	 * 
	 * [CONTENT]
	 * 
	 * 		@Background = /images/file2.jpg
	 * 		@Size = 6
	 * 		
	 * 		@Block
	 * 		Bla bla bla bla
	 * 		Bla bla bla 
	 * 
	 */
	
	private var _bills:Dynamic;
	
	public function fetch():Void {
		_bills = {};
		var table:ITable = Jotun.all('[thing-container]');
		table.each(function(container:IDisplay){
			if (container.data._thinker == null){
				container.data._thinker = {
					thought: null,
					things:[],
				};
			}
			var things:Array<IDisplay> = container.data._thinker.things;
			container.all('thing:not([completed-thought])').each(function(thing:IDisplay){
				thing.attribute('completed-thought');
				things.push(thing);
			});
		});
	}
	
	public function new(){
		_bills = {};
	}
	
}