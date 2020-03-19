# frozen_string_literal: true

module UrlStubbing
  def add_url_stub(uri, path, file_name)
    response = Typhoeus::Response.new(
      code: 200,
      body: File.read("#{stub_path}/#{file_name}")
    )
    Typhoeus.stub(
      "#{uri}#{path}",
      headers: { 'Content-Type' => 'application/xml; charset=UTF-8' }
    ).and_return(response)
  end
end
