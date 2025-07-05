project('com.github.phoneybadger.picker', 'c', 'vala', version: '2.0.0')

subdir('src')
subdir('data')
subdir('po')

glib_dep = dependency('glib-2.0')
gtk_dep = dependency('gtk4')
granite_dep = dependency('granite-7')
portal_dep = dependency('libportal')

picker_dependencies = [glib_dep, gtk_dep, granite_dep, portal_dep, meson.get_compiler('c').find_library('m', required: true)]

gresource = gnome.compile_resources(
    'gresource',
    'data' / 'gresource.xml',
    source_dir: 'data'
)

executable(
    meson.project_name(),
    gresource,
    sources: [picker_source_files],
    dependencies: picker_dependencies,
    install: true
)

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true
  )