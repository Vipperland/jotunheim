export class RealmsLocale {
		#_null = {};
		#_lib = Jotun.resources.buffer() || this.#_null;
		#_get(q){
			var v;
			var i = this.#_lib.length;
			while(i-- > 0){
				v = this.#_lib[i];
				if(v != null && v['locale']){
					return this.#_lib[i].locale[q];
				}
			}
			return '%' + q + '%';
		}
		add(o){
			this.#_lib.push(o.locale == null ? {locale:o} : o);
		}
		get(q){
			var v;
			q = (q+'').split(' ');
			for(var i in q){
				v = q[i];
				var cmd = v.substr(0, 1);
				switch(cmd){
					case '*' : {
						v = q.substring(1, q.length);
						break;
					}
					case '^' : {
						v = q[i].toUpperCase();
						break;
					}
					case '~' : {
						v = q[i].toLowerCase();
						break;
					}
					case '@' : {
						v = q[i];
						v = v.substr(0, 1).toUpperCase() + v.substring(1, q.length).toLowerCase();
						break;
					}
					default : {
						v = this.#_get(q);
					}
				}
				q[i] = v;
			}
			return q.join(' ');
		}
		url(q){
			q = q.split('/');
			for(var i in q){
				if(q[i].length > 0){
					q[i] = this.get(q[i]);
				}
			}
			return q.join('/');
		}
	}