const { env, publicPath } = require('../configuration.js')

module.exports = {
  test: /\.(jpg|jpeg|png|gif)$/i,
  use: [{
    loader: 'file-loader',
    options: {
      publicPath,
      name: env.NODE_ENV === 'production' ? '[name]-[hash].[ext]' : '[name].[ext]'
    }
  }, {
    loader: 'image-webpack-loader',
    query: {
        mozjpeg: {
          progressive: true,
          quality: 65
        },
        pngquant: {
          quality: "65-90",
          speed: 4
        },
        gifsicle: {
          interlaced: false
        },
        svgo: {
          plugins: [
            {
              removeViewBox: false
            },
            {
              removeEmptyAttrs: false
            }
          ]
        }
    }
  }]
}
