package sirius.seo;
import haxe.Json;
import haxe.Log;
import js.Browser;
import js.html.ScriptElement;
import sirius.dom.Display;
import sirius.dom.Style;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.seo.Product")
class Product extends SEO {
	
	public var reviewOf:IReview;
	
	public var brandOf:IBrand;
	
	public var offerOf:IOffer;
	
	public function new() {
		super("Product");
	}
	
	
	public function name(q:String):String {
		if (q != null) Reflect.setField(data, "name", q);
		return Reflect.field(data, "name");
	}
	
	public function image(q:String):String {
		if (q != null) Reflect.setField(data, "image", q);
		return Reflect.field(data, "image");
	}
	
	public function description(q:String):String {
		if (q != null) Reflect.setField(data, "description", q);
		return Reflect.field(data, "description");
	}
	
	public function mpn(q:Dynamic):String {
		if (q != null) Reflect.setField(data, "mpn", Std.string(q));
		return Reflect.field(data, "mpn");
	}
	
	public function review(?value:Float, ?reviews:Int):IReview {
		if (reviewOf == null) {
			reviewOf = cast { "@type":"AggregateRating", ratingValue:0, reviewCount:0 };
			Reflect.setField(data, "aggregateRating", reviewOf);
		}
		if (value != null) reviewOf.ratingValue = Std.string(value);
		if (reviews != null) reviewOf.reviewCount = Std.string(reviews);
		return reviewOf;
	}
	
	public function brand(?name:String, ?image:String, ?url:String):IBrand {
		if (brandOf == null) {
			brandOf = cast { "@type":"Thing", name:"" };
			Reflect.setField(data, "brand", brandOf);
		}
		if (name != null) brandOf.name = name;
		if (image != null) brandOf.image = image;
		if (url != null) brandOf.url = url;
		return brandOf;
	}
	
	public function offer(?currency:String, ?availability:String, ?from:Float, ?to:Float):IOffer {
		if (offerOf == null) {
			offerOf = cast { "@type":"AggregateOffer", name:"" };
			Reflect.setField(data, "offers", offerOf);
		}
		if (currency != null) offerOf.priceCurrency = currency.toUpperCase();
		if (availability != null) offerOf.availability = "http://schema.org/" + availability;
		if (from != null) {
			if (to != null) {
				offerOf.lowPrice = from;
				offerOf.highPrice = to;
			}else {
				offerOf.price = from;
			}
		}
		return offerOf;
	}
	
	public function build(?name:String, ?image:String, ?description:String, ?mpn:String):Product {
		this.name(name);
		this.image(image);
		this.description(description);
		this.mpn(mpn);
		return this;
	}
	
}