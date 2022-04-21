project('com.github.phoneybadger.picker', 'c', 'vala')

subdir('src')

glib_dep = dependency('glib-2.0')

picker_dependencies = [glib_dep]

executable(
  meson.project_name(),
  sources: picker_source_files,
  dependencies: picker_dependencies
)
