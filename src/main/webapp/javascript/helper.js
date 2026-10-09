// ------------------------------------------------------------------------------------
Object.eachProperty || Object.defineProperty(Object.prototype, 'eachProperty', {
// ------------------------------------------------------------------------------------
    enumerable: false,
    value: function(callback) {
        let i = 0;
        for(let k in this)
            if(this.hasOwnProperty(k))
                callback(k, i++);
        return this;
    }
});

// ------------------------------------------------------------------------------------
Object.eachPropertyValue || Object.defineProperty(Object.prototype, 'eachPropertyValue', {
// ------------------------------------------------------------------------------------
    enumerable: false,
    value: function(callback) {
        let i = 0;
        for(let k in this)
            if(this.hasOwnProperty(k) && callback(k, this[k], i++) === false)
                break;
        return this;
    }
});

// ------------------------------------------------------------------------------------
Object.countProperties || Object.defineProperty(Object.prototype, 'countProperties', {
// ------------------------------------------------------------------------------------
    enumerable: false,
    value: function(callback) {
        if(typeof callback === 'function') {
            callback(Object.keys(this).length);
            return this;
        }
        return Object.keys(this).length;
    }
});

// ------------------------------------------------------------------------------------
String.with || Object.defineProperty(String.prototype, 'with', {
// ------------------------------------------------------------------------------------
    enumerable: false,
    value: function() {
        let s = String(this);
        for(let i = 0; i < arguments.length; i++)
            s = s.replace('%s', arguments[i]);
        return s;
    }
});

// ------------------------------------------------------------------------------------- */
Array.equals || Object.defineProperty(Array.prototype, 'equals', {
// ----------------------------------------------------------------------------------------
    enumerable: false,
    value: function (other, deep = true) {
        if(!other || this.length != other.length)
            return false;
        for(let i = this.length - 1; i >= 0; i--) {
            if(deep && Array.isArray(this[i]) && Array.isArray(other[i]) && !this[i].equals(other[i], true))
                return false;
            else if(this[i] !== other[i])
                return false;
        }
        return true;
    }
});

// ------------------------------------------------------------------------------------- */
Array.includesAnyOf || Object.defineProperty(Array.prototype, 'includesAnyOf', {
// ----------------------------------------------------------------------------------------
    enumerable: false,
    value: function (other) {
        if(!(other instanceof Array))
            return false;
        return other.some(v => this.includes(v));
    }
});

// ------------------------------------------------------------------------------------
Object.getNestedValue || Object.defineProperty(Object.prototype, 'getNestedValue', {
// ------------------------------------------------------------------------------------
    enumerable: false,
    value: function(key) {
        if(typeof key === 'string')
            return this[key];
        if(key.length === 0)
            return undefined;
        let curVal = this;
        for(let i = 0; i < key.length && typeof curVal === 'object'; i++)
            curVal = curVal[key[i]];
        return curVal;
    }
});

var Helper = {

    // ------------------------------------------------------------------------------------
    sprintf: function(
        fmt
        /* arguments */
    ) {
    // ------------------------------------------------------------------------------------
        let s = fmt;
        for(let a = 1; a < arguments.length; a++)
            s = s.replace('%s', arguments[a]);
        return s;
    },

    // ------------------------------------------------------------------------------------
    startTiming: function() {
    // ------------------------------------------------------------------------------------
        return new Date();
    },

    // ------------------------------------------------------------------------------------
    getElapsedSeconds: function (start) {
    // ------------------------------------------------------------------------------------
        let diff = new Date() - start; // in ms
        return diff / 1000.;
    },

    // ------------------------------------------------------------------------------------
    // This function is based on https://stackoverflow.com/a/28847388/5529515 
    // by Tyler Johnson (https://stackoverflow.com/users/371587/tyler-johnson)
    decodeEntities: (function() {
    // ------------------------------------------------------------------------------------
        var div = document.createElement('div');
        var pattern = /&(?:#x[a-f0-9]+|#[0-9]+|[a-z0-9]+);?/ig;
        return function (str) {
            if(typeof str !== 'string')
                return str;
            str = str.replace(pattern, match => {
                div.innerHTML = match;
                return div.textContent;
            });
            div.textContent = '';
            return str;
        }
    })()
};

// ====================================================================
$.fn.extend({
	// found this at https://gist.github.com/Demwunz/2959289
	deferredResize: function(fn, delay){
		var timer = null;
		$(this).resize(function(){
			if(timer != null){
				clearTimeout(timer);
				timer = null;
			}
			timer = setTimeout(fn, delay);
		});
		return this;
	}
});
