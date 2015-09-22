module UrlStubbing
  def add_url_stub(uri, path, file_name)
    response = Typhoeus::Response.new(
      code: 200,
      body: File.read("#{stub_path}/#{file_name}")
    )
    Typhoeus.stub("#{uri}#{path}").and_return(response)
  end
end
