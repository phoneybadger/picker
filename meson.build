project('com.github.phoneybadger.picker', 'c', 'vala')

subdir('src')
subdir('data')

glib_dep = dependency('glib-2.0')
gtk_dep = dependency('gtk+-3.0')
granite_dep = dependency('granite')

picker_dependencies = [glib_dep, gtk_dep, granite_dep]

executable(
  meson.project_name(),
  sources: picker_source_files,
  dependencies: picker_dependencies
)

meson.add_install_script('meson/post_install.py')
