(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.1/optimize for better performance and smaller assets.');


var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	result = init(result.a);
	var model = result.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		result = A2(update, msg, model);
		stepper(model = result.a, viewMetadata);
		_Platform_enqueueEffects(managers, result.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, result.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**_UNUSED/
	var node = args['node'];
	//*/
	/**/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS


function _VirtualDom_noScript(tag)
{
	return tag == 'script' ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return /^(on|formAction$)/i.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri_UNUSED(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,'')) ? '' : value;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,''))
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri_UNUSED(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2($elm$json$Json$Decode$map, func, handler.a)
				:
			A3($elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				$elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		message: func(record.message),
		stopPropagation: record.stopPropagation,
		preventDefault: record.preventDefault
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		(key !== 'value' || key !== 'checked' || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		value
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		value
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: $elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!$elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.message;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.stopPropagation;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.preventDefault) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			var oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			var newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}



// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var view = impl.view;
			/**_UNUSED/
			var domNode = args['node'];
			//*/
			/**/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.setup && impl.setup(sendToApp)
			var view = impl.view;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.body);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.title) && (_VirtualDom_doc.title = title = doc.title);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.onUrlChange;
	var onUrlRequest = impl.onUrlRequest;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		setup: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = $elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.protocol === next.protocol
							&& curr.host === next.host
							&& curr.port_.a === next.port_.a
						)
							? $elm$browser$Browser$Internal(next)
							: $elm$browser$Browser$External(href)
					));
				}
			});
		},
		init: function(flags)
		{
			return A3(impl.init, flags, _Browser_getUrl(), key);
		},
		view: impl.view,
		update: impl.update,
		subscriptions: impl.subscriptions
	});
}

function _Browser_getUrl()
{
	return $elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return $elm$core$Result$isOk(result) ? $elm$core$Maybe$Just(result.a) : $elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { hidden: 'hidden', change: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { hidden: 'mozHidden', change: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { hidden: 'msHidden', change: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { hidden: 'webkitHidden', change: 'webkitvisibilitychange' }
		: { hidden: 'hidden', change: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail($elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		scene: _Browser_getScene(),
		viewport: {
			x: _Browser_window.pageXOffset,
			y: _Browser_window.pageYOffset,
			width: _Browser_doc.documentElement.clientWidth,
			height: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			scene: {
				width: node.scrollWidth,
				height: node.scrollHeight
			},
			viewport: {
				x: node.scrollLeft,
				y: node.scrollTop,
				width: node.clientWidth,
				height: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			scene: _Browser_getScene(),
			viewport: {
				x: x,
				y: y,
				width: _Browser_doc.documentElement.clientWidth,
				height: _Browser_doc.documentElement.clientHeight
			},
			element: {
				x: x + rect.left,
				y: y + rect.top,
				width: rect.width,
				height: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});
var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$LT = {$: 'LT'};
var $elm$core$List$cons = _List_cons;
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0.a;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Basics$GT = {$: 'GT'};
var $elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var $elm$core$Basics$False = {$: 'False'};
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var $elm$core$Maybe$Nothing = {$: 'Nothing'};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 'Nothing') {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / $elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = {$: 'True'};
var $elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 'Normal':
			return 0;
		case 'MayStopPropagation':
			return 1;
		case 'MayPreventDefault':
			return 2;
		default:
			return 3;
	}
};
var $elm$browser$Browser$External = function (a) {
	return {$: 'External', a: a};
};
var $elm$browser$Browser$Internal = function (a) {
	return {$: 'Internal', a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$browser$Browser$Dom$NotFound = function (a) {
	return {$: 'NotFound', a: a};
};
var $elm$url$Url$Http = {$: 'Http'};
var $elm$url$Url$Https = {$: 'Https'};
var $elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {fragment: fragment, host: host, path: path, port_: port_, protocol: protocol, query: query};
	});
var $elm$core$String$contains = _String_contains;
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$indexes = _String_indexes;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toInt = _String_toInt;
var $elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if ($elm$core$String$isEmpty(str) || A2($elm$core$String$contains, '@', str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, ':', str);
			if (!_v0.b) {
				return $elm$core$Maybe$Just(
					A6($elm$url$Url$Url, protocol, str, $elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_v0.b.b) {
					var i = _v0.a;
					var _v1 = $elm$core$String$toInt(
						A2($elm$core$String$dropLeft, i + 1, str));
					if (_v1.$ === 'Nothing') {
						return $elm$core$Maybe$Nothing;
					} else {
						var port_ = _v1;
						return $elm$core$Maybe$Just(
							A6(
								$elm$url$Url$Url,
								protocol,
								A2($elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		}
	});
var $elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '/', str);
			if (!_v0.b) {
				return A5($elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _v0.a;
				return A5(
					$elm$url$Url$chompBeforePath,
					protocol,
					A2($elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '?', str);
			if (!_v0.b) {
				return A4($elm$url$Url$chompBeforeQuery, protocol, $elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _v0.a;
				return A4(
					$elm$url$Url$chompBeforeQuery,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '#', str);
			if (!_v0.b) {
				return A3($elm$url$Url$chompBeforeFragment, protocol, $elm$core$Maybe$Nothing, str);
			} else {
				var i = _v0.a;
				return A3(
					$elm$url$Url$chompBeforeFragment,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$core$String$startsWith = _String_startsWith;
var $elm$url$Url$fromString = function (str) {
	return A2($elm$core$String$startsWith, 'http://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Http,
		A2($elm$core$String$dropLeft, 7, str)) : (A2($elm$core$String$startsWith, 'https://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Https,
		A2($elm$core$String$dropLeft, 8, str)) : $elm$core$Maybe$Nothing);
};
var $elm$core$Basics$never = function (_v0) {
	never:
	while (true) {
		var nvr = _v0.a;
		var $temp$_v0 = nvr;
		_v0 = $temp$_v0;
		continue never;
	}
};
var $elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(_Utils_Tuple0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0.a;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return _Utils_Tuple0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(_Utils_Tuple0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0.a;
		return $elm$core$Task$Perform(
			A2($elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			$elm$core$Task$Perform(
				A2($elm$core$Task$map, toMessage, task)));
	});
var $elm$browser$Browser$element = _Browser_element;
var $author$project$Main$Model = function (app) {
	return {app: app};
};
var $author$project$Music$Models$Key$C = {$: 'C'};
var $author$project$Music$Models$Key$Major = {$: 'Major'};
var $author$project$Music$Models$Time$Four = {$: 'Four'};
var $author$project$Music$Models$Time$Time = F2(
	function (beats, beatType) {
		return {beatType: beatType, beats: beats};
	});
var $author$project$Music$Models$Time$common = A2($author$project$Music$Models$Time$Time, 4, $author$project$Music$Models$Time$Four);
var $author$project$Music$Models$Part$Part = F3(
	function (id, name, abbrev) {
		return {abbrev: abbrev, id: id, name: name};
	});
var $elm$core$String$toLower = _String_toLower;
var $author$project$Music$Models$Part$part = F2(
	function (name, abbrev) {
		var id = $elm$core$String$toLower(name);
		return A3($author$project$Music$Models$Part$Part, id, name, abbrev);
	});
var $author$project$Music$Models$Part$default = A2($author$project$Music$Models$Part$part, 'Piano', 'Pno.');
var $author$project$Music$Models$Measure$Measure = F2(
	function (attributes, notes) {
		return {attributes: attributes, notes: notes};
	});
var $mgold$elm_nonempty_list$List$Nonempty$Nonempty = F2(
	function (a, b) {
		return {$: 'Nonempty', a: a, b: b};
	});
var $mgold$elm_nonempty_list$List$Nonempty$fromElement = function (x) {
	return A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, x, _List_Nil);
};
var $author$project$Music$Models$Note$Note = F4(
	function (_do, duration, modifiers, harmony) {
		return {_do: _do, duration: duration, harmony: harmony, modifiers: modifiers};
	});
var $author$project$Music$Models$Note$Rest = {$: 'Rest'};
var $author$project$Music$Models$Note$restFor = function (d) {
	return A4($author$project$Music$Models$Note$Note, $author$project$Music$Models$Note$Rest, d, _List_Nil, $elm$core$Maybe$Nothing);
};
var $author$project$Music$Models$Duration$Duration = F2(
	function (count, divisor) {
		return {count: count, divisor: divisor};
	});
var $author$project$Music$Models$Duration$division = $author$project$Music$Models$Duration$Duration(1);
var $author$project$Music$Models$Duration$whole = $author$project$Music$Models$Duration$division(1);
var $author$project$Music$Models$Measure$fromAttributes = function (attrs) {
	return A2(
		$author$project$Music$Models$Measure$Measure,
		attrs,
		$mgold$elm_nonempty_list$List$Nonempty$fromElement(
			$author$project$Music$Models$Note$restFor($author$project$Music$Models$Duration$whole)));
};
var $author$project$Music$Models$Measure$initial = F3(
	function (s, t, k) {
		var attrs = {
			key: $elm$core$Maybe$Just(k),
			staff: $elm$core$Maybe$Just(s),
			time: $elm$core$Maybe$Just(t)
		};
		return $author$project$Music$Models$Measure$fromAttributes(attrs);
	});
var $author$project$Music$Models$Key$Key = F2(
	function (fifths, mode) {
		return {fifths: fifths, mode: mode};
	});
var $elm$core$Basics$modBy = _Basics_modBy;
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $author$project$Music$Models$Key$modeShift = function (mode) {
	switch (mode.$) {
		case 'Major':
			return 0;
		case 'Minor':
			return -3;
		case 'Ionian':
			return 0;
		case 'Dorian':
			return -2;
		case 'Phrygian':
			return -4;
		case 'Lydian':
			return 1;
		case 'Mixolydian':
			return -1;
		case 'Aeolian':
			return -3;
		case 'Locrian':
			return -5;
		default:
			return 0;
	}
};
var $author$project$Music$Models$Key$keyOf = F2(
	function (name, mode) {
		var normalize = function (n) {
			return A2($elm$core$Basics$modBy, 12, n + 17) - 5;
		};
		var fifths = function () {
			switch (name.$) {
				case 'C':
					return 0;
				case 'G':
					return 1;
				case 'D':
					return 2;
				case 'A':
					return 3;
				case 'E':
					return 4;
				case 'B':
					return 5;
				case 'Fsharp':
					return 6;
				case 'Gflat':
					return -6;
				case 'Dflat':
					return -5;
				case 'Aflat':
					return -4;
				case 'Eflat':
					return -3;
				case 'Bflat':
					return -2;
				default:
					return -1;
			}
		}();
		return A2(
			$author$project$Music$Models$Key$Key,
			normalize(
				fifths + $author$project$Music$Models$Key$modeShift(mode)),
			mode);
	});
var $author$project$Music$Models$Measure$noAttributes = {key: $elm$core$Maybe$Nothing, staff: $elm$core$Maybe$Nothing, time: $elm$core$Maybe$Nothing};
var $author$project$Music$Models$Measure$new = $author$project$Music$Models$Measure$fromAttributes($author$project$Music$Models$Measure$noAttributes);
var $author$project$Music$Models$Score$Score = F3(
	function (title, parts, measures) {
		return {measures: measures, parts: parts, title: title};
	});
var $elm$core$Array$fromListHelp = F3(
	function (list, nodeList, nodeListSize) {
		fromListHelp:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, list);
			var jsArray = _v0.a;
			var remainingItems = _v0.b;
			if (_Utils_cmp(
				$elm$core$Elm$JsArray$length(jsArray),
				$elm$core$Array$branchFactor) < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					true,
					{nodeList: nodeList, nodeListSize: nodeListSize, tail: jsArray});
			} else {
				var $temp$list = remainingItems,
					$temp$nodeList = A2(
					$elm$core$List$cons,
					$elm$core$Array$Leaf(jsArray),
					nodeList),
					$temp$nodeListSize = nodeListSize + 1;
				list = $temp$list;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue fromListHelp;
			}
		}
	});
var $elm$core$Array$fromList = function (list) {
	if (!list.b) {
		return $elm$core$Array$empty;
	} else {
		return A3($elm$core$Array$fromListHelp, list, _List_Nil, 0);
	}
};
var $author$project$Music$Models$Score$score = F3(
	function (t, pList, mList) {
		return A3(
			$author$project$Music$Models$Score$Score,
			t,
			pList,
			$elm$core$Array$fromList(mList));
	});
var $author$project$Music$Models$Staff$Staff = function (basePitch) {
	return {basePitch: basePitch};
};
var $author$project$Music$Models$Pitch$E = {$: 'E'};
var $author$project$Music$Models$Pitch$Pitch = F3(
	function (step, alter, octave) {
		return {alter: alter, octave: octave, step: step};
	});
var $author$project$Music$Models$Pitch$unaltered = 0;
var $author$project$Music$Models$Pitch$e_ = A2($author$project$Music$Models$Pitch$Pitch, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$unaltered);
var $author$project$Music$Models$Staff$treble = $author$project$Music$Models$Staff$Staff(
	$author$project$Music$Models$Pitch$e_(5));
var $author$project$Music$Models$Score$empty = A3(
	$author$project$Music$Models$Score$score,
	'New Score',
	_List_fromArray(
		[$author$project$Music$Models$Part$default]),
	_List_fromArray(
		[
			A3(
			$author$project$Music$Models$Measure$initial,
			$author$project$Music$Models$Staff$treble,
			$author$project$Music$Models$Time$common,
			A2($author$project$Music$Models$Key$keyOf, $author$project$Music$Models$Key$C, $author$project$Music$Models$Key$Major)),
			$author$project$Music$Models$Measure$new,
			$author$project$Music$Models$Measure$new,
			$author$project$Music$Models$Measure$new
		]));
var $author$project$TouchTunes$Models$App$App = F2(
	function (score, editing) {
		return {editing: editing, score: score};
	});
var $author$project$TouchTunes$Models$App$init = function (score) {
	return A2($author$project$TouchTunes$Models$App$App, score, $elm$core$Maybe$Nothing);
};
var $author$project$Main$initialModel = $author$project$Main$Model(
	$author$project$TouchTunes$Models$App$init($author$project$Music$Models$Score$empty));
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$core$Platform$Sub$none = $elm$core$Platform$Sub$batch(_List_Nil);
var $author$project$TouchTunes$Models$App$close = function (app) {
	return _Utils_update(
		app,
		{editing: $elm$core$Maybe$Nothing});
};
var $elm$core$Debug$log = _Debug_log;
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $elm_community$maybe_extra$Maybe$Extra$or = F2(
	function (ma, mb) {
		if (ma.$ === 'Nothing') {
			return mb;
		} else {
			return ma;
		}
	});
var $elm_community$list_extra$List$Extra$scanl = F3(
	function (f, b, xs) {
		var scan1 = F2(
			function (x, accAcc) {
				if (accAcc.b) {
					var acc = accAcc.a;
					return A2(
						$elm$core$List$cons,
						A2(f, x, acc),
						accAcc);
				} else {
					return _List_Nil;
				}
			});
		return $elm$core$List$reverse(
			A3(
				$elm$core$List$foldl,
				scan1,
				_List_fromArray(
					[b]),
				xs));
	});
var $author$project$Music$Models$Score$attributes = function (s) {
	var measures = s.measures;
	var fn = F2(
		function (a, b) {
			return {
				key: A2($elm_community$maybe_extra$Maybe$Extra$or, a.key, b.key),
				staff: A2($elm_community$maybe_extra$Maybe$Extra$or, a.staff, b.staff),
				time: A2($elm_community$maybe_extra$Maybe$Extra$or, a.time, b.time)
			};
		});
	return $elm$core$Array$fromList(
		A3(
			$elm_community$list_extra$List$Extra$scanl,
			fn,
			$author$project$Music$Models$Measure$noAttributes,
			A2(
				$elm$core$List$map,
				function (m) {
					return m.attributes;
				},
				$elm$core$Array$toList(measures))));
};
var $elm$core$Bitwise$and = _Bitwise_and;
var $elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var $elm$core$Array$bitMask = 4294967295 >>> (32 - $elm$core$Array$shiftStep);
var $elm$core$Basics$ge = _Utils_ge;
var $elm$core$Elm$JsArray$unsafeGet = _JsArray_unsafeGet;
var $elm$core$Array$getHelp = F3(
	function (shift, index, tree) {
		getHelp:
		while (true) {
			var pos = $elm$core$Array$bitMask & (index >>> shift);
			var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
			if (_v0.$ === 'SubTree') {
				var subTree = _v0.a;
				var $temp$shift = shift - $elm$core$Array$shiftStep,
					$temp$index = index,
					$temp$tree = subTree;
				shift = $temp$shift;
				index = $temp$index;
				tree = $temp$tree;
				continue getHelp;
			} else {
				var values = _v0.a;
				return A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, values);
			}
		}
	});
var $elm$core$Bitwise$shiftLeftBy = _Bitwise_shiftLeftBy;
var $elm$core$Array$tailIndex = function (len) {
	return (len >>> 5) << 5;
};
var $elm$core$Array$get = F2(
	function (index, _v0) {
		var len = _v0.a;
		var startShift = _v0.b;
		var tree = _v0.c;
		var tail = _v0.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? $elm$core$Maybe$Nothing : ((_Utils_cmp(
			index,
			$elm$core$Array$tailIndex(len)) > -1) ? $elm$core$Maybe$Just(
			A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, tail)) : $elm$core$Maybe$Just(
			A3($elm$core$Array$getHelp, startShift, index, tree)));
	});
var $author$project$Music$Models$Score$measure = F2(
	function (i, s) {
		return A2($elm$core$Array$get, i, s.measures);
	});
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$Music$Models$Score$measureWithContext = F2(
	function (i, s) {
		var a = A2(
			$elm$core$Maybe$withDefault,
			$author$project$Music$Models$Measure$noAttributes,
			A2(
				$elm$core$Array$get,
				i,
				$author$project$Music$Models$Score$attributes(s)));
		return A2(
			$elm$core$Maybe$map,
			function (m) {
				return _Utils_Tuple2(m, a);
			},
			A2($author$project$Music$Models$Score$measure, i, s));
	});
var $author$project$TouchTunes$Models$Editor$Editor = F3(
	function (measure, controls, overlay) {
		return {controls: controls, measure: measure, overlay: overlay};
	});
var $author$project$Music$Models$Layout$Layout = F4(
	function (zoom, divisors, indirect, direct) {
		return {direct: direct, divisors: divisors, indirect: indirect, zoom: zoom};
	});
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $mgold$elm_nonempty_list$List$Nonempty$filter = F3(
	function (p, d, _v0) {
		var x = _v0.a;
		var xs = _v0.b;
		if (p(x)) {
			return A2(
				$mgold$elm_nonempty_list$List$Nonempty$Nonempty,
				x,
				A2($elm$core$List$filter, p, xs));
		} else {
			var _v1 = A2($elm$core$List$filter, p, xs);
			if (!_v1.b) {
				return A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, d, _List_Nil);
			} else {
				var y = _v1.a;
				var ys = _v1.b;
				return A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, y, ys);
			}
		}
	});
var $mgold$elm_nonempty_list$List$Nonempty$foldl = F3(
	function (f, b, _v0) {
		var x = _v0.a;
		var xs = _v0.b;
		return A3(
			$elm$core$List$foldl,
			f,
			b,
			A2($elm$core$List$cons, x, xs));
	});
var $author$project$Music$Models$Time$divisor = function (time) {
	var _v0 = time.beatType;
	switch (_v0.$) {
		case 'Two':
			return 2;
		case 'Four':
			return 4;
		default:
			return 8;
	}
};
var $author$project$Music$Models$Beat$Beat = F3(
	function (full, parts, divisor) {
		return {divisor: divisor, full: full, parts: parts};
	});
var $author$project$Music$Models$Beat$fullBeat = function (n) {
	return A3($author$project$Music$Models$Beat$Beat, n, 0, 1);
};
var $author$project$Music$Models$Beat$fromDuration = F2(
	function (time, d) {
		if (_Utils_cmp(
			d.divisor,
			$author$project$Music$Models$Time$divisor(time)) > 0) {
			var div = (d.divisor / $author$project$Music$Models$Time$divisor(time)) | 0;
			return {
				divisor: div,
				full: (d.count / div) | 0,
				parts: A2($elm$core$Basics$modBy, div, d.count)
			};
		} else {
			return $author$project$Music$Models$Beat$fullBeat(
				((d.count * $author$project$Music$Models$Time$divisor(time)) / d.divisor) | 0);
		}
	});
var $mgold$elm_nonempty_list$List$Nonempty$map = F2(
	function (f, _v0) {
		var x = _v0.a;
		var xs = _v0.b;
		return A2(
			$mgold$elm_nonempty_list$List$Nonempty$Nonempty,
			f(x),
			A2($elm$core$List$map, f, xs));
	});
var $author$project$Music$Models$Duration$changeDivisor = F2(
	function (div, dur) {
		return A2($author$project$Music$Models$Duration$Duration, ((dur.count * div) / dur.divisor) | 0, div);
	});
var $author$project$Music$Models$Duration$commonDivisor = F2(
	function (a, b) {
		return A2($elm$core$Basics$max, a.divisor, b.divisor);
	});
var $author$project$Music$Models$Duration$makeCommon = function (_v0) {
	var a = _v0.a;
	var b = _v0.b;
	var change = $author$project$Music$Models$Duration$changeDivisor(
		A2($author$project$Music$Models$Duration$commonDivisor, a, b));
	return _Utils_Tuple2(
		change(a),
		change(b));
};
var $author$project$Music$Models$Duration$reduce = function (d) {
	return (!A2($elm$core$Basics$modBy, d.divisor, d.count)) ? A2($author$project$Music$Models$Duration$Duration, (d.count / d.divisor) | 0, 1) : ((!A2($elm$core$Basics$modBy, (d.divisor / 2) | 0, d.count)) ? A2($author$project$Music$Models$Duration$Duration, ((2 * d.count) / d.divisor) | 0, 2) : ((!A2($elm$core$Basics$modBy, (d.divisor / 4) | 0, d.count)) ? A2($author$project$Music$Models$Duration$Duration, ((4 * d.count) / d.divisor) | 0, 4) : d));
};
var $author$project$Music$Models$Duration$add = F2(
	function (a, b) {
		var _v0 = $author$project$Music$Models$Duration$makeCommon(
			_Utils_Tuple2(a, b));
		var ac = _v0.a;
		var bc = _v0.b;
		return $author$project$Music$Models$Duration$reduce(
			_Utils_update(
				bc,
				{count: ac.count + bc.count}));
	});
var $mgold$elm_nonempty_list$List$Nonempty$head = function (_v0) {
	var x = _v0.a;
	var xs = _v0.b;
	return x;
};
var $mgold$elm_nonempty_list$List$Nonempty$tail = function (_v0) {
	var x = _v0.a;
	var xs = _v0.b;
	return xs;
};
var $author$project$Music$Models$Duration$zero = A2($author$project$Music$Models$Duration$Duration, 0, 1);
var $author$project$Music$Models$Measure$offsets = function (measure) {
	var beats = A2(
		$mgold$elm_nonempty_list$List$Nonempty$map,
		function ($) {
			return $.duration;
		},
		measure.notes);
	var head = $mgold$elm_nonempty_list$List$Nonempty$head(beats);
	var tail = A3(
		$elm_community$list_extra$List$Extra$scanl,
		$author$project$Music$Models$Duration$add,
		head,
		$mgold$elm_nonempty_list$List$Nonempty$tail(beats));
	return A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, $author$project$Music$Models$Duration$zero, tail);
};
var $author$project$Music$Models$Layout$divisorFor = F3(
	function (t, measure, i) {
		return A3(
			$mgold$elm_nonempty_list$List$Nonempty$foldl,
			$elm$core$Basics$max,
			1,
			A2(
				$mgold$elm_nonempty_list$List$Nonempty$map,
				function (b) {
					return b.divisor;
				},
				A3(
					$mgold$elm_nonempty_list$List$Nonempty$filter,
					function (b) {
						return _Utils_eq(b.full, i);
					},
					$author$project$Music$Models$Beat$fullBeat(1),
					A2(
						$mgold$elm_nonempty_list$List$Nonempty$map,
						$author$project$Music$Models$Beat$fromDuration(t),
						$author$project$Music$Models$Measure$offsets(measure)))));
	});
var $author$project$Music$Models$Key$equal = F2(
	function (akey, bkey) {
		return _Utils_eq(akey.fifths, bkey.fifths) && _Utils_eq(akey.mode, bkey.mode);
	});
var $author$project$Music$Models$Time$equal = F2(
	function (atime, btime) {
		return _Utils_eq(atime.beatType, btime.beatType) && _Utils_eq(atime.beats, btime.beats);
	});
var $author$project$Music$Models$Measure$essentialAttributes = F2(
	function (indirect, direct) {
		return _Utils_update(
			direct,
			{
				key: function () {
					var _v0 = direct.key;
					if (_v0.$ === 'Just') {
						var dkey = _v0.a;
						var _v1 = indirect.key;
						if (_v1.$ === 'Just') {
							var ikey = _v1.a;
							return A2($author$project$Music$Models$Key$equal, ikey, dkey) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(dkey);
						} else {
							return $elm$core$Maybe$Just(dkey);
						}
					} else {
						return $elm$core$Maybe$Nothing;
					}
				}(),
				time: function () {
					var _v2 = direct.time;
					if (_v2.$ === 'Just') {
						var dtime = _v2.a;
						var _v3 = indirect.time;
						if (_v3.$ === 'Just') {
							var itime = _v3.a;
							return A2($author$project$Music$Models$Time$equal, itime, dtime) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(dtime);
						} else {
							return $elm$core$Maybe$Just(dtime);
						}
					} else {
						return $elm$core$Maybe$Nothing;
					}
				}()
			});
	});
var $elm$core$Basics$neq = _Utils_notEqual;
var $author$project$Music$Models$Beat$fitToTime = F2(
	function (time, beats) {
		var b = A2(
			$elm$core$Basics$max,
			time.beats,
			beats.full + ((!(!beats.parts)) ? 1 : 0));
		return A2($author$project$Music$Models$Time$Time, b, time.beatType);
	});
var $mgold$elm_nonempty_list$List$Nonempty$foldl1 = F2(
	function (f, _v0) {
		var x = _v0.a;
		var xs = _v0.b;
		return A3($elm$core$List$foldl, f, x, xs);
	});
var $author$project$Music$Models$Measure$length = function (measure) {
	var durs = A2(
		$mgold$elm_nonempty_list$List$Nonempty$map,
		function ($) {
			return $.duration;
		},
		measure.notes);
	return A2($mgold$elm_nonempty_list$List$Nonempty$foldl1, $author$project$Music$Models$Duration$add, durs);
};
var $author$project$Music$Models$Duration$longerThan = F2(
	function (a, b) {
		var _v0 = $author$project$Music$Models$Duration$makeCommon(
			_Utils_Tuple2(a, b));
		var ac = _v0.a;
		var bc = _v0.b;
		return _Utils_cmp(ac.count, bc.count) < 0;
	});
var $author$project$Music$Models$Time$toDuration = function (time) {
	return A2(
		$author$project$Music$Models$Duration$Duration,
		time.beats,
		$author$project$Music$Models$Time$divisor(time));
};
var $author$project$Music$Models$Layout$length = F2(
	function (t, measure) {
		var tdur = $author$project$Music$Models$Time$toDuration(t);
		var mdur = $author$project$Music$Models$Measure$length(measure);
		return A2($author$project$Music$Models$Duration$longerThan, tdur, mdur) ? A2($author$project$Music$Models$Beat$fromDuration, t, mdur) : $author$project$Music$Models$Beat$fullBeat(t.beats);
	});
var $author$project$Music$Models$Layout$fitTime = F2(
	function (t, measure) {
		var beats = A2($author$project$Music$Models$Layout$length, t, measure);
		return A2($author$project$Music$Models$Beat$fitToTime, t, beats);
	});
var $mgold$elm_nonempty_list$List$Nonempty$fromList = function (ys) {
	if (ys.b) {
		var x = ys.a;
		var xs = ys.b;
		return $elm$core$Maybe$Just(
			A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, x, xs));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm_community$list_extra$List$Extra$initialize = F2(
	function (n, f) {
		var step = F2(
			function (i, acc) {
				step:
				while (true) {
					if (i < 0) {
						return acc;
					} else {
						var $temp$i = i - 1,
							$temp$acc = A2(
							$elm$core$List$cons,
							f(i),
							acc);
						i = $temp$i;
						acc = $temp$acc;
						continue step;
					}
				}
			});
		return A2(step, n - 1, _List_Nil);
	});
var $author$project$Music$Models$Layout$forMeasure = F2(
	function (indirect, measure) {
		var t = function () {
			var _v0 = measure.attributes.time;
			if (_v0.$ === 'Just') {
				var theTime = _v0.a;
				return theTime;
			} else {
				return A2($elm$core$Maybe$withDefault, $author$project$Music$Models$Time$common, indirect.time);
			}
		}();
		var ft = A2($author$project$Music$Models$Layout$fitTime, t, measure);
		var divs = A2(
			$elm_community$list_extra$List$Extra$initialize,
			ft.beats,
			A2($author$project$Music$Models$Layout$divisorFor, t, measure));
		var direct = A2($author$project$Music$Models$Measure$essentialAttributes, indirect, measure.attributes);
		return A4(
			$author$project$Music$Models$Layout$Layout,
			2.0,
			A2(
				$elm$core$Maybe$withDefault,
				$mgold$elm_nonempty_list$List$Nonempty$fromElement(1),
				$mgold$elm_nonempty_list$List$Nonempty$fromList(divs)),
			indirect,
			direct);
	});
var $author$project$TouchTunes$Models$Overlay$NoSelection = {$: 'NoSelection'};
var $author$project$TouchTunes$Models$Overlay$Overlay = F2(
	function (layout, selection) {
		return {layout: layout, selection: selection};
	});
var $author$project$TouchTunes$Models$Overlay$fromLayout = function (layout) {
	return A2($author$project$TouchTunes$Models$Overlay$Overlay, layout, $author$project$TouchTunes$Models$Overlay$NoSelection);
};
var $author$project$Music$Models$Harmony$Major = function (a) {
	return {$: 'Major', a: a};
};
var $author$project$Music$Models$Pitch$Natural = {$: 'Natural'};
var $author$project$Music$Models$Harmony$Seventh = {$: 'Seventh'};
var $author$project$Music$Models$Harmony$Triad = {$: 'Triad'};
var $author$project$Music$Models$Harmony$chord = F2(
	function (kind, root) {
		return {alter: _List_Nil, bass: $elm$core$Maybe$Nothing, kind: kind, root: root};
	});
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $author$project$Music$Models$Harmony$Add = function (a) {
	return {$: 'Add', a: a};
};
var $author$project$Music$Models$Harmony$Lowered = function (a) {
	return {$: 'Lowered', a: a};
};
var $author$project$Music$Models$Harmony$No = function (a) {
	return {$: 'No', a: a};
};
var $author$project$Music$Models$Harmony$Raised = function (a) {
	return {$: 'Raised', a: a};
};
var $author$project$Music$Models$Harmony$Sus = function (a) {
	return {$: 'Sus', a: a};
};
var $author$project$TouchTunes$Models$Dial$Dial = F3(
	function (value, config, tracking) {
		return {config: config, tracking: tracking, value: value};
	});
var $author$project$TouchTunes$Models$Dial$init = F2(
	function (v, config) {
		return A3($author$project$TouchTunes$Models$Dial$Dial, v, config, $elm$core$Maybe$Nothing);
	});
var $elm$json$Json$Encode$string = _Json_wrap;
var $elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$string(string));
	});
var $elm$html$Html$Attributes$class = $elm$html$Html$Attributes$stringProperty('className');
var $cultureamp$elm_css_modules_loader$CssModules$CssModule = F2(
	function (a, b) {
		return {$: 'CssModule', a: a, b: b};
	});
var $cultureamp$elm_css_modules_loader$CssModules$class = F2(
	function (_v0, accessor) {
		var classes = _v0.b;
		return $elm$html$Html$Attributes$class(
			accessor(classes));
	});
var $elm$core$Tuple$second = function (_v0) {
	var y = _v0.b;
	return y;
};
var $elm$html$Html$Attributes$classList = function (classes) {
	return $elm$html$Html$Attributes$class(
		A2(
			$elm$core$String$join,
			' ',
			A2(
				$elm$core$List$map,
				$elm$core$Tuple$first,
				A2($elm$core$List$filter, $elm$core$Tuple$second, classes))));
};
var $elm$core$Tuple$mapFirst = F2(
	function (func, _v0) {
		var x = _v0.a;
		var y = _v0.b;
		return _Utils_Tuple2(
			func(x),
			y);
	});
var $cultureamp$elm_css_modules_loader$CssModules$classList = F2(
	function (_v0, list) {
		var classes = _v0.b;
		return $elm$html$Html$Attributes$classList(
			A2(
				$elm$core$List$map,
				$elm$core$Tuple$mapFirst(
					function (accessor) {
						return accessor(classes);
					}),
				list));
	});
var $cultureamp$elm_css_modules_loader$CssModules$toString = F2(
	function (_v0, accessor) {
		var classes = _v0.b;
		return accessor(classes);
	});
var $cultureamp$elm_css_modules_loader$CssModules$css = F2(
	function (stylesheet, classes) {
		var cssModule = A2($cultureamp$elm_css_modules_loader$CssModules$CssModule, stylesheet, classes);
		return {
			_class: $cultureamp$elm_css_modules_loader$CssModules$class(cssModule),
			classList: $cultureamp$elm_css_modules_loader$CssModules$classList(cssModule),
			toString: $cultureamp$elm_css_modules_loader$CssModules$toString(cssModule)
		};
	});
var $author$project$Music$Views$HarmonyStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./Music/Views/css/harmony.css',
	{alt: 'alt', altList: 'alt-list', chromatic: 'chromatic', degree: 'degree', harmony: 'harmony', kind: 'kind', over: 'over', root: 'root'}).toString;
var $elm$html$Html$span = _VirtualDom_node('span');
var $author$project$Music$Views$Symbols$Symbol = F2(
	function (viewbox, id) {
		return {id: id, viewbox: viewbox};
	});
var $author$project$Music$Views$Symbols$ViewBox = F4(
	function (x, y, width, height) {
		return {height: height, width: width, x: x, y: y};
	});
var $author$project$Music$Views$Symbols$flat = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 22, 62),
	'tt-flat');
var $elm$core$String$fromFloat = _String_fromNumber;
var $elm$svg$Svg$Attributes$height = _VirtualDom_attribute('height');
var $elm$svg$Svg$trustedNode = _VirtualDom_nodeNS('http://www.w3.org/2000/svg');
var $elm$svg$Svg$svg = $elm$svg$Svg$trustedNode('svg');
var $elm$svg$Svg$use = $elm$svg$Svg$trustedNode('use');
var $elm$svg$Svg$Attributes$viewBox = _VirtualDom_attribute('viewBox');
var $elm$svg$Svg$Attributes$width = _VirtualDom_attribute('width');
var $elm$svg$Svg$Attributes$x = _VirtualDom_attribute('x');
var $elm$svg$Svg$Attributes$xlinkHref = function (value) {
	return A3(
		_VirtualDom_attributeNS,
		'http://www.w3.org/1999/xlink',
		'xlink:href',
		_VirtualDom_noJavaScriptUri(value));
};
var $elm$svg$Svg$Attributes$y = _VirtualDom_attribute('y');
var $author$project$Music$Views$Symbols$glyph = function (asset) {
	var box = asset.viewbox;
	var h = $elm$core$String$fromFloat(box.height);
	var w = $elm$core$String$fromFloat(box.width);
	return A2(
		$elm$svg$Svg$svg,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$height('1em'),
				$elm$svg$Svg$Attributes$viewBox('0 0 ' + (w + (' ' + h)))
			]),
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$use,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$xlinkHref('#' + asset.id),
						$elm$svg$Svg$Attributes$x('0'),
						$elm$svg$Svg$Attributes$y('0'),
						$elm$svg$Svg$Attributes$height(h),
						$elm$svg$Svg$Attributes$width(w)
					]),
				_List_Nil)
			]));
};
var $author$project$Music$Views$Symbols$sharp = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 22, 62),
	'tt-sharp');
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $author$project$Music$Views$HarmonyView$viewAlteration = function (alteration) {
	switch (alteration.$) {
		case 'Sus':
			var n = alteration.a;
			return A2(
				$elm$html$Html$span,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class(
						$author$project$Music$Views$HarmonyStyles$css(
							function ($) {
								return $.alt;
							}))
					]),
				_List_fromArray(
					[
						$elm$html$Html$text(
						'sus' + $elm$core$String$fromInt(n))
					]));
		case 'Add':
			var n = alteration.a;
			return A2(
				$elm$html$Html$span,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class(
						$author$project$Music$Views$HarmonyStyles$css(
							function ($) {
								return $.alt;
							}))
					]),
				_List_fromArray(
					[
						$elm$html$Html$text(
						'add' + $elm$core$String$fromInt(n))
					]));
		case 'No':
			var n = alteration.a;
			return A2(
				$elm$html$Html$span,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class(
						$author$project$Music$Views$HarmonyStyles$css(
							function ($) {
								return $.alt;
							}))
					]),
				_List_fromArray(
					[
						$elm$html$Html$text(
						'no' + $elm$core$String$fromInt(n))
					]));
		case 'Raised':
			var n = alteration.a;
			return A2(
				$elm$html$Html$span,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class(
						$author$project$Music$Views$HarmonyStyles$css(
							function ($) {
								return $.alt;
							}))
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('('),
						$author$project$Music$Views$Symbols$glyph($author$project$Music$Views$Symbols$sharp),
						$elm$html$Html$text(
						$elm$core$String$fromInt(n)),
						$elm$html$Html$text(')')
					]));
		case 'Lowered':
			var n = alteration.a;
			return A2(
				$elm$html$Html$span,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class(
						$author$project$Music$Views$HarmonyStyles$css(
							function ($) {
								return $.alt;
							}))
					]),
				_List_fromArray(
					[
						$elm$html$Html$text('('),
						$author$project$Music$Views$Symbols$glyph($author$project$Music$Views$Symbols$flat),
						$elm$html$Html$text(
						$elm$core$String$fromInt(n)),
						$elm$html$Html$text(')')
					]));
		default:
			var s = alteration.a;
			var n = alteration.b;
			return A2(
				$elm$html$Html$span,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class(
						$author$project$Music$Views$HarmonyStyles$css(
							function ($) {
								return $.alt;
							}))
					]),
				_List_fromArray(
					[
						$elm$html$Html$text(
						'(' + (s + ($elm$core$String$fromInt(n) + ')')))
					]));
	}
};
var $author$project$Music$Views$HarmonyView$viewAlterationList = function (alterationList) {
	return A2(
		$elm$html$Html$span,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$Music$Views$HarmonyStyles$css(
					function ($) {
						return $.altList;
					}))
			]),
		A2($elm$core$List$map, $author$project$Music$Views$HarmonyView$viewAlteration, alterationList));
};
var $author$project$TouchTunes$Models$Controls$initAltHarmonyDial = function (ls) {
	return A2(
		$author$project$TouchTunes$Models$Dial$init,
		A2($elm$core$Maybe$withDefault, _List_Nil, ls),
		{
			options: $elm$core$Array$fromList(
				_List_fromArray(
					[
						_List_Nil,
						_List_fromArray(
						[
							$author$project$Music$Models$Harmony$Sus(2)
						]),
						_List_fromArray(
						[
							$author$project$Music$Models$Harmony$Sus(4)
						]),
						_List_fromArray(
						[
							$author$project$Music$Models$Harmony$Add(9)
						]),
						_List_fromArray(
						[
							$author$project$Music$Models$Harmony$No(3)
						]),
						_List_fromArray(
						[
							$author$project$Music$Models$Harmony$Raised(5)
						]),
						_List_fromArray(
						[
							$author$project$Music$Models$Harmony$Raised(9)
						]),
						_List_fromArray(
						[
							$author$project$Music$Models$Harmony$Raised(11)
						]),
						_List_fromArray(
						[
							$author$project$Music$Models$Harmony$Lowered(5)
						]),
						_List_fromArray(
						[
							$author$project$Music$Models$Harmony$Lowered(9)
						])
					])),
			segments: 12,
			viewValue: $author$project$Music$Views$HarmonyView$viewAlterationList
		});
};
var $author$project$Music$Models$Pitch$DoubleFlat = {$: 'DoubleFlat'};
var $author$project$Music$Models$Pitch$DoubleSharp = {$: 'DoubleSharp'};
var $author$project$Music$Models$Pitch$Flat = {$: 'Flat'};
var $author$project$Music$Models$Pitch$Sharp = {$: 'Sharp'};
var $author$project$Music$Views$Symbols$doubleFlat = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 22, 62),
	'tt-double-flat');
var $author$project$Music$Views$Symbols$doubleSharp = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 22, 62),
	'tt-double-sharp');
var $author$project$Music$Views$Symbols$natural = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 22, 62),
	'tt-natural');
var $author$project$Music$Views$NoteView$alteration = function (chr) {
	switch (chr.$) {
		case 'DoubleFlat':
			return $author$project$Music$Views$Symbols$doubleFlat;
		case 'Flat':
			return $author$project$Music$Views$Symbols$flat;
		case 'Natural':
			return $author$project$Music$Views$Symbols$natural;
		case 'Sharp':
			return $author$project$Music$Views$Symbols$sharp;
		default:
			return $author$project$Music$Views$Symbols$doubleSharp;
	}
};
var $author$project$TouchTunes$Models$Controls$viewAlteration = function (chr) {
	var symbol = $author$project$Music$Views$NoteView$alteration(chr);
	return $author$project$Music$Views$Symbols$glyph(symbol);
};
var $author$project$TouchTunes$Models$Controls$initAlterationDial = function (chr) {
	return A2(
		$author$project$TouchTunes$Models$Dial$init,
		chr,
		{
			options: $elm$core$Array$fromList(
				_List_fromArray(
					[$author$project$Music$Models$Pitch$DoubleFlat, $author$project$Music$Models$Pitch$Flat, $author$project$Music$Models$Pitch$Natural, $author$project$Music$Models$Pitch$Sharp, $author$project$Music$Models$Pitch$DoubleSharp])),
			segments: 6,
			viewValue: $author$project$TouchTunes$Models$Controls$viewAlteration
		});
};
var $author$project$Music$Models$Pitch$A = {$: 'A'};
var $author$project$Music$Models$Pitch$B = {$: 'B'};
var $author$project$Music$Models$Pitch$C = {$: 'C'};
var $author$project$Music$Models$Pitch$D = {$: 'D'};
var $author$project$Music$Models$Pitch$F = {$: 'F'};
var $author$project$Music$Models$Pitch$G = {$: 'G'};
var $author$project$Music$Models$Pitch$Root = F2(
	function (step, alter) {
		return {alter: alter, step: step};
	});
var $author$project$Music$Models$Pitch$semitones = function (chr) {
	switch (chr.$) {
		case 'DoubleFlat':
			return -2;
		case 'DoubleSharp':
			return 2;
		case 'Flat':
			return -1;
		case 'Sharp':
			return 1;
		default:
			return 0;
	}
};
var $author$project$Music$Models$Pitch$root = F2(
	function (step, chr) {
		return A2(
			$author$project$Music$Models$Pitch$Root,
			step,
			$author$project$Music$Models$Pitch$semitones(chr));
	});
var $elm$core$Basics$abs = function (n) {
	return (n < 0) ? (-n) : n;
};
var $author$project$Music$Models$Pitch$chromatic = function (semi) {
	var _v0 = $elm$core$Basics$abs(semi);
	switch (_v0) {
		case 0:
			return $elm$core$Maybe$Just($author$project$Music$Models$Pitch$Natural);
		case 1:
			return $elm$core$Maybe$Just(
				(semi > 0) ? $author$project$Music$Models$Pitch$Sharp : $author$project$Music$Models$Pitch$Flat);
		case 2:
			return $elm$core$Maybe$Just(
				(semi > 0) ? $author$project$Music$Models$Pitch$DoubleSharp : $author$project$Music$Models$Pitch$DoubleFlat);
		default:
			return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Music$Views$HarmonyView$chromaticSymbol = function (alt) {
	var _v0 = $author$project$Music$Models$Pitch$chromatic(alt);
	if (_v0.$ === 'Just') {
		var chr = _v0.a;
		switch (chr.$) {
			case 'DoubleFlat':
				return $elm$core$Maybe$Just($author$project$Music$Views$Symbols$doubleFlat);
			case 'Flat':
				return $elm$core$Maybe$Just($author$project$Music$Views$Symbols$flat);
			case 'Natural':
				return $elm$core$Maybe$Nothing;
			case 'Sharp':
				return $elm$core$Maybe$Just($author$project$Music$Views$Symbols$sharp);
			default:
				return $elm$core$Maybe$Just($author$project$Music$Views$Symbols$doubleSharp);
		}
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Music$Models$Pitch$stepToString = function (s) {
	switch (s.$) {
		case 'C':
			return 'C';
		case 'D':
			return 'D';
		case 'E':
			return 'E';
		case 'F':
			return 'F';
		case 'G':
			return 'G';
		case 'A':
			return 'A';
		default:
			return 'B';
	}
};
var $author$project$Music$Views$HarmonyView$viewRoot = function (root) {
	var chsym = $author$project$Music$Views$HarmonyView$chromaticSymbol(root.alter);
	return A2(
		$elm$html$Html$span,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$Music$Views$HarmonyStyles$css(
					function ($) {
						return $.root;
					}))
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(
				$author$project$Music$Models$Pitch$stepToString(root.step)),
				A2(
				$elm$core$Maybe$withDefault,
				$elm$html$Html$text(''),
				A2(
					$elm$core$Maybe$map,
					function (s) {
						return A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class(
									$author$project$Music$Views$HarmonyStyles$css(
										function ($) {
											return $.chromatic;
										}))
								]),
							_List_fromArray(
								[
									$author$project$Music$Views$Symbols$glyph(s)
								]));
					},
					chsym))
			]));
};
var $author$project$Music$Views$HarmonyView$viewBass = function (bass) {
	if (bass.$ === 'Just') {
		var r = bass.a;
		return A2(
			$elm$html$Html$span,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class(
					$author$project$Music$Views$HarmonyStyles$css(
						function ($) {
							return $.over;
						}))
				]),
			_List_fromArray(
				[
					$elm$html$Html$text('/'),
					$author$project$Music$Views$HarmonyView$viewRoot(r)
				]));
	} else {
		return $elm$html$Html$text('');
	}
};
var $author$project$TouchTunes$Models$Controls$initBassDial = F2(
	function (k, r) {
		return A2(
			$author$project$TouchTunes$Models$Dial$init,
			A2(
				$elm$core$Maybe$withDefault,
				A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Natural),
				r),
			{
				options: $elm$core$Array$fromList(
					_List_fromArray(
						[
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$Flat),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$Flat),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$Flat),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$Flat),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$Flat),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$Natural),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Natural),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$Natural),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$Natural),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$Natural),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$Natural),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$Natural),
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$Sharp)
						])),
				segments: 15,
				viewValue: A2($elm$core$Basics$composeL, $author$project$Music$Views$HarmonyView$viewBass, $elm$core$Maybe$Just)
			});
	});
var $author$project$Music$Models$Harmony$Eleventh = {$: 'Eleventh'};
var $author$project$Music$Models$Harmony$Ninth = {$: 'Ninth'};
var $author$project$Music$Models$Harmony$Sixth = {$: 'Sixth'};
var $author$project$Music$Models$Harmony$Thirteenth = {$: 'Thirteenth'};
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $author$project$Music$Views$HarmonyView$degreeNumber = function (chord) {
	switch (chord.$) {
		case 'Triad':
			return $elm$core$Maybe$Nothing;
		case 'Sixth':
			return $elm$core$Maybe$Just('6');
		case 'Seventh':
			return $elm$core$Maybe$Just('7');
		case 'Ninth':
			return $elm$core$Maybe$Just('9');
		case 'Eleventh':
			return $elm$core$Maybe$Just('11');
		default:
			return $elm$core$Maybe$Just('13');
	}
};
var $author$project$Music$Views$HarmonyView$viewDegree = function (s) {
	return A2(
		$elm$html$Html$span,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$Music$Views$HarmonyStyles$css(
					function ($) {
						return $.degree;
					}))
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(s)
			]));
};
var $author$project$TouchTunes$Models$Controls$initChordDial = function (ch) {
	return A2(
		$author$project$TouchTunes$Models$Dial$init,
		A2($elm$core$Maybe$withDefault, $author$project$Music$Models$Harmony$Triad, ch),
		{
			options: $elm$core$Array$fromList(
				_List_fromArray(
					[$author$project$Music$Models$Harmony$Triad, $author$project$Music$Models$Harmony$Sixth, $author$project$Music$Models$Harmony$Seventh, $author$project$Music$Models$Harmony$Ninth, $author$project$Music$Models$Harmony$Eleventh, $author$project$Music$Models$Harmony$Thirteenth])),
			segments: 9,
			viewValue: A2(
				$elm$core$Basics$composeR,
				$author$project$Music$Views$HarmonyView$degreeNumber,
				A2(
					$elm$core$Basics$composeR,
					$elm$core$Maybe$withDefault('Triad'),
					$author$project$Music$Views$HarmonyView$viewDegree))
		});
};
var $author$project$Music$Models$Harmony$I = {$: 'I'};
var $author$project$Music$Models$Harmony$II = {$: 'II'};
var $author$project$Music$Models$Harmony$III = {$: 'III'};
var $author$project$Music$Models$Harmony$IV = {$: 'IV'};
var $author$project$Music$Models$Harmony$V = {$: 'V'};
var $author$project$Music$Models$Harmony$VI = {$: 'VI'};
var $author$project$Music$Models$Harmony$VII = {$: 'VII'};
var $author$project$Music$Models$Harmony$Dominant = function (a) {
	return {$: 'Dominant', a: a};
};
var $author$project$Music$Models$Harmony$HalfDiminished = {$: 'HalfDiminished'};
var $author$project$Music$Models$Harmony$Minor = function (a) {
	return {$: 'Minor', a: a};
};
var $author$project$Music$Models$Scale$chromaticScale = $elm$core$Array$fromList(
	_List_fromArray(
		[
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Sharp),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$Flat),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$Sharp),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$Flat),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$Flat),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$Natural)
		]));
var $author$project$Music$Models$Scale$rootSemis = function (r) {
	var stepsemis = function () {
		var _v0 = r.step;
		switch (_v0.$) {
			case 'C':
				return 0;
			case 'D':
				return 2;
			case 'E':
				return 4;
			case 'F':
				return 5;
			case 'G':
				return 7;
			case 'A':
				return 9;
			default:
				return 11;
		}
	}();
	return A2($elm$core$Basics$modBy, 12, stepsemis + r.alter);
};
var $author$project$Music$Models$Scale$step = F2(
	function (r, t) {
		var semis = A2(
			$elm$core$Basics$modBy,
			12,
			$author$project$Music$Models$Scale$rootSemis(r) + t);
		var _v0 = A2($elm$core$Array$get, semis, $author$project$Music$Models$Scale$chromaticScale);
		if (_v0.$ === 'Just') {
			var theRoot = _v0.a;
			return theRoot;
		} else {
			return A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Natural);
		}
	});
var $author$project$Music$Models$Scale$fromList = F2(
	function (list, tonic) {
		return $elm$core$Array$fromList(
			A2(
				$elm$core$List$map,
				$author$project$Music$Models$Scale$step(tonic),
				list));
	});
var $author$project$Music$Models$Scale$major = $author$project$Music$Models$Scale$fromList(
	_List_fromArray(
		[0, 2, 4, 5, 7, 9, 11]));
var $author$project$Music$Models$Scale$note = function (i) {
	return $elm$core$Array$get(i - 1);
};
var $author$project$Music$Models$Key$flatTonics = $elm$core$Array$fromList(
	_List_fromArray(
		[
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$Flat),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$Flat),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$Flat),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$Flat),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$Flat)
		]));
var $author$project$Music$Models$Key$sharpTonics = $elm$core$Array$fromList(
	_List_fromArray(
		[
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$Natural),
			A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$Sharp)
		]));
var $author$project$Music$Models$Key$tonic = function (key) {
	return (key.fifths > 0) ? A2(
		$elm$core$Maybe$withDefault,
		A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Natural),
		A2($elm$core$Array$get, key.fifths, $author$project$Music$Models$Key$sharpTonics)) : A2(
		$elm$core$Maybe$withDefault,
		A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Natural),
		A2(
			$elm$core$Array$get,
			$elm$core$Basics$abs(key.fifths),
			$author$project$Music$Models$Key$flatTonics));
};
var $author$project$Music$Models$Harmony$function = F3(
	function (k, degree, f) {
		var tonic = $author$project$Music$Models$Key$tonic(k);
		var scale = $author$project$Music$Models$Scale$major(tonic);
		var _v0 = function () {
			switch (f.$) {
				case 'I':
					return _Utils_Tuple2(
						1,
						$author$project$Music$Models$Harmony$Major(degree));
				case 'II':
					return _Utils_Tuple2(
						2,
						$author$project$Music$Models$Harmony$Minor(degree));
				case 'III':
					return _Utils_Tuple2(
						3,
						$author$project$Music$Models$Harmony$Minor(degree));
				case 'IV':
					return _Utils_Tuple2(
						4,
						$author$project$Music$Models$Harmony$Major(degree));
				case 'V':
					return _Utils_Tuple2(
						5,
						$author$project$Music$Models$Harmony$Dominant(degree));
				case 'VI':
					return _Utils_Tuple2(
						6,
						$author$project$Music$Models$Harmony$Minor(degree));
				default:
					return _Utils_Tuple2(7, $author$project$Music$Models$Harmony$HalfDiminished);
			}
		}();
		var step = _v0.a;
		var kind = _v0.b;
		return A2(
			$author$project$Music$Models$Harmony$chord,
			kind,
			A2(
				$elm$core$Maybe$withDefault,
				tonic,
				A2(
					$author$project$Music$Models$Scale$note,
					step,
					$author$project$Music$Models$Scale$major(tonic))));
	});
var $elm$html$Html$div = _VirtualDom_node('div');
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $author$project$Music$Views$HarmonyView$kindString = function (kind) {
	switch (kind.$) {
		case 'Major':
			var c = kind.a;
			return _Utils_eq(c, $author$project$Music$Models$Harmony$Triad) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just('Maj');
		case 'Minor':
			var c = kind.a;
			return $elm$core$Maybe$Just('m');
		case 'Diminished':
			var c = kind.a;
			return $elm$core$Maybe$Just('o');
		case 'Augmented':
			var c = kind.a;
			return $elm$core$Maybe$Just('+');
		case 'Dominant':
			var c = kind.a;
			return $elm$core$Maybe$Nothing;
		case 'HalfDiminished':
			return $elm$core$Maybe$Just('ø');
		case 'MajorMinor':
			return $elm$core$Maybe$Just('m');
		default:
			return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Music$Views$HarmonyView$viewKindString = function (s) {
	return A2(
		$elm$html$Html$span,
		_List_Nil,
		_List_fromArray(
			[
				$elm$html$Html$text(s)
			]));
};
var $author$project$Music$Views$HarmonyView$viewKind = function (kind) {
	return A2(
		$elm$html$Html$span,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$Music$Views$HarmonyStyles$css(
					function ($) {
						return $.kind;
					}))
			]),
		_List_fromArray(
			[
				A2(
				$elm$core$Maybe$withDefault,
				$elm$html$Html$text(''),
				A2(
					$elm$core$Maybe$map,
					$author$project$Music$Views$HarmonyView$viewKindString,
					$author$project$Music$Views$HarmonyView$kindString(kind))),
				A2(
				$elm$core$Maybe$withDefault,
				$elm$html$Html$text(''),
				A2(
					$elm$core$Maybe$map,
					$author$project$Music$Views$HarmonyView$viewDegree,
					function () {
						switch (kind.$) {
							case 'Major':
								var c = kind.a;
								return $author$project$Music$Views$HarmonyView$degreeNumber(c);
							case 'Minor':
								var c = kind.a;
								return $author$project$Music$Views$HarmonyView$degreeNumber(c);
							case 'Diminished':
								var c = kind.a;
								return $author$project$Music$Views$HarmonyView$degreeNumber(c);
							case 'Augmented':
								var c = kind.a;
								return $author$project$Music$Views$HarmonyView$degreeNumber(c);
							case 'Dominant':
								var c = kind.a;
								return $author$project$Music$Views$HarmonyView$degreeNumber(c);
							case 'HalfDiminished':
								return $elm$core$Maybe$Just('7');
							case 'MajorMinor':
								return $elm$core$Maybe$Nothing;
							default:
								return $elm$core$Maybe$Just('5');
						}
					}()))
			]));
};
var $author$project$Music$Views$HarmonyView$view = function (harmony) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$Music$Views$HarmonyStyles$css(
					function ($) {
						return $.harmony;
					}))
			]),
		_List_fromArray(
			[
				$author$project$Music$Views$HarmonyView$viewRoot(harmony.root),
				$author$project$Music$Views$HarmonyView$viewKind(harmony.kind),
				$elm$core$List$isEmpty(harmony.alter) ? $elm$html$Html$text('') : $author$project$Music$Views$HarmonyView$viewAlterationList(harmony.alter),
				$author$project$Music$Views$HarmonyView$viewBass(harmony.bass)
			]));
};
var $author$project$TouchTunes$Models$Controls$initHarmonyDial = F3(
	function (k, degree, h) {
		return A2(
			$author$project$TouchTunes$Models$Dial$init,
			A2(
				$elm$core$Maybe$withDefault,
				A2(
					$author$project$Music$Models$Harmony$chord,
					$author$project$Music$Models$Harmony$Major($author$project$Music$Models$Harmony$Seventh),
					$author$project$Music$Models$Key$tonic(k)),
				h),
			{
				options: $elm$core$Array$fromList(
					A2(
						$elm$core$List$map,
						A2($author$project$Music$Models$Harmony$function, k, degree),
						_List_fromArray(
							[$author$project$Music$Models$Harmony$I, $author$project$Music$Models$Harmony$II, $author$project$Music$Models$Harmony$III, $author$project$Music$Models$Harmony$IV, $author$project$Music$Models$Harmony$V, $author$project$Music$Models$Harmony$VI, $author$project$Music$Models$Harmony$VII]))),
				segments: 12,
				viewValue: $author$project$Music$Views$HarmonyView$view
			});
	});
var $author$project$Music$Models$Key$A = {$: 'A'};
var $author$project$Music$Models$Key$Aflat = {$: 'Aflat'};
var $author$project$Music$Models$Key$B = {$: 'B'};
var $author$project$Music$Models$Key$Bflat = {$: 'Bflat'};
var $author$project$Music$Models$Key$D = {$: 'D'};
var $author$project$Music$Models$Key$Dflat = {$: 'Dflat'};
var $author$project$Music$Models$Key$E = {$: 'E'};
var $author$project$Music$Models$Key$Eflat = {$: 'Eflat'};
var $author$project$Music$Models$Key$F = {$: 'F'};
var $author$project$Music$Models$Key$Fsharp = {$: 'Fsharp'};
var $author$project$Music$Models$Key$G = {$: 'G'};
var $author$project$TouchTunes$Models$Controls$fakeLayout = A2($author$project$Music$Models$Layout$forMeasure, $author$project$Music$Models$Measure$noAttributes, $author$project$Music$Models$Measure$new);
var $author$project$Music$Models$Layout$Tenths = function (ths) {
	return {ths: ths};
};
var $author$project$Music$Models$Layout$Pixels = function (px) {
	return {px: px};
};
var $author$project$Music$Models$Layout$toPixels = F2(
	function (layout, tenths) {
		return $author$project$Music$Models$Layout$Pixels(layout.zoom * tenths.ths);
	});
var $author$project$Music$Models$Layout$spacing = function (layout) {
	return A2(
		$author$project$Music$Models$Layout$toPixels,
		layout,
		$author$project$Music$Models$Layout$Tenths(10.0));
};
var $elm$svg$Svg$text = $elm$virtual_dom$VirtualDom$text;
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$svg$Svg$Attributes$class = _VirtualDom_attribute('class');
var $author$project$Music$Views$MeasureStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./Music/Views/css/measure.css',
	{key: 'key', measure: 'measure', staff: 'staff', time: 'time'}).toString;
var $author$project$Music$Views$MeasureView$flatSymbol = $author$project$Music$Views$Symbols$flat;
var $elm$svg$Svg$g = $elm$svg$Svg$trustedNode('g');
var $author$project$Music$Models$Layout$Margins = F4(
	function (top, right, bottom, left) {
		return {bottom: bottom, left: left, right: right, top: top};
	});
var $author$project$Music$Models$Layout$margins = function (layout) {
	var sp = $author$project$Music$Models$Layout$spacing(layout).px;
	var vmargin = $author$project$Music$Models$Layout$Pixels(4.5 * sp);
	var rmargin = $author$project$Music$Models$Layout$Pixels(sp);
	var lmargin = $author$project$Music$Models$Layout$Pixels(
		(sp + function () {
			var _v0 = layout.direct.time;
			if (_v0.$ === 'Just') {
				return 2.0 * sp;
			} else {
				return 0.0;
			}
		}()) + function () {
			var _v1 = layout.direct.key;
			if (_v1.$ === 'Just') {
				var k = _v1.a;
				return $elm$core$Basics$abs(k.fifths) * sp;
			} else {
				return 0.0;
			}
		}());
	return A4($author$project$Music$Models$Layout$Margins, vmargin, rmargin, vmargin, lmargin);
};
var $author$project$Music$Models$Layout$getAttribute = F2(
	function (getter, layout) {
		var _v0 = getter(layout.direct);
		if (_v0.$ === 'Just') {
			var v = _v0.a;
			return $elm$core$Maybe$Just(v);
		} else {
			return getter(layout.indirect);
		}
	});
var $author$project$Music$Models$Layout$staff = function (layout) {
	return A2(
		$elm$core$Maybe$withDefault,
		$author$project$Music$Models$Staff$treble,
		A2(
			$author$project$Music$Models$Layout$getAttribute,
			function ($) {
				return $.staff;
			},
			layout));
};
var $author$project$Music$Models$Layout$basePitch = function (layout) {
	var s = $author$project$Music$Models$Layout$staff(layout);
	return s.basePitch;
};
var $author$project$Music$Models$Pitch$stepNumber = function (p) {
	var offset = function () {
		var _v0 = p.step;
		switch (_v0.$) {
			case 'C':
				return 0;
			case 'D':
				return 1;
			case 'E':
				return 2;
			case 'F':
				return 3;
			case 'G':
				return 4;
			case 'A':
				return 5;
			default:
				return 6;
		}
	}();
	return (7 * p.octave) + offset;
};
var $author$project$Music$Models$Layout$scaleStep = F2(
	function (layout, sn) {
		var s = $author$project$Music$Models$Layout$spacing(layout);
		var n = $author$project$Music$Models$Pitch$stepNumber(
			$author$project$Music$Models$Layout$basePitch(layout)) - sn;
		var m = $author$project$Music$Models$Layout$margins(layout);
		return $author$project$Music$Models$Layout$Pixels((((n / 2.0) * s.px) + m.top.px) + (s.px / 2.0));
	});
var $author$project$Music$Models$Layout$scalePitch = F2(
	function (layout, p) {
		return A2(
			$author$project$Music$Models$Layout$scaleStep,
			layout,
			$author$project$Music$Models$Pitch$stepNumber(p));
	});
var $author$project$Music$Views$MeasureView$sharpSymbol = $author$project$Music$Views$Symbols$sharp;
var $elm$svg$Svg$Attributes$transform = _VirtualDom_attribute('transform');
var $author$project$Music$Views$Symbols$view = function (asset) {
	var box = asset.viewbox;
	var xOffset = ((-0.5) * box.width) - box.x;
	var yOffset = ((-0.5) * box.height) - box.y;
	return A2(
		$elm$svg$Svg$use,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$xlinkHref('#' + asset.id),
				$elm$svg$Svg$Attributes$x(
				$elm$core$String$fromFloat(xOffset)),
				$elm$svg$Svg$Attributes$y(
				$elm$core$String$fromFloat(yOffset)),
				$elm$svg$Svg$Attributes$height(
				$elm$core$String$fromFloat(box.height)),
				$elm$svg$Svg$Attributes$width(
				$elm$core$String$fromFloat(box.width))
			]),
		_List_Nil);
};
var $author$project$Music$Views$MeasureView$drawKeySymbol = F3(
	function (layout, n, p) {
		var ypos = A2($author$project$Music$Models$Layout$scalePitch, layout, p);
		var symbol = (p.alter > 0) ? $author$project$Music$Views$MeasureView$sharpSymbol : $author$project$Music$Views$MeasureView$flatSymbol;
		var sp = $author$project$Music$Models$Layout$spacing(layout);
		var xpos = $author$project$Music$Models$Layout$Pixels(sp.px * n);
		var margins = $author$project$Music$Models$Layout$margins(layout);
		return A2(
			$elm$svg$Svg$g,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$transform(
					'translate(' + ($elm$core$String$fromFloat(xpos.px + sp.px) + (',' + ($elm$core$String$fromFloat(ypos.px - margins.top.px) + ')'))))
				]),
			_List_fromArray(
				[
					$author$project$Music$Views$Symbols$view(symbol)
				]));
	});
var $author$project$Music$Models$Pitch$a = A2($author$project$Music$Models$Pitch$Pitch, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$unaltered);
var $author$project$Music$Models$Pitch$b = A2($author$project$Music$Models$Pitch$Pitch, $author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$unaltered);
var $author$project$Music$Models$Pitch$c = A2($author$project$Music$Models$Pitch$Pitch, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$unaltered);
var $author$project$Music$Models$Pitch$d = A2($author$project$Music$Models$Pitch$Pitch, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$unaltered);
var $author$project$Music$Models$Pitch$alter = F2(
	function (semi, base) {
		var alteration = function (p) {
			return _Utils_update(
				p,
				{alter: p.alter + semi});
		};
		return function (oct) {
			return alteration(
				base(oct));
		};
	});
var $author$project$Music$Models$Pitch$flat = $author$project$Music$Models$Pitch$alter(-1);
var $author$project$Music$Models$Pitch$g = A2($author$project$Music$Models$Pitch$Pitch, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$unaltered);
var $author$project$Music$Views$MeasureView$flatPitches = _List_fromArray(
	[
		A2($author$project$Music$Models$Pitch$flat, $author$project$Music$Models$Pitch$b, 4),
		A2($author$project$Music$Models$Pitch$flat, $author$project$Music$Models$Pitch$e_, 5),
		A2($author$project$Music$Models$Pitch$flat, $author$project$Music$Models$Pitch$a, 4),
		A2($author$project$Music$Models$Pitch$flat, $author$project$Music$Models$Pitch$d, 5),
		A2($author$project$Music$Models$Pitch$flat, $author$project$Music$Models$Pitch$g, 4),
		A2($author$project$Music$Models$Pitch$flat, $author$project$Music$Models$Pitch$c, 5)
	]);
var $author$project$Music$Models$Layout$height = function (layout) {
	var s = $author$project$Music$Models$Layout$spacing(layout);
	var m = $author$project$Music$Models$Layout$margins(layout);
	return $author$project$Music$Models$Layout$Pixels((m.top.px + m.bottom.px) + (4 * s.px));
};
var $author$project$Music$Models$Pitch$f = A2($author$project$Music$Models$Pitch$Pitch, $author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$unaltered);
var $author$project$Music$Models$Pitch$sharp = $author$project$Music$Models$Pitch$alter(1);
var $author$project$Music$Views$MeasureView$sharpPitches = _List_fromArray(
	[
		A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$f, 5),
		A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$c, 5),
		A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$g, 5),
		A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$d, 5),
		A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$a, 4),
		A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$e_, 5)
	]);
var $elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2($elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var $elm$core$List$takeTailRec = F2(
	function (n, list) {
		return $elm$core$List$reverse(
			A3($elm$core$List$takeReverse, n, list, _List_Nil));
	});
var $elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _v0 = _Utils_Tuple2(n, list);
			_v0$1:
			while (true) {
				_v0$5:
				while (true) {
					if (!_v0.b.b) {
						return list;
					} else {
						if (_v0.b.b.b) {
							switch (_v0.a) {
								case 1:
									break _v0$1;
								case 2:
									var _v2 = _v0.b;
									var x = _v2.a;
									var _v3 = _v2.b;
									var y = _v3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_v0.b.b.b.b) {
										var _v4 = _v0.b;
										var x = _v4.a;
										var _v5 = _v4.b;
										var y = _v5.a;
										var _v6 = _v5.b;
										var z = _v6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _v0$5;
									}
								default:
									if (_v0.b.b.b.b && _v0.b.b.b.b.b) {
										var _v7 = _v0.b;
										var x = _v7.a;
										var _v8 = _v7.b;
										var y = _v8.a;
										var _v9 = _v8.b;
										var z = _v9.a;
										var _v10 = _v9.b;
										var w = _v10.a;
										var tl = _v10.b;
										return (ctr > 1000) ? A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A2($elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A3($elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _v0$5;
									}
							}
						} else {
							if (_v0.a === 1) {
								break _v0$1;
							} else {
								break _v0$5;
							}
						}
					}
				}
				return list;
			}
			var _v1 = _v0.b;
			var x = _v1.a;
			return _List_fromArray(
				[x]);
		}
	});
var $elm$core$List$take = F2(
	function (n, list) {
		return A3($elm$core$List$takeFast, 0, n, list);
	});
var $author$project$Music$Views$MeasureView$viewKey = F2(
	function (layout, key) {
		if (key.$ === 'Just') {
			var k = key.a;
			var sp = $author$project$Music$Models$Layout$spacing(layout);
			var sharps = (k.fifths > 0) ? A2($elm$core$List$take, k.fifths, $author$project$Music$Views$MeasureView$sharpPitches) : _List_Nil;
			var marks = $elm$core$Basics$abs(k.fifths);
			var h = $author$project$Music$Models$Layout$height(layout);
			var flats = (k.fifths < 0) ? A2($elm$core$List$take, 0 - k.fifths, $author$project$Music$Views$MeasureView$flatPitches) : _List_Nil;
			return A2(
				$elm$svg$Svg$svg,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$class(
						$author$project$Music$Views$MeasureStyles$css(
							function ($) {
								return $.key;
							})),
						$elm$svg$Svg$Attributes$width(
						$elm$core$String$fromFloat((1.0 + marks) * sp.px)),
						$elm$svg$Svg$Attributes$height(
						$elm$core$String$fromFloat(5.0 * sp.px)),
						$elm$svg$Svg$Attributes$viewBox(
						'0 ' + ($elm$core$String$fromFloat((-1.0) * sp.px) + (' ' + ($elm$core$String$fromFloat((1.0 + marks) * sp.px) + (' ' + $elm$core$String$fromFloat(5.0 * sp.px))))))
					]),
				A2(
					$elm$core$List$indexedMap,
					$author$project$Music$Views$MeasureView$drawKeySymbol(layout),
					A2($elm$core$List$append, sharps, flats)));
		} else {
			return $elm$html$Html$text('');
		}
	});
var $author$project$TouchTunes$Models$Controls$viewKey = function (kn) {
	var sp = $author$project$Music$Models$Layout$spacing($author$project$TouchTunes$Models$Controls$fakeLayout);
	var key = A2($author$project$Music$Models$Key$keyOf, kn, $author$project$Music$Models$Key$Major);
	return (!key.fifths) ? A2(
		$elm$html$Html$span,
		_List_Nil,
		_List_fromArray(
			[
				$elm$svg$Svg$text('0'),
				$author$project$Music$Views$Symbols$glyph($author$project$Music$Views$Symbols$sharp),
				$elm$svg$Svg$text(' , 0'),
				$author$project$Music$Views$Symbols$glyph($author$project$Music$Views$Symbols$flat)
			])) : A2(
		$author$project$Music$Views$MeasureView$viewKey,
		$author$project$TouchTunes$Models$Controls$fakeLayout,
		$elm$core$Maybe$Just(key));
};
var $author$project$TouchTunes$Models$Controls$initKeyDial = function (k) {
	return A2(
		$author$project$TouchTunes$Models$Dial$init,
		A2($elm$core$Maybe$withDefault, $author$project$Music$Models$Key$C, k),
		{
			options: $elm$core$Array$fromList(
				_List_fromArray(
					[$author$project$Music$Models$Key$Dflat, $author$project$Music$Models$Key$Aflat, $author$project$Music$Models$Key$Eflat, $author$project$Music$Models$Key$Bflat, $author$project$Music$Models$Key$F, $author$project$Music$Models$Key$C, $author$project$Music$Models$Key$G, $author$project$Music$Models$Key$D, $author$project$Music$Models$Key$A, $author$project$Music$Models$Key$E, $author$project$Music$Models$Key$B, $author$project$Music$Models$Key$Fsharp])),
			segments: 15,
			viewValue: $author$project$TouchTunes$Models$Controls$viewKey
		});
};
var $author$project$Music$Models$Harmony$Augmented = function (a) {
	return {$: 'Augmented', a: a};
};
var $author$project$Music$Models$Harmony$Diminished = function (a) {
	return {$: 'Diminished', a: a};
};
var $author$project$Music$Models$Harmony$MajorMinor = {$: 'MajorMinor'};
var $author$project$Music$Models$Harmony$Power = {$: 'Power'};
var $author$project$TouchTunes$Models$Controls$initKindDial = function (k) {
	var initial = A2(
		$elm$core$Maybe$withDefault,
		$author$project$Music$Models$Harmony$Major($author$project$Music$Models$Harmony$Triad),
		k);
	var chord = function () {
		switch (initial.$) {
			case 'Major':
				var ch = initial.a;
				return ch;
			case 'Minor':
				var ch = initial.a;
				return ch;
			case 'Diminished':
				var ch = initial.a;
				return ch;
			case 'Augmented':
				var ch = initial.a;
				return ch;
			case 'Dominant':
				var ch = initial.a;
				return ch;
			case 'HalfDiminished':
				return $author$project$Music$Models$Harmony$Seventh;
			case 'MajorMinor':
				return $author$project$Music$Models$Harmony$Seventh;
			default:
				return $author$project$Music$Models$Harmony$Triad;
		}
	}();
	return A2(
		$author$project$TouchTunes$Models$Dial$init,
		initial,
		{
			options: $elm$core$Array$fromList(
				_List_fromArray(
					[
						$author$project$Music$Models$Harmony$Major(chord),
						$author$project$Music$Models$Harmony$Minor(chord),
						$author$project$Music$Models$Harmony$Diminished(chord),
						$author$project$Music$Models$Harmony$Augmented(chord),
						$author$project$Music$Models$Harmony$Dominant(chord),
						$author$project$Music$Models$Harmony$HalfDiminished,
						$author$project$Music$Models$Harmony$MajorMinor,
						$author$project$Music$Models$Harmony$Power
					])),
			segments: 12,
			viewValue: A2(
				$elm$core$Basics$composeR,
				$author$project$Music$Views$HarmonyView$kindString,
				A2(
					$elm$core$Basics$composeR,
					$elm$core$Maybe$withDefault('Maj'),
					$author$project$Music$Views$HarmonyView$viewKindString))
		});
};
var $author$project$Music$Models$Duration$eighth = $author$project$Music$Models$Duration$division(8);
var $author$project$Music$Models$Duration$half = $author$project$Music$Models$Duration$division(2);
var $author$project$Music$Models$Duration$quarter = $author$project$Music$Models$Duration$division(4);
var $author$project$Music$Views$NoteView$isWhole = function (d) {
	return ((d.count / d.divisor) | 0) === 1;
};
var $author$project$Music$Models$Key$flatSteps = _List_fromArray(
	[$author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$C]);
var $elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var $elm$core$List$member = F2(
	function (x, xs) {
		return A2(
			$elm$core$List$any,
			function (a) {
				return _Utils_eq(a, x);
			},
			xs);
	});
var $author$project$Music$Models$Key$sharpSteps = _List_fromArray(
	[$author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$E]);
var $author$project$Music$Models$Key$stepAlteredIn = F2(
	function (key, step) {
		return (key.fifths > 0) ? (A2(
			$elm$core$List$member,
			step,
			A2($elm$core$List$take, key.fifths, $author$project$Music$Models$Key$sharpSteps)) ? 1 : 0) : (A2(
			$elm$core$List$member,
			step,
			A2($elm$core$List$take, 0 - key.fifths, $author$project$Music$Models$Key$flatSteps)) ? (-1) : 0);
	});
var $author$project$Music$Views$NoteView$accidental = F2(
	function (key, p) {
		return _Utils_eq(
			A2($author$project$Music$Models$Key$stepAlteredIn, key, p.step),
			p.alter) ? $elm$core$Maybe$Nothing : A2(
			$elm$core$Maybe$map,
			$author$project$Music$Views$NoteView$alteration,
			$author$project$Music$Models$Pitch$chromatic(p.alter));
	});
var $author$project$Music$Models$Layout$key = function (layout) {
	return A2(
		$elm$core$Maybe$withDefault,
		A2($author$project$Music$Models$Key$keyOf, $author$project$Music$Models$Key$C, $author$project$Music$Models$Key$Major),
		A2(
			$author$project$Music$Models$Layout$getAttribute,
			function ($) {
				return $.key;
			},
			layout));
};
var $author$project$Music$Views$Symbols$ledgerLine = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 60, 12),
	'tt-ledger-line');
var $author$project$Music$Models$Layout$positionOnStaff = F2(
	function (layout, p) {
		return $author$project$Music$Models$Pitch$stepNumber(p) - $author$project$Music$Models$Pitch$stepNumber(
			$author$project$Music$Models$Layout$basePitch(layout));
	});
var $author$project$Music$Views$NoteView$ledgerLines = F2(
	function (layout, p) {
		var sp = $author$project$Music$Models$Layout$spacing(layout);
		var n = A2($author$project$Music$Models$Layout$positionOnStaff, layout, p);
		var steps = (n > 2) ? A2($elm$core$List$range, 0, n - 3) : ((_Utils_cmp(n, -8) < 0) ? A2($elm$core$List$range, n + 9, 0) : _List_Nil);
		var isEven = function (num) {
			return !A2($elm$core$Basics$modBy, 2, num);
		};
		var spaces = A2($elm$core$List$filter, isEven, steps);
		var isBelow = _Utils_cmp(n, -8) < 0;
		var isAbove = n > 2;
		var lineOffset = isAbove ? (2 - A2($elm$core$Basics$modBy, 2, n)) : A2($elm$core$Basics$modBy, 2, n);
		var spaceToPixels = function (i) {
			return $author$project$Music$Models$Layout$Pixels((((i + lineOffset) - 1) * sp.px) / 2);
		};
		return A2($elm$core$List$map, spaceToPixels, spaces);
	});
var $author$project$Music$Views$Symbols$noteheadClosed = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 34, 24),
	'tt-notehead-closed');
var $author$project$Music$Views$Symbols$noteheadOpen = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 34, 24),
	'tt-notehead-open');
var $author$project$Music$Views$NoteView$noteHead = function (d) {
	return ((d.divisor / d.count) > 2.0) ? $author$project$Music$Views$Symbols$noteheadClosed : $author$project$Music$Views$Symbols$noteheadOpen;
};
var $author$project$Music$Views$Symbols$stemDown = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 34, 164),
	'tt-stem-down');
var $author$project$Music$Views$Symbols$stemDown1Flag = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 34, 164),
	'tt-stem-down-1flag');
var $author$project$Music$Views$Symbols$stemUp = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 34, 164),
	'tt-stem-up');
var $author$project$Music$Views$Symbols$stemUp1Flag = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 80, 164),
	'tt-stem-up-1flag');
var $author$project$Music$Views$NoteView$noteStem = F3(
	function (layout, d, p) {
		var down = _Utils_cmp(
			A2($author$project$Music$Models$Layout$positionOnStaff, layout, p),
			-3) > 0;
		return $author$project$Music$Views$NoteView$isWhole(d) ? $elm$core$Maybe$Nothing : (((d.divisor / d.count) > 4.0) ? $elm$core$Maybe$Just(
			down ? $author$project$Music$Views$Symbols$stemDown1Flag : $author$project$Music$Views$Symbols$stemUp1Flag) : $elm$core$Maybe$Just(
			down ? $author$project$Music$Views$Symbols$stemDown : $author$project$Music$Views$Symbols$stemUp));
	});
var $author$project$Music$Views$Symbols$rightAlign = F2(
	function (xOffset, asset) {
		var box = asset.viewbox;
		var newBox = _Utils_update(
			box,
			{x: (box.x - xOffset) + (1.5 * box.width)});
		return _Utils_update(
			asset,
			{viewbox: newBox});
	});
var $elm$svg$Svg$text_ = $elm$svg$Svg$trustedNode('text');
var $author$project$Music$Views$Symbols$singleDot = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 20, 20),
	'tt-dot');
var $author$project$Music$Views$NoteView$dotted = function (d) {
	var b = d.count;
	return (b === 3) ? $elm$core$Maybe$Just($author$project$Music$Views$Symbols$singleDot) : $elm$core$Maybe$Nothing;
};
var $author$project$Music$Views$Symbols$leftAlign = F2(
	function (xOffset, asset) {
		var box = asset.viewbox;
		var newBox = _Utils_update(
			box,
			{x: (box.x - xOffset) - (0.5 * box.width)});
		return _Utils_update(
			asset,
			{viewbox: newBox});
	});
var $author$project$Music$Views$NoteView$viewDot = function (d) {
	var sp = 20.0;
	var xOffset = 0.75 * sp;
	var dot = $author$project$Music$Views$NoteView$dotted(d);
	if (dot.$ === 'Just') {
		var theDot = dot.a;
		return $author$project$Music$Views$Symbols$view(
			A2($author$project$Music$Views$Symbols$leftAlign, xOffset, theDot));
	} else {
		return A2($elm$svg$Svg$text_, _List_Nil, _List_Nil);
	}
};
var $author$project$Music$Views$NoteView$viewNote = F3(
	function (layout, d, p) {
		var ypos = A2($author$project$Music$Models$Layout$scalePitch, layout, p);
		var viewLedger = function (y) {
			return A2(
				$elm$svg$Svg$g,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$transform(
						'translate(0,' + ($elm$core$String$fromFloat(y.px) + ')'))
					]),
				_List_fromArray(
					[
						$author$project$Music$Views$Symbols$view($author$project$Music$Views$Symbols$ledgerLine)
					]));
		};
		var stem = A3($author$project$Music$Views$NoteView$noteStem, layout, d, p);
		var sp = $author$project$Music$Models$Layout$spacing(layout);
		var w = 1.5 * sp.px;
		var position = A2(
			$elm$core$String$join,
			',',
			A2(
				$elm$core$List$map,
				$elm$core$String$fromFloat,
				_List_fromArray(
					[0, ypos.px])));
		var note = $author$project$Music$Views$NoteView$noteHead(d);
		var ledgers = A2($author$project$Music$Views$NoteView$ledgerLines, layout, p);
		var alt = A2(
			$author$project$Music$Views$NoteView$accidental,
			$author$project$Music$Models$Layout$key(layout),
			p);
		return A2(
			$elm$svg$Svg$g,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$transform(
					'translate(0,' + ($elm$core$String$fromFloat(ypos.px) + ')'))
				]),
			_List_fromArray(
				[
					$author$project$Music$Views$Symbols$view(note),
					$author$project$Music$Views$NoteView$viewDot(d),
					function () {
					if (stem.$ === 'Just') {
						var theStem = stem.a;
						return $author$project$Music$Views$Symbols$view(theStem);
					} else {
						return A2($elm$svg$Svg$text_, _List_Nil, _List_Nil);
					}
				}(),
					A2(
					$elm$svg$Svg$g,
					_List_Nil,
					A2($elm$core$List$map, viewLedger, ledgers)),
					function () {
					if (alt.$ === 'Just') {
						var theAlt = alt.a;
						return $author$project$Music$Views$Symbols$view(
							A2($author$project$Music$Views$Symbols$rightAlign, 0, theAlt));
					} else {
						return A2($elm$svg$Svg$text_, _List_Nil, _List_Nil);
					}
				}()
				]));
	});
var $author$project$TouchTunes$Models$Controls$viewSubdivision = function (d) {
	var staffHeight = $author$project$Music$Models$Layout$height($author$project$TouchTunes$Models$Controls$fakeLayout);
	var pitch = $author$project$Music$Views$NoteView$isWhole(d) ? $author$project$Music$Models$Pitch$b(4) : $author$project$Music$Models$Pitch$e_(4);
	return A2(
		$elm$svg$Svg$g,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$transform(
				'translate(0,' + ($elm$core$String$fromFloat((-0.5) * staffHeight.px) + ')'))
			]),
		_List_fromArray(
			[
				A3($author$project$Music$Views$NoteView$viewNote, $author$project$TouchTunes$Models$Controls$fakeLayout, d, pitch)
			]));
};
var $author$project$TouchTunes$Models$Controls$initSubdivisionDial = A2(
	$author$project$TouchTunes$Models$Dial$init,
	$author$project$Music$Models$Duration$quarter,
	{
		options: $elm$core$Array$fromList(
			_List_fromArray(
				[$author$project$Music$Models$Duration$eighth, $author$project$Music$Models$Duration$quarter, $author$project$Music$Models$Duration$half])),
		segments: 10,
		viewValue: $author$project$TouchTunes$Models$Controls$viewSubdivision
	});
var $author$project$Music$Models$Time$Eight = {$: 'Eight'};
var $author$project$Music$Models$Time$Two = {$: 'Two'};
var $author$project$Music$Models$Time$cut = A2($author$project$Music$Models$Time$Time, 2, $author$project$Music$Models$Time$Two);
var $elm$svg$Svg$Attributes$fontSize = _VirtualDom_attribute('font-size');
var $author$project$Music$Models$Layout$timeOffset = function (layout) {
	var sp = $author$project$Music$Models$Layout$spacing(layout).px;
	return $author$project$Music$Models$Layout$Pixels(
		function () {
			var _v0 = layout.direct.key;
			if (_v0.$ === 'Just') {
				var k = _v0.a;
				return sp + ($elm$core$Basics$abs(k.fifths) * sp);
			} else {
				return 0.0;
			}
		}());
};
var $author$project$Music$Views$MeasureView$viewTime = F2(
	function (layout, time) {
		var sp = $author$project$Music$Models$Layout$spacing(layout);
		var offset = $author$project$Music$Models$Layout$timeOffset(layout);
		if (time.$ === 'Just') {
			var t = time.a;
			return A2(
				$elm$svg$Svg$svg,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$class(
						$author$project$Music$Views$MeasureStyles$css(
							function ($) {
								return $.time;
							})),
						$elm$svg$Svg$Attributes$width(
						$elm$core$String$fromFloat(4.0 * sp.px)),
						$elm$svg$Svg$Attributes$height(
						$elm$core$String$fromFloat(4.0 * sp.px)),
						$elm$svg$Svg$Attributes$viewBox(
						'0 0 ' + ($elm$core$String$fromFloat(4.0 * sp.px) + (' ' + $elm$core$String$fromFloat(4.0 * sp.px))))
					]),
				_List_fromArray(
					[
						A2(
						$elm$svg$Svg$text_,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$fontSize(
								$elm$core$String$fromFloat(3.0 * sp.px)),
								$elm$svg$Svg$Attributes$x(
								$elm$core$String$fromFloat(0.8 * sp.px)),
								$elm$svg$Svg$Attributes$y(
								$elm$core$String$fromFloat(2.0 * sp.px))
							]),
						_List_fromArray(
							[
								$elm$html$Html$text(
								$elm$core$String$fromInt(t.beats))
							])),
						A2(
						$elm$svg$Svg$text_,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$fontSize(
								$elm$core$String$fromFloat(3.0 * sp.px)),
								$elm$svg$Svg$Attributes$x(
								$elm$core$String$fromFloat(1.2 * sp.px)),
								$elm$svg$Svg$Attributes$y(
								$elm$core$String$fromFloat(4.0 * sp.px))
							]),
						_List_fromArray(
							[
								$elm$html$Html$text(
								$elm$core$String$fromInt(
									$author$project$Music$Models$Time$divisor(t)))
							]))
					]));
		} else {
			return $elm$html$Html$text('');
		}
	});
var $author$project$TouchTunes$Models$Controls$viewTime = function (time) {
	var staffHeight = $author$project$Music$Models$Layout$height($author$project$TouchTunes$Models$Controls$fakeLayout);
	var sp = $author$project$Music$Models$Layout$spacing($author$project$TouchTunes$Models$Controls$fakeLayout);
	var m = $author$project$Music$Models$Layout$margins($author$project$TouchTunes$Models$Controls$fakeLayout);
	return A2(
		$author$project$Music$Views$MeasureView$viewTime,
		$author$project$TouchTunes$Models$Controls$fakeLayout,
		$elm$core$Maybe$Just(time));
};
var $author$project$TouchTunes$Models$Controls$initTimeDial = function (t) {
	return A2(
		$author$project$TouchTunes$Models$Dial$init,
		A2($elm$core$Maybe$withDefault, $author$project$Music$Models$Time$common, t),
		{
			options: $elm$core$Array$fromList(
				_List_fromArray(
					[
						$author$project$Music$Models$Time$cut,
						A2($author$project$Music$Models$Time$Time, 2, $author$project$Music$Models$Time$Four),
						A2($author$project$Music$Models$Time$Time, 3, $author$project$Music$Models$Time$Four),
						$author$project$Music$Models$Time$common,
						A2($author$project$Music$Models$Time$Time, 5, $author$project$Music$Models$Time$Four),
						A2($author$project$Music$Models$Time$Time, 6, $author$project$Music$Models$Time$Eight),
						A2($author$project$Music$Models$Time$Time, 7, $author$project$Music$Models$Time$Eight),
						A2($author$project$Music$Models$Time$Time, 9, $author$project$Music$Models$Time$Eight)
					])),
			segments: 10,
			viewValue: $author$project$TouchTunes$Models$Controls$viewTime
		});
};
var $author$project$Music$Models$Key$Gflat = {$: 'Gflat'};
var $author$project$Music$Models$Key$flatKeyNames = $elm$core$Array$fromList(
	_List_fromArray(
		[$author$project$Music$Models$Key$C, $author$project$Music$Models$Key$F, $author$project$Music$Models$Key$Bflat, $author$project$Music$Models$Key$Eflat, $author$project$Music$Models$Key$Aflat, $author$project$Music$Models$Key$Dflat, $author$project$Music$Models$Key$Gflat]));
var $author$project$Music$Models$Key$sharpKeyNames = $elm$core$Array$fromList(
	_List_fromArray(
		[$author$project$Music$Models$Key$C, $author$project$Music$Models$Key$G, $author$project$Music$Models$Key$D, $author$project$Music$Models$Key$A, $author$project$Music$Models$Key$E, $author$project$Music$Models$Key$B, $author$project$Music$Models$Key$Fsharp]));
var $author$project$Music$Models$Key$keyName = function (key) {
	return (key.fifths > 0) ? A2(
		$elm$core$Maybe$withDefault,
		$author$project$Music$Models$Key$C,
		A2($elm$core$Array$get, key.fifths, $author$project$Music$Models$Key$sharpKeyNames)) : A2(
		$elm$core$Maybe$withDefault,
		$author$project$Music$Models$Key$C,
		A2(
			$elm$core$Array$get,
			$elm$core$Basics$abs(key.fifths),
			$author$project$Music$Models$Key$flatKeyNames));
};
var $author$project$Music$Models$Layout$time = function (layout) {
	return A2(
		$elm$core$Maybe$withDefault,
		$author$project$Music$Models$Time$common,
		A2(
			$author$project$Music$Models$Layout$getAttribute,
			function ($) {
				return $.time;
			},
			layout));
};
var $author$project$TouchTunes$Models$Controls$init = function (layout) {
	if (layout.$ === 'Just') {
		var l = layout.a;
		return {
			altHarmonyDial: $author$project$TouchTunes$Models$Controls$initAltHarmonyDial(
				$elm$core$Maybe$Just(_List_Nil)),
			alterationDial: $author$project$TouchTunes$Models$Controls$initAlterationDial($author$project$Music$Models$Pitch$Natural),
			bassDial: A2(
				$author$project$TouchTunes$Models$Controls$initBassDial,
				$author$project$Music$Models$Layout$key(l),
				A2(
					$elm$core$Maybe$map,
					$author$project$Music$Models$Key$tonic,
					$elm$core$Maybe$Just(
						$author$project$Music$Models$Layout$key(l)))),
			chordDial: $author$project$TouchTunes$Models$Controls$initChordDial(
				$elm$core$Maybe$Just($author$project$Music$Models$Harmony$Seventh)),
			harmonyDial: A3(
				$author$project$TouchTunes$Models$Controls$initHarmonyDial,
				$author$project$Music$Models$Layout$key(l),
				$author$project$Music$Models$Harmony$Seventh,
				A2(
					$elm$core$Maybe$map,
					A2(
						$elm$core$Basics$composeL,
						$author$project$Music$Models$Harmony$chord(
							$author$project$Music$Models$Harmony$Major($author$project$Music$Models$Harmony$Seventh)),
						$author$project$Music$Models$Key$tonic),
					$elm$core$Maybe$Just(
						$author$project$Music$Models$Layout$key(l)))),
			keyDial: $author$project$TouchTunes$Models$Controls$initKeyDial(
				A2(
					$elm$core$Maybe$map,
					$author$project$Music$Models$Key$keyName,
					$elm$core$Maybe$Just(
						$author$project$Music$Models$Layout$key(l)))),
			kindDial: $author$project$TouchTunes$Models$Controls$initKindDial(
				$elm$core$Maybe$Just(
					$author$project$Music$Models$Harmony$Major($author$project$Music$Models$Harmony$Triad))),
			subdivisionDial: $author$project$TouchTunes$Models$Controls$initSubdivisionDial,
			timeDial: $author$project$TouchTunes$Models$Controls$initTimeDial(
				$elm$core$Maybe$Just(
					$author$project$Music$Models$Layout$time(l)))
		};
	} else {
		return {
			altHarmonyDial: $author$project$TouchTunes$Models$Controls$initAltHarmonyDial($elm$core$Maybe$Nothing),
			alterationDial: $author$project$TouchTunes$Models$Controls$initAlterationDial($author$project$Music$Models$Pitch$Natural),
			bassDial: A2(
				$author$project$TouchTunes$Models$Controls$initBassDial,
				A2($author$project$Music$Models$Key$keyOf, $author$project$Music$Models$Key$C, $author$project$Music$Models$Key$Major),
				$elm$core$Maybe$Nothing),
			chordDial: $author$project$TouchTunes$Models$Controls$initChordDial($elm$core$Maybe$Nothing),
			harmonyDial: A3(
				$author$project$TouchTunes$Models$Controls$initHarmonyDial,
				A2($author$project$Music$Models$Key$keyOf, $author$project$Music$Models$Key$C, $author$project$Music$Models$Key$Major),
				$author$project$Music$Models$Harmony$Seventh,
				$elm$core$Maybe$Nothing),
			keyDial: $author$project$TouchTunes$Models$Controls$initKeyDial($elm$core$Maybe$Nothing),
			kindDial: $author$project$TouchTunes$Models$Controls$initKindDial($elm$core$Maybe$Nothing),
			subdivisionDial: $author$project$TouchTunes$Models$Controls$initSubdivisionDial,
			timeDial: $author$project$TouchTunes$Models$Controls$initTimeDial($elm$core$Maybe$Nothing)
		};
	}
};
var $author$project$TouchTunes$Models$Editor$open = F2(
	function (indirect, measure) {
		var layout = A2($author$project$Music$Models$Layout$forMeasure, indirect, measure);
		return A3(
			$author$project$TouchTunes$Models$Editor$Editor,
			measure,
			$author$project$TouchTunes$Models$Controls$init(
				$elm$core$Maybe$Just(layout)),
			$author$project$TouchTunes$Models$Overlay$fromLayout(layout));
	});
var $author$project$TouchTunes$Models$App$open = F3(
	function (pid, mnum, app) {
		var maybeMeasureAttrs = A2($author$project$Music$Models$Score$measureWithContext, mnum, app.score);
		var editMeasure = function (_v0) {
			var measure = _v0.a;
			var attrs = _v0.b;
			return {
				editor: A2($author$project$TouchTunes$Models$Editor$open, attrs, measure),
				measureNum: mnum,
				partId: pid
			};
		};
		return _Utils_update(
			app,
			{
				editing: A2($elm$core$Maybe$map, editMeasure, maybeMeasureAttrs)
			});
	});
var $elm$core$Elm$JsArray$unsafeSet = _JsArray_unsafeSet;
var $elm$core$Array$setHelp = F4(
	function (shift, index, value, tree) {
		var pos = $elm$core$Array$bitMask & (index >>> shift);
		var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
		if (_v0.$ === 'SubTree') {
			var subTree = _v0.a;
			var newSub = A4($elm$core$Array$setHelp, shift - $elm$core$Array$shiftStep, index, value, subTree);
			return A3(
				$elm$core$Elm$JsArray$unsafeSet,
				pos,
				$elm$core$Array$SubTree(newSub),
				tree);
		} else {
			var values = _v0.a;
			var newLeaf = A3($elm$core$Elm$JsArray$unsafeSet, $elm$core$Array$bitMask & index, value, values);
			return A3(
				$elm$core$Elm$JsArray$unsafeSet,
				pos,
				$elm$core$Array$Leaf(newLeaf),
				tree);
		}
	});
var $elm$core$Array$set = F3(
	function (index, value, array) {
		var len = array.a;
		var startShift = array.b;
		var tree = array.c;
		var tail = array.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? array : ((_Utils_cmp(
			index,
			$elm$core$Array$tailIndex(len)) > -1) ? A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			tree,
			A3($elm$core$Elm$JsArray$unsafeSet, $elm$core$Array$bitMask & index, value, tail)) : A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			A4($elm$core$Array$setHelp, startShift, index, value, tree),
			tail));
	});
var $author$project$Music$Models$Score$setMeasure = F3(
	function (i, m, s) {
		return _Utils_update(
			s,
			{
				measures: A3($elm$core$Array$set, i, m, s.measures)
			});
	});
var $elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (maybeValue.$ === 'Just') {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$TouchTunes$Models$Overlay$HarmonySelection = F3(
	function (a, b, c) {
		return {$: 'HarmonySelection', a: a, b: b, c: c};
	});
var $author$project$TouchTunes$Models$Overlay$changeHarmony = F2(
	function (harmony, overlay) {
		var _v0 = overlay.selection;
		if (_v0.$ === 'HarmonySelection') {
			var key = _v0.b;
			var beat = _v0.c;
			return _Utils_update(
				overlay,
				{
					selection: A3($author$project$TouchTunes$Models$Overlay$HarmonySelection, harmony, key, beat)
				});
		} else {
			return overlay;
		}
	});
var $author$project$Music$Models$Note$Play = function (a) {
	return {$: 'Play', a: a};
};
var $author$project$Music$Models$Note$modPitch = F2(
	function (fn, note) {
		var _v0 = note._do;
		if (_v0.$ === 'Play') {
			var p = _v0.a;
			return _Utils_update(
				note,
				{
					_do: $author$project$Music$Models$Note$Play(
						fn(p))
				});
		} else {
			return note;
		}
	});
var $mgold$elm_nonempty_list$List$Nonempty$cons = F2(
	function (y, _v0) {
		var x = _v0.a;
		var xs = _v0.b;
		return A2(
			$mgold$elm_nonempty_list$List$Nonempty$Nonempty,
			y,
			A2($elm$core$List$cons, x, xs));
	});
var $mgold$elm_nonempty_list$List$Nonempty$replaceHead = F2(
	function (y, _v0) {
		var x = _v0.a;
		var xs = _v0.b;
		return A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, y, xs);
	});
var $mgold$elm_nonempty_list$List$Nonempty$reverse = function (_v0) {
	var x = _v0.a;
	var xs = _v0.b;
	var revapp = function (_v1) {
		revapp:
		while (true) {
			var ls = _v1.a;
			var c = _v1.b;
			var rs = _v1.c;
			if (!rs.b) {
				return A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, c, ls);
			} else {
				var r = rs.a;
				var rss = rs.b;
				var $temp$_v1 = _Utils_Tuple3(
					A2($elm$core$List$cons, c, ls),
					r,
					rss);
				_v1 = $temp$_v1;
				continue revapp;
			}
		}
	};
	return revapp(
		_Utils_Tuple3(_List_Nil, x, xs));
};
var $author$project$Music$Models$Measure$aggregateRests = function (measure) {
	var agg = F2(
		function (singleton, sofar) {
			var prevNote = $mgold$elm_nonempty_list$List$Nonempty$head(sofar);
			var note = $mgold$elm_nonempty_list$List$Nonempty$head(singleton);
			var _v0 = _Utils_Tuple2(prevNote._do, note._do);
			if ((_v0.a.$ === 'Rest') && (_v0.b.$ === 'Rest')) {
				var _v1 = _v0.a;
				var _v2 = _v0.b;
				return A2(
					$mgold$elm_nonempty_list$List$Nonempty$replaceHead,
					_Utils_update(
						prevNote,
						{
							duration: A2($author$project$Music$Models$Duration$add, prevNote.duration, note.duration)
						}),
					sofar);
			} else {
				return A2($mgold$elm_nonempty_list$List$Nonempty$cons, note, sofar);
			}
		});
	return A2(
		$author$project$Music$Models$Measure$Measure,
		measure.attributes,
		A2(
			$mgold$elm_nonempty_list$List$Nonempty$foldl1,
			agg,
			$mgold$elm_nonempty_list$List$Nonempty$reverse(
				A2($mgold$elm_nonempty_list$List$Nonempty$map, $mgold$elm_nonempty_list$List$Nonempty$fromElement, measure.notes))));
};
var $author$project$Music$Models$Duration$equal = F2(
	function (a, b) {
		var _v0 = $author$project$Music$Models$Duration$makeCommon(
			_Utils_Tuple2(a, b));
		var ac = _v0.a;
		var bc = _v0.b;
		return _Utils_eq(ac.count, bc.count);
	});
var $elm_community$list_extra$List$Extra$find = F2(
	function (predicate, list) {
		find:
		while (true) {
			if (!list.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				var first = list.a;
				var rest = list.b;
				if (predicate(first)) {
					return $elm$core$Maybe$Just(first);
				} else {
					var $temp$predicate = predicate,
						$temp$list = rest;
					predicate = $temp$predicate;
					list = $temp$list;
					continue find;
				}
			}
		}
	});
var $mgold$elm_nonempty_list$List$Nonempty$map2 = F3(
	function (f, _v0, _v1) {
		var x = _v0.a;
		var xs = _v0.b;
		var y = _v1.a;
		var ys = _v1.b;
		return A2(
			$mgold$elm_nonempty_list$List$Nonempty$Nonempty,
			A2(f, x, y),
			A3($elm$core$List$map2, f, xs, ys));
	});
var $mgold$elm_nonempty_list$List$Nonempty$toList = function (_v0) {
	var x = _v0.a;
	var xs = _v0.b;
	return A2($elm$core$List$cons, x, xs);
};
var $author$project$Music$Models$Measure$toSequence = function (measure) {
	return $mgold$elm_nonempty_list$List$Nonempty$toList(
		A3(
			$mgold$elm_nonempty_list$List$Nonempty$map2,
			F2(
				function (a, b) {
					return _Utils_Tuple2(a, b);
				}),
			$author$project$Music$Models$Measure$offsets(measure),
			measure.notes));
};
var $author$project$Music$Models$Measure$findNote = F2(
	function (offset, measure) {
		return A2(
			$elm$core$Maybe$map,
			function (_v0) {
				var n = _v0.b;
				return n;
			},
			A2(
				$elm_community$list_extra$List$Extra$find,
				function (_v1) {
					var d = _v1.a;
					return A2($author$project$Music$Models$Duration$equal, offset, d);
				},
				$author$project$Music$Models$Measure$toSequence(measure)));
	});
var $author$project$Music$Models$Measure$fromNotes = F2(
	function (attrs, notes) {
		var _v0 = $mgold$elm_nonempty_list$List$Nonempty$fromList(notes);
		if (_v0.$ === 'Nothing') {
			return $author$project$Music$Models$Measure$fromAttributes(attrs);
		} else {
			var nonempty = _v0.a;
			return A2($author$project$Music$Models$Measure$Measure, attrs, nonempty);
		}
	});
var $author$project$Music$Models$Measure$fromSequence = F2(
	function (attrs, sequence) {
		return A2(
			$author$project$Music$Models$Measure$fromNotes,
			attrs,
			A2(
				$elm$core$List$map,
				function (_v0) {
					var b = _v0.a;
					var n = _v0.b;
					return n;
				},
				sequence));
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $elm$core$Basics$not = _Basics_not;
var $author$project$Music$Models$Duration$shorterThan = F2(
	function (a, b) {
		var _v0 = $author$project$Music$Models$Duration$makeCommon(
			_Utils_Tuple2(a, b));
		var ac = _v0.a;
		var bc = _v0.b;
		return _Utils_cmp(ac.count, bc.count) > 0;
	});
var $author$project$Music$Models$Duration$subtract = F2(
	function (a, b) {
		var _v0 = $author$project$Music$Models$Duration$makeCommon(
			_Utils_Tuple2(a, b));
		var ac = _v0.a;
		var bc = _v0.b;
		return $author$project$Music$Models$Duration$reduce(
			_Utils_update(
				bc,
				{count: bc.count - ac.count}));
	});
var $author$project$Music$Models$Measure$spliceNote = F2(
	function (_v0, _v1) {
		var b0 = _v0.a;
		var n0 = _v0.b;
		var b1 = _v1.a;
		var n1 = _v1.b;
		var restFromTo = F3(
			function (b, e, _v2) {
				return $author$project$Music$Models$Note$restFor(
					A2($author$project$Music$Models$Duration$subtract, b, e));
			});
		var e1 = A2($author$project$Music$Models$Duration$add, n1.duration, b1);
		var e0 = A2($author$project$Music$Models$Duration$add, n0.duration, b0);
		var clipFromTo = F3(
			function (b, e, n) {
				return _Utils_update(
					n,
					{
						duration: A2($author$project$Music$Models$Duration$subtract, b, e)
					});
			});
		return (!A2($author$project$Music$Models$Duration$longerThan, b0, e1)) ? _List_fromArray(
			[
				_Utils_Tuple2(b1, n1)
			]) : ((!A2($author$project$Music$Models$Duration$longerThan, b1, e0)) ? _List_fromArray(
			[
				_Utils_Tuple2(b1, n1)
			]) : (A2($author$project$Music$Models$Duration$equal, b0, b1) ? (A2($author$project$Music$Models$Duration$shorterThan, e1, e0) ? _List_fromArray(
			[
				_Utils_Tuple2(b0, n0),
				_Utils_Tuple2(
				e0,
				A3(restFromTo, e0, e1, n1))
			]) : _List_fromArray(
			[
				_Utils_Tuple2(b0, n0)
			])) : (A2($author$project$Music$Models$Duration$shorterThan, b0, b1) ? (A2($author$project$Music$Models$Duration$shorterThan, e1, e0) ? _List_fromArray(
			[
				_Utils_Tuple2(
				b1,
				A3(clipFromTo, b1, b0, n1)),
				_Utils_Tuple2(b0, n0),
				_Utils_Tuple2(
				e0,
				A3(clipFromTo, e0, e1, n1))
			]) : _List_fromArray(
			[
				_Utils_Tuple2(
				b1,
				A3(clipFromTo, b1, b0, n1)),
				_Utils_Tuple2(b0, n0)
			])) : (A2($author$project$Music$Models$Duration$shorterThan, e1, e0) ? _List_fromArray(
			[
				_Utils_Tuple2(
				e0,
				A3(clipFromTo, e0, e1, n1))
			]) : _List_Nil))));
	});
var $author$project$Music$Models$Measure$spliceSequence = F2(
	function (bn, seq) {
		return $elm$core$List$concat(
			A2(
				$elm$core$List$map,
				$author$project$Music$Models$Measure$spliceNote(bn),
				seq));
	});
var $author$project$Music$Models$Measure$modifyNote = F3(
	function (f, offset, measure) {
		var seq = $author$project$Music$Models$Measure$toSequence(measure);
		var note = A2(
			$elm$core$Maybe$withDefault,
			$author$project$Music$Models$Note$restFor($author$project$Music$Models$Duration$quarter),
			A2($author$project$Music$Models$Measure$findNote, offset, measure));
		return $author$project$Music$Models$Measure$aggregateRests(
			A2(
				$author$project$Music$Models$Measure$fromSequence,
				measure.attributes,
				A2(
					$author$project$Music$Models$Measure$spliceSequence,
					_Utils_Tuple2(
						offset,
						f(note)),
					seq)));
	});
var $author$project$Music$Models$Pitch$setAlter = F2(
	function (chr, p) {
		return _Utils_update(
			p,
			{
				alter: $author$project$Music$Models$Pitch$semitones(chr)
			});
	});
var $author$project$Music$Models$Beat$toDuration = F2(
	function (time, beat) {
		return A2(
			$author$project$Music$Models$Duration$add,
			A2(
				$author$project$Music$Models$Duration$Duration,
				beat.full,
				$author$project$Music$Models$Time$divisor(time)),
			A2(
				$author$project$Music$Models$Duration$Duration,
				beat.parts,
				beat.divisor * $author$project$Music$Models$Time$divisor(time)));
	});
var $author$project$TouchTunes$Models$Dial$value = function (dial) {
	return dial.value;
};
var $author$project$Music$Models$Measure$withAttributes = F2(
	function (attrs, measure) {
		return _Utils_update(
			measure,
			{attributes: attrs});
	});
var $author$project$Music$Models$Measure$withEssentialAttributes = F3(
	function (indirect, direct, measure) {
		return A2(
			$author$project$Music$Models$Measure$withAttributes,
			A2($author$project$Music$Models$Measure$essentialAttributes, indirect, direct),
			measure);
	});
var $author$project$TouchTunes$Models$Editor$latent = function (editor) {
	var layout = editor.overlay.layout;
	var override = function (m) {
		var direct = m.attributes;
		return A3(
			$author$project$Music$Models$Measure$withEssentialAttributes,
			layout.indirect,
			_Utils_update(
				direct,
				{
					key: $elm$core$Maybe$Just(
						A2($author$project$Music$Models$Key$keyOf, editor.controls.keyDial.value, $author$project$Music$Models$Key$Major)),
					time: $elm$core$Maybe$Just(editor.controls.timeDial.value)
				}),
			m);
	};
	var controlled = override(editor.measure);
	var _v0 = A2($elm$core$Debug$log, 'selection', editor.overlay.selection);
	switch (_v0.$) {
		case 'HarmonySelection':
			var beat = _v0.c;
			var t = $author$project$Music$Models$Layout$time(layout);
			var harmony = editor.controls.harmonyDial.value;
			var deg = editor.controls.chordDial.value;
			var bass = editor.controls.bassDial.value;
			var h = _Utils_update(
				harmony,
				{
					alter: editor.controls.altHarmonyDial.value,
					bass: _Utils_eq(bass, harmony.root) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(bass),
					kind: function () {
						var _v1 = editor.controls.kindDial.value;
						switch (_v1.$) {
							case 'Major':
								return $author$project$Music$Models$Harmony$Major(deg);
							case 'Minor':
								return $author$project$Music$Models$Harmony$Minor(deg);
							case 'Diminished':
								return $author$project$Music$Models$Harmony$Diminished(deg);
							case 'Augmented':
								return $author$project$Music$Models$Harmony$Augmented(deg);
							case 'Dominant':
								return $author$project$Music$Models$Harmony$Dominant(deg);
							case 'HalfDiminished':
								return $author$project$Music$Models$Harmony$HalfDiminished;
							case 'MajorMinor':
								return $author$project$Music$Models$Harmony$MajorMinor;
							default:
								return $author$project$Music$Models$Harmony$Power;
						}
					}()
				});
			var fn = A2(
				$author$project$Music$Models$Measure$modifyNote,
				function (original) {
					return _Utils_update(
						original,
						{
							harmony: $elm$core$Maybe$Just(h)
						});
				},
				A2($author$project$Music$Models$Beat$toDuration, t, beat));
			return fn(controlled);
		case 'NoteSelection':
			var note = _v0.a;
			var location = _v0.b;
			var t = $author$project$Music$Models$Layout$time(layout);
			var replace = F2(
				function (n, orig) {
					return _Utils_update(
						n,
						{harmony: orig.harmony});
				});
			var alteration = $author$project$TouchTunes$Models$Dial$value(editor.controls.alterationDial);
			var changed = A2(
				$author$project$Music$Models$Note$modPitch,
				$author$project$Music$Models$Pitch$setAlter(alteration),
				note);
			var fn = A2(
				$author$project$Music$Models$Measure$modifyNote,
				function (original) {
					return A2(replace, changed, original);
				},
				A2($author$project$Music$Models$Beat$toDuration, t, location.beat));
			return fn(controlled);
		default:
			return controlled;
	}
};
var $author$project$Music$Models$Layout$subdivide = F2(
	function (div, layout) {
		return _Utils_update(
			layout,
			{
				divisors: A2(
					$mgold$elm_nonempty_list$List$Nonempty$map,
					function (d) {
						return A2($elm$core$Basics$max, 1, div);
					},
					layout.divisors)
			});
	});
var $author$project$TouchTunes$Models$Overlay$subdivide = F2(
	function (duration, overlay) {
		var time = $author$project$Music$Models$Layout$time(overlay.layout);
		var l = A2(
			$author$project$Music$Models$Layout$subdivide,
			(duration.divisor / $author$project$Music$Models$Time$divisor(time)) | 0,
			overlay.layout);
		return _Utils_update(
			overlay,
			{layout: l});
	});
var $author$project$TouchTunes$Models$Editor$commit = function (editor) {
	var theMeasure = $author$project$TouchTunes$Models$Editor$latent(editor);
	var overlay = editor.overlay;
	var newLayout = A2($author$project$Music$Models$Layout$forMeasure, overlay.layout.indirect, theMeasure);
	var dur = $author$project$TouchTunes$Models$Dial$value(editor.controls.subdivisionDial);
	return _Utils_update(
		editor,
		{
			measure: A2($elm$core$Debug$log, 'commit', theMeasure),
			overlay: A2(
				$author$project$TouchTunes$Models$Overlay$subdivide,
				dur,
				_Utils_update(
					overlay,
					{layout: newLayout}))
		});
};
var $author$project$TouchTunes$Models$Overlay$deselect = function (overlay) {
	return _Utils_update(
		overlay,
		{selection: $author$project$TouchTunes$Models$Overlay$NoSelection});
};
var $author$project$TouchTunes$Models$Overlay$NoteSelection = F3(
	function (a, b, c) {
		return {$: 'NoteSelection', a: a, b: b, c: c};
	});
var $author$project$Music$Models$Beat$durationFrom = F3(
	function (t, a, b) {
		return A2(
			$author$project$Music$Models$Duration$subtract,
			A2($author$project$Music$Models$Beat$toDuration, t, a),
			A2($author$project$Music$Models$Beat$toDuration, t, b));
	});
var $author$project$Music$Models$Beat$toFloat = function (b) {
	return b.full + ((!(!b.parts)) ? (b.parts / b.divisor) : 0);
};
var $author$project$Music$Models$Beat$equal = F2(
	function (a, b) {
		return _Utils_eq(
			$author$project$Music$Models$Beat$toFloat(a),
			$author$project$Music$Models$Beat$toFloat(b));
	});
var $author$project$Music$Models$Beat$add = F3(
	function (t, d, b) {
		return A2(
			$author$project$Music$Models$Beat$fromDuration,
			t,
			A2(
				$author$project$Music$Models$Duration$add,
				d,
				A2($author$project$Music$Models$Beat$toDuration, t, b)));
	});
var $mgold$elm_nonempty_list$List$Nonempty$length = function (_v0) {
	var x = _v0.a;
	var xs = _v0.b;
	return $elm$core$List$length(xs) + 1;
};
var $mgold$elm_nonempty_list$List$Nonempty$get = F2(
	function (i, ne) {
		var x = ne.a;
		var xs = ne.b;
		var j = A2(
			$elm$core$Basics$modBy,
			$mgold$elm_nonempty_list$List$Nonempty$length(ne),
			i);
		var find = F2(
			function (k, ys) {
				find:
				while (true) {
					if (!ys.b) {
						return x;
					} else {
						var z = ys.a;
						var zs = ys.b;
						if (!k) {
							return z;
						} else {
							var $temp$k = k - 1,
								$temp$ys = zs;
							k = $temp$k;
							ys = $temp$ys;
							continue find;
						}
					}
				}
			});
		return (!j) ? x : A2(find, j - 1, xs);
	});
var $author$project$Music$Models$Layout$locationAfter = F2(
	function (layout, loc) {
		var divisor = $author$project$Music$Models$Time$divisor(
			$author$project$Music$Models$Layout$time(layout)) * A2($mgold$elm_nonempty_list$List$Nonempty$get, loc.beat.full, layout.divisors);
		return {
			beat: A3(
				$author$project$Music$Models$Beat$add,
				$author$project$Music$Models$Layout$time(layout),
				$author$project$Music$Models$Duration$division(divisor),
				loc.beat),
			step: loc.step
		};
	});
var $author$project$Music$Models$Layout$beatSpacing = function (layout) {
	var t = $author$project$Music$Models$Layout$time(layout);
	var tenths = function () {
		var _v0 = t.beatType;
		switch (_v0.$) {
			case 'Two':
				return 80.0;
			case 'Four':
				return 40.0;
			default:
				return 30.0;
		}
	}();
	return A2(
		$author$project$Music$Models$Layout$toPixels,
		layout,
		$author$project$Music$Models$Layout$Tenths(tenths));
};
var $author$project$Music$Models$Layout$unscaleBeat = F2(
	function (layout, x) {
		var m = $author$project$Music$Models$Layout$margins(layout);
		var bs = $author$project$Music$Models$Layout$beatSpacing(layout);
		var scaled = (x.px - m.left.px) / bs.px;
		var divisor = A2(
			$mgold$elm_nonempty_list$List$Nonempty$get,
			$elm$core$Basics$floor(scaled),
			layout.divisors);
		var totalDivs = $elm$core$Basics$floor(scaled * divisor);
		return {
			divisor: divisor,
			full: (totalDivs / divisor) | 0,
			parts: A2($elm$core$Basics$modBy, divisor, totalDivs)
		};
	});
var $elm$core$Basics$round = _Basics_round;
var $author$project$Music$Models$Layout$unscaleStep = F2(
	function (layout, y) {
		var s = $author$project$Music$Models$Layout$spacing(layout);
		var m = $author$project$Music$Models$Layout$margins(layout);
		var n = $elm$core$Basics$round((2.0 * ((y.px - m.top.px) - (s.px / 2.0))) / s.px);
		return $author$project$Music$Models$Pitch$stepNumber(
			$author$project$Music$Models$Layout$basePitch(layout)) - n;
	});
var $author$project$Music$Models$Layout$positionToLocation = F2(
	function (layout, offset) {
		var y = $author$project$Music$Models$Layout$Pixels(offset.b);
		var x = $author$project$Music$Models$Layout$Pixels(offset.a);
		var step = A2($author$project$Music$Models$Layout$unscaleStep, layout, y);
		var beat = A2($author$project$Music$Models$Layout$unscaleBeat, layout, x);
		return {beat: beat, step: step};
	});
var $author$project$TouchTunes$Models$Overlay$positionToLocation = F2(
	function (pos, overlay) {
		return A2($author$project$Music$Models$Layout$positionToLocation, overlay.layout, pos);
	});
var $author$project$Music$Models$Pitch$stepFromNumber = function (n) {
	var steps = $elm$core$Array$fromList(
		_List_fromArray(
			[$author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$B]));
	var _v0 = A2(
		$elm$core$Array$get,
		A2($elm$core$Basics$modBy, 7, n),
		steps);
	if (_v0.$ === 'Just') {
		var step = _v0.a;
		return step;
	} else {
		return $author$project$Music$Models$Pitch$C;
	}
};
var $author$project$Music$Models$Key$stepNumberToPitch = F2(
	function (key, number) {
		var step = $author$project$Music$Models$Pitch$stepFromNumber(number);
		var octave = (number / 7) | 0;
		var alt = A2($author$project$Music$Models$Key$stepAlteredIn, key, step);
		return A3($author$project$Music$Models$Pitch$Pitch, step, alt, octave);
	});
var $author$project$TouchTunes$Models$Overlay$drag = F2(
	function (pos, overlay) {
		var _v0 = overlay.selection;
		switch (_v0.$) {
			case 'HarmonySelection':
				var harm = _v0.a;
				var key = _v0.b;
				var beat = _v0.c;
				return _Utils_update(
					overlay,
					{
						selection: A3($author$project$TouchTunes$Models$Overlay$HarmonySelection, harm, key, beat)
					});
			case 'NoteSelection':
				var note = _v0.a;
				var location = _v0.b;
				var dragging = _v0.c;
				if (dragging) {
					var loc = A2($author$project$TouchTunes$Models$Overlay$positionToLocation, pos, overlay);
					var layout = overlay.layout;
					var nextLoc = A2($author$project$Music$Models$Layout$locationAfter, layout, loc);
					var time = $author$project$Music$Models$Layout$time(layout);
					var key = $author$project$Music$Models$Layout$key(layout);
					var beat = location.beat;
					var modifier = function (n) {
						var dur = A3(
							$author$project$Music$Models$Beat$durationFrom,
							$author$project$Music$Models$Layout$time(layout),
							beat,
							nextLoc.beat);
						return A2($author$project$Music$Models$Beat$equal, beat, loc.beat) ? _Utils_update(
							n,
							{
								_do: $author$project$Music$Models$Note$Play(
									A2($author$project$Music$Models$Key$stepNumberToPitch, key, loc.step)),
								duration: dur
							}) : _Utils_update(
							n,
							{duration: dur});
					};
					return _Utils_update(
						overlay,
						{
							selection: A3(
								$author$project$TouchTunes$Models$Overlay$NoteSelection,
								modifier(note),
								location,
								dragging)
						});
				} else {
					return overlay;
				}
			default:
				return overlay;
		}
	});
var $author$project$TouchTunes$Models$Overlay$editHarmony = F3(
	function (pos, harmony, overlay) {
		var loc = A2($author$project$TouchTunes$Models$Overlay$positionToLocation, pos, overlay);
		var key = $author$project$Music$Models$Layout$key(overlay.layout);
		return _Utils_update(
			overlay,
			{
				selection: A3($author$project$TouchTunes$Models$Overlay$HarmonySelection, harmony, key, loc.beat)
			});
	});
var $author$project$TouchTunes$Models$Overlay$editNote = F3(
	function (pos, note, overlay) {
		var loc = A2($author$project$TouchTunes$Models$Overlay$positionToLocation, pos, overlay);
		return _Utils_update(
			overlay,
			{
				selection: A3($author$project$TouchTunes$Models$Overlay$NoteSelection, note, loc, true)
			});
	});
var $author$project$TouchTunes$Models$Overlay$findNote = F3(
	function (pos, measure, overlay) {
		var time = $author$project$Music$Models$Layout$time(overlay.layout);
		var loc = A2($author$project$TouchTunes$Models$Overlay$positionToLocation, pos, overlay);
		var offset = A2($author$project$Music$Models$Beat$toDuration, time, loc.beat);
		return A2($author$project$Music$Models$Measure$findNote, offset, measure);
	});
var $author$project$TouchTunes$Models$Overlay$finish = function (overlay) {
	return _Utils_update(
		overlay,
		{
			selection: function () {
				var _v0 = overlay.selection;
				switch (_v0.$) {
					case 'NoteSelection':
						var note = _v0.a;
						var location = _v0.b;
						var bool = _v0.c;
						return A3($author$project$TouchTunes$Models$Overlay$NoteSelection, note, location, false);
					case 'HarmonySelection':
						var harm = _v0.a;
						var key = _v0.b;
						var beat = _v0.c;
						return A3($author$project$TouchTunes$Models$Overlay$HarmonySelection, harm, key, beat);
					default:
						return $author$project$TouchTunes$Models$Overlay$NoSelection;
				}
			}()
		});
};
var $author$project$TouchTunes$Models$Editor$finish = function (editor) {
	return $author$project$TouchTunes$Models$Editor$commit(
		_Utils_update(
			editor,
			{
				overlay: $author$project$TouchTunes$Models$Overlay$finish(editor.overlay)
			}));
};
var $author$project$TouchTunes$Models$Overlay$reselect = F2(
	function (measure, overlay) {
		var time = $author$project$Music$Models$Layout$time(overlay.layout);
		var key = $author$project$Music$Models$Layout$key(overlay.layout);
		var _v0 = overlay.selection;
		if (_v0.$ === 'HarmonySelection') {
			var beat = _v0.c;
			var offset = A2($author$project$Music$Models$Beat$toDuration, time, beat);
			var mNote = A2($author$project$Music$Models$Measure$findNote, offset, measure);
			var mHarm = A2(
				$elm$core$Maybe$andThen,
				function ($) {
					return $.harmony;
				},
				mNote);
			if (mHarm.$ === 'Just') {
				var h = mHarm.a;
				return _Utils_update(
					overlay,
					{
						selection: A3($author$project$TouchTunes$Models$Overlay$HarmonySelection, h, key, beat)
					});
			} else {
				return overlay;
			}
		} else {
			return overlay;
		}
	});
var $author$project$TouchTunes$Models$Overlay$startHarmony = F2(
	function (pos, overlay) {
		var key = $author$project$Music$Models$Layout$key(overlay.layout);
		var harmony = A2(
			$author$project$Music$Models$Harmony$chord,
			$author$project$Music$Models$Harmony$Major($author$project$Music$Models$Harmony$Triad),
			$author$project$Music$Models$Key$tonic(key));
		return A3($author$project$TouchTunes$Models$Overlay$editHarmony, pos, harmony, overlay);
	});
var $author$project$Music$Models$Layout$locationDuration = F2(
	function (layout, loc) {
		var divisor = $author$project$Music$Models$Time$divisor(
			$author$project$Music$Models$Layout$time(layout)) * A2($mgold$elm_nonempty_list$List$Nonempty$get, loc.beat.full, layout.divisors);
		return $author$project$Music$Models$Duration$division(divisor);
	});
var $author$project$TouchTunes$Models$Overlay$startNote = F2(
	function (pos, overlay) {
		var loc = A2($author$project$TouchTunes$Models$Overlay$positionToLocation, pos, overlay);
		var key = $author$project$Music$Models$Layout$key(overlay.layout);
		var pitch = A2($author$project$Music$Models$Key$stepNumberToPitch, key, loc.step);
		var duration = A2($author$project$Music$Models$Layout$locationDuration, overlay.layout, loc);
		var note = A4(
			$author$project$Music$Models$Note$Note,
			$author$project$Music$Models$Note$Play(pitch),
			duration,
			_List_Nil,
			$elm$core$Maybe$Nothing);
		return A3($author$project$TouchTunes$Models$Overlay$editNote, pos, note, overlay);
	});
var $elm_community$list_extra$List$Extra$findIndexHelp = F3(
	function (index, predicate, list) {
		findIndexHelp:
		while (true) {
			if (!list.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				var x = list.a;
				var xs = list.b;
				if (predicate(x)) {
					return $elm$core$Maybe$Just(index);
				} else {
					var $temp$index = index + 1,
						$temp$predicate = predicate,
						$temp$list = xs;
					index = $temp$index;
					predicate = $temp$predicate;
					list = $temp$list;
					continue findIndexHelp;
				}
			}
		}
	});
var $elm_community$list_extra$List$Extra$findIndex = $elm_community$list_extra$List$Extra$findIndexHelp(0);
var $elm_community$maybe_extra$Maybe$Extra$join = function (mx) {
	if (mx.$ === 'Just') {
		var x = mx.a;
		return x;
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$TouchTunes$Models$Dial$transientValue = function (dial) {
	return A2(
		$elm$core$Maybe$withDefault,
		dial.value,
		$elm_community$maybe_extra$Maybe$Extra$join(
			A2(
				$elm$core$Maybe$map,
				function (t) {
					return A2($elm$core$Array$get, t.index, dial.config.options);
				},
				dial.tracking)));
};
var $author$project$TouchTunes$Models$Dial$update = F2(
	function (dialAction, dial) {
		var i0 = function () {
			var _v1 = dial.tracking;
			if (_v1.$ === 'Just') {
				var theTrack = _v1.a;
				return theTrack.originalIndex;
			} else {
				return A2(
					$elm$core$Maybe$withDefault,
					0,
					A2(
						$elm_community$list_extra$List$Extra$findIndex,
						$elm$core$Basics$eq(dial.value),
						$elm$core$Array$toList(dial.config.options)));
			}
		}();
		switch (dialAction.$) {
			case 'Start':
				return _Utils_update(
					dial,
					{
						tracking: $elm$core$Maybe$Just(
							{index: i0, originalIndex: i0})
					});
			case 'Set':
				var i = dialAction.a;
				return _Utils_update(
					dial,
					{
						tracking: $elm$core$Maybe$Just(
							{index: i, originalIndex: i0})
					});
			case 'Cancel':
				return _Utils_update(
					dial,
					{tracking: $elm$core$Maybe$Nothing});
			default:
				return _Utils_update(
					dial,
					{
						tracking: $elm$core$Maybe$Nothing,
						value: $author$project$TouchTunes$Models$Dial$transientValue(dial)
					});
		}
	});
var $author$project$Music$Models$Harmony$chordDegree = function (harmony) {
	var _v0 = harmony.kind;
	switch (_v0.$) {
		case 'Major':
			var ch = _v0.a;
			return ch;
		case 'Minor':
			var ch = _v0.a;
			return ch;
		case 'Diminished':
			var ch = _v0.a;
			return ch;
		case 'Augmented':
			var ch = _v0.a;
			return ch;
		case 'Dominant':
			var ch = _v0.a;
			return ch;
		case 'HalfDiminished':
			return $author$project$Music$Models$Harmony$Seventh;
		case 'MajorMinor':
			return $author$project$Music$Models$Harmony$Seventh;
		default:
			return $author$project$Music$Models$Harmony$Triad;
	}
};
var $author$project$Music$Models$Note$pitch = function (note) {
	var _v0 = note._do;
	if (_v0.$ === 'Play') {
		var p = _v0.a;
		return $elm$core$Maybe$Just(p);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$TouchTunes$Models$Controls$forSelection = F2(
	function (selection, controls) {
		switch (selection.$) {
			case 'NoSelection':
				return controls;
			case 'HarmonySelection':
				var harmony = selection.a;
				var key = selection.b;
				var deg = $author$project$Music$Models$Harmony$chordDegree(harmony);
				var hd = A3(
					$author$project$TouchTunes$Models$Controls$initHarmonyDial,
					key,
					deg,
					$elm$core$Maybe$Just(
						A2($elm$core$Debug$log, 'harmony for selection ', harmony)));
				var h = hd.value;
				return _Utils_update(
					controls,
					{
						altHarmonyDial: $author$project$TouchTunes$Models$Controls$initAltHarmonyDial(
							$elm$core$Maybe$Just(h.alter)),
						bassDial: A2(
							$author$project$TouchTunes$Models$Controls$initBassDial,
							key,
							$elm$core$Maybe$Just(
								A2($elm$core$Maybe$withDefault, h.root, h.bass))),
						chordDial: $author$project$TouchTunes$Models$Controls$initChordDial(
							$elm$core$Maybe$Just(
								$author$project$Music$Models$Harmony$chordDegree(h))),
						harmonyDial: hd,
						kindDial: $author$project$TouchTunes$Models$Controls$initKindDial(
							$elm$core$Maybe$Just(h.kind))
					});
			default:
				var note = selection.a;
				var _v1 = $author$project$Music$Models$Note$pitch(note);
				if (_v1.$ === 'Just') {
					var p = _v1.a;
					return A2(
						$elm$core$Maybe$withDefault,
						controls,
						A2(
							$elm$core$Maybe$map,
							function (chr) {
								return _Utils_update(
									controls,
									{
										alterationDial: $author$project$TouchTunes$Models$Controls$initAlterationDial(chr)
									});
							},
							$author$project$Music$Models$Pitch$chromatic(p.alter)));
				} else {
					return controls;
				}
		}
	});
var $author$project$TouchTunes$Models$Editor$withOverlay = F2(
	function (overlay, editor) {
		var controls = A2($author$project$TouchTunes$Models$Controls$forSelection, overlay.selection, editor.controls);
		return _Utils_update(
			editor,
			{controls: controls, overlay: overlay});
	});
var $author$project$TouchTunes$Actions$Update$update = F2(
	function (msg, editor) {
		var controls = editor.controls;
		var subdivisions = $author$project$TouchTunes$Models$Dial$value(controls.subdivisionDial);
		var overlay = A2($author$project$TouchTunes$Models$Overlay$subdivide, subdivisions, editor.overlay);
		var _v0 = A2($elm$core$Debug$log, 'Editor got msg', msg);
		switch (_v0.$) {
			case 'StartEdit':
				var attributes = _v0.c;
				var measure = _v0.d;
				return A2($author$project$TouchTunes$Models$Editor$open, attributes, measure);
			case 'NoteEdit':
				var pos = _v0.a;
				var mNote = A3($author$project$TouchTunes$Models$Overlay$findNote, pos, editor.measure, editor.overlay);
				var overnote = function () {
					if (mNote.$ === 'Just') {
						var note = mNote.a;
						return A3($author$project$TouchTunes$Models$Overlay$editNote, pos, note, editor.overlay);
					} else {
						return A2($author$project$TouchTunes$Models$Overlay$startNote, pos, editor.overlay);
					}
				}();
				return A2($author$project$TouchTunes$Models$Editor$withOverlay, overnote, editor);
			case 'HarmonyEdit':
				var pos = _v0.a;
				var mNote = A3($author$project$TouchTunes$Models$Overlay$findNote, pos, editor.measure, editor.overlay);
				var mHarmony = A2(
					$elm$core$Maybe$andThen,
					function ($) {
						return $.harmony;
					},
					mNote);
				var overharm = function () {
					if (mHarmony.$ === 'Just') {
						var harmony = mHarmony.a;
						return A3($author$project$TouchTunes$Models$Overlay$editHarmony, pos, harmony, editor.overlay);
					} else {
						return A2($author$project$TouchTunes$Models$Overlay$startHarmony, pos, editor.overlay);
					}
				}();
				return A2($author$project$TouchTunes$Models$Editor$withOverlay, overharm, editor);
			case 'DragEdit':
				var pos = _v0.a;
				var overnote = A2($author$project$TouchTunes$Models$Overlay$drag, pos, editor.overlay);
				return A2($author$project$TouchTunes$Models$Editor$withOverlay, overnote, editor);
			case 'FinishEdit':
				return $author$project$TouchTunes$Models$Editor$finish(editor);
			case 'SaveEdit':
				return $author$project$TouchTunes$Models$Editor$commit(editor);
			case 'DoneEdit':
				return $author$project$TouchTunes$Models$Editor$commit(editor);
			case 'NextEdit':
				return $author$project$TouchTunes$Models$Editor$commit(editor);
			case 'PreviousEdit':
				return $author$project$TouchTunes$Models$Editor$commit(editor);
			case 'CancelEdit':
				return _Utils_update(
					editor,
					{
						overlay: $author$project$TouchTunes$Models$Overlay$deselect(editor.overlay)
					});
			case 'SubdivisionMsg':
				var dialAction = _v0.a;
				return $author$project$TouchTunes$Models$Editor$commit(
					_Utils_update(
						editor,
						{
							controls: _Utils_update(
								controls,
								{
									subdivisionDial: A2($author$project$TouchTunes$Models$Dial$update, dialAction, controls.subdivisionDial)
								})
						}));
			case 'AlterationMsg':
				var dialAction = _v0.a;
				return _Utils_update(
					editor,
					{
						controls: _Utils_update(
							controls,
							{
								alterationDial: A2($author$project$TouchTunes$Models$Dial$update, dialAction, controls.alterationDial)
							})
					});
			case 'TimeMsg':
				var dialAction = _v0.a;
				return $author$project$TouchTunes$Models$Editor$commit(
					_Utils_update(
						editor,
						{
							controls: _Utils_update(
								controls,
								{
									timeDial: A2($author$project$TouchTunes$Models$Dial$update, dialAction, controls.timeDial)
								})
						}));
			case 'KeyMsg':
				var dialAction = _v0.a;
				return $author$project$TouchTunes$Models$Editor$commit(
					_Utils_update(
						editor,
						{
							controls: _Utils_update(
								controls,
								{
									keyDial: A2($author$project$TouchTunes$Models$Dial$update, dialAction, controls.keyDial)
								})
						}));
			case 'HarmonyMsg':
				var dialAction = _v0.a;
				var hd = A2($author$project$TouchTunes$Models$Dial$update, dialAction, controls.harmonyDial);
				var ed = _Utils_update(
					editor,
					{
						controls: _Utils_update(
							controls,
							{harmonyDial: hd})
					});
				if (dialAction.$ === 'Finish') {
					return A2(
						$author$project$TouchTunes$Models$Editor$withOverlay,
						A2($author$project$TouchTunes$Models$Overlay$changeHarmony, hd.value, ed.overlay),
						$author$project$TouchTunes$Models$Editor$commit(ed));
				} else {
					return ed;
				}
			case 'KindMsg':
				var dialAction = _v0.a;
				var kd = A2($author$project$TouchTunes$Models$Dial$update, dialAction, controls.kindDial);
				var ed = _Utils_update(
					editor,
					{
						controls: _Utils_update(
							controls,
							{kindDial: kd})
					});
				var m = $author$project$TouchTunes$Models$Editor$latent(ed);
				if (dialAction.$ === 'Finish') {
					return A2(
						$author$project$TouchTunes$Models$Editor$withOverlay,
						A2($author$project$TouchTunes$Models$Overlay$reselect, m, overlay),
						$author$project$TouchTunes$Models$Editor$commit(ed));
				} else {
					return ed;
				}
			case 'DegreeMsg':
				var dialAction = _v0.a;
				var cd = A2($author$project$TouchTunes$Models$Dial$update, dialAction, controls.chordDial);
				var ed = _Utils_update(
					editor,
					{
						controls: _Utils_update(
							controls,
							{chordDial: cd})
					});
				var m = $author$project$TouchTunes$Models$Editor$latent(ed);
				if (dialAction.$ === 'Finish') {
					return A2(
						$author$project$TouchTunes$Models$Editor$withOverlay,
						A2($author$project$TouchTunes$Models$Overlay$reselect, m, overlay),
						$author$project$TouchTunes$Models$Editor$commit(ed));
				} else {
					return ed;
				}
			case 'AltHarmonyMsg':
				var dialAction = _v0.a;
				var ad = A2($author$project$TouchTunes$Models$Dial$update, dialAction, controls.altHarmonyDial);
				var ed = _Utils_update(
					editor,
					{
						controls: _Utils_update(
							controls,
							{altHarmonyDial: ad})
					});
				var m = $author$project$TouchTunes$Models$Editor$latent(ed);
				if (dialAction.$ === 'Finish') {
					return A2(
						$author$project$TouchTunes$Models$Editor$withOverlay,
						A2($author$project$TouchTunes$Models$Overlay$reselect, m, overlay),
						$author$project$TouchTunes$Models$Editor$commit(ed));
				} else {
					return ed;
				}
			default:
				var dialAction = _v0.a;
				var bd = A2($author$project$TouchTunes$Models$Dial$update, dialAction, controls.bassDial);
				var ed = _Utils_update(
					editor,
					{
						controls: _Utils_update(
							controls,
							{bassDial: bd})
					});
				var m = $author$project$TouchTunes$Models$Editor$latent(ed);
				if (dialAction.$ === 'Finish') {
					return A2(
						$author$project$TouchTunes$Models$Editor$withOverlay,
						A2($author$project$TouchTunes$Models$Overlay$reselect, m, overlay),
						$author$project$TouchTunes$Models$Editor$commit(ed));
				} else {
					return ed;
				}
		}
	});
var $author$project$TouchTunes$Models$App$update = F2(
	function (msg, app) {
		var _v0 = app.editing;
		if (_v0.$ === 'Just') {
			var e = _v0.a;
			var updatedApp = _Utils_update(
				app,
				{
					editing: $elm$core$Maybe$Just(
						_Utils_update(
							e,
							{
								editor: A2($author$project$TouchTunes$Actions$Update$update, msg, e.editor)
							}))
				});
			var save = function (a) {
				return _Utils_update(
					a,
					{
						score: A3($author$project$Music$Models$Score$setMeasure, e.measureNum, e.editor.measure, app.score)
					});
			};
			var _v1 = A2($elm$core$Debug$log, 'App got msg', msg);
			switch (_v1.$) {
				case 'CancelEdit':
					return $author$project$TouchTunes$Models$App$close(updatedApp);
				case 'SaveEdit':
					return save(updatedApp);
				case 'NextEdit':
					return A3(
						$author$project$TouchTunes$Models$App$open,
						e.partId,
						e.measureNum + 1,
						save(updatedApp));
				case 'PreviousEdit':
					return A3(
						$author$project$TouchTunes$Models$App$open,
						e.partId,
						e.measureNum - 1,
						save(updatedApp));
				case 'DoneEdit':
					return $author$project$TouchTunes$Models$App$close(
						save(updatedApp));
				default:
					return updatedApp;
			}
		} else {
			var _v2 = A2($elm$core$Debug$log, 'App got msg', msg);
			if (_v2.$ === 'StartEdit') {
				var id = _v2.a;
				var mnum = _v2.b;
				return A3($author$project$TouchTunes$Models$App$open, id, mnum, app);
			} else {
				return app;
			}
		}
	});
var $author$project$Main$update = F2(
	function (msg, model) {
		if (msg.$ === 'Open') {
			var score = msg.a;
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{
						app: $author$project$TouchTunes$Models$App$init(score)
					}),
				$elm$core$Platform$Cmd$none);
		} else {
			var appmsg = msg.a;
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{
						app: A2($author$project$TouchTunes$Models$App$update, appmsg, model.app)
					}),
				$elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Main$AppMessage = function (a) {
	return {$: 'AppMessage', a: a};
};
var $author$project$Main$Open = function (a) {
	return {$: 'Open', a: a};
};
var $elm$html$Html$button = _VirtualDom_node('button');
var $author$project$TouchTunes$Views$AppStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./TouchTunes/Views/css/app.css',
	{app: 'app', body: 'body', footer: 'footer', fullscreen: 'fullscreen'}).toString;
var $elm$html$Html$footer = _VirtualDom_node('footer');
var $elm$virtual_dom$VirtualDom$map = _VirtualDom_map;
var $elm$html$Html$map = $elm$virtual_dom$VirtualDom$map;
var $elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 'Normal', a: a};
};
var $elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var $elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var $elm$html$Html$Events$onClick = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'click',
		$elm$json$Json$Decode$succeed(msg));
};
var $author$project$Music$Models$Measure$Attributes = F3(
	function (staff, time, key) {
		return {key: key, staff: staff, time: time};
	});
var $author$project$Music$Models$Key$Minor = {$: 'Minor'};
var $author$project$Music$Models$Harmony$dominant = function (c) {
	return $author$project$Music$Models$Harmony$chord(
		$author$project$Music$Models$Harmony$Dominant(c));
};
var $author$project$Music$Models$Note$harmonize = F2(
	function (harmony, note) {
		return _Utils_update(
			note,
			{
				harmony: $elm$core$Maybe$Just(harmony)
			});
	});
var $author$project$Music$Models$Harmony$withAlteration = F2(
	function (alt, harmony) {
		return _Utils_update(
			harmony,
			{
				alter: A2(
					$elm$core$List$append,
					harmony.alter,
					_List_fromArray(
						[alt]))
			});
	});
var $author$project$Music$Models$Harmony$lowered = F2(
	function (_int, harmony) {
		return A2(
			$author$project$Music$Models$Harmony$withAlteration,
			$author$project$Music$Models$Harmony$Lowered(_int),
			harmony);
	});
var $author$project$Music$Models$Harmony$major = function (c) {
	return $author$project$Music$Models$Harmony$chord(
		$author$project$Music$Models$Harmony$Major(c));
};
var $author$project$Music$Models$Harmony$minor = function (c) {
	return $author$project$Music$Models$Harmony$chord(
		$author$project$Music$Models$Harmony$Minor(c));
};
var $author$project$Music$Models$Note$playFor = F2(
	function (d, p) {
		return A4(
			$author$project$Music$Models$Note$Note,
			$author$project$Music$Models$Note$Play(p),
			d,
			_List_Nil,
			$elm$core$Maybe$Nothing);
	});
var $author$project$AutumnLeaves$score = A3(
	$author$project$Music$Models$Score$Score,
	'Autumn Leaves',
	_List_fromArray(
		[
			A2($author$project$Music$Models$Part$part, 'Piano', 'Pno.')
		]),
	$elm$core$Array$fromList(
		_List_fromArray(
			[
				A2(
				$author$project$Music$Models$Measure$fromNotes,
				A3(
					$author$project$Music$Models$Measure$Attributes,
					$elm$core$Maybe$Just($author$project$Music$Models$Staff$treble),
					$elm$core$Maybe$Just($author$project$Music$Models$Time$cut),
					$elm$core$Maybe$Just(
						A2($author$project$Music$Models$Key$keyOf, $author$project$Music$Models$Key$E, $author$project$Music$Models$Key$Minor))),
				_List_fromArray(
					[
						$author$project$Music$Models$Note$restFor($author$project$Music$Models$Duration$half),
						A2(
						$author$project$Music$Models$Note$harmonize,
						A2(
							$author$project$Music$Models$Harmony$dominant,
							$author$project$Music$Models$Harmony$Seventh,
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$Natural)),
						$author$project$Music$Models$Note$restFor($author$project$Music$Models$Duration$eighth)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$e_(4)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$f, 4)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$g(4))
					])),
				A2(
				$author$project$Music$Models$Measure$fromNotes,
				$author$project$Music$Models$Measure$noAttributes,
				_List_fromArray(
					[
						A2(
						$author$project$Music$Models$Note$harmonize,
						A2(
							$author$project$Music$Models$Harmony$minor,
							$author$project$Music$Models$Harmony$Seventh,
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$A, $author$project$Music$Models$Pitch$Natural)),
						A2(
							$author$project$Music$Models$Note$playFor,
							$author$project$Music$Models$Duration$half,
							$author$project$Music$Models$Pitch$c(5))),
						A2(
						$author$project$Music$Models$Note$harmonize,
						A2(
							$author$project$Music$Models$Harmony$dominant,
							$author$project$Music$Models$Harmony$Seventh,
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$D, $author$project$Music$Models$Pitch$Natural)),
						$author$project$Music$Models$Note$restFor($author$project$Music$Models$Duration$eighth)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$d(4)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$e_(4)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$f, 4))
					])),
				A2(
				$author$project$Music$Models$Measure$fromNotes,
				$author$project$Music$Models$Measure$noAttributes,
				_List_fromArray(
					[
						A2(
						$author$project$Music$Models$Note$harmonize,
						A2(
							$author$project$Music$Models$Harmony$major,
							$author$project$Music$Models$Harmony$Seventh,
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$G, $author$project$Music$Models$Pitch$Natural)),
						A2(
							$author$project$Music$Models$Note$playFor,
							$author$project$Music$Models$Duration$quarter,
							$author$project$Music$Models$Pitch$b(4))),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$quarter,
						$author$project$Music$Models$Pitch$b(4)),
						A2(
						$author$project$Music$Models$Note$harmonize,
						A2(
							$author$project$Music$Models$Harmony$major,
							$author$project$Music$Models$Harmony$Seventh,
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$C, $author$project$Music$Models$Pitch$Natural)),
						$author$project$Music$Models$Note$restFor($author$project$Music$Models$Duration$eighth)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$c(4)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$d(4)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$e_(4))
					])),
				A2(
				$author$project$Music$Models$Measure$fromNotes,
				$author$project$Music$Models$Measure$noAttributes,
				_List_fromArray(
					[
						A2(
						$author$project$Music$Models$Note$harmonize,
						A2(
							$author$project$Music$Models$Harmony$lowered,
							5,
							A2(
								$author$project$Music$Models$Harmony$minor,
								$author$project$Music$Models$Harmony$Seventh,
								A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$F, $author$project$Music$Models$Pitch$Sharp))),
						A2(
							$author$project$Music$Models$Note$playFor,
							$author$project$Music$Models$Duration$half,
							$author$project$Music$Models$Pitch$a(4))),
						A2(
						$author$project$Music$Models$Note$harmonize,
						A2(
							$author$project$Music$Models$Harmony$dominant,
							$author$project$Music$Models$Harmony$Ninth,
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$B, $author$project$Music$Models$Pitch$Natural)),
						$author$project$Music$Models$Note$restFor($author$project$Music$Models$Duration$eighth)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$b(3)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$c, 4)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$d, 4))
					])),
				A2(
				$author$project$Music$Models$Measure$fromNotes,
				$author$project$Music$Models$Measure$noAttributes,
				_List_fromArray(
					[
						A2(
						$author$project$Music$Models$Note$harmonize,
						A2(
							$author$project$Music$Models$Harmony$minor,
							$author$project$Music$Models$Harmony$Seventh,
							A2($author$project$Music$Models$Pitch$root, $author$project$Music$Models$Pitch$E, $author$project$Music$Models$Pitch$Natural)),
						A2(
							$author$project$Music$Models$Note$playFor,
							$author$project$Music$Models$Duration$half,
							$author$project$Music$Models$Pitch$g(4))),
						$author$project$Music$Models$Note$restFor($author$project$Music$Models$Duration$eighth),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$e_(4)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						A2($author$project$Music$Models$Pitch$sharp, $author$project$Music$Models$Pitch$f, 4)),
						A2(
						$author$project$Music$Models$Note$playFor,
						$author$project$Music$Models$Duration$eighth,
						$author$project$Music$Models$Pitch$g(4))
					]))
			])));
var $elm$html$Html$section = _VirtualDom_node('section');
var $author$project$TouchTunes$Models$Sheet$Sheet = function (score) {
	return {score: score};
};
var $elm$html$Html$article = _VirtualDom_node('article');
var $author$project$TouchTunes$Views$EditorStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./TouchTunes/Views/css/editor.css',
	{controls: 'controls', editor: 'editor', frame: 'frame', harmonyarea: 'harmonyarea', margins: 'margins', navigation: 'navigation', notearea: 'notearea', overflow: 'overflow', overlay: 'overlay', pitchLevel: 'pitchLevel', ruler: 'ruler', selection: 'selection', underharmony: 'underharmony', understaff: 'understaff'}).toString;
var $author$project$TouchTunes$Actions$Top$AltHarmonyMsg = function (a) {
	return {$: 'AltHarmonyMsg', a: a};
};
var $author$project$TouchTunes$Actions$Top$AlterationMsg = function (a) {
	return {$: 'AlterationMsg', a: a};
};
var $author$project$TouchTunes$Actions$Top$BassMsg = function (a) {
	return {$: 'BassMsg', a: a};
};
var $author$project$TouchTunes$Actions$Top$DegreeMsg = function (a) {
	return {$: 'DegreeMsg', a: a};
};
var $author$project$TouchTunes$Actions$Top$HarmonyMsg = function (a) {
	return {$: 'HarmonyMsg', a: a};
};
var $author$project$TouchTunes$Actions$Top$KeyMsg = function (a) {
	return {$: 'KeyMsg', a: a};
};
var $author$project$TouchTunes$Actions$Top$KindMsg = function (a) {
	return {$: 'KindMsg', a: a};
};
var $author$project$TouchTunes$Actions$Top$SubdivisionMsg = function (a) {
	return {$: 'SubdivisionMsg', a: a};
};
var $author$project$TouchTunes$Actions$Top$TimeMsg = function (a) {
	return {$: 'TimeMsg', a: a};
};
var $elm$html$Html$li = _VirtualDom_node('li');
var $elm$html$Html$ul = _VirtualDom_node('ul');
var $author$project$TouchTunes$Models$Dial$Finish = {$: 'Finish'};
var $author$project$TouchTunes$Models$Dial$Set = function (a) {
	return {$: 'Set', a: a};
};
var $author$project$TouchTunes$Models$Dial$Start = {$: 'Start'};
var $author$project$TouchTunes$Views$DialView$collarRadius = 100.0;
var $elm$core$Basics$cos = _Basics_cos;
var $author$project$TouchTunes$Views$DialStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./TouchTunes/Views/css/dial.css',
	{active: 'active', collar: 'collar', dial: 'dial', face: 'face', option: 'option', value: 'value', viewValue: 'viewValue'}).toString;
var $elm$core$Basics$pi = _Basics_pi;
var $elm$core$Basics$degrees = function (angleInDegrees) {
	return (angleInDegrees * $elm$core$Basics$pi) / 180;
};
var $author$project$TouchTunes$Views$DialView$dialRadius = 50.0;
var $elm$core$Array$length = function (_v0) {
	var len = _v0.a;
	return len;
};
var $elm_community$array_extra$Array$Extra$indexedMapToList = F2(
	function (f, xs) {
		return A3(
			$elm$core$Array$foldr,
			F2(
				function (x, _v0) {
					var i = _v0.a;
					var ys = _v0.b;
					return _Utils_Tuple2(
						i - 1,
						A2(
							$elm$core$List$cons,
							A2(f, i, x),
							ys));
				}),
			_Utils_Tuple2(
				$elm$core$Array$length(xs) - 1,
				_List_Nil),
			xs).b;
	});
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$defaultOptions = {preventDefault: true, stopPropagation: false};
var $elm$virtual_dom$VirtualDom$Custom = function (a) {
	return {$: 'Custom', a: a};
};
var $elm$html$Html$Events$custom = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$Custom(decoder));
	});
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$Event = F5(
	function (pointerType, pointer, pointerId, isPrimary, contactDetails) {
		return {contactDetails: contactDetails, isPrimary: isPrimary, pointer: pointer, pointerId: pointerId, pointerType: pointerType};
	});
var $elm$json$Json$Decode$bool = _Json_decodeBool;
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$ContactDetails = F5(
	function (width, height, pressure, tiltX, tiltY) {
		return {height: height, pressure: pressure, tiltX: tiltX, tiltY: tiltY, width: width};
	});
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$json$Json$Decode$float = _Json_decodeFloat;
var $elm$json$Json$Decode$map5 = _Json_map5;
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$contactDetailsDecoder = A6(
	$elm$json$Json$Decode$map5,
	$mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$ContactDetails,
	A2($elm$json$Json$Decode$field, 'width', $elm$json$Json$Decode$float),
	A2($elm$json$Json$Decode$field, 'height', $elm$json$Json$Decode$float),
	A2($elm$json$Json$Decode$field, 'pressure', $elm$json$Json$Decode$float),
	A2($elm$json$Json$Decode$field, 'tiltX', $elm$json$Json$Decode$float),
	A2($elm$json$Json$Decode$field, 'tiltY', $elm$json$Json$Decode$float));
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$Event = F6(
	function (keys, button, clientPos, offsetPos, pagePos, screenPos) {
		return {button: button, clientPos: clientPos, keys: keys, offsetPos: offsetPos, pagePos: pagePos, screenPos: screenPos};
	});
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$BackButton = {$: 'BackButton'};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$ErrorButton = {$: 'ErrorButton'};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$ForwardButton = {$: 'ForwardButton'};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$MainButton = {$: 'MainButton'};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$MiddleButton = {$: 'MiddleButton'};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$SecondButton = {$: 'SecondButton'};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$buttonFromId = function (id) {
	switch (id) {
		case 0:
			return $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$MainButton;
		case 1:
			return $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$MiddleButton;
		case 2:
			return $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$SecondButton;
		case 3:
			return $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$BackButton;
		case 4:
			return $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$ForwardButton;
		default:
			return $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$ErrorButton;
	}
};
var $elm$json$Json$Decode$int = _Json_decodeInt;
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$buttonDecoder = A2(
	$elm$json$Json$Decode$map,
	$mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$buttonFromId,
	A2($elm$json$Json$Decode$field, 'button', $elm$json$Json$Decode$int));
var $mpizenberg$elm_pointer_events$Internal$Decode$clientPos = A3(
	$elm$json$Json$Decode$map2,
	F2(
		function (a, b) {
			return _Utils_Tuple2(a, b);
		}),
	A2($elm$json$Json$Decode$field, 'clientX', $elm$json$Json$Decode$float),
	A2($elm$json$Json$Decode$field, 'clientY', $elm$json$Json$Decode$float));
var $mpizenberg$elm_pointer_events$Internal$Decode$Keys = F3(
	function (alt, ctrl, shift) {
		return {alt: alt, ctrl: ctrl, shift: shift};
	});
var $elm$json$Json$Decode$map3 = _Json_map3;
var $mpizenberg$elm_pointer_events$Internal$Decode$keys = A4(
	$elm$json$Json$Decode$map3,
	$mpizenberg$elm_pointer_events$Internal$Decode$Keys,
	A2($elm$json$Json$Decode$field, 'altKey', $elm$json$Json$Decode$bool),
	A2($elm$json$Json$Decode$field, 'ctrlKey', $elm$json$Json$Decode$bool),
	A2($elm$json$Json$Decode$field, 'shiftKey', $elm$json$Json$Decode$bool));
var $elm$json$Json$Decode$map6 = _Json_map6;
var $mpizenberg$elm_pointer_events$Internal$Decode$offsetPos = A3(
	$elm$json$Json$Decode$map2,
	F2(
		function (a, b) {
			return _Utils_Tuple2(a, b);
		}),
	A2($elm$json$Json$Decode$field, 'offsetX', $elm$json$Json$Decode$float),
	A2($elm$json$Json$Decode$field, 'offsetY', $elm$json$Json$Decode$float));
var $mpizenberg$elm_pointer_events$Internal$Decode$pagePos = A3(
	$elm$json$Json$Decode$map2,
	F2(
		function (a, b) {
			return _Utils_Tuple2(a, b);
		}),
	A2($elm$json$Json$Decode$field, 'pageX', $elm$json$Json$Decode$float),
	A2($elm$json$Json$Decode$field, 'pageY', $elm$json$Json$Decode$float));
var $mpizenberg$elm_pointer_events$Internal$Decode$screenPos = A3(
	$elm$json$Json$Decode$map2,
	F2(
		function (a, b) {
			return _Utils_Tuple2(a, b);
		}),
	A2($elm$json$Json$Decode$field, 'screenX', $elm$json$Json$Decode$float),
	A2($elm$json$Json$Decode$field, 'screenY', $elm$json$Json$Decode$float));
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$eventDecoder = A7($elm$json$Json$Decode$map6, $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$Event, $mpizenberg$elm_pointer_events$Internal$Decode$keys, $mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$buttonDecoder, $mpizenberg$elm_pointer_events$Internal$Decode$clientPos, $mpizenberg$elm_pointer_events$Internal$Decode$offsetPos, $mpizenberg$elm_pointer_events$Internal$Decode$pagePos, $mpizenberg$elm_pointer_events$Internal$Decode$screenPos);
var $elm$json$Json$Decode$string = _Json_decodeString;
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$MouseType = {$: 'MouseType'};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$PenType = {$: 'PenType'};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$TouchType = {$: 'TouchType'};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$stringToPointerType = function (str) {
	switch (str) {
		case 'pen':
			return $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$PenType;
		case 'touch':
			return $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$TouchType;
		default:
			return $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$MouseType;
	}
};
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$pointerTypeDecoder = A2($elm$json$Json$Decode$map, $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$stringToPointerType, $elm$json$Json$Decode$string);
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$eventDecoder = A6(
	$elm$json$Json$Decode$map5,
	$mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$Event,
	A2($elm$json$Json$Decode$field, 'pointerType', $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$pointerTypeDecoder),
	$mpizenberg$elm_pointer_events$Html$Events$Extra$Mouse$eventDecoder,
	A2($elm$json$Json$Decode$field, 'pointerId', $elm$json$Json$Decode$int),
	A2($elm$json$Json$Decode$field, 'isPrimary', $elm$json$Json$Decode$bool),
	$mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$contactDetailsDecoder);
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onWithOptions = F3(
	function (event, options, tag) {
		return A2(
			$elm$html$Html$Events$custom,
			event,
			A2(
				$elm$json$Json$Decode$map,
				function (ev) {
					return {
						message: tag(ev),
						preventDefault: options.preventDefault,
						stopPropagation: options.stopPropagation
					};
				},
				$mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$eventDecoder));
	});
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onDown = A2($mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onWithOptions, 'pointerdown', $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$defaultOptions);
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onEnter = A2($mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onWithOptions, 'pointerenter', $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$defaultOptions);
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onUp = A2($mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onWithOptions, 'pointerup', $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$defaultOptions);
var $elm$core$Basics$sin = _Basics_sin;
var $elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var $elm$html$Html$Attributes$style = $elm$virtual_dom$VirtualDom$style;
var $author$project$TouchTunes$Views$DialView$view = F2(
	function (dial, toMsg) {
		var theValue = $author$project$TouchTunes$Models$Dial$transientValue(dial);
		var r = ($author$project$TouchTunes$Views$DialView$dialRadius / 2.0) + ($author$project$TouchTunes$Views$DialView$collarRadius / 2.0);
		var cy = $author$project$TouchTunes$Views$DialView$collarRadius;
		var cx = $author$project$TouchTunes$Views$DialView$collarRadius;
		var _v0 = dial;
		var config = _v0.config;
		var tracking = _v0.tracking;
		var n = $elm$core$Array$length(config.options);
		var sect = (360 / config.segments) | 0;
		var segments = config.segments;
		var viewOption = F2(
			function (i, v) {
				var ri = ((((2 * i) - n) + 1) * sect) / 2;
				return A2(
					$elm$html$Html$li,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class(
							$author$project$TouchTunes$Views$DialStyles$css(
								function ($) {
									return $.option;
								})),
							A2(
							$elm$html$Html$Attributes$style,
							'left',
							$elm$core$String$fromFloat(
								cx + (r * $elm$core$Basics$cos(
									$elm$core$Basics$degrees(ri)))) + 'px'),
							A2(
							$elm$html$Html$Attributes$style,
							'top',
							$elm$core$String$fromFloat(
								cy - (r * $elm$core$Basics$sin(
									$elm$core$Basics$degrees(ri)))) + 'px')
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class(
									$author$project$TouchTunes$Views$DialStyles$css(
										function ($) {
											return $.viewValue;
										})),
									$mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onEnter(
									function (_v4) {
										return toMsg(
											$author$project$TouchTunes$Models$Dial$Set(i));
									})
								]),
							_List_fromArray(
								[
									config.viewValue(v)
								]))
						]));
			});
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class(
					function () {
						var _v1 = dial.tracking;
						if (_v1.$ === 'Just') {
							return $author$project$TouchTunes$Views$DialStyles$css(
								function ($) {
									return $.dial;
								}) + (' ' + $author$project$TouchTunes$Views$DialStyles$css(
								function ($) {
									return $.active;
								}));
						} else {
							return $author$project$TouchTunes$Views$DialStyles$css(
								function ($) {
									return $.dial;
								});
						}
					}()),
					$mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onUp(
					function (_v2) {
						return toMsg($author$project$TouchTunes$Models$Dial$Finish);
					})
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$ul,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class(
							$author$project$TouchTunes$Views$DialStyles$css(
								function ($) {
									return $.collar;
								}))
						]),
					A2($elm_community$array_extra$Array$Extra$indexedMapToList, viewOption, config.options)),
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class(
							$author$project$TouchTunes$Views$DialStyles$css(
								function ($) {
									return $.value;
								})),
							$mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onDown(
							function (_v3) {
								return toMsg($author$project$TouchTunes$Models$Dial$Start);
							})
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$span,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class(
									$author$project$TouchTunes$Views$DialStyles$css(
										function ($) {
											return $.viewValue;
										}))
								]),
							_List_fromArray(
								[
									config.viewValue(theValue)
								]))
						]))
				]));
	});
var $author$project$TouchTunes$Views$EditorView$viewControls = function (editor) {
	var overlay = editor.overlay;
	var controls = editor.controls;
	return A2(
		$elm$html$Html$ul,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$TouchTunes$Views$EditorStyles$css(
					function ($) {
						return $.controls;
					}))
			]),
		A2(
			$elm$core$List$map,
			function (e) {
				return A2(
					$elm$html$Html$li,
					_List_Nil,
					_List_fromArray(
						[e]));
			},
			function () {
				var _v0 = overlay.selection;
				switch (_v0.$) {
					case 'HarmonySelection':
						return _List_fromArray(
							[
								A2($author$project$TouchTunes$Views$DialView$view, controls.harmonyDial, $author$project$TouchTunes$Actions$Top$HarmonyMsg),
								A2($author$project$TouchTunes$Views$DialView$view, controls.kindDial, $author$project$TouchTunes$Actions$Top$KindMsg),
								A2($author$project$TouchTunes$Views$DialView$view, controls.chordDial, $author$project$TouchTunes$Actions$Top$DegreeMsg),
								A2($author$project$TouchTunes$Views$DialView$view, controls.altHarmonyDial, $author$project$TouchTunes$Actions$Top$AltHarmonyMsg),
								A2($author$project$TouchTunes$Views$DialView$view, controls.bassDial, $author$project$TouchTunes$Actions$Top$BassMsg)
							]);
					case 'NoteSelection':
						return _List_fromArray(
							[
								A2($author$project$TouchTunes$Views$DialView$view, controls.alterationDial, $author$project$TouchTunes$Actions$Top$AlterationMsg),
								A2($author$project$TouchTunes$Views$DialView$view, controls.subdivisionDial, $author$project$TouchTunes$Actions$Top$SubdivisionMsg)
							]);
					default:
						return _List_fromArray(
							[
								A2($author$project$TouchTunes$Views$DialView$view, controls.timeDial, $author$project$TouchTunes$Actions$Top$TimeMsg),
								A2($author$project$TouchTunes$Views$DialView$view, controls.keyDial, $author$project$TouchTunes$Actions$Top$KeyMsg)
							]);
				}
			}()));
};
var $author$project$Music$Views$StaffStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./Music/Views/css/staff.css',
	{barline: 'barline', lines: 'lines', staff: 'staff'}).toString;
var $elm$svg$Svg$line = $elm$svg$Svg$trustedNode('line');
var $author$project$Music$Models$Layout$width = function (layout) {
	var m = $author$project$Music$Models$Layout$margins(layout);
	var bs = $author$project$Music$Models$Layout$beatSpacing(layout);
	var b = $mgold$elm_nonempty_list$List$Nonempty$length(layout.divisors);
	return $author$project$Music$Models$Layout$Pixels((m.left.px + m.right.px) + (b * bs.px));
};
var $elm$svg$Svg$Attributes$x1 = _VirtualDom_attribute('x1');
var $elm$svg$Svg$Attributes$x2 = _VirtualDom_attribute('x2');
var $elm$svg$Svg$Attributes$y1 = _VirtualDom_attribute('y1');
var $elm$svg$Svg$Attributes$y2 = _VirtualDom_attribute('y2');
var $author$project$Music$Views$StaffView$drawBarLine = function (layout) {
	var width = $author$project$Music$Models$Layout$width(layout);
	var sp = $author$project$Music$Models$Layout$spacing(layout);
	var height = 4.0 * sp.px;
	return A2(
		$elm$svg$Svg$line,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$x1(
				$elm$core$String$fromFloat(width.px)),
				$elm$svg$Svg$Attributes$y1('0'),
				$elm$svg$Svg$Attributes$x2(
				$elm$core$String$fromFloat(width.px)),
				$elm$svg$Svg$Attributes$y2(
				$elm$core$String$fromFloat(height))
			]),
		_List_Nil);
};
var $author$project$Music$Views$StaffView$drawStaffLine = F2(
	function (layout, n) {
		var width = $author$project$Music$Models$Layout$width(layout);
		var s = $author$project$Music$Models$Layout$spacing(layout);
		var y = n * s.px;
		return A2(
			$elm$svg$Svg$line,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$x1('0'),
					$elm$svg$Svg$Attributes$x2(
					$elm$core$String$fromFloat(width.px)),
					$elm$svg$Svg$Attributes$y1(
					$elm$core$String$fromFloat(y)),
					$elm$svg$Svg$Attributes$y2(
					$elm$core$String$fromFloat(y))
				]),
			_List_Nil);
	});
var $author$project$Music$Views$StaffView$draw = function (layout) {
	return A2(
		$elm$svg$Svg$g,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$class(
				$author$project$Music$Views$StaffStyles$css(
					function ($) {
						return $.staff;
					}))
			]),
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$g,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$class(
						$author$project$Music$Views$StaffStyles$css(
							function ($) {
								return $.lines;
							}))
					]),
				A2(
					$elm$core$List$map,
					$author$project$Music$Views$StaffView$drawStaffLine(layout),
					A2($elm$core$List$range, 0, 4))),
				A2(
				$elm$svg$Svg$g,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$class(
						$author$project$Music$Views$StaffStyles$css(
							function ($) {
								return $.barline;
							}))
					]),
				_List_fromArray(
					[
						$author$project$Music$Views$StaffView$drawBarLine(layout)
					]))
			]));
};
var $author$project$Music$Models$Layout$fixedWidth = function (layout) {
	var t = $author$project$Music$Models$Layout$time(layout);
	var m = $author$project$Music$Models$Layout$margins(layout);
	var bs = $author$project$Music$Models$Layout$beatSpacing(layout);
	var b = t.beats;
	return $author$project$Music$Models$Layout$Pixels((m.left.px + m.right.px) + (b * bs.px));
};
var $author$project$Music$Models$Layout$keyOffset = function (layout) {
	return $author$project$Music$Models$Layout$Pixels(0);
};
var $author$project$Music$Views$NoteStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./Music/Views/css/note.css',
	{blank: 'blank', harmony: 'harmony', ledger: 'ledger', note: 'note', rest: 'rest', stem: 'stem'}).toString;
var $author$project$Music$Models$Layout$durationSpacing = F2(
	function (layout, dur) {
		var bs = $author$project$Music$Models$Layout$beatSpacing(layout);
		var beats = $author$project$Music$Models$Beat$toFloat(
			A2(
				$author$project$Music$Models$Beat$fromDuration,
				$author$project$Music$Models$Layout$time(layout),
				dur));
		return $author$project$Music$Models$Layout$Pixels(beats * bs.px);
	});
var $author$project$Music$Models$Duration$divideBy = F2(
	function (divisor, dur) {
		return _Utils_update(
			dur,
			{divisor: divisor * dur.divisor});
	});
var $author$project$Music$Models$Beat$halfBeat = function (n) {
	return A3($author$project$Music$Models$Beat$Beat, 0, n, 2);
};
var $author$project$Music$Views$NoteView$notePlacement = F3(
	function (time, dur, beat) {
		var half = (_Utils_cmp(
			dur.divisor,
			$author$project$Music$Models$Time$divisor(time)) > 0) ? A2($author$project$Music$Models$Duration$divideBy, 2, dur) : A2(
			$author$project$Music$Models$Beat$toDuration,
			time,
			$author$project$Music$Models$Beat$halfBeat(1));
		return A3($author$project$Music$Models$Beat$add, time, half, beat);
	});
var $author$project$Music$Models$Layout$scaleBeat = F2(
	function (layout, beat) {
		var m = $author$project$Music$Models$Layout$margins(layout);
		var bs = $author$project$Music$Models$Layout$beatSpacing(layout);
		return $author$project$Music$Models$Layout$Pixels(
			m.left.px + (bs.px * $author$project$Music$Models$Beat$toFloat(beat)));
	});
var $author$project$Music$Views$Symbols$eighthRest = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 40, 80),
	'tt-rest-eighth');
var $author$project$Music$Views$Symbols$halfRest = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 30, 80),
	'tt-rest-half');
var $author$project$Music$Views$Symbols$quarterRest = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 30, 80),
	'tt-rest-quarter');
var $author$project$Music$Views$Symbols$wholeRest = A2(
	$author$project$Music$Views$Symbols$Symbol,
	A4($author$project$Music$Views$Symbols$ViewBox, 0, 0, 30, 80),
	'tt-rest-whole');
var $author$project$Music$Views$NoteView$restSymbol = function (d) {
	var div = d.divisor / d.count;
	return (div <= 1.0) ? $author$project$Music$Views$Symbols$wholeRest : ((div <= 2.0) ? $author$project$Music$Views$Symbols$halfRest : ((div <= 4.0) ? $author$project$Music$Views$Symbols$quarterRest : $author$project$Music$Views$Symbols$eighthRest));
};
var $author$project$Music$Views$NoteView$viewRest = F2(
	function (layout, d) {
		var sp = $author$project$Music$Models$Layout$spacing(layout);
		var rest = $author$project$Music$Views$NoteView$restSymbol(d);
		var m = $author$project$Music$Models$Layout$margins(layout);
		return A2(
			$elm$svg$Svg$g,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$transform(
					'translate(0,' + ($elm$core$String$fromFloat(m.top.px + (2.0 * sp.px)) + ')'))
				]),
			_List_fromArray(
				[
					$author$project$Music$Views$Symbols$view(rest),
					$author$project$Music$Views$NoteView$viewDot(d)
				]));
	});
var $author$project$Music$Views$NoteView$view = F3(
	function (layout, beat, note) {
		var x0 = A2($author$project$Music$Models$Layout$scaleBeat, layout, beat);
		var maxWidth = 80.0;
		var h = $author$project$Music$Models$Layout$height(layout);
		var d = note.duration;
		var w = A2($author$project$Music$Models$Layout$durationSpacing, layout, d);
		var xpos = A2(
			$author$project$Music$Models$Layout$scaleBeat,
			layout,
			A3(
				$author$project$Music$Views$NoteView$notePlacement,
				$author$project$Music$Models$Layout$time(layout),
				d,
				beat));
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class(
					$author$project$Music$Views$NoteStyles$css(
						function ($) {
							return $.note;
						})),
					A2(
					$elm$html$Html$Attributes$style,
					'left',
					$elm$core$String$fromFloat(x0.px) + 'px'),
					A2(
					$elm$html$Html$Attributes$style,
					'width',
					$elm$core$String$fromFloat(w.px) + 'px')
				]),
			_List_fromArray(
				[
					A2(
					$elm$svg$Svg$svg,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$height(
							$elm$core$String$fromFloat(h.px)),
							$elm$svg$Svg$Attributes$width(
							$elm$core$String$fromFloat(maxWidth)),
							$elm$svg$Svg$Attributes$viewBox(
							$elm$core$String$fromFloat((-0.5) * maxWidth) + (' 0 ' + ($elm$core$String$fromFloat(maxWidth) + (' ' + $elm$core$String$fromFloat(h.px))))),
							$elm$svg$Svg$Attributes$transform(
							'translate(' + ($elm$core$String$fromFloat((xpos.px - x0.px) - (0.5 * maxWidth)) + ',0)'))
						]),
					_List_fromArray(
						[
							function () {
							var _v0 = note._do;
							if (_v0.$ === 'Play') {
								var p = _v0.a;
								return A3($author$project$Music$Views$NoteView$viewNote, layout, d, p);
							} else {
								return A2($author$project$Music$Views$NoteView$viewRest, layout, d);
							}
						}()
						])),
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							A2($elm$html$Html$Attributes$style, 'top', '0')
						]),
					_List_fromArray(
						[
							A2(
							$elm$core$Maybe$withDefault,
							$elm$svg$Svg$text(''),
							A2($elm$core$Maybe$map, $author$project$Music$Views$HarmonyView$view, note.harmony))
						]))
				]));
	});
var $author$project$Music$Views$MeasureView$view = F2(
	function (layout, measure) {
		var w = $author$project$Music$Models$Layout$width(layout);
		var timeOffset = $author$project$Music$Models$Layout$timeOffset(layout);
		var t = $author$project$Music$Models$Layout$time(layout);
		var sp = $author$project$Music$Models$Layout$spacing(layout);
		var noteSequence = A2(
			$elm$core$List$map,
			function (_v1) {
				var d = _v1.a;
				var n = _v1.b;
				return _Utils_Tuple2(
					A2($author$project$Music$Models$Beat$fromDuration, t, d),
					n);
			},
			$author$project$Music$Models$Measure$toSequence(measure));
		var margins = $author$project$Music$Models$Layout$margins(layout);
		var keyOffset = $author$project$Music$Models$Layout$keyOffset(layout);
		var h = $author$project$Music$Models$Layout$height(layout);
		var fixed = $author$project$Music$Models$Layout$fixedWidth(layout);
		var drawNote = function (_v0) {
			var beat = _v0.a;
			var note = _v0.b;
			return A3($author$project$Music$Views$NoteView$view, layout, beat, note);
		};
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class(
					$author$project$Music$Views$MeasureStyles$css(
						function ($) {
							return $.measure;
						}))
				]),
			A2(
				$elm$core$List$append,
				_List_fromArray(
					[
						A2(
						$elm$svg$Svg$svg,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$class(
								$author$project$Music$Views$MeasureStyles$css(
									function ($) {
										return $.staff;
									})),
								$elm$svg$Svg$Attributes$height(
								$elm$core$String$fromFloat(h.px)),
								$elm$svg$Svg$Attributes$width(
								$elm$core$String$fromFloat(w.px))
							]),
						_List_fromArray(
							[
								A2(
								$elm$svg$Svg$g,
								_List_fromArray(
									[
										$elm$svg$Svg$Attributes$transform(
										'translate(0,' + ($elm$core$String$fromFloat(margins.top.px) + ')'))
									]),
								_List_fromArray(
									[
										$author$project$Music$Views$StaffView$draw(layout)
									]))
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$class(
								$author$project$Music$Views$MeasureStyles$css(
									function ($) {
										return $.key;
									})),
								A2(
								$elm$html$Html$Attributes$style,
								'top',
								$elm$core$String$fromFloat(margins.top.px - sp.px) + 'px'),
								A2(
								$elm$html$Html$Attributes$style,
								'left',
								$elm$core$String$fromFloat(keyOffset.px) + 'px')
							]),
						_List_fromArray(
							[
								A2($author$project$Music$Views$MeasureView$viewKey, layout, layout.direct.key)
							])),
						A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$class(
								$author$project$Music$Views$MeasureStyles$css(
									function ($) {
										return $.time;
									})),
								A2(
								$elm$html$Html$Attributes$style,
								'top',
								$elm$core$String$fromFloat(margins.top.px) + 'px'),
								A2(
								$elm$html$Html$Attributes$style,
								'left',
								$elm$core$String$fromFloat(timeOffset.px) + 'px')
							]),
						_List_fromArray(
							[
								A2($author$project$Music$Views$MeasureView$viewTime, layout, layout.direct.time)
							]))
					]),
				A2($elm$core$List$map, drawNote, noteSequence)));
	});
var $author$project$TouchTunes$Actions$Top$DragEdit = function (a) {
	return {$: 'DragEdit', a: a};
};
var $author$project$TouchTunes$Actions$Top$FinishEdit = {$: 'FinishEdit'};
var $author$project$TouchTunes$Actions$Top$HarmonyEdit = function (a) {
	return {$: 'HarmonyEdit', a: a};
};
var $author$project$TouchTunes$Actions$Top$NoteEdit = function (a) {
	return {$: 'NoteEdit', a: a};
};
var $author$project$TouchTunes$Views$OverlayView$fromPixels = function (p) {
	return $elm$core$String$fromFloat(p.px);
};
var $author$project$Music$Models$Layout$harmonyHeight = function (layout) {
	var sp = $author$project$Music$Models$Layout$spacing(layout).px;
	return $author$project$Music$Models$Layout$Pixels(2.0 * sp);
};
var $elm$core$Tuple$mapBoth = F3(
	function (funcA, funcB, _v0) {
		var x = _v0.a;
		var y = _v0.b;
		return _Utils_Tuple2(
			funcA(x),
			funcB(y));
	});
var $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onMove = A2($mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onWithOptions, 'pointermove', $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$defaultOptions);
var $author$project$TouchTunes$Views$OverlayView$pointerCoordinates = function (event) {
	return event.pointer.offsetPos;
};
var $elm$svg$Svg$rect = $elm$svg$Svg$trustedNode('rect');
var $author$project$TouchTunes$Views$OverlayView$view = F2(
	function (measure, overlay) {
		var upNoteHandler = $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onUp(
			function (_v10) {
				return $author$project$TouchTunes$Actions$Top$FinishEdit;
			});
		var sameBeat = function (_v9) {
			var b = _v9.a;
			var _v8 = overlay.selection;
			switch (_v8.$) {
				case 'NoteSelection':
					var location = _v8.b;
					return A2($author$project$Music$Models$Beat$equal, location.beat, b);
				case 'HarmonySelection':
					var beat = _v8.c;
					return A2($author$project$Music$Models$Beat$equal, beat, b);
				default:
					return false;
			}
		};
		var layout = overlay.layout;
		var m = $author$project$Music$Models$Layout$margins(layout);
		var sp = $author$project$Music$Models$Layout$spacing(layout);
		var t = $author$project$Music$Models$Layout$time(layout);
		var seq = A2(
			$elm$core$List$map,
			function (_v7) {
				var d = _v7.a;
				var n = _v7.b;
				return _Utils_Tuple2(
					A2($author$project$Music$Models$Beat$fromDuration, t, d),
					n);
			},
			$author$project$Music$Models$Measure$toSequence(measure));
		var hh = $author$project$Music$Models$Layout$harmonyHeight(layout).px;
		var h = $author$project$Music$Models$Layout$height(layout).px;
		var duration = function () {
			var _v5 = A2($elm_community$list_extra$List$Extra$find, sameBeat, seq);
			if (_v5.$ === 'Just') {
				var _v6 = _v5.a;
				var n = _v6.b;
				return n.duration;
			} else {
				return $author$project$Music$Models$Duration$quarter;
			}
		}();
		var adjustCoordinates = function (_v4) {
			var x = _v4.a;
			var y = _v4.b;
			return _Utils_Tuple2(x + m.left.px, y + hh);
		};
		var downHarmonyHandler = $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onDown(
			A2(
				$elm$core$Basics$composeR,
				$author$project$TouchTunes$Views$OverlayView$pointerCoordinates,
				A2(
					$elm$core$Basics$composeR,
					adjustCoordinates,
					A2(
						$elm$core$Basics$composeR,
						A2($elm$core$Tuple$mapBoth, $elm$core$Basics$floor, $elm$core$Basics$floor),
						$author$project$TouchTunes$Actions$Top$HarmonyEdit))));
		var downNoteHandler = A3(
			$mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onWithOptions,
			'pointerdown',
			{preventDefault: true, stopPropagation: true},
			A2(
				$elm$core$Basics$composeR,
				$author$project$TouchTunes$Views$OverlayView$pointerCoordinates,
				A2(
					$elm$core$Basics$composeR,
					adjustCoordinates,
					A2(
						$elm$core$Basics$composeR,
						A2($elm$core$Tuple$mapBoth, $elm$core$Basics$floor, $elm$core$Basics$floor),
						$author$project$TouchTunes$Actions$Top$NoteEdit))));
		var moveNoteHandler = $mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onMove(
			A2(
				$elm$core$Basics$composeR,
				$author$project$TouchTunes$Views$OverlayView$pointerCoordinates,
				A2(
					$elm$core$Basics$composeR,
					adjustCoordinates,
					A2(
						$elm$core$Basics$composeR,
						A2($elm$core$Tuple$mapBoth, $elm$core$Basics$floor, $elm$core$Basics$floor),
						$author$project$TouchTunes$Actions$Top$DragEdit))));
		var activeNoteHandlers = function () {
			var _v3 = overlay.selection;
			switch (_v3.$) {
				case 'NoteSelection':
					var dragging = _v3.c;
					return dragging ? _List_fromArray(
						[moveNoteHandler, upNoteHandler]) : _List_fromArray(
						[downNoteHandler]);
				case 'HarmonySelection':
					return _List_fromArray(
						[downNoteHandler]);
				default:
					return _List_fromArray(
						[downNoteHandler]);
			}
		}();
		var activeHarmonyHandlers = function () {
			var _v2 = overlay.selection;
			switch (_v2.$) {
				case 'NoteSelection':
					var active = _v2.c;
					return _List_fromArray(
						[downHarmonyHandler]);
				case 'HarmonySelection':
					return _List_fromArray(
						[downHarmonyHandler]);
				default:
					return _List_fromArray(
						[downHarmonyHandler]);
			}
		}();
		return A2(
			$elm$svg$Svg$svg,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$class(
					$author$project$TouchTunes$Views$EditorStyles$css(
						function ($) {
							return $.overlay;
						})),
					$elm$svg$Svg$Attributes$height(
					$elm$core$String$fromFloat(h)),
					$elm$svg$Svg$Attributes$width(
					$author$project$TouchTunes$Views$OverlayView$fromPixels(
						$author$project$Music$Models$Layout$width(layout)))
				]),
			A2(
				$elm$core$List$append,
				_List_fromArray(
					[
						A2(
						$elm$svg$Svg$rect,
						A2(
							$elm$core$List$append,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$class(
									$author$project$TouchTunes$Views$EditorStyles$css(
										function ($) {
											return $.notearea;
										})),
									$elm$svg$Svg$Attributes$x(
									$author$project$TouchTunes$Views$OverlayView$fromPixels(m.left)),
									$elm$svg$Svg$Attributes$y(
									$elm$core$String$fromFloat(hh)),
									$elm$svg$Svg$Attributes$height(
									$elm$core$String$fromFloat(h - hh)),
									$elm$svg$Svg$Attributes$width(
									$author$project$TouchTunes$Views$OverlayView$fromPixels(
										A2(
											$author$project$Music$Models$Layout$durationSpacing,
											layout,
											$author$project$Music$Models$Measure$length(measure))))
								]),
							activeNoteHandlers),
						_List_Nil),
						A2(
						$elm$svg$Svg$rect,
						A2(
							$elm$core$List$append,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$class(
									$author$project$TouchTunes$Views$EditorStyles$css(
										function ($) {
											return $.harmonyarea;
										})),
									$elm$svg$Svg$Attributes$x(
									$author$project$TouchTunes$Views$OverlayView$fromPixels(m.left)),
									$elm$svg$Svg$Attributes$y('0'),
									$elm$svg$Svg$Attributes$height(
									$elm$core$String$fromFloat(hh)),
									$elm$svg$Svg$Attributes$width(
									$author$project$TouchTunes$Views$OverlayView$fromPixels(
										A2(
											$author$project$Music$Models$Layout$durationSpacing,
											layout,
											$author$project$Music$Models$Measure$length(measure))))
								]),
							activeHarmonyHandlers),
						_List_Nil)
					]),
				function () {
					var _v0 = overlay.selection;
					switch (_v0.$) {
						case 'HarmonySelection':
							var beat = _v0.c;
							return _List_fromArray(
								[
									A2(
									$elm$svg$Svg$rect,
									_List_fromArray(
										[
											$elm$svg$Svg$Attributes$class(
											$author$project$TouchTunes$Views$EditorStyles$css(
												function ($) {
													return $.selection;
												})),
											$elm$svg$Svg$Attributes$x(
											$author$project$TouchTunes$Views$OverlayView$fromPixels(
												A2($author$project$Music$Models$Layout$scaleBeat, overlay.layout, beat))),
											$elm$svg$Svg$Attributes$y('0'),
											$elm$svg$Svg$Attributes$height(
											$elm$core$String$fromFloat(hh)),
											$elm$svg$Svg$Attributes$width(
											$author$project$TouchTunes$Views$OverlayView$fromPixels(
												A2($author$project$Music$Models$Layout$durationSpacing, layout, duration)))
										]),
									_List_Nil)
								]);
						case 'NoteSelection':
							var note = _v0.a;
							var location = _v0.b;
							var dragging = _v0.c;
							return A2(
								$elm$core$List$append,
								_List_fromArray(
									[
										A2(
										$elm$svg$Svg$rect,
										_List_fromArray(
											[
												$elm$svg$Svg$Attributes$class(
												$author$project$TouchTunes$Views$EditorStyles$css(
													function ($) {
														return $.selection;
													})),
												$elm$svg$Svg$Attributes$x(
												$author$project$TouchTunes$Views$OverlayView$fromPixels(
													A2($author$project$Music$Models$Layout$scaleBeat, overlay.layout, location.beat))),
												$elm$svg$Svg$Attributes$y(
												$elm$core$String$fromFloat(hh)),
												$elm$svg$Svg$Attributes$height(
												$elm$core$String$fromFloat(h - hh)),
												$elm$svg$Svg$Attributes$width(
												$author$project$TouchTunes$Views$OverlayView$fromPixels(
													A2($author$project$Music$Models$Layout$durationSpacing, layout, duration)))
											]),
										_List_Nil)
									]),
								function () {
									var _v1 = note._do;
									if (_v1.$ === 'Play') {
										var pitch = _v1.a;
										return dragging ? _List_fromArray(
											[
												A2(
												$elm$svg$Svg$rect,
												_List_fromArray(
													[
														$elm$svg$Svg$Attributes$class(
														$author$project$TouchTunes$Views$EditorStyles$css(
															function ($) {
																return $.pitchLevel;
															})),
														$elm$svg$Svg$Attributes$x('0'),
														$elm$svg$Svg$Attributes$y(
														$elm$core$String$fromFloat(
															A2($author$project$Music$Models$Layout$scalePitch, overlay.layout, pitch).px - (0.5 * sp.px))),
														$elm$svg$Svg$Attributes$height(
														$author$project$TouchTunes$Views$OverlayView$fromPixels(sp)),
														$elm$svg$Svg$Attributes$width(
														$author$project$TouchTunes$Views$OverlayView$fromPixels(
															$author$project$Music$Models$Layout$width(layout)))
													]),
												_List_Nil)
											]) : _List_Nil;
									} else {
										return _List_Nil;
									}
								}());
						default:
							return _List_Nil;
					}
				}()));
	});
var $author$project$TouchTunes$Views$RulerView$fromPixels = function (p) {
	return $elm$core$String$fromFloat(p.px);
};
var $author$project$TouchTunes$Views$RulerView$viewBand = F3(
	function (layout, x_, w) {
		var sp = $author$project$Music$Models$Layout$spacing(layout).px;
		var pad = sp / 8.0;
		var hh = $author$project$Music$Models$Layout$harmonyHeight(layout).px;
		var h = $author$project$Music$Models$Layout$height(layout).px;
		return A2(
			$elm$svg$Svg$g,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$elm$svg$Svg$rect,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$class(
							$author$project$TouchTunes$Views$EditorStyles$css(
								function ($) {
									return $.underharmony;
								})),
							$elm$svg$Svg$Attributes$x(
							$elm$core$String$fromFloat(x_)),
							$elm$svg$Svg$Attributes$y('0'),
							$elm$svg$Svg$Attributes$height(
							$elm$core$String$fromFloat(hh - pad)),
							$elm$svg$Svg$Attributes$width(
							$elm$core$String$fromFloat(w))
						]),
					_List_Nil),
					A2(
					$elm$svg$Svg$rect,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$class(
							$author$project$TouchTunes$Views$EditorStyles$css(
								function ($) {
									return $.understaff;
								})),
							$elm$svg$Svg$Attributes$x(
							$elm$core$String$fromFloat(x_)),
							$elm$svg$Svg$Attributes$y(
							$elm$core$String$fromFloat(hh + pad)),
							$elm$svg$Svg$Attributes$height(
							$elm$core$String$fromFloat((h - hh) - pad)),
							$elm$svg$Svg$Attributes$width(
							$elm$core$String$fromFloat(w))
						]),
					_List_Nil),
					A2(
					$elm$svg$Svg$rect,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$x(
							$elm$core$String$fromFloat(x_)),
							$elm$svg$Svg$Attributes$y(
							$elm$core$String$fromFloat(h - (sp / 4.0))),
							$elm$svg$Svg$Attributes$height(
							$elm$core$String$fromFloat(sp / 4.0)),
							$elm$svg$Svg$Attributes$width(
							$elm$core$String$fromFloat(w))
						]),
					_List_Nil)
				]));
	});
var $author$project$TouchTunes$Views$RulerView$viewSegment = F3(
	function (layout, dur, beat) {
		var xmin = A2($author$project$Music$Models$Layout$scaleBeat, layout, beat);
		var time = $author$project$Music$Models$Layout$time(layout);
		var xmax = A2(
			$author$project$Music$Models$Layout$scaleBeat,
			layout,
			A3($author$project$Music$Models$Beat$add, time, dur, beat));
		var sp = $author$project$Music$Models$Layout$spacing(layout);
		var pad = sp.px / 8.0;
		return A3($author$project$TouchTunes$Views$RulerView$viewBand, layout, xmin.px + pad, (xmax.px - xmin.px) - (2.0 * pad));
	});
var $author$project$TouchTunes$Views$RulerView$viewBeat = F3(
	function (layout, divisor, fullBeat) {
		var time = $author$project$Music$Models$Layout$time(layout);
		var dur = A2(
			$author$project$Music$Models$Beat$toDuration,
			time,
			{divisor: divisor, full: 0, parts: 1});
		var beats = A2(
			$elm$core$List$map,
			function (p) {
				return {divisor: divisor, full: fullBeat.full, parts: p};
			},
			A2($elm$core$List$range, 0, divisor - 1));
		return A2(
			$elm$svg$Svg$g,
			_List_Nil,
			A2(
				$elm$core$List$map,
				A2($author$project$TouchTunes$Views$RulerView$viewSegment, layout, dur),
				beats));
	});
var $author$project$TouchTunes$Views$RulerView$view = function (layout) {
	var w = $author$project$Music$Models$Layout$width(layout);
	var time = $author$project$Music$Models$Layout$time(layout);
	var sp = $author$project$Music$Models$Layout$spacing(layout);
	var pad = sp.px / 8.0;
	var m = $author$project$Music$Models$Layout$margins(layout);
	var h = $author$project$Music$Models$Layout$height(layout);
	var fixed = $author$project$Music$Models$Layout$fixedWidth(layout);
	var beats = time.beats;
	return A2(
		$elm$svg$Svg$svg,
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$class(
				$author$project$TouchTunes$Views$EditorStyles$css(
					function ($) {
						return $.ruler;
					})),
				$elm$svg$Svg$Attributes$height(
				$author$project$TouchTunes$Views$RulerView$fromPixels(h)),
				$elm$svg$Svg$Attributes$width(
				$author$project$TouchTunes$Views$RulerView$fromPixels(w))
			]),
		$elm$core$List$concat(
			_List_fromArray(
				[
					_List_fromArray(
					[
						A2(
						$elm$svg$Svg$g,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$class(
								$author$project$TouchTunes$Views$EditorStyles$css(
									function ($) {
										return $.margins;
									}))
							]),
						_List_fromArray(
							[
								A3($author$project$TouchTunes$Views$RulerView$viewBand, layout, 0, m.left.px - pad),
								A3($author$project$TouchTunes$Views$RulerView$viewBand, layout, (w.px - m.right.px) + pad, m.right.px - pad)
							]))
					]),
					(_Utils_cmp(w.px, fixed.px) > 0) ? _List_fromArray(
					[
						A2(
						$elm$svg$Svg$g,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$class(
								$author$project$TouchTunes$Views$EditorStyles$css(
									function ($) {
										return $.overflow;
									}))
							]),
						_List_fromArray(
							[
								A3($author$project$TouchTunes$Views$RulerView$viewBand, layout, (fixed.px - m.right.px) + pad, (w.px - fixed.px) - (2.0 * pad))
							]))
					]) : _List_Nil,
					_List_fromArray(
					[
						A2(
						$elm$svg$Svg$g,
						_List_Nil,
						A3(
							$elm$core$List$map2,
							$author$project$TouchTunes$Views$RulerView$viewBeat(layout),
							$mgold$elm_nonempty_list$List$Nonempty$toList(layout.divisors),
							A2(
								$elm$core$List$map,
								$author$project$Music$Models$Beat$fullBeat,
								A2($elm$core$List$range, 0, beats - 1))))
					])
				])));
};
var $author$project$TouchTunes$Actions$Top$CancelEdit = {$: 'CancelEdit'};
var $author$project$TouchTunes$Actions$Top$DoneEdit = {$: 'DoneEdit'};
var $author$project$TouchTunes$Actions$Top$NextEdit = {$: 'NextEdit'};
var $author$project$TouchTunes$Actions$Top$PreviousEdit = {$: 'PreviousEdit'};
var $author$project$TouchTunes$Views$EditorView$viewNavigation = function (editor) {
	return A2(
		$elm$html$Html$ul,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$TouchTunes$Views$EditorStyles$css(
					function ($) {
						return $.navigation;
					}))
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$li,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Events$onClick($author$project$TouchTunes$Actions$Top$PreviousEdit)
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('<Previous')
							]))
					])),
				A2(
				$elm$html$Html$li,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Events$onClick($author$project$TouchTunes$Actions$Top$CancelEdit)
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('Cancel')
							]))
					])),
				A2(
				$elm$html$Html$li,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Events$onClick($author$project$TouchTunes$Actions$Top$DoneEdit)
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('Done')
							]))
					])),
				A2(
				$elm$html$Html$li,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Events$onClick($author$project$TouchTunes$Actions$Top$NextEdit)
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('Next>')
							]))
					]))
			]));
};
var $author$project$TouchTunes$Views$EditorView$viewMeasure = function (editor) {
	var m = $author$project$TouchTunes$Models$Editor$latent(editor);
	var l = editor.overlay.layout;
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$TouchTunes$Views$EditorStyles$css(
					function ($) {
						return $.editor;
					}))
			]),
		_List_fromArray(
			[
				$author$project$TouchTunes$Views$RulerView$view(l),
				A2($author$project$Music$Views$MeasureView$view, l, m),
				A2($author$project$TouchTunes$Views$OverlayView$view, m, editor.overlay),
				$author$project$TouchTunes$Views$EditorView$viewNavigation(editor)
			]));
};
var $author$project$TouchTunes$Views$EditorView$view = function (editor) {
	return A2(
		$elm$html$Html$article,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$TouchTunes$Views$EditorStyles$css(
					function ($) {
						return $.frame;
					}))
			]),
		_List_fromArray(
			[
				$author$project$TouchTunes$Views$EditorView$viewControls(editor),
				$author$project$TouchTunes$Views$EditorView$viewMeasure(editor)
			]));
};
var $author$project$Music$Models$Score$countParts = function (s) {
	return $elm$core$List$length(s.parts);
};
var $author$project$Music$Views$ScoreStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./Music/Views/css/score.css',
	{parts: 'parts', stats: 'stats', title: 'title'}).toString;
var $author$project$TouchTunes$Views$SheetStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./TouchTunes/Views/css/sheet.css',
	{body: 'body', frame: 'frame', header: 'header', pane: 'pane', sheet: 'sheet'}).toString;
var $elm$html$Html$dd = _VirtualDom_node('dd');
var $elm$html$Html$dl = _VirtualDom_node('dl');
var $elm$html$Html$dt = _VirtualDom_node('dt');
var $elm$html$Html$h1 = _VirtualDom_node('h1');
var $elm$html$Html$header = _VirtualDom_node('header');
var $author$project$Music$Models$Score$length = function (s) {
	return $elm$core$Array$length(s.measures);
};
var $author$project$Music$Views$PartStyles$css = A2(
	$cultureamp$elm_css_modules_loader$CssModules$css,
	'./Music/Views/css/part.css',
	{abbrev: 'abbrev', body: 'body', header: 'header', part: 'part'}).toString;
var $elm$html$Html$h3 = _VirtualDom_node('h3');
var $elm$core$Elm$JsArray$foldl = _JsArray_foldl;
var $elm$core$Elm$JsArray$indexedMap = _JsArray_indexedMap;
var $elm$core$Array$indexedMap = F2(
	function (func, _v0) {
		var len = _v0.a;
		var tree = _v0.c;
		var tail = _v0.d;
		var initialBuilder = {
			nodeList: _List_Nil,
			nodeListSize: 0,
			tail: A3(
				$elm$core$Elm$JsArray$indexedMap,
				func,
				$elm$core$Array$tailIndex(len),
				tail)
		};
		var helper = F2(
			function (node, builder) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldl, helper, builder, subTree);
				} else {
					var leaf = node.a;
					var offset = builder.nodeListSize * $elm$core$Array$branchFactor;
					var mappedLeaf = $elm$core$Array$Leaf(
						A3($elm$core$Elm$JsArray$indexedMap, func, offset, leaf));
					return {
						nodeList: A2($elm$core$List$cons, mappedLeaf, builder.nodeList),
						nodeListSize: builder.nodeListSize + 1,
						tail: builder.tail
					};
				}
			});
		return A2(
			$elm$core$Array$builderToArray,
			true,
			A3($elm$core$Elm$JsArray$foldl, helper, initialBuilder, tree));
	});
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm$core$Basics$min = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) < 0) ? x : y;
	});
var $elm$core$Elm$JsArray$appendN = _JsArray_appendN;
var $elm$core$Elm$JsArray$slice = _JsArray_slice;
var $elm$core$Array$appendHelpBuilder = F2(
	function (tail, builder) {
		var tailLen = $elm$core$Elm$JsArray$length(tail);
		var notAppended = ($elm$core$Array$branchFactor - $elm$core$Elm$JsArray$length(builder.tail)) - tailLen;
		var appended = A3($elm$core$Elm$JsArray$appendN, $elm$core$Array$branchFactor, builder.tail, tail);
		return (notAppended < 0) ? {
			nodeList: A2(
				$elm$core$List$cons,
				$elm$core$Array$Leaf(appended),
				builder.nodeList),
			nodeListSize: builder.nodeListSize + 1,
			tail: A3($elm$core$Elm$JsArray$slice, notAppended, tailLen, tail)
		} : ((!notAppended) ? {
			nodeList: A2(
				$elm$core$List$cons,
				$elm$core$Array$Leaf(appended),
				builder.nodeList),
			nodeListSize: builder.nodeListSize + 1,
			tail: $elm$core$Elm$JsArray$empty
		} : {nodeList: builder.nodeList, nodeListSize: builder.nodeListSize, tail: appended});
	});
var $elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var $elm$core$Array$sliceLeft = F2(
	function (from, array) {
		var len = array.a;
		var tree = array.c;
		var tail = array.d;
		if (!from) {
			return array;
		} else {
			if (_Utils_cmp(
				from,
				$elm$core$Array$tailIndex(len)) > -1) {
				return A4(
					$elm$core$Array$Array_elm_builtin,
					len - from,
					$elm$core$Array$shiftStep,
					$elm$core$Elm$JsArray$empty,
					A3(
						$elm$core$Elm$JsArray$slice,
						from - $elm$core$Array$tailIndex(len),
						$elm$core$Elm$JsArray$length(tail),
						tail));
			} else {
				var skipNodes = (from / $elm$core$Array$branchFactor) | 0;
				var helper = F2(
					function (node, acc) {
						if (node.$ === 'SubTree') {
							var subTree = node.a;
							return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
						} else {
							var leaf = node.a;
							return A2($elm$core$List$cons, leaf, acc);
						}
					});
				var leafNodes = A3(
					$elm$core$Elm$JsArray$foldr,
					helper,
					_List_fromArray(
						[tail]),
					tree);
				var nodesToInsert = A2($elm$core$List$drop, skipNodes, leafNodes);
				if (!nodesToInsert.b) {
					return $elm$core$Array$empty;
				} else {
					var head = nodesToInsert.a;
					var rest = nodesToInsert.b;
					var firstSlice = from - (skipNodes * $elm$core$Array$branchFactor);
					var initialBuilder = {
						nodeList: _List_Nil,
						nodeListSize: 0,
						tail: A3(
							$elm$core$Elm$JsArray$slice,
							firstSlice,
							$elm$core$Elm$JsArray$length(head),
							head)
					};
					return A2(
						$elm$core$Array$builderToArray,
						true,
						A3($elm$core$List$foldl, $elm$core$Array$appendHelpBuilder, initialBuilder, rest));
				}
			}
		}
	});
var $elm$core$Array$fetchNewTail = F4(
	function (shift, end, treeEnd, tree) {
		fetchNewTail:
		while (true) {
			var pos = $elm$core$Array$bitMask & (treeEnd >>> shift);
			var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
			if (_v0.$ === 'SubTree') {
				var sub = _v0.a;
				var $temp$shift = shift - $elm$core$Array$shiftStep,
					$temp$end = end,
					$temp$treeEnd = treeEnd,
					$temp$tree = sub;
				shift = $temp$shift;
				end = $temp$end;
				treeEnd = $temp$treeEnd;
				tree = $temp$tree;
				continue fetchNewTail;
			} else {
				var values = _v0.a;
				return A3($elm$core$Elm$JsArray$slice, 0, $elm$core$Array$bitMask & end, values);
			}
		}
	});
var $elm$core$Array$hoistTree = F3(
	function (oldShift, newShift, tree) {
		hoistTree:
		while (true) {
			if ((_Utils_cmp(oldShift, newShift) < 1) || (!$elm$core$Elm$JsArray$length(tree))) {
				return tree;
			} else {
				var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, 0, tree);
				if (_v0.$ === 'SubTree') {
					var sub = _v0.a;
					var $temp$oldShift = oldShift - $elm$core$Array$shiftStep,
						$temp$newShift = newShift,
						$temp$tree = sub;
					oldShift = $temp$oldShift;
					newShift = $temp$newShift;
					tree = $temp$tree;
					continue hoistTree;
				} else {
					return tree;
				}
			}
		}
	});
var $elm$core$Array$sliceTree = F3(
	function (shift, endIdx, tree) {
		var lastPos = $elm$core$Array$bitMask & (endIdx >>> shift);
		var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, lastPos, tree);
		if (_v0.$ === 'SubTree') {
			var sub = _v0.a;
			var newSub = A3($elm$core$Array$sliceTree, shift - $elm$core$Array$shiftStep, endIdx, sub);
			return (!$elm$core$Elm$JsArray$length(newSub)) ? A3($elm$core$Elm$JsArray$slice, 0, lastPos, tree) : A3(
				$elm$core$Elm$JsArray$unsafeSet,
				lastPos,
				$elm$core$Array$SubTree(newSub),
				A3($elm$core$Elm$JsArray$slice, 0, lastPos + 1, tree));
		} else {
			return A3($elm$core$Elm$JsArray$slice, 0, lastPos, tree);
		}
	});
var $elm$core$Array$sliceRight = F2(
	function (end, array) {
		var len = array.a;
		var startShift = array.b;
		var tree = array.c;
		var tail = array.d;
		if (_Utils_eq(end, len)) {
			return array;
		} else {
			if (_Utils_cmp(
				end,
				$elm$core$Array$tailIndex(len)) > -1) {
				return A4(
					$elm$core$Array$Array_elm_builtin,
					end,
					startShift,
					tree,
					A3($elm$core$Elm$JsArray$slice, 0, $elm$core$Array$bitMask & end, tail));
			} else {
				var endIdx = $elm$core$Array$tailIndex(end);
				var depth = $elm$core$Basics$floor(
					A2(
						$elm$core$Basics$logBase,
						$elm$core$Array$branchFactor,
						A2($elm$core$Basics$max, 1, endIdx - 1)));
				var newShift = A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep);
				return A4(
					$elm$core$Array$Array_elm_builtin,
					end,
					newShift,
					A3(
						$elm$core$Array$hoistTree,
						startShift,
						newShift,
						A3($elm$core$Array$sliceTree, startShift, endIdx, tree)),
					A4($elm$core$Array$fetchNewTail, startShift, end, endIdx, tree));
			}
		}
	});
var $elm$core$Array$translateIndex = F2(
	function (index, _v0) {
		var len = _v0.a;
		var posIndex = (index < 0) ? (len + index) : index;
		return (posIndex < 0) ? 0 : ((_Utils_cmp(posIndex, len) > 0) ? len : posIndex);
	});
var $elm$core$Array$slice = F3(
	function (from, to, array) {
		var correctTo = A2($elm$core$Array$translateIndex, to, array);
		var correctFrom = A2($elm$core$Array$translateIndex, from, array);
		return (_Utils_cmp(correctFrom, correctTo) > 0) ? $elm$core$Array$empty : A2(
			$elm$core$Array$sliceLeft,
			correctFrom,
			A2($elm$core$Array$sliceRight, correctTo, array));
	});
var $elm_community$array_extra$Array$Extra$apply = F2(
	function (fs, xs) {
		var l = A2(
			$elm$core$Basics$min,
			$elm$core$Array$length(fs),
			$elm$core$Array$length(xs));
		var fs_ = $elm$core$Array$toList(
			A3($elm$core$Array$slice, 0, l, fs));
		return $elm$core$Array$fromList(
			A2(
				$elm$core$List$filterMap,
				$elm$core$Basics$identity,
				A2(
					$elm$core$List$indexedMap,
					F2(
						function (n, f) {
							return A2(
								$elm$core$Maybe$map,
								f,
								A2($elm$core$Array$get, n, xs));
						}),
					fs_)));
	});
var $elm$core$Elm$JsArray$map = _JsArray_map;
var $elm$core$Array$map = F2(
	function (func, _v0) {
		var len = _v0.a;
		var startShift = _v0.b;
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = function (node) {
			if (node.$ === 'SubTree') {
				var subTree = node.a;
				return $elm$core$Array$SubTree(
					A2($elm$core$Elm$JsArray$map, helper, subTree));
			} else {
				var values = node.a;
				return $elm$core$Array$Leaf(
					A2($elm$core$Elm$JsArray$map, func, values));
			}
		};
		return A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			A2($elm$core$Elm$JsArray$map, helper, tree),
			A2($elm$core$Elm$JsArray$map, func, tail));
	});
var $elm_community$array_extra$Array$Extra$map2 = F2(
	function (f, ws) {
		return $elm_community$array_extra$Array$Extra$apply(
			A2($elm$core$Array$map, f, ws));
	});
var $author$project$TouchTunes$Actions$Top$StartEdit = F4(
	function (a, b, c, d) {
		return {$: 'StartEdit', a: a, b: b, c: c, d: d};
	});
var $author$project$TouchTunes$Views$SheetView$viewMeasure = F4(
	function (viewer, id, j, _v0) {
		var layout = _v0.a;
		var measure = _v0.b;
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$mpizenberg$elm_pointer_events$Html$Events$Extra$Pointer$onDown(
					function (_v1) {
						return A4($author$project$TouchTunes$Actions$Top$StartEdit, id, j, layout.indirect, measure);
					})
				]),
			_List_fromArray(
				[
					A2($author$project$Music$Views$MeasureView$view, layout, measure)
				]));
	});
var $author$project$TouchTunes$Views$SheetView$viewPart = F3(
	function (viewer, score, part) {
		var layoutMeasures = A3(
			$elm_community$array_extra$Array$Extra$map2,
			F2(
				function (a, m) {
					return _Utils_Tuple2(
						A2($author$project$Music$Models$Layout$forMeasure, a, m),
						m);
				}),
			$author$project$Music$Models$Score$attributes(score),
			score.measures);
		return A2(
			$elm$html$Html$section,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class(
					$author$project$Music$Views$PartStyles$css(
						function ($) {
							return $.part;
						}))
				]),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$header,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class(
							$author$project$Music$Views$PartStyles$css(
								function ($) {
									return $.header;
								}))
						]),
					_List_fromArray(
						[
							A2(
							$elm$html$Html$h3,
							_List_fromArray(
								[
									$elm$html$Html$Attributes$class(
									$author$project$Music$Views$PartStyles$css(
										function ($) {
											return $.abbrev;
										}))
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(part.abbrev)
								]))
						])),
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class(
							$author$project$Music$Views$PartStyles$css(
								function ($) {
									return $.body;
								}))
						]),
					$elm$core$Array$toList(
						A2(
							$elm$core$Array$indexedMap,
							A2($author$project$TouchTunes$Views$SheetView$viewMeasure, viewer, part.id),
							layoutMeasures)))
				]));
	});
var $author$project$TouchTunes$Views$SheetView$view = function (viewer) {
	var s = viewer.score;
	var nParts = $author$project$Music$Models$Score$countParts(s);
	var nMeasures = $author$project$Music$Models$Score$length(s);
	return A2(
		$elm$html$Html$article,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$TouchTunes$Views$SheetStyles$css(
					function ($) {
						return $.frame;
					}))
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$header,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class(
						$author$project$TouchTunes$Views$SheetStyles$css(
							function ($) {
								return $.header;
							}))
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$h1,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class(
								$author$project$Music$Views$ScoreStyles$css(
									function ($) {
										return $.title;
									}))
							]),
						_List_fromArray(
							[
								$elm$html$Html$text(s.title)
							])),
						A2(
						$elm$html$Html$dl,
						_List_fromArray(
							[
								$elm$html$Html$Attributes$class(
								$author$project$Music$Views$ScoreStyles$css(
									function ($) {
										return $.stats;
									}))
							]),
						_List_fromArray(
							[
								A2(
								$elm$html$Html$dt,
								_List_Nil,
								_List_fromArray(
									[
										$elm$html$Html$text('Parts')
									])),
								A2(
								$elm$html$Html$dd,
								_List_Nil,
								_List_fromArray(
									[
										$elm$html$Html$text(
										$elm$core$String$fromInt(nParts))
									])),
								A2(
								$elm$html$Html$dt,
								_List_Nil,
								_List_fromArray(
									[
										$elm$html$Html$text('Measures')
									])),
								A2(
								$elm$html$Html$dd,
								_List_Nil,
								_List_fromArray(
									[
										$elm$html$Html$text(
										$elm$core$String$fromInt(nMeasures))
									]))
							]))
					])),
				A2(
				$elm$html$Html$div,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$classList(
						_List_fromArray(
							[
								_Utils_Tuple2(
								$author$project$TouchTunes$Views$SheetStyles$css(
									function ($) {
										return $.pane;
									}),
								true),
								_Utils_Tuple2(
								$author$project$Music$Views$ScoreStyles$css(
									function ($) {
										return $.parts;
									}),
								true)
							]))
					]),
				A2(
					$elm$core$List$map,
					A2($author$project$TouchTunes$Views$SheetView$viewPart, viewer, s),
					s.parts))
			]));
};
var $author$project$TouchTunes$Views$AppView$view = function (app) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class(
				$author$project$TouchTunes$Views$AppStyles$css(
					function ($) {
						return $.body;
					}))
			]),
		_List_fromArray(
			[
				$author$project$TouchTunes$Views$SheetView$view(
				$author$project$TouchTunes$Models$Sheet$Sheet(app.score)),
				function () {
				var _v0 = app.editing;
				if (_v0.$ === 'Just') {
					var e = _v0.a;
					return $author$project$TouchTunes$Views$EditorView$view(e.editor);
				} else {
					return $elm$html$Html$text('');
				}
			}()
			]));
};
var $author$project$Main$view = function (model) {
	return A2(
		$elm$html$Html$section,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$classList(
				_List_fromArray(
					[
						_Utils_Tuple2(
						$author$project$TouchTunes$Views$AppStyles$css(
							function ($) {
								return $.app;
							}),
						true),
						_Utils_Tuple2(
						$author$project$TouchTunes$Views$AppStyles$css(
							function ($) {
								return $.fullscreen;
							}),
						true)
					]))
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$map,
				$author$project$Main$AppMessage,
				$author$project$TouchTunes$Views$AppView$view(model.app)),
				A2(
				$elm$html$Html$footer,
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class(
						$author$project$TouchTunes$Views$AppStyles$css(
							function ($) {
								return $.footer;
							}))
					]),
				_List_fromArray(
					[
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Events$onClick(
								$author$project$Main$Open($author$project$Music$Models$Score$empty))
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('Clear')
							])),
						A2(
						$elm$html$Html$button,
						_List_fromArray(
							[
								$elm$html$Html$Events$onClick(
								$author$project$Main$Open($author$project$AutumnLeaves$score))
							]),
						_List_fromArray(
							[
								$elm$html$Html$text('Autumn Leaves')
							]))
					]))
			]));
};
var $author$project$Main$main = $elm$browser$Browser$element(
	{
		init: function (flags) {
			return _Utils_Tuple2($author$project$Main$initialModel, $elm$core$Platform$Cmd$none);
		},
		subscriptions: function (model) {
			return $elm$core$Platform$Sub$none;
		},
		update: $author$project$Main$update,
		view: $author$project$Main$view
	});
_Platform_export({'Main':{'init':$author$project$Main$main(
	$elm$json$Json$Decode$succeed(_Utils_Tuple0))(0)}});}(this));