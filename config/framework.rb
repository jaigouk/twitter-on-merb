Merb::Config[:framework] = {
  :application => Merb.root / "application.rb",
  :config => [Merb.root / "config", nil],
  :envrionment => Merb.root / "config/environments",
  :public => [Merb.root / "public", nil],
  :model => Merb.root / "models",
  :view   => Merb.root / "views"
}

