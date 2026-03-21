Rswag::Ui.configure do |c|
  c.openapi_endpoint "/api-docs/v1/swagger.yaml", "Restaurant Menu API – V1"

  # Optional: expand all operations by default
  # c.config_object[:defaultModelsExpandDepth] = -1
end
