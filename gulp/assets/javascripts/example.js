// MODEL
var model = function() {
  var attributes = {};

  this.set = function(name, value) {
    attributes[name] = value;
    this.trigger('change', {
      name: name,
      value: value
    });
  };

  this.get = function(name) {
    return attributes[name];
  };

  _.extend(this, Backbone.Events)
};

// GEORGE
var george = {};
model.call(george).set('name', 'George');
george.get('name'); // George

george.on('change', function(event){
  console.log(event.name, event.value);
});

george.set('name', 'Simon'); // name Simon
