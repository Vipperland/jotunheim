var utils = window.extended || {};
(function(utils) {
    var table=[];
    for(var i=0;i<26;i++) {
        table[i] = String.fromCharCode("A".charCodeAt(0)+i);
		table[i+26] = String.fromCharCode("a".charCodeAt(0)+i);
		if(i < 10) table[i + 52] = i.toString(10);
    }
    table.push("+");
    table.push("/");
    function b64encode(x) {
        var bits=[];
        for(var i=0;i<x.length;i++) {
            var byte=x.charCodeAt(i);
            for(var j=7;j>=0;j--) bits.push(byte&(1<<j));
		}
        var output=[];
        for(var i=0;i<bits.length;i+=6) {
            var sec=bits.slice(i, i+6).map(function(bit) {return bit?1:0;});
            var req=6-sec.length;
            while(sec.length<6) sec.push(0);
            sec=(sec[0]<<5)|(sec[1]<<4)|(sec[2]<<3)|(sec[3]<<2)|(sec[4]<<1)|sec[5];
            output.push(table[sec]);
            if(req==2) {
                output.push('=');
            }else if(req==4) {
                output.push('==');
            }
        }
        output=output.join("");
        return output;
    }
    if(window.btoa) b64encode=window.btoa;
    utils.CreatePixel = (hexColor, opacity) {
        var colorTuple=[
            (hexColor&(0xFF<<16))>>16,
            (hexColor&(0xFF<<8))>>8,
            hexColor&0xFF,
            Math.floor(opacity*255)
        ];
        var data="P7\nWIDTH 1\nHEIGHT 1\nDEPTH 4\nMAXVAL 255\nTUPLTYPE RGB_ALPHA\nENDHDR\n";
        colorTuple.forEach(function(tupleElement) { data+=String.fromCharCode(tupleElement); });
        var base64DataURL="data:image/pam;base64,"+b64encode(data);
        return base64DataURL;
    }
})(utils);