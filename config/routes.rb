ChrnoAudit::Engine.routes.draw do
  root to: 'chrno_audit#index'
  #match '/:model_name/:id' => 'chrno_audit#history', as: :history
  match '/*model_name/by/:attr_name/:value' => 'chrno_audit#history', as: :history
  match '/*model_name' => 'chrno_audit#model', as: :model
end
