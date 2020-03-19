# frozen_string_literal: true

module SchemaPath
  def schema_path(schema)
    File.expand_path(File.join('test', 'support', schema))
  end
end
