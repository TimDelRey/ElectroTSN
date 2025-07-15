# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "users/profiles/profile_form", to: "users/profiles/profile_form.js"
pin "jquery" # @3.7.1
pin "welcome/index", to: "welcome/index.js"
pin "layouts/for_application", to: "layouts/for_application.js"
