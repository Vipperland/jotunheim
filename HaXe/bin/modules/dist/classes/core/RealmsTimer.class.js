class TimerCalc {
	#_base;
	#_root;
	#_cap;
	#_value;
	constructor(root, base, cap){
		this.#_base = base;
		this.#_root = root;
		this.#_cap = cap;
	}
	calc(value){
		this.#_value = this.#_base * (value || 0);
		return this;
	}
	offset(value){
		value = this.calc(value).value;
		this.#_value = this.#_root.value + value;
		return this;
	}
	elapsed(value){
		return ((this.offset(value).value - this.#_root.binded)/this.#_base)>>0;
	}
	segment(value){
		return this.elapsed(value)%this.#_cap;
	}
	get value(){
		return this.#_value;
	}
	get date(){
		return this.#_root.toDate(this.#_value);
	}
}
export class RealmsTimer {
	static now(){
		return this.init(new Date().getTime());
	}
	static init(time){
		return new RealmsTimer(time);
	}
	#_seconds;
	#_minutes;
	#_hours;
	#_days;
	#_bind;
	get value(){
		return this.date.getTime();
	}
	get seconds() {
		return this.#_seconds;
	}
	get minutes() {
		return this.#_minutes;
	}
	get hours() {
		return this.#_hours;
	}
	get days() {
		return this.#_days;
	}
	get binded() {
		return this.#_bind || this.now;
	}
	get date(){
		return new Date();
	}
	get bindedDate() {
		return new Date(this.binded);
	}
	constructor(bind){
		this.#_seconds = new TimerCalc(this, 1000, 60);
		this.#_minutes = new TimerCalc(this, 60000, 60);
		this.#_hours = new TimerCalc(this, 3600000, 24);
		this.#_days = new TimerCalc(this, 86400000, 1);
		if(bind != null){
			this.bind(bind);
		}
	}
	bind(time){
		this.#_bind = time;
		return this;
	}
	unbind(){
		this.#_bind = null;
		return this;
	}
	elapsed(time){
		return this.value - (time || this.binded);
	}
	toString(){
		function p(q){ return q < 10 ? '0' + q : q; }
		return 'RealmsTimer[now=' + this.date + (this.#_bind != null ? ',binded=' + this.bindedDate  + ',elapsed=' + 
			this.days.elapsed() + ':' + p(this.hours.segment()) + ':' + p(this.minutes.segment()) + ':' + p(this.seconds.segment())
		 : 'null') + ']';
	}
}