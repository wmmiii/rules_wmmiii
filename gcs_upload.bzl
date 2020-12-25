def _gcs_upload_impl(ctx):
    bucket = ctx.attr.bucket

    file_list = []
    path_list = []
    for target in ctx.attr.srcs:
        for file in target.files.to_list():
            if file.is_directory:
                fail("Directories are not supported yet!")
            file_list.append(file)
            path_list.append(file.path)

    paths = "\n".join(path_list)

    cmd = "echo \"Uploading; %s\" && echo \"%s\" | gsutil -m cp -I gs://%s" % (paths, paths, bucket)

    ctx.actions.write(
        output = ctx.outputs.executable,
        content = cmd,
    )
    return [DefaultInfo(data_runfiles = ctx.runfiles(file_list))]

gcs_upload = rule(
    implementation = _gcs_upload_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "bucket": attr.string(),
        "strip_prefix": attr.string_list(),
    },
    executable = True,
    doc = "Uplaod to GCS."
)
