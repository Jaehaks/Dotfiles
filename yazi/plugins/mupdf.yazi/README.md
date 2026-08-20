# MuPDF Previewer

Preview PDF files and scroll through pages directly in Yazi with high performance!

## Requirements

- [`mupdf`](https://mupdf.com/) (`mutool` command must be available in your system's `$PATH`)


## Usage

```toml
[plugin]
prepend_previewers = [
	{ mime = "application/pdf", run = "mupdf" },
]
prepend_preloaders = [
	{ mime = "application/pdf", run = "mupdf" },
]
```

## Settings

This plugin automatically respects Yazi's native preview configurations.
It extracts specific pages based on your seek actions and converts them on-the-fly.

You can fine-tune the rendering behavior by adjusting the default preview settings
in your `~/.config/yazi/yazi.toml`:

This is example configuration.
```toml
[preview]
image_quality = 75    # Used for `mutool -r` argument
max_width     = 1920  # Used for `mutool -w` argument
image_delay   = 30    # Delay before rendering the preview
```


