STORAGE = {
  upload: {
        provider:   'AWS',
        url:        "//risebox-upload-prod.s3-external-3.amazonaws.com",
        access_key: ENV['S3_KEY'],
        secret_key: ENV['S3_SECRET'],
        bucket:     'risebox-upload-prod',
        conditions: { size: 5242880 },
        region:     'eu-west-1'
                },
  strip_photos: {
        provider:   'AWS',
        url:        "//risebox-strips-prod.s3-external-3.amazonaws.com",
        access_key: ENV['S3_KEY'],
        secret_key: ENV['S3_SECRET'],
        bucket:     'risebox-strips-prod',
        conditions: { size: 5242880 },
        region:     'eu-west-1'
                }
}