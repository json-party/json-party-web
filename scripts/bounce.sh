#!/bin/bash

# TODO: Generalize this for other projects

ROOT=json.party

function bounce() {
    filename=$1
    content_type=$2
    metaserve --bounce $filename --out $filename.bounced
    aws s3 cp $filename.bounced s3://$ROOT/$filename --content-type $content_type
    echo "✓ Bounced $filename to s3://$ROOT/$filename"
    rm $filename.bounced
}

bounce index.html text/html
bounce js/app.js application/javascript
bounce css/app.css text/css
