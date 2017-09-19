// please see instructions https://github.com/rails/webpacker#add-common-chunks

const webpack = require('webpack')

module.exports = {
  plugins: [
    new webpack.DefinePlugin({
      SENTRY_PUBLIC_DSN: JSON.stringify(process.env.SENTRY_PUBLIC_DSN)
    })
  ]
}
