// How do I inherit privileged methods and privat data?
var a = stampit().enclose(function() {
  // Secrets go here
  var a = 'a';

  // Methods can access secrets.
  // Nothing else can.
  this.getA = function() {
    return a;
  };
});

var b = stampit().enclose(function() {
  // use the same variable a
  // but it's in a clousure, so you
  // can safely combine them.
  var a = 'b';

  // Methods can access secrets.
  // Nothing else can.
  this.getB = function() {
    return a;
  };
});

// Combine
var c = stampit.compose(a, b);

var foo = c(); // We wont throw this one away...

foo.getA(); // "a"
foo.getB(); // "b"
