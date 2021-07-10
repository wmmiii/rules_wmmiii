def _gcs_upload_impl(ctx):
    bucket = ctx.attr.bucket

    file_list = []
    path_list = []
    for file in ctx.files.srcs:
        if file.is_directory:
            fail("Directories are not supported yet!")
        file_list.append(file)
        path_list.append(file.path)

    paths = " ".join(path_list)

    cmd = "printf '%%s\\n' %s | gsutil -m cp -I gs://%s" % (paths, bucket)

    ctx.actions.write(
        output = ctx.outputs.executable,
        content = cmd,
    )
    return [DefaultInfo(
        files = depset(ctx.files.srcs),
        runfiles = ctx.runfiles(file_list),
    )]

gcs_upload = rule(
    implementation = _gcs_upload_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            allow_files = True,
            mandatory  = True,
        ),
        "bucket": attr.string(),
    },
    executable = True,
    doc = "Upload to GCS."
)
