var gulp = require('gulp');
var elm  = require('gulp-elm');

gulp.task('elm', function(){
  return gulp.src('src/Main.elm')
    .pipe(elm.bundle('main.js'))
    .pipe(gulp.dest('build/'));
});

gulp.task('default', ['elm']);
