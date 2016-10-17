var publicAssets = "./public/assets";
var sourceFiles  = "./gulp/assets";

module.exports = {
  publicAssets: publicAssets,
  sass: {
    src: sourceFiles + "/stylesheets/**/*.{sass,scss}",
    dest: publicAssets + "/stylesheets",
    settings: {
      indentedSyntax: false, // 'true' to enable .sass syntax!
      imagePath: '/assets/images' // Used by the image-url helper
    }
  },
  images: {
    src: sourceFiles + "/images/**",
    dest: publicAssets + "/images"
  },
  iconFont: {
    name: 'XYZ Icons',
    src: sourceFiles + "/icons/*.svg",
    dest: publicAssets + '/fonts',
    sassDest: sourceFiles + '/stylesheets/base',
    template: './gulp/tasks/iconFont/template.sass',
    sassOutputName: '_iconFont.sass',
    fontPath: '/assets/fonts',
    className: 'icon',
    options: {
      fontName: 'xyz-icons',
      appendCodepoints: true,
      normalize: false
    }
  },
  browserify: {
    bundleConfigs: [{
      entries: sourceFiles + '/javascripts/main.js',
      dest: publicAssets + '/javascripts',
      outputName: 'main.js',
      extensions: ['.js','.coffee']
    }]
  }
};
