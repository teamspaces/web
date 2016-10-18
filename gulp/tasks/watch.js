/* Notes:
   - gulp/tasks/browserify.js handles js recompiling with watchify
*/

var gulp   = require('gulp');
var config = require('../config');
var watch  = require('gulp-watch');

gulp.task('watch', ['watchify'], function(callback) {
  watch(config.sass.src, function() { gulp.start('sass'); });
  watch(config.images.src, function() { gulp.start('images'); });
  watch(config.iconFont.src, function() { gulp.start('iconFont'); });
  // Watchify will watch and recompile our JS, so no need to gulp.watch it
});

// TODO: Move this into a file of it's own and include it?
// Ctrl + C won't work otherwise..
process.on('SIGINT', function() {
  setTimeout(function() {
    process.exit(1);
  }, 100);
});
