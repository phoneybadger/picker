project('com.github.phoneybadger.picker', 'c', 'vala')

subdir('src')
subdir('data')
subdir('po')

glib_dep = dependency('glib-2.0')
gtk_dep = dependency('gtk+-3.0')
granite_dep = dependency('granite')
handy_dep = dependency('libhandy-1')

picker_dependencies = [glib_dep, gtk_dep, granite_dep, handy_dep]

executable(
    meson.project_name(),
    sources: [picker_source_files, picker_resources],
    dependencies: picker_dependencies,
    install: true
)

meson.add_install_script('meson/post_install.py')
