module SchemaPath
  def schema_path(schema)
    File.expand_path(File.join('test', 'support', schema))
  end
end
