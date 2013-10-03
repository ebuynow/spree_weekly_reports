Spree::Core::Engine.routes.draw do
  get 'admin/reports/shipped_weekly', controller: 'admin/reports', action: 'shipped_weekly', as: 'shipped_weekly_admin_reports'
  post 'admin/reports/shipped_weekly', controller: 'admin/reports', action: 'shipped_weekly'
end
