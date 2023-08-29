const gulp = require('gulp');
const headerComment = require('gulp-header-comment');
const moment = require('moment');
var watch = require('gulp-watch');
var clean = require('gulp-clean');
var rimraf = require('gulp-rimraf');
var replace = require('gulp-replace');
var log = require('fancy-log');
cache = require('gulp-cached'),
    remember = require('gulp-remember');
var pjson = require('./package.json');

var version = pjson.version;

var directories = ['JunglePatrol.Cam_Lao_Nam', 'JunglePatrol.vn_khe_sanh'];

// Perform a default watch to the root folder
gulp.task('default', function () {
    var source = './JP'
    gulp.start('copy');
    // Callback mode, useful if any plugin in the pipeline depends on the `end`/`flush` event

    for (var i = 0; i < directories.length; i++) {
        gulp.src(source + '/**/*', { base: source })
            .pipe(watch(source, { base: source }))
            .on('change', function (data) { log('File change - copying ' + data); })
            .on('added', function (data) { log('File added - copying ' + data); })
            .pipe(replace('{VERSION}', version))
            .pipe(replace('{WORLD_NAME}', getDirectory(directories[i])))
            .pipe(gulp.dest('./' + directories[i] + '/JP'));

        gulp.src('./stringtable.xml')
            .pipe(watch('./stringtable.xml'))
            .on('change', function (data) { log('File change - stringtable.xml '); })
            .on('added', function (data) { log('File added -  stringtable.xml '); })
            .pipe(replace('{VERSION}', version))
            .pipe(replace('{WORLD_NAME}', getDirectory(directories[i])))
            .pipe(gulp.dest('./' + directories[i]));
    }

});

gulp.task('copy', function () {
    for (let i = 0; i < directories.length; i++) {
        console.log(directories[i].split('.')[1]);
        gulp.src('JP/**/*')
            .pipe(replace('{VERSION}', version))
            .pipe(replace('{WORLD_NAME}', getDirectory(directories[i])))
            .pipe(gulp.dest('./' + directories[i] + '/JP'));

        gulp.src('./stringtable.xml')
            .pipe(replace('{VERSION}', version))
            .pipe(replace('{WORLD_NAME}', getDirectory(directories[i])))
            .pipe(gulp.dest('./' + directories[i]));
    }
});


gulp.task('clean', function () {
    for (var i = 0; i < directories.length; i++) {
        gulp.src(directories[i] + '/JP', { read: false })
            .pipe(rimraf());
    }
});

function getDirectory (dir) {
    var island = dir.split('.')[1]
    switch (island) {
        case "Enoch":
            return "Livonia"
        default:
            return island;
    }
}

const pbo = require('gulp-armapbo');

gulp.task('mission', () => {
    return gulp.src('JunglePatrol.Malden/**/*')
        .pipe(pbo.pack({
            fileName: 'JunglePatrol.Malden.pbo',
            extensions: [{
                name: 'Bidass',
                value: 'AntoineBidault'
            }, {
                name: 'JunglePatrol',
                value: 'DynamicCivilWar'
            }],
            compress: [
                // '**/*.sqf',
                //  'config.cpp'
            ]
        }))
        .pipe(gulp.dest('Build/MPMissions'));
});