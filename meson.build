project('com.github.phoneybadger.picker', 'c', 'vala', version: '1.1.0')

subdir('src')
subdir('data')
subdir('po')

glib_dep = dependency('glib-2.0')
gtk_dep = dependency('gtk4')
granite_dep = dependency('granite-7')
adw_dep = dependency('libadwaita-1')

picker_dependencies = [glib_dep, gtk_dep, granite_dep, adw_dep]

executable(
    meson.project_name(),
    sources: [picker_source_files, picker_resources],
    dependencies: picker_dependencies,
    install: true
)

meson.add_install_script('meson/post_install.py')
