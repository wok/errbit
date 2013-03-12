class JavascriptBeautifier
  class << self
    def fetch_and_beautify(url)
      Dir.mkdir(cache_path) rescue nil

      file = File.basename(url)
      map_file, js_file = map_path(file), js_path(file)

      if File.exists?(js_file) && File.exists?(map_file)
        beautified_js, source_map = File.read(js_file), File.read(map_file)
      else
        response = HTTParty.get(url, :format => :javascript)
        return false unless response.code == 200

        uglifier = Uglifier.new(
          :output => {
            :beautify => true,
            :space_colon => true
          },
          :compress => false,
          :mangle => false,
          :source_filename => 'source.js',
          :output_filename => 'generated.js'
        )

        beautified_js, source_map = uglifier.compile_with_map(response.body)

        File.open(map_file, 'w') {|f| f.puts source_map }
        File.open(js_file, 'w')  {|f| f.puts beautified_js }
      end

      return beautified_js, source_map
    end

    def map_path(file)
      File.join(cache_path, "#{file}.map")
    end

    def js_path(file)
      File.join(cache_path, file)
    end

    private

    def cache_path
      Rails.root.join("tmp/beautified_maps")
    end
  end
end
