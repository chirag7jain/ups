module SchemaPath
  def schema_path(schema)
    File.expand_path(File.join('spec', 'support', schema))
  end
end
