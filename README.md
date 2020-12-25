# rules_wmmiii
A random assortment of Bazel rules.

**Note:** these have only been tested on Ubuntu 20.04 so they may not work on other systems.

## Installation

### Bazel

Simply add 
the following to your WORKSPACE

     load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

    http_archive(
      name = "rules_wmmiii",
      sha256 = "[zip sha]",
      urls = [
          "https://github.com/wmmiii/rules_wmmiii/archive/[commit sha].zip",
      ],
      strip_prefix = "wmmiii_rules-[commit sha]",
  )

**zip sha** is the SHA of the zip file downloaded.

**commit sha** is the SHA of the latest commit.

**Tip:** To figure out the zip's sha just stick the `http_archive` rule in your workspace without the `sha256` property and run Bazel. It will tell you what the sha of the zip is and you can just include that. It's not secure but it is hermetic!

## gcs_upload

This rule does what it says on the tin, it uploads files to Google Cloud Storage.

### Google Cloud SDK

To run this rule you must have the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed on the client system.

You must be authenticated using a principle that has access to the bucket you will be uploading to.
    
    gcloud auth login

### Example ###

Assuming you have a bucket called "example-bucket" (you probably don't, lets be honest).

    load("@rules_wmmiii//:gcs_upload.bzl", upload = "gcs_upload")

    upload(
        name = "upload",
        srcs = [
            "photos/vacation_photo.jpg",
            "vacation.html",
        ],
        bucket = "example-bucket",
    )

If you run `bazel run //:upload` it will upload the files to `http://example-bucket.storage.googleapis.com/vacation_photo.jpg` and `http://example-bucket.storage.googleapis.com/vacation.html` respectively.

Note that the files are all located in the root. There is no way to configure this as of right now. If you need this feature just open an issue and I'll look into it!